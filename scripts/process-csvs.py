#!/usr/bin/env python3
"""
Process all downloaded CSVs and populate the stem_normalization database.
Reads from outputs/csv/, parses each source, generates SQL, and inserts.

Usage: python3 scripts/process-csvs.py
"""

import csv
import io
import os
import re
import subprocess
import sys

DB = os.environ.get("DATABASE_URL", "postgresql://postgres:postgres@127.0.0.1:54322/postgres")
DB_USER = os.environ.get("USER", "max")

# ============================================================
# Poppy color categories (must match seed data)
# ============================================================
COLOR_CATEGORIES = [
    "white", "cream", "tan", "light yellow", "yellow", "dark yellow",
    "peach", "blush", "light pink", "coral", "orange", "terracotta",
    "rust", "red", "pink", "hot pink", "mauve", "burgundy", "berry",
    "plum", "lavender", "purple", "eggplant", "sage", "dark green",
    "light blue", "blue", "gray", "dark brown", "lime green",
]

# Map raw color terms → Poppy color category
COLOR_MAP = {
    "white": "white", "cream": "cream", "tan": "tan",
    "light yellow": "light yellow", "yellow": "yellow",
    "dark yellow": "dark yellow", "peach": "peach", "blush": "blush",
    "light pink": "light pink", "coral": "coral", "orange": "orange",
    "terracotta": "terracotta", "terra cotta": "terracotta",
    "rust": "rust", "red": "red", "pink": "pink",
    "hot pink": "hot pink", "bright pink": "hot pink",
    "dark pink": "hot pink", "deep pink": "hot pink",
    "medium pink": "pink", "mauve": "mauve",
    "burgundy": "burgundy", "wine": "burgundy",
    "berry": "berry", "plum": "plum",
    "lavender": "lavender", "lilac": "lavender",
    "purple": "purple", "eggplant": "eggplant",
    "sage": "sage", "dark green": "dark green", "green": "dark green",
    "light blue": "light blue", "blue": "blue",
    "gray": "gray", "grey": "gray",
    "dark brown": "dark brown", "brown": "dark brown",
    "lime green": "lime green",
    "beige": "cream", "champagne": "cream", "salmon": "coral",
    "copper": "terracotta", "bronze": "terracotta",
    "gold": "dark yellow", "mustard": "dark yellow",
    "natural": "cream",
}

# Category names that embed subcategory
CATEGORY_PARSE = {
    "spray rose": ("rose", "spray"),
    "spray roses": ("rose", "spray"),
    "spray roses wayuu": ("rose", "spray"),
    "garden rose": ("rose", "garden"),
    "standard ranunculus": ("ranunculus", "standard"),
    "butterfly ranunculus": ("ranunculus", "butterfly"),
    "mini carnation": ("carnation", "mini"),
    "gerbera daisy": ("gerbera daisy", None),
    "baby's breath": ("baby's breath", None),
    "bells of ireland": ("bells of ireland", None),
    "snap dragon": ("snapdragon", None),
    "snapdragon": ("snapdragon", None),
    "alstroemeria": ("alstroemeria", None),
    "alstroemeria wayuu": ("alstroemeria", None),
    "carnation": ("carnation", None),
    "carnations wayuu": ("carnation", None),
    "chrysanthemum": ("chrysanthemum", None),
    "summer flowers": None,  # Section header, not a single category
    "fillers": None,
    "greens": None,
}


def esc(s):
    """Escape a string for SQL."""
    if s is None:
        return "NULL"
    return "'" + str(s).replace("'", "''") + "'"


def map_color(raw_color):
    """Map a raw color string to a Poppy color category."""
    if not raw_color:
        return None
    c = raw_color.strip().lower()
    # Direct match
    if c in COLOR_MAP:
        return COLOR_MAP[c]
    # Try multi-word from longest
    for term in sorted(COLOR_MAP.keys(), key=len, reverse=True):
        if c.startswith(term):
            return COLOR_MAP[term]
    return None


def normalize_category(raw_cat):
    """Parse raw category string into (stem_category, stem_subcategory)."""
    c = raw_cat.strip().lower()
    if c in CATEGORY_PARSE:
        result = CATEGORY_PARSE[c]
        if result is None:
            return (c, None)  # Generic section
        return result
    return (c, None)


