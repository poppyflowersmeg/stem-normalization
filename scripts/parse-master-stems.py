#!/usr/bin/env python3
"""
Parse Stem Pricing Master FLOWERS data and generate SQL inserts.
Reads the raw data, parses stem names into category/subcategory/color/variety,
and generates SQL for stems, varieties, stem_varieties, stem_color_categories, and product_items.
"""

import re
import json

# ============================================================
# Raw data from FLOWERS - MASTER (253 rows)
# Format: (stem_category, stem_name)
# All have Preferred Vendor = Agrogana
# ============================================================
RAW_DATA = [
    ("Anemone", "Anemone Light Pink"),
    ("Anemone", "Anemone Burgundi"),
    ("Anemone", "Anemone Blush"),
    ("Anemone", "Anemone Red"),
    ("Anemone", "Anemone Soft Purple"),
    ("Anemone", "Anemone Pinkie"),
    ("Anemone", "Anemone White"),
    ("Anemone", "Anemone- Purple"),
    ("Astrantia", "Astrantia White"),
    ("Astrantia", "Astrantia Light Pink"),
    ("Astrantia", "Astrantia Pink"),
    ("Astrantia", "Astrantia Burgundy"),
    ("Baby's Breath", "Baby's Breath White - Xlence"),
    ("Bells of Ireland", "Bells of Ireland"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus terra cotta- Musa"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Lavender - Europe"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Light Yellow - Liati"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus - Orange Minoan"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus pink - Hera"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Blush - Ariande"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Yellow - Artemis"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Pink - Lycia"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Orange - Charis"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Yellow - Phytalos"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus - Red Hades"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus White - Magical Mascarpone"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Purple - Magical Chocolate"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Salmon - Magical Salmon"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Yellow - Helios"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Light Pink - Isis"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus Terracotta - Theseus"),
    ("Butterfly Ranunculus", "Butterfly Ranunculus - Eris"),
    ("Calla", "Mini Calla Lily Cream"),
    ("Calla", "Mini Calla Lily Purple/white - Picasso"),
    ("Calla", "Mini Calla Lily Purple - La Paz"),
    ("Calla", "Mini Calla Lily Orange - Mango"),
    ("Carnation", "Carnation - Copper Extasis"),
    ("Carnation", "Carnation White - Polar Route"),
    ("Carnation", "Carnation Peach - Novia"),
    ("Carnation", "Carnation Peach - Brut"),
    ("Carnation", "Carnation Burgundy- Red Velvet"),
    ("Carnation", "Carnation Burgundy - Clavel Velvet"),
    ("Carnation", "Carnation - Chroma Thrill"),
    ("Carnation", "Carnation Peach - Minami"),
    ("Carnation", "Carnation Peach/blush - Creta"),
    ("Carnation", "Carnation Peach - Lizzy"),
    ("Carnation", "Carnation Purple/Mauve - Hypnosis"),
    ("Carnation", "Carnation Green- Viper"),
    ("Chrysanthemum", "Bronze/gold Football Mum"),
    ("Chrysanthemum", "Mum Salmon - Oefa"),
    ("Chrysanthemum", "Yellow - Anastasia Sunny"),
    ("Craspedia", "Craspedia Yellow"),
    ("Delphinium", "Delphinium Pink - Trick"),
    ("Delphinium", "Delphinium Blush - Pink Planet"),
    ("Delphinium", "Delphinium - Blue Planet Spray (dark)"),
    ("Delphinium", "Delphinium Yellow - Trick"),
    ("Delphinium", "Delphinium Lavender - Trick"),
    ("Delphinium", "Delphinium White"),
    ("Delphinium", "Delphinium Purple- Black Knight"),
    ("Dried", "Dried - Bunny Tail Brown (Natural)"),
    ("Dried", "Dried - Bunny Tail White"),
    ("Dried Baby's Breath", "Dried - White Baby's Breath"),
    ("Eryngium", "Thistle Eryngium - Blue Lagoon"),
    ("Eryngium", "Thistle Eryngium - Green Lagoon"),
    ("Eryngium", "Thistle Eryngium - Green Jackpot"),
    ("Eryngium", "Thistle Eryngium - Blue Jackpot"),
    ("Freesia", "Freesia Lavender"),
    ("Freesia", "Freesia Yellow"),
    ("Freesia", "Freesia White"),
    ("Freesia", "Freesia Hot Pink"),
    ("Garden Rose", "Rose Blush - Garden Spirit"),
    ("Gerbera Daisy", "Gerbera Peach"),
    ("Gerbera Daisy", "Gerbera Mini Blush"),
    ("Gerbera Daisy", "Gerbera White"),
    ("Gerbera Daisy", "Gerbera Blush - Bubbles"),
    ("Gerbera Daisy", "Gerbera Mini Salmon"),
    ("Godetia", "Godetia Pink - Salmon Princess"),
    ("Godetia", "Godetia White - Princess"),
    ("Godetia", "Godetia Dark Pink - Fuchsia Princess"),
    ("Godetia", "Godetia Lavender - Princess"),
    ("Gypsophila", "Million Stars Gypsophila (xlence)"),
    ("Gypsophila", "Xlence Gyp Tinted Blue"),
    ("Gypsophila", "Xlence Gyp Tinted Peach"),
    ("Hydrangea", "Hydrangea - Blue"),
    ("Hydrangea", "Hydrangea - Green/Antique"),
    ("Hydrangea", "Hydrangea - White"),
    ("Hypericum", "Hypericum Red- Fire Flair"),
    ("Hypericum", "Hypericum Green- Emerald Flair"),
    ("Hypericum", "Hypericum Pink - Candy Flair"),
    ("Hypericum", "Hypericum Peach - Coral Flair"),
    ("Hypericum", "Hypericum White - Ivory Flair"),
    ("Larkspur", "Larkspur White"),
    ("Larkspur", "Larkspur Purple"),
    ("Lisianthus", "Lisianthus White"),
    ("Lisianthus", "Lisianthus Peach"),
    ("Lisianthus", "Lisianthus Cream"),
    ("Lisianthus", "Lisianthus Hot Pink"),
    ("Lisianthus", "Lisianthus Pink"),
    ("Marigold", "Marigold Orange"),
    ("Marigold", "Marigold Yellow"),
    ("Matilda", "Matilda"),
    ("Mini Carnation", "Mini Carnation - Clavel Vinium"),
    ("Mini Carnation", "Mini Carnation Beige - Estacion"),
    ("Mini Carnation", "Mini Carnation Burgundy- Chatau"),
    ("Orchid", "Cymbidium - Gold"),
    ("Orchid", "Cymbidium Burgundy"),
    ("Orchid", "White Cymbidium"),
    ("Orchid", "Copper Cymbidium"),
    ("Ornithogalum", "Ornithogalum - Orange"),
    ("Ornithogalum", "Ornithogalum - White"),
    ("Pampas", "Dried Pampas Grass Short"),
    ("Pampas", "Dried Pampas Grass Tall"),
    ("Poppy", "Poppy Mixed Colors"),
    ("Rose", "Princess Crown"),
    ("Rose", "Rose White - Polo"),
    ("Rose", "Rose - Red Monster"),
    ("Rose", "Rose Beige - Quicksand"),
    ("Rose", "Rose Bright Pink - Mayra's Queen"),
    ("Rose", "Rose Orange/Yellow - Espana"),
    ("Rose", "Rose Cream - Candlelight"),
    ("Rose", "Rose Peach/Coral- Taxo"),
    ("Rose", "Rose Purple - Blueberry XL"),
    ("Rose", "Rose Coral - Dark Xpression"),
    ("Rose", "Rose Orange - Martina"),
    ("Rose", "Rose Hot Pink - Rose"),
    ("Rose", "Rose Yellow - Country Sun"),
    ("Rose", "Rose Blush/cream - Marzipan"),
    ("Rose", "Rose Hot Pink - Gotcha"),
    ("Rose", "Rose Lavender - Andrea"),
    ("Rose", "Rose Lavender - Cool Water"),
    ("Rose", "Rose Lavender - Queen's Crown"),
    ("Rose", "Rose Lavender - Grey Knights"),
    ("Rose", "Rose Cream - Crème De La Crème"),
    ("Rose", "Rose Orange - Mosaico"),
    ("Rose", "Rose - Mayra's Red"),
    ("Rose", "Rose Blush - Ragazza"),
    ("Rose", "Rose Blush _ Sweet Escimo"),
    ("Rose", "Rose Blush - Frutteto"),
    ("Rose", "Rose - Pink O'hare"),
    ("Rose", "Rose Champagne/peach - Shimmer"),
    ("Rose", "Rose - Mayra's White"),
    ("Rose", "Rose Mauve - Piacere"),
    ("Rose", "Rose Burgundy - Heart"),
    ("Rose", "Rose - Pink Xpression"),
    ("Rose", "Rose Peach - Phoenix"),
    ("Rose", "Rose - Orange Crush"),
    ("Rose", "Rose - Whipped Cream"),
    ("Rose", "Rose White - Moonstone"),
    ("Rose", "Rose White - Siente"),
    ("Rose", "Rose Blush -Emely"),
    ("Rose", "Rose Cream - Talea"),
    ("Rose", "Rose Lavender - Ocean Song"),
    ("Rose", "Rose Blush - Nena"),
    ("Rose", "Rose Dark Pink - Caralinda"),
    ("Rose", "Rose Beige - Sahara"),
    ("Rose", "Rose Pink - Art Deco"),
    ("Rose", "Rose Red- Explorer"),
    ("Rose", "Rose Pink - All 4 Love"),
    ("Rose", "Rose Yellow - Catalina"),
    ("Rose", "Rose Peach - Tiffany"),
    ("Rose", "Rose Mustard - Symbol"),
    ("Rose", "Rose - Cream Carpediem"),
    ("Rose", "Rose Red - Devotion"),
    ("Rose", "Rose Lavender - Tiara"),
    ("Rose", "Rose White - Blizzard"),
    ("Rose", "Rose Lavender/Mauve - Brujas"),
    ("Rose", "Rose Orange - Free Spirit"),
    ("Rose", "Rose Peach - Kahala"),
    ("Rose", "Rose Peach - Country Home"),
    ("Rose", "Rose - Coral Reef"),
    ("Rose", "Rose Red - Freedom"),
    ("Rose", "Rose Peach/pale green- Dynamic"),
    ("Rose", "Rose Blush - Poma Rosa"),
    ("Rose", "Rose Pink/White bicolor- Joyce"),
    ("Rose", "Rose Coral/Pink - LaHabana"),
    ("Rose", "Rose Orange - Showbiz"),
    ("Rose", "Rose Burgundy/ Purple - Venturosa"),
    ("Rose", "Rose Wine - Merlot"),
    ("Rose", "Rose - Red Paris"),
    ("Rose", "Rose Blush/champagne - Sprit"),
    ("Rose", "Rose Coral - Mayra's Peach"),
    ("Rose", "Rose - Mondial"),
    ("Rose", "Rose - Peach/Pink - Sevilla"),
    ("Rose", "Rose - Pink Mondial"),
    ("Rose", "Rose Cream/Blush - Priority"),
    ("Rose", "Rose - Pink Floyd"),
    ("Rose", "Rose Pink/lavender - Country Blues"),
    ("Rose", "Rose Lavender/Grey - Earl Grey"),
    ("Rose", "Rose Lavender - Moody Blues"),
    ("Rose", "Rose White - Tibet"),
    ("Rose", "Rose Cream - Vendela"),
    ("Rose", "Rose Cream - Queen Of Pearl"),
    ("Rose", "Rose Pink - Famous"),
    ("Rose", "Rose Red/Orange - Nina"),
    ("Rose", "Rose Orange - Nexus"),
    ("Rose", "Rose Purple/Mauve- Govinda"),
    ("Rose", "Rose Orange/Yellow- Carumba"),
    ("Rose", "Rose Blush - Pink Porcelain"),
    ("Rose", "Rose Yellow/Orange - Shine On"),
    ("Rose", "Rose Cream/natural - Pompeii"),
    ("Rose", "Rose Hot Pink - Mayra's Bright"),
    ("Rose", "Rose Cream/Blush - Suspiro"),
    ("Rose", "Rose White - Playa Blanca"),
    ("Rose", "Rose Blush - Aly"),
    ("Rose", "Rose White - Escimo"),
    ("Scabiosa", "Scabiosa White - Focal Scoop"),
    ("Scabiosa", "Scabiosa Pink - Focal Scoop Bon Bon Vanilla"),
    ("Scabiosa", "Scabiosa Lilac - Focal Scoop"),
    ("Scabiosa", "Scabiosa Dark Purple - Focal Scoop"),
    ("Scabiosa", "Scabiosa Dark Pink - Strawberry"),
    ("Scabiosa", "Scabiosa Burgundy/Purple - Focal Scoop Mon"),
    ("Scabiosa", "Scabiosa Purple - Focal Scoop Blackberry"),
    ("Scabiosa", "Scabiosa Hot Pink"),
    ("Snap Dragon", "Snapdragon Lavender"),
    ("Snap Dragon", "Snapdragon Orange- Bronze"),
    ("Snap Dragon", "Snapdragon Peach- Appleblossom"),
    ("Snap Dragon", "Snapdragon White - Potomac"),
    ("Snap Dragon", "Snapdragon Light Pink"),
    ("Snap Dragon", "Snapdragon Yellow"),
    ("Snap Dragon", "Snapdragon Deep Pink/Burgundy"),
    ("Spray Rose", "Spray Rose Cream - Porcelina"),
    ("Spray Rose", "Spray Rose - Lavender"),
    ("Spray Rose", "Spray Rose Orange - Clementine"),
    ("Spray Rose", "Spray Rose Peach - Sahara"),
    ("Spray Rose", "Spray Rose Light Pink - Odila"),
    ("Spray Rose", "Spray Rose White"),
    ("Spray Rose", "Spray Rose Pink - Pink Majolika"),
    ("Spray Rose", "Spray Rose Lavender - Silver Shadow"),
    ("Spray Rose", "Spray Rose Peach - Talea"),
    ("Spray Rose", "Spray Rose White - Snowflake"),
    ("Spray Rose", "Spray Rose Cream/peach - Campanella"),
    ("Spray Rose", "Spray Rose Pink - Bridal Piano"),
    ("Spray Rose", "Spray Rose White - Blanche"),
    ("Spray Rose", "Spray Rose White - Libelle"),
    ("Spray Rose", "Spray Rose Pink - Mimi Eden"),
    ("Spray Rose", "Spray Rose Peach - Julieta"),
    ("Spray Rose", "Spray Rose Pink - Lovely Lydia"),
    ("Spray Rose", "Spray Rose Burgundy - Rubicon"),
    ("Spray Rose", "Spray Rose Yellow - Fire Flash"),
    ("Spray Rose", "Spray Rose Red - Red Mikado"),
    ("Spray Rose", "Spray Rose Pink- Star Blush"),
    ("Standard Ranunculus", "Ranunculus - Orange Elegance"),
    ("Standard Ranunculus", "Ranunculus - Clementine Elegance"),
    ("Standard Ranunculus", "Ranunculus - Peach/Blush Elegance"),
    ("Standard Ranunculus", "Ranunculus - White Elegance"),
    ("Standard Ranunculus", "Ranunculus - Pink Elegance"),
    ("Standard Ranunculus", "Ranunculus - Yellow Elegance"),
    ("Standard Ranunculus", "Ranunculus - Pastel Pink Elegance"),
    ("Standard Ranunculus", "Ranunculus - Cream/Salmon Elegance"),
    ("Standard Ranunculus", "Ranunculus - Dark Pink Elegance"),
    ("Standard Ranunculus", "Ranunculus - Red Elegance"),
    ("Standard Ranunculus", "Ranunculus - Burgundy Elegance"),
    ("Standard Ranunculus", "Ranunculus - Purple Elegance"),
]

# ============================================================
# Color mapping: raw color terms → Poppy color_category name
# ============================================================
COLOR_MAP = {
    "white": "white",
    "cream": "cream",
    "tan": "tan",
    "light yellow": "light yellow",
    "yellow": "yellow",
    "dark yellow": "dark yellow",
    "peach": "peach",
    "blush": "blush",
    "light pink": "light pink",
    "coral": "coral",
    "orange": "orange",
    "terracotta": "terracotta",
    "terra cotta": "terracotta",
    "rust": "rust",
    "red": "red",
    "pink": "pink",
    "hot pink": "hot pink",
    "bright pink": "hot pink",
    "dark pink": "hot pink",
    "deep pink": "hot pink",
    "mauve": "mauve",
    "burgundy": "burgundy",
    "burgundi": "burgundy",
    "wine": "burgundy",
    "berry": "berry",
    "plum": "plum",
    "lavender": "lavender",
    "lilac": "lavender",
    "purple": "purple",
    "soft purple": "purple",
    "eggplant": "eggplant",
    "sage": "sage",
    "dark green": "dark green",
    "green": "dark green",
    "light blue": "light blue",
    "blue": "blue",
    "gray": "gray",
    "grey": "gray",
    "dark brown": "dark brown",
    "brown": "dark brown",
    "lime green": "lime green",
    "beige": "cream",
    "champagne": "cream",
    "salmon": "coral",
    "copper": "terracotta",
    "bronze": "terracotta",
    "gold": "dark yellow",
    "mustard": "dark yellow",
    "natural": "cream",
    "pinkie": "pink",
}

# Categories that embed subcategory in the category name
CATEGORY_PARSE = {
    "Spray Rose": ("rose", "spray"),
    "Garden Rose": ("rose", "garden"),
    "Standard Ranunculus": ("ranunculus", "standard"),
    "Butterfly Ranunculus": ("ranunculus", "butterfly"),
    "Mini Carnation": ("carnation", "mini"),
    "Gerbera Daisy": ("gerbera daisy", None),
    "Baby's Breath": ("baby's breath", None),
    "Bells of Ireland": ("bells of ireland", None),
    "Dried Baby's Breath": ("baby's breath", "dried"),
    "Snap Dragon": ("snapdragon", None),
}


def normalize_category(raw_cat):
    """Parse raw category into (stem_category, stem_subcategory)."""
    if raw_cat in CATEGORY_PARSE:
        return CATEGORY_PARSE[raw_cat]
    return (raw_cat.lower(), None)


def parse_stem_name(raw_cat, raw_name):
    """
    Parse a stem name like "Rose Cream - Candlelight" into:
    - color_hint: the primary color term
    - variety_name: the cultivar name
    - confidence: HIGH, MEDIUM, or LOW
    - issues: list of parsing notes
    """
    stem_cat, stem_subcat = normalize_category(raw_cat)

    # Remove the category prefix from the name
    name = raw_name.strip()

    # Try to remove category prefix
    prefixes_to_strip = [
        raw_cat, stem_cat.title(),
        "Rose", "Spray Rose", "Carnation", "Mini Carnation",
        "Delphinium", "Freesia", "Lisianthus", "Marigold",
        "Hypericum", "Larkspur", "Snapdragon", "Scabiosa",
        "Gerbera", "Godetia", "Anemone", "Astrantia",
        "Butterfly Ranunculus", "Ranunculus", "Craspedia",
        "Ornithogalum", "Thistle Eryngium", "Hydrangea",
        "Chrysanthemum", "Mum", "Gypsophila", "Orchid",
        "Cymbidium", "Mini Calla Lily", "Poppy",
        "Dried Pampas Grass", "Dried",
    ]

    remainder = name
    for prefix in sorted(prefixes_to_strip, key=len, reverse=True):
        if remainder.lower().startswith(prefix.lower()):
            remainder = remainder[len(prefix):].strip().lstrip('-').lstrip('_').strip()
            break

    color_hint = None
    variety_name = None
    confidence = "HIGH"
    issues = []

    # Pattern: "Color - Variety"
    if " - " in remainder:
        parts = remainder.split(" - ", 1)
        left = parts[0].strip()
        right = parts[1].strip()

        # Check if left is a color
        left_lower = left.lower().replace("/", " ").strip()
        # Try to match the first word(s) as a color
        color_candidate = _find_color(left_lower)
        if color_candidate:
            color_hint = color_candidate
            # Anything after the color in the left part goes to variety context
            variety_name = right.lower()
        else:
            # Left might be the color or something else
            # Check if right contains a color
            right_lower = right.lower()
            color_candidate = _find_color(right_lower)
            if color_candidate:
                color_hint = color_candidate
                variety_name = right_lower.replace(color_candidate, "").strip()
                if not variety_name:
                    variety_name = None
            else:
                # Neither side is clearly a color
                variety_name = right.lower()
                confidence = "MEDIUM"
                issues.append(f"No clear color in '{remainder}'")
    elif remainder:
        # No separator — try to decompose "Color Variety" or just "Color"
        remainder_lower = remainder.lower()
        color_candidate = _find_color(remainder_lower)
        if color_candidate:
            color_hint = color_candidate
            after_color = remainder_lower.replace(color_candidate, "", 1).strip()
            if after_color:
                variety_name = after_color
        else:
            # Could be just a variety name or something complex
            variety_name = remainder_lower if remainder_lower else None
            if variety_name:
                confidence = "MEDIUM"
                issues.append(f"No color found, treating as variety: '{variety_name}'")

    # Handle bicolor hints
    bicolor = False
    bicolor_colors = None
    if color_hint and "/" in (raw_name or ""):
        # Check for bicolor pattern like "Pink/White"
        pass  # Keep simple for now — flag for review

    # Clean up variety name
    if variety_name:
        # Remove parenthetical notes
        variety_name = re.sub(r'\(.*?\)', '', variety_name).strip()
        # Remove leading/trailing punctuation
        variety_name = variety_name.strip("-_. ")
        if not variety_name:
            variety_name = None

    return {
        "stem_category": stem_cat,
        "stem_subcategory": stem_subcat,
        "color_hint": color_hint,
        "variety_name": variety_name,
        "confidence": confidence,
        "issues": issues,
        "raw_name": raw_name,
        "raw_category": raw_cat,
    }


def _find_color(text):
    """Find the best color match in a text string using COLOR_MAP."""
    text = text.strip()
    # Try multi-word colors first (longest match first)
    sorted_colors = sorted(COLOR_MAP.keys(), key=len, reverse=True)
    for color_term in sorted_colors:
        if text == color_term or text.startswith(color_term + " ") or text.startswith(color_term):
            return COLOR_MAP[color_term]
    return None


def main():
    parsed_rows = []
    for raw_cat, raw_name in RAW_DATA:
        result = parse_stem_name(raw_cat, raw_name)
        parsed_rows.append(result)

    # ============================================================
    # Collect unique entities
    # ============================================================
    stems_seen = set()  # (category, subcategory)
    varieties_seen = set()
    confident_inserts = []
    needs_review = []

    for row in parsed_rows:
        key = (row["stem_category"], row["stem_subcategory"] or "")
        stems_seen.add(key)
        if row["variety_name"]:
            varieties_seen.add(row["variety_name"])

        if row["confidence"] == "HIGH":
            confident_inserts.append(row)
        else:
            needs_review.append(row)

    # ============================================================
    # Generate SQL
    # ============================================================
    sql_lines = []
    sql_lines.append("-- Auto-generated from Stem Pricing Master FLOWERS - MASTER")
    sql_lines.append("-- Source: 253 rows, all Preferred Vendor = Agrogana")
    sql_lines.append("")

    # Insert stems
    sql_lines.append("-- ============================================================")
    sql_lines.append("-- STEMS")
    sql_lines.append("-- ============================================================")
    for cat, subcat in sorted(stems_seen):
        subcat_val = f"'{subcat}'" if subcat else "NULL"
        sql_lines.append(
            f"INSERT INTO stems (stem_category, stem_subcategory) "
            f"VALUES ('{cat}', {subcat_val}) "
            f"ON CONFLICT (stem_category, COALESCE(stem_subcategory, '')) DO NOTHING;"
        )
    sql_lines.append("")

    # Insert varieties
    sql_lines.append("-- ============================================================")
    sql_lines.append("-- VARIETIES")
    sql_lines.append("-- ============================================================")
    for v in sorted(varieties_seen):
        escaped = v.replace("'", "''")
        sql_lines.append(
            f"INSERT INTO varieties (name) VALUES ('{escaped}') ON CONFLICT (name) DO NOTHING;"
        )
    sql_lines.append("")

    # Insert stem_varieties (link each variety to its stem)
    sql_lines.append("-- ============================================================")
    sql_lines.append("-- STEM_VARIETIES")
    sql_lines.append("-- ============================================================")
    seen_sv = set()
    for row in parsed_rows:
        if row["variety_name"]:
            sv_key = (row["stem_category"], row["stem_subcategory"] or "", row["variety_name"])
            if sv_key in seen_sv:
                continue
            seen_sv.add(sv_key)
            subcat_clause = f"stem_subcategory = '{row['stem_subcategory']}'" if row["stem_subcategory"] else "stem_subcategory IS NULL"
            escaped_var = row["variety_name"].replace("'", "''")
            sql_lines.append(
                f"INSERT INTO stem_varieties (stem_id, variety_id) "
                f"SELECT s.id, v.id FROM stems s, varieties v "
                f"WHERE s.stem_category = '{row['stem_category']}' AND s.{subcat_clause} "
                f"AND v.name = '{escaped_var}' "
                f"ON CONFLICT (stem_id, variety_id) DO NOTHING;"
            )
    sql_lines.append("")

    # Insert stem_color_categories (link each color to its stem)
    sql_lines.append("-- ============================================================")
    sql_lines.append("-- STEM_COLOR_CATEGORIES")
    sql_lines.append("-- ============================================================")
    seen_scc = set()
    for row in parsed_rows:
        if row["color_hint"]:
            scc_key = (row["stem_category"], row["stem_subcategory"] or "", row["color_hint"])
            if scc_key in seen_scc:
                continue
            seen_scc.add(scc_key)
            subcat_clause = f"stem_subcategory = '{row['stem_subcategory']}'" if row["stem_subcategory"] else "stem_subcategory IS NULL"
            sql_lines.append(
                f"INSERT INTO stem_color_categories (stem_id, color_type, primary_color_category_id) "
                f"SELECT s.id, 'single', cc.id FROM stems s, color_categories cc "
                f"WHERE s.stem_category = '{row['stem_category']}' AND s.{subcat_clause} "
                f"AND cc.name = '{row['color_hint']}' "
                f"ON CONFLICT DO NOTHING;"
            )
    sql_lines.append("")

    # Write SQL file
    sql_content = "\n".join(sql_lines)
    with open("scripts/insert-stems-master.sql", "w") as f:
        f.write(sql_content)

    # ============================================================
    # Stats
    # ============================================================
    print(f"Total rows: {len(parsed_rows)}")
    print(f"Unique stems (category+subcategory): {len(stems_seen)}")
    print(f"Unique varieties: {len(varieties_seen)}")
    print(f"Confident inserts: {len(confident_inserts)}")
    print(f"Needs review: {len(needs_review)}")
    print(f"\nSQL written to scripts/insert-stems-master.sql")

    # Write needs-review entries
    if needs_review:
        review_lines = ["# Needs Review — Stem Pricing Master\n"]
        review_lines.append(f"**Total items needing review:** {len(needs_review)}\n")
        review_lines.append("| Raw Category | Raw Name | Parsed Color | Parsed Variety | Issue |")
        review_lines.append("|---|---|---|---|---|")
        for row in needs_review:
            issues = "; ".join(row["issues"]) if row["issues"] else "—"
            color = row["color_hint"] or "—"
            variety = row["variety_name"] or "—"
            review_lines.append(f"| {row['raw_category']} | {row['raw_name']} | {color} | {variety} | {issues} |")

        review_content = "\n".join(review_lines)
        with open("outputs/2026-03-08/data-population/needs-review.md", "w") as f:
            f.write(review_content)
        print(f"\nReview file written to outputs/2026-03-08/data-population/needs-review.md")

    # Write confident inserts log
    confident_lines = ["# Confident Inserts — Stem Pricing Master\n"]
    confident_lines.append(f"**Total confident inserts:** {len(confident_inserts)}\n")
    confident_lines.append("| Stem | Color | Variety | Source |")
    confident_lines.append("|---|---|---|---|")
    for row in confident_inserts:
        stem = f"{row['stem_category']}" + (f" ({row['stem_subcategory']})" if row['stem_subcategory'] else "")
        color = row["color_hint"] or "—"
        variety = row["variety_name"] or "—"
        confident_lines.append(f"| {stem} | {color} | {variety} | {row['raw_name']} |")

    confident_content = "\n".join(confident_lines)
    with open("outputs/2026-03-08/data-population/confident-inserts.md", "w") as f:
        f.write(confident_content)
    print(f"Confident inserts written to outputs/2026-03-08/data-population/confident-inserts.md")


if __name__ == "__main__":
    main()