def run_sql(sql, quiet=False):
    """Execute SQL against the database."""
    result = subprocess.run(
        ["psql", DB, "-c", sql],
        capture_output=True, text=True
    )
    if result.returncode != 0 and not quiet:
        print(f"  SQL Error: {result.stderr.strip()[:200]}")
    return result


def run_sql_batch(sql_statements):
    """Execute a batch of SQL statements."""
    full_sql = "\n".join(sql_statements)
    result = subprocess.run(
        ["psql", DB],
        input=full_sql, capture_output=True, text=True
    )
    if result.returncode != 0:
        # Count errors vs successes
        errors = result.stderr.count("ERROR")
        print(f"  ⚠️  {errors} SQL errors in batch")
    return result


# ============================================================
# Track all inserted data for reporting
# ============================================================
confident = []  # List of dicts: {source, stem_category, variety, color, ...}
review = []     # List of dicts: {source, raw_data, issue}
sql_batch = []  # Accumulate SQL statements


def ensure_stem(category, subcategory=None):
    """Generate SQL to ensure a stem exists."""
    subcat_val = esc(subcategory) if subcategory else "NULL"
    sql_batch.append(
        f"INSERT INTO stems (stem_category, stem_subcategory) "
        f"VALUES ({esc(category)}, {subcat_val}) "
        f"ON CONFLICT (stem_category, COALESCE(stem_subcategory, '')) DO NOTHING;"
    )


def ensure_variety(name):
    """Generate SQL to ensure a variety exists."""
    sql_batch.append(
        f"INSERT INTO varieties (name) VALUES ({esc(name)}) ON CONFLICT (name) DO NOTHING;"
    )


def ensure_stem_variety(category, subcategory, variety_name):
    """Generate SQL to link a variety to a stem."""
    subcat_clause = f"stem_subcategory = {esc(subcategory)}" if subcategory else "stem_subcategory IS NULL"
    sql_batch.append(
        f"INSERT INTO stem_varieties (stem_id, variety_id) "
        f"SELECT s.id, v.id FROM stems s, varieties v "
        f"WHERE s.stem_category = {esc(category)} AND s.{subcat_clause} "
        f"AND v.name = {esc(variety_name)} "
        f"ON CONFLICT (stem_id, variety_id) DO NOTHING;"
    )


def ensure_stem_color(category, subcategory, color_category):
    """Generate SQL to link a color to a stem."""
    subcat_clause = f"stem_subcategory = {esc(subcategory)}" if subcategory else "stem_subcategory IS NULL"
    sql_batch.append(
        f"INSERT INTO stem_color_categories (stem_id, color_type, primary_color_category_id) "
        f"SELECT s.id, 'single', cc.id FROM stems s, color_categories cc "
        f"WHERE s.stem_category = {esc(category)} AND s.{subcat_clause} "
        f"AND cc.name = {esc(color_category)} "
        f"ON CONFLICT DO NOTHING;"
    )


def ensure_product_item(category, subcategory, variety_name, color_category, vendor_name, product_item_name, vendor_sku=None):
    """Generate SQL to insert a product_item using subqueries for FK resolution."""
    subcat_clause = f"stem_subcategory = {esc(subcategory)}" if subcategory else "stem_subcategory IS NULL"

    # Resolve stem_id via subquery
    stem_subq = (
        f"(SELECT id FROM stems WHERE stem_category = {esc(category)} "
        f"AND {subcat_clause} LIMIT 1)"
    )

    # Resolve vendor_id via subquery
    vendor_subq = f"(SELECT id FROM vendors WHERE name = {esc(vendor_name)} LIMIT 1)"

    # Resolve stem_color_category_id via subquery (or NULL)
    if color_category:
        color_subq = (
            f"(SELECT scc.id FROM stem_color_categories scc "
            f"WHERE scc.stem_id = {stem_subq} "
            f"AND scc.primary_color_category_id = "
            f"(SELECT id FROM color_categories WHERE name = {esc(color_category)} LIMIT 1) "
            f"LIMIT 1)"
        )
    else:
        color_subq = "NULL"

    # Resolve stem_variety_id via subquery (or NULL)
    if variety_name:
        variety_subq = (
            f"(SELECT sv.id FROM stem_varieties sv "
            f"WHERE sv.stem_id = {stem_subq} "
            f"AND sv.variety_id = "
            f"(SELECT id FROM varieties WHERE name = {esc(variety_name)} LIMIT 1) "
            f"LIMIT 1)"
        )
    else:
        variety_subq = "NULL"

    sku_val = esc(vendor_sku) if vendor_sku else "NULL"

    sql_batch.append(
        f"INSERT INTO product_items (stem_id, vendor_id, stem_color_category_id, stem_variety_id, product_item_name, vendor_sku) "
        f"VALUES ({stem_subq}, {vendor_subq}, {color_subq}, {variety_subq}, {esc(product_item_name)}, {sku_val});"
    )


# ============================================================
# PROCESSOR: Elite Roses
# ============================================================
def process_elite_roses():
    print("\n🌹 Processing Elite Roses...")
    filepath = "outputs/csv/elite-x-poppy/SO_Fob_Bog_2026_Roses.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    current_color = None
    count = 0

    for row in rows:
        # Skip empty rows and headers
        if len(row) < 4:
            continue

        # The CSV has dual columns (standard + high season)
        # We care about cols B(1), C(2), D(3) for Color, Variety, Category
        color_cell = row[1].strip() if len(row) > 1 else ""
        variety_cell = row[2].strip() if len(row) > 2 else ""
        category_cell = row[3].strip() if len(row) > 3 else ""

        # Skip header rows
        if color_cell == "Color" or variety_cell == "Variety":
            continue

        # Is this a color section header?
        if color_cell and not variety_cell:
            continue  # Pure header row
        if color_cell:
            current_color = color_cell

        if not variety_cell or not category_cell:
            continue

        # Determine stem subcategory
        stem_cat = "rose"
        stem_subcat = None
        if category_cell.lower() == "garden":
            stem_subcat = "garden"

        # Map color
        color_mapped = map_color(current_color)
        if current_color and current_color.lower().startswith("bicolor"):
            # Handle bicolor sections — flag for review
            review.append({
                "source": "Elite Roses",
                "raw_data": f"{current_color} | {variety_cell} | {category_cell}",
                "parsed_category": "rose",
                "parsed_variety": variety_cell.lower(),
                "parsed_color": current_color,
                "issue": f"Bicolor section '{current_color}' — needs manual color mapping",
            })
            continue

        if not color_mapped and current_color:
            review.append({
                "source": "Elite Roses",
                "raw_data": f"{current_color} | {variety_cell} | {category_cell}",
                "parsed_category": "rose",
                "parsed_variety": variety_cell.lower(),
                "parsed_color": current_color,
                "issue": f"Unmapped color: '{current_color}'",
            })
            continue

        variety_lower = variety_cell.lower().strip()

        # Generate SQL
        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        # Check which lengths have pricing (cols E-H, indices 4-7)
        for cm_idx, cm_val in [(4, 40), (5, 50), (6, 60), (7, 70)]:
            if len(row) > cm_idx and row[cm_idx].strip().startswith("$"):
                # This variety is available at this length
                pass  # stem_lengths already seeded; we'd link product_items per length

        product_name = f"{current_color} {variety_cell} Rose".strip()
        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Elite", product_name)

        confident.append({
            "source": "Elite Roses",
            "stem": f"rose ({stem_subcat})" if stem_subcat else "rose",
            "variety": variety_lower,
            "color": color_mapped,
            "product_name": product_name,
        })
        count += 1

    print(f"  ✅ {count} rose varieties processed")


# ============================================================
# PROCESSOR: Elite Other Product
# ============================================================
def process_elite_other():
    print("\n🌿 Processing Elite Other Product...")
    filepath = "outputs/csv/elite-x-poppy/SO_Fob_Bog_2026_Other_Product.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    current_section = None
    count = 0

    for row in rows:
        if len(row) < 2:
            continue

        cell_b = row[1].strip() if len(row) > 1 else ""
        cell_c = row[2].strip() if len(row) > 2 else ""

        # Detect section headers (they appear in column B with no pricing data)
        if cell_b and ("Wayuu" in cell_b or cell_b in ["Summer Flowers", "Fillers", "Greens"]):
            if not cell_c or cell_c in ["40 cms", "50 cms", "60 cms", "Incredible", "Premium", "Select", "Fancy"]:
                current_section = cell_b
                continue

        if not current_section or not cell_b:
            continue

        # Skip aggregate rows
        if "Solid Colors" in cell_b or "Assorted Colors" in cell_b or "Custom Pack" in cell_b:
            continue

        # Parse based on section
        stem_cat, stem_subcat = normalize_category(current_section)
        variety_lower = cell_b.lower().strip()

        # Try to extract color from variety name
        color_mapped = None
        parts = variety_lower.split()
        # Check if last word(s) are a color
        for n in [2, 1]:
            if len(parts) >= n + 1:
                color_candidate = " ".join(parts[-n:])
                mapped = map_color(color_candidate)
                if mapped:
                    color_mapped = mapped
                    variety_lower = " ".join(parts[:-n])
                    break

        if not variety_lower:
            variety_lower = cell_b.lower().strip()

        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        product_name = f"{cell_b}"
        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Elite", product_name)

        confident.append({
            "source": "Elite Other",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_lower,
            "color": color_mapped or "—",
            "product_name": product_name,
        })
        count += 1

    print(f"  ✅ {count} other products processed")


# ============================================================
# PROCESSOR: DV x Poppy RFP
# ============================================================
def process_dv():
    print("\n📋 Processing DV x Poppy RFP...")
    filepath = "outputs/csv/dv-poppy-rfp/DV_Pricing_Request_Final_combined.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    count = 0
    for row in rows:
        stem_type = (row.get("Stem Type", "") or "").strip()
        vendor_name_raw = (row.get("Vendor Product Name", "") or "").strip()
        vendor_code = (row.get("Vendor Product Code", "") or "").strip()
        poppy_name = (row.get("Poppy Product Name", "") or "").strip()

        if not stem_type:
            continue

        stem_cat, stem_subcat = normalize_category(stem_type)

        # Use the vendor product name as the product item name
        display_name = vendor_name_raw or poppy_name or stem_type

        # Try to extract variety from vendor name
        variety_name = None
        color_mapped = None

        if vendor_name_raw:
            # Product names are like "Acacia Knifeblade", "Rose Red Freedom 60cm"
            name_lower = vendor_name_raw.lower()

            # Remove length suffixes
            name_clean = re.sub(r'\d+\s*cm\s*$', '', name_lower).strip()

            # Remove the stem category prefix
            prefixes = [stem_cat]
            if stem_subcat:
                prefixes.append(f"{stem_subcat} {stem_cat}")
                prefixes.append(f"{stem_cat} {stem_subcat}")
            prefixes.sort(key=len, reverse=True)

            remainder = name_clean
            for prefix in prefixes:
                if remainder.startswith(prefix):
                    remainder = remainder[len(prefix):].strip()
                    break

            if remainder:
                # Try to identify color at the start
                for n_words in [2, 1]:
                    words = remainder.split()
                    if len(words) >= n_words:
                        candidate = " ".join(words[:n_words])
                        mapped = map_color(candidate)
                        if mapped:
                            color_mapped = mapped
                            remainder = " ".join(words[n_words:]).strip()
                            break

                if remainder:
                    variety_name = remainder

        # Insert
        ensure_stem(stem_cat, stem_subcat)
        if variety_name:
            ensure_variety(variety_name)
            ensure_stem_variety(stem_cat, stem_subcat, variety_name)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        confidence = "HIGH" if variety_name else "MEDIUM"

        ensure_product_item(
            stem_cat, stem_subcat, variety_name, color_mapped,
            "DV", display_name, vendor_sku=vendor_code
        )

        confident.append({
            "source": "DV",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_name or "—",
            "color": color_mapped or "—",
            "product_name": display_name,
        })
        count += 1

    print(f"  ✅ {count} DV products processed")


# ============================================================
# PROCESSOR: Stem Cost Database Summary
# ============================================================
def process_stem_cost_summary():
    print("\n💰 Processing Stem Cost Database Summary...")
    filepath = "outputs/csv/stem-cost-database/Summary.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    count = 0
    for row in rows:
        if len(row) < 2:
            continue
        stem_type = row[0].strip() if row[0].strip() else None
        if not stem_type or stem_type.lower() in ("stem type", "stem", ""):
            continue

        stem_cat, stem_subcat = normalize_category(stem_type)
        ensure_stem(stem_cat, stem_subcat)

        confident.append({
            "source": "Stem Cost Summary",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": "—",
            "color": "—",
            "product_name": stem_type,
        })
        count += 1

    print(f"  ✅ {count} stem types from cost summary")


# ============================================================
# PROCESSOR: Agrogana (stem-cost-database)
# ============================================================
def process_agrogana():
    print("\n🌸 Processing Agrogana...")
    filepath = "outputs/csv/stem-cost-database/Agrogana.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    count = 0
    seen = set()  # Deduplicate by (stem_type, variety)

    for row in rows:
        if len(row) < 3:
            continue

        stem_type = row[0].strip()
        variety_raw = row[1].strip()

        if not stem_type or not variety_raw:
            continue
        if stem_type.lower() in ("stem type", ""):
            continue

        # Normalize stem type (handles "Rose - Garden" → ("rose", "garden") etc.)
        stem_type_lower = stem_type.lower()
        # Handle Agrogana-specific categories like "Rose - Spray", "Rose - Garden"
        stem_cat = stem_type_lower
        stem_subcat = None
        if " - " in stem_type_lower:
            parts = stem_type_lower.split(" - ", 1)
            stem_cat = parts[0].strip()
            stem_subcat = parts[1].strip()
        else:
            stem_cat, stem_subcat = normalize_category(stem_type)

        # Parse variety name — strip prefixes like "PK ", "S ", "Y "
        variety_lower = variety_raw.lower().strip()
        for prefix in ["pk ", "s ", "y "]:
            if variety_lower.startswith(prefix):
                variety_lower = variety_lower[len(prefix):]
                break

        # Try to extract color from variety name
        color_mapped = None
        # Common pattern: "STEM_TYPE COLOR" e.g. "SNAPDRAGON RED"
        # Remove stem category prefix if present
        remainder = variety_lower
        cat_prefixes = [stem_cat]
        if stem_subcat:
            cat_prefixes.append(f"{stem_subcat} {stem_cat}")
            cat_prefixes.append(f"{stem_cat} {stem_subcat}")
        cat_prefixes.sort(key=len, reverse=True)
        for p in cat_prefixes:
            if remainder.startswith(p + " "):
                remainder = remainder[len(p):].strip()
                break
            elif remainder.startswith(p):
                remainder = remainder[len(p):].strip()
                break

        # Check if last word(s) are a color
        words = remainder.split()
        for n in [2, 1]:
            if len(words) >= n + 1:
                color_candidate = " ".join(words[-n:])
                mapped = map_color(color_candidate)
                if mapped:
                    color_mapped = mapped
                    variety_lower = " ".join(words[:-n]).strip()
                    break
            elif len(words) == n:
                # Entire remainder might be just a color
                color_candidate = " ".join(words)
                mapped = map_color(color_candidate)
                if mapped:
                    color_mapped = mapped
                    variety_lower = ""
                    break

        # Use original variety if extraction left it empty
        if not variety_lower:
            variety_lower = variety_raw.lower().strip()
            for prefix in ["pk ", "s ", "y "]:
                if variety_lower.startswith(prefix):
                    variety_lower = variety_lower[len(prefix):]
                    break

        # Deduplicate
        key = (stem_cat, stem_subcat, variety_lower)
        if key in seen:
            continue
        seen.add(key)

        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        product_name = variety_raw
        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Agrogana", product_name)

        confident.append({
            "source": "Agrogana",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_lower,
            "color": color_mapped or "—",
            "product_name": product_name,
        })
        count += 1

    print(f"  ✅ {count} Agrogana products processed")


# ============================================================
# PROCESSOR: Magic (stem-cost-database — tropical/greens)
# ============================================================
def process_magic_stems():
    print("\n🪄 Processing Magic Stems...")
    filepath = "outputs/csv/stem-cost-database/Magic.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    count = 0
    for row in rows:
        if len(row) < 3:
            continue

        species = row[0].strip()
        product = row[1].strip()

        if not species or not product:
            continue
        if species.lower() in ("species", ""):
            continue

        stem_cat, stem_subcat = normalize_category(species)

        # Parse variety from product description
        # Products are like "MONSTERA GREEN LARGE 90CM. 5ST. HB/QB (NC)"
        variety_lower = product.lower()
        # Remove size/packaging suffixes
        variety_lower = re.sub(r'\d+cm\.?.*$', '', variety_lower).strip()
        # Remove stem category prefix
        for prefix in [stem_cat, species.lower()]:
            if variety_lower.startswith(prefix + " "):
                variety_lower = variety_lower[len(prefix):].strip()
                break
            elif variety_lower.startswith(prefix):
                variety_lower = variety_lower[len(prefix):].strip()
                break

        # Try to extract color
        color_mapped = None
        words = variety_lower.split()
        for n in [2, 1]:
            if len(words) >= n + 1:
                candidate = " ".join(words[-n:])
                mapped = map_color(candidate)
                if mapped:
                    color_mapped = mapped
                    variety_lower = " ".join(words[:-n]).strip()
                    break

        if not variety_lower:
            variety_lower = product.lower()
            variety_lower = re.sub(r'\d+cm\.?.*$', '', variety_lower).strip()

        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Magic", product)

        confident.append({
            "source": "Magic",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_lower,
            "color": color_mapped or "—",
            "product_name": product[:60],
        })
        count += 1

    print(f"  ✅ {count} Magic stem products processed")


# ============================================================
# PROCESSOR: Mayesh (stem-cost-database — wholesale pricing)
# ============================================================
def process_mayesh():
    print("\n🌺 Processing Mayesh...")
    filepath = "outputs/csv/stem-cost-database/Mayesh.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    count = 0
    seen = set()  # Deduplicate — Mayesh has many repeated entries

    for row in rows:
        if len(row) < 4:
            continue

        # Mayesh format: Branch, Stem Type, Variety, Price, ...
        stem_type = row[1].strip()
        variety_raw = row[2].strip()

        if not variety_raw:
            continue
        if stem_type.lower() in ("stem type", "") and not variety_raw:
            continue

        # Some rows have empty stem_type but valid variety (later entries)
        # Skip header row
        if variety_raw.lower() in ("variety - gs", ""):
            continue

        # Use stem_type if available, otherwise try to infer from variety
        if stem_type:
            stem_type_lower = stem_type.lower()
            stem_cat = stem_type_lower
            stem_subcat = None
            if " - " in stem_type_lower:
                parts = stem_type_lower.split(" - ", 1)
                stem_cat = parts[0].strip()
                stem_subcat = parts[1].strip()
            else:
                stem_cat, stem_subcat = normalize_category(stem_type)
        else:
            # Try to infer from variety name
            stem_cat = "unknown"
            stem_subcat = None
            variety_lower_temp = variety_raw.lower()
            # Common patterns
            infer_map = [
                ("rose garden ", "rose", "garden"),
                ("rose spray ", "rose", "spray"),
                ("spray rose ", "rose", "spray"),
                ("rose ", "rose", None),
                ("tulip ", "tulip", None),
                ("eucalyptus ", "eucalyptus", None),
                ("ruscus ", "greenery", None),
                ("hydrangea ", "hydrangea", None),
                ("delphinium ", "delphinium", None),
                ("snapdragon ", "snapdragon", None),
                ("ranunculus ", "ranunculus", None),
                ("lisianthus ", "lisianthus", None),
                ("carnation ", "carnation", None),
                ("gypsophila ", "baby's breath", None),
                ("calla ", "calla", None),
                ("pittosporum ", "greenery", None),
                ("huckleberry ", "greenery", None),
            ]
            for prefix, cat, subcat in infer_map:
                if variety_lower_temp.startswith(prefix):
                    stem_cat = cat
                    stem_subcat = subcat
                    break

        # Clean variety name
        variety_lower = variety_raw.lower().strip()

        # Deduplicate by (stem_cat, stem_subcat, variety)
        key = (stem_cat, stem_subcat, variety_lower)
        if key in seen:
            continue
        seen.add(key)

        # Try to extract color from variety name
        color_mapped = None
        # Remove stem category prefixes
        remainder = variety_lower
        cat_prefixes = [stem_cat]
        if stem_subcat:
            cat_prefixes.extend([f"{stem_subcat} {stem_cat}", f"{stem_cat} {stem_subcat}"])
        cat_prefixes.sort(key=len, reverse=True)
        for p in cat_prefixes:
            if remainder.startswith(p + " "):
                remainder = remainder[len(p):].strip()
                break

        words = remainder.split()
        for n in [2, 1]:
            if len(words) >= n + 1:
                candidate = " ".join(words[-n:])
                mapped = map_color(candidate)
                if mapped:
                    color_mapped = mapped
                    break

        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Mayesh", variety_raw)

        confident.append({
            "source": "Mayesh",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_lower,
            "color": color_mapped or "—",
            "product_name": variety_raw[:60],
        })
        count += 1

    print(f"  ✅ {count} Mayesh products processed")


# ============================================================
# PROCESSOR: Magic Pricing (full catalog — tropicals + greens)
# ============================================================
def process_magic_pricing():
    print("\n🌴 Processing Magic Pricing Catalog...")
    filepath = "outputs/csv/magic-pricing/Sheet1.csv"

    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    count = 0
    seen = set()  # Deduplicate across packaging variants

    # Section headers to skip (bouquets/combos are composite, not individual stems)
    skip_sections = {
        "bouquets", "round bouquets", "flat bouquets",
        "kits", "combos flower boxes", "combos boxes-greens",
        "green bouquets", "greens bouquets",
        "assorted boxes / combos", "assorted green boxes / green combos",
    }

    # Section header detection: column 0 has a category name, column 1 says "Product Name"
    # These rows re-declare the column headers within the CSV
    def is_section_header(row):
        if len(row) < 2:
            return False
        return row[1].strip().lower() in ("product name", "product name ")

    for row in rows:
        if len(row) < 2:
            continue

        # Skip section header rows
        if is_section_header(row):
            continue

        category = row[0].strip()
        product_name = row[1].strip()

        if not category or not product_name:
            continue

        # Skip composite product sections
        if category.lower() in skip_sections:
            continue

        # Map category to stem type
        cat_lower = category.lower()

        # Skip combo/kit individual rows too
        if any(kw in cat_lower for kw in ["combo", "kit", "bouquet"]):
            continue

        # Normalize tropical/green categories
        stem_cat = cat_lower
        stem_subcat = None

        # Handle compound categories
        if " - " in cat_lower:
            parts = cat_lower.split(" - ", 1)
            stem_cat = parts[0].strip()
            stem_subcat = parts[1].strip()
        elif "-" in cat_lower and not cat_lower.startswith("dried"):
            # e.g. "Gingers-Seasonal" → ("ginger", "seasonal")
            parts = cat_lower.split("-", 1)
            stem_cat = parts[0].strip()
            stem_subcat = parts[1].strip()

        # Normalize known categories
        cat_map = {
            "gingers": "ginger",
            "gingers-seasonal": "ginger",
            "heliconia up-right xl": "heliconia",
            "heliconia up-right": "heliconia",
            "heliconia pendant": "heliconia",
            "heliconia": "heliconia",
            "musas": "musa",
            "musas - oversize": "musa",
            "bird of paradise": "bird of paradise",
            "bird of paradise - oversize": "bird of paradise",
            "anthurium tropicals": "anthurium",
            "curcuma": "curcuma",
            "curcuma elata": "curcuma",
            "hypericum": "hypericum",
            "palm": "palm",
            "palm - oversize": "palm",
            "leaves": "greenery",
            "leaves - oversize": "greenery",
            "tips": "greenery",
            "greens - oversize": "greenery",
            "dried & preserved": "dried",
        }
        if cat_lower in cat_map:
            stem_cat = cat_map[cat_lower]
            # Preserve subcategory from cat_map entries with " - "
            if " - " in cat_lower and stem_subcat:
                pass  # keep stem_subcat
            elif cat_lower in ("gingers-seasonal",):
                stem_subcat = "seasonal"
            elif "oversize" in cat_lower:
                stem_subcat = "oversize"
            else:
                stem_subcat = None

        # Clean variety/product name
        variety_lower = product_name.lower().strip()

        # Deduplicate by unique product
        key = (stem_cat, stem_subcat, variety_lower)
        if key in seen:
            continue
        seen.add(key)

        # Try to extract color from product name
        color_mapped = None
        # Remove common prefixes (stem type abbreviations)
        remainder = variety_lower
        strip_prefixes = [
            "hel. ", "ant. ", "phi. ",
            stem_cat + " ",
        ]
        for p in strip_prefixes:
            if remainder.startswith(p):
                remainder = remainder[len(p):].strip()
                break

        # Remove size suffixes
        remainder = re.sub(r'\b(xl|large|medium|small|petite|mini|jumbo|fat|oversize)\b', '', remainder, flags=re.IGNORECASE).strip()
        remainder = re.sub(r'\s+', ' ', remainder).strip()

        # Check last word(s) for color
        words = remainder.split()
        for n in [2, 1]:
            if len(words) >= n + 1:
                candidate = " ".join(words[-n:])
                mapped = map_color(candidate)
                if mapped:
                    color_mapped = mapped
                    break

        ensure_stem(stem_cat, stem_subcat)
        ensure_variety(variety_lower)
        ensure_stem_variety(stem_cat, stem_subcat, variety_lower)
        if color_mapped:
            ensure_stem_color(stem_cat, stem_subcat, color_mapped)

        ensure_product_item(stem_cat, stem_subcat, variety_lower, color_mapped, "Magic", product_name)

        confident.append({
            "source": "Magic Pricing",
            "stem": f"{stem_cat} ({stem_subcat})" if stem_subcat else stem_cat,
            "variety": variety_lower,
            "color": color_mapped or "—",
            "product_name": product_name[:60],
        })
        count += 1

    print(f"  ✅ {count} Magic pricing products processed")


# MAIN
# ============================================================
def main():
    generate_only = "--generate-only" in sys.argv

    print("=" * 60)
    print("Stem Normalization — CSV Processing Pipeline")
    if generate_only:
        print("  (generate-only mode — will not execute SQL)")
    print("=" * 60)

    # Process each source
    process_elite_roses()
    process_elite_other()
    process_dv()
    process_stem_cost_summary()
    process_agrogana()
    process_magic_stems()
    process_magic_pricing()
    process_mayesh()

    # Write SQL batch
    print(f"\n📝 Writing {len(sql_batch)} SQL statements...")
    sql_file = "scripts/insert-all-sources.sql"
    with open(sql_file, "w") as f:
        f.write("-- Auto-generated from CSV data processing\n")
        f.write(f"-- {len(sql_batch)} statements\n\n")
        f.write("\n".join(sql_batch))
    print(f"  Written to {sql_file}")

    if generate_only:
        print(f"\n⏭️  Skipping SQL execution (--generate-only). Run:")
        print(f"  psql {DB} -f {sql_file}")
    else:
        # Execute SQL
        print(f"\n🚀 Executing SQL batch...")
        result = run_sql_batch(sql_batch)

    if not generate_only:
        # Query final counts
        print("\n📊 Database counts:")
        count_result = subprocess.run(
            ["psql", DB, "-c",
             "SELECT 'stems' AS tbl, COUNT(*) FROM stems "
             "UNION ALL SELECT 'varieties', COUNT(*) FROM varieties "
             "UNION ALL SELECT 'stem_varieties', COUNT(*) FROM stem_varieties "
             "UNION ALL SELECT 'stem_color_categories', COUNT(*) FROM stem_color_categories "
             "UNION ALL SELECT 'product_items', COUNT(*) FROM product_items "
             "ORDER BY tbl;"],
            capture_output=True, text=True
        )
        print(count_result.stdout)

    # Write reports
    report_dir = "outputs/2026-03-08/data-population"
    os.makedirs(report_dir, exist_ok=True)

    # Confident inserts report
    with open(f"{report_dir}/confident-inserts.md", "w") as f:
        f.write("# Confident Inserts — All Sources\n\n")
        f.write(f"**Total confident inserts:** {len(confident)}\n\n")

        # Group by source
        sources = {}
        for item in confident:
            src = item["source"]
            sources.setdefault(src, []).append(item)

        for src, items in sources.items():
            f.write(f"\n## {src} ({len(items)} items)\n\n")
            f.write("| Stem | Variety | Color | Product Name |\n")
            f.write("|---|---|---|---|\n")
            for item in items[:50]:  # Limit per-source output
                f.write(f"| {item['stem']} | {item['variety']} | {item['color']} | {item['product_name'][:60]} |\n")
            if len(items) > 50:
                f.write(f"| ... | ... | ... | *({len(items) - 50} more)* |\n")

    # Needs review report
    with open(f"{report_dir}/needs-review.md", "w") as f:
        f.write("# Needs Review — Data Population\n\n")
        f.write(f"**Total items needing review:** {len(review)}\n\n")

        sources = {}
        for item in review:
            src = item["source"]
            sources.setdefault(src, []).append(item)

        for src, items in sources.items():
            f.write(f"\n## {src} ({len(items)} items)\n\n")
            f.write("| Raw Data | Parsed Category | Parsed Variety | Parsed Color | Issue |\n")
            f.write("|---|---|---|---|---|\n")
            for item in items:
                f.write(f"| {item['raw_data'][:60]} | {item.get('parsed_category', '—')} | {item.get('parsed_variety', '—')} | {item.get('parsed_color', '—')} | {item['issue']} |\n")

    print(f"\n✅ Reports written to {report_dir}/")
    print(f"  - confident-inserts.md ({len(confident)} items)")
    print(f"  - needs-review.md ({len(review)} items)")


if __name__ == "__main__":
    main()
