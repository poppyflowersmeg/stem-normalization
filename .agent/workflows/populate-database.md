---
description: Create local postgres database with stem normalization schema and populate it from analyzed spreadsheet data
---

# Populate Stem Database Workflow

This workflow creates a local PostgreSQL database, applies the finalized stem normalization schema, and makes a first pass at populating it by analyzing the source spreadsheets. Confident data is inserted directly; ambiguous data is written to a review file.

## Prerequisites

- PostgreSQL is running locally (`brew services list | grep postgresql` to check)
- The user should have already run the `/stem-normalization-process` workflow (or equivalent) to generate analysis outputs under `outputs/`
- The finalized schema is defined in `scripts/create-schema.sql`
- Seed data is defined in `scripts/seed-data.sql`
- The spreadsheet URLs are listed in `spreadsheets.md`

## Inputs

- `spreadsheets.md` — list of Google Sheet URLs to process
- `outputs/` — existing analysis reports from the stem normalization workflow
- `scripts/create-schema.sql` — DDL for all tables
- `scripts/seed-data.sql` — static seed data (color categories, vendors, lengths)
- `color_categories.jpg` — Poppy's 30 color classification reference

## Outputs

- A local PostgreSQL database named `stem_normalization`
- `outputs/{date}/data-population/confident-inserts.md` — log of what was inserted and why
- `outputs/{date}/data-population/needs-review.md` — ambiguous data flagged for human review
- `outputs/{date}/data-population/population-summary.md` — overall statistics and coverage

---

## Workflow Steps

### Step 1: Verify PostgreSQL and Create Database

// turbo
1. Check that PostgreSQL is running:
   ```
   pg_isready
   ```
2. Check if the `stem_normalization` database already exists:
   ```
   psql -U "$USER" -lqt | cut -d \| -f 1 | grep -qw stem_normalization
   ```
3. If it does NOT exist, create it:
   ```
   createdb -U "$USER" stem_normalization
   ```
4. If it DOES exist, ask the user whether to drop and recreate or continue with existing.

### Step 2: Apply Schema

// turbo
1. Run the schema DDL:
   ```
   psql -U "$USER" -d stem_normalization -f scripts/create-schema.sql
   ```
2. Verify tables were created:
   ```
   psql -U "$USER" -d stem_normalization -c "\dt"
   ```
   Expected: 10 tables (vendors, vendor_locations, stems, color_categories, stem_color_categories, varieties, stem_varieties, lengths, stem_lengths, product_items)

### Step 3: Seed Static Data

// turbo
1. Run seed data:
   ```
   psql -U "$USER" -d stem_normalization -f scripts/seed-data.sql
   ```
2. Verify seed data was inserted:
   ```
   psql -U "$USER" -d stem_normalization -c "SELECT COUNT(*) AS color_count FROM color_categories; SELECT COUNT(*) AS vendor_count FROM vendors; SELECT COUNT(*) AS length_count FROM lengths;"
   ```
   Expected: 30 color categories, 8 vendors, 7 lengths

### Step 4: Create Output Directory

// turbo
1. Create the date-stamped output directory:
   ```
   mkdir -p outputs/$(date +%Y-%m-%d)/data-population
   ```

### Step 5: Read Analysis Context

Before processing spreadsheets, read the existing analysis outputs to understand the data landscape:

1. Read the schema reference: `product_items_analysis.md` artifact
2. Read the master synthesis: `outputs/*/04-master-synthesis.md`
3. Read all file summaries under `outputs/*/03-file-summaries/`
4. Read all sheet reports under `outputs/*/02-sheets/`

This gives you the column mappings, data quality issues, and matching strategy for each spreadsheet.

### Step 6: Process Stem Pricing Master (GOLD STANDARD — do first)

This is the most authoritative source. It has existing Stem IDs and a curated master list.

1. Open the Stem Pricing Master spreadsheet (URL #5 from spreadsheets.md) in the browser
2. Navigate to the "✅ FLOWERS - MASTER" tab
3. For each row, extract:
   - **Stem ID** → `stem_varieties.legacy_stem_id`
   - **Stem Category** → parse into `stem_category` + `stem_subcategory` (e.g., "Spray Rose" → category: "rose", subcategory: "spray")
   - **Stem Name** → parse into variety name (e.g., "Rose Cream - Candlelight" → variety: "candlelight", color_hint: "cream")
4. **Confidence rules:**
   - Stem Category is unambiguous (CONFIDENT) → insert into `stems`
   - Stem Name can be parsed into variety + color (CONFIDENT if clean, REVIEW if ambiguous)
   - Legacy Stem ID exists (CONFIDENT) → insert into `stem_varieties` with legacy_stem_id
5. Insert confident data via `psql` commands
6. Log ambiguous rows to `needs-review.md` with the reason (e.g., "Cannot parse variety from stem name 'Greenery Mixed'")

### Step 7: Process Elite x Poppy (second — cleanest structured data)

1. Open the Elite spreadsheet (CORRECTED URL from spreadsheets.md) in the browser
2. Process the **"S.O Fob Bog 2026 Roses"** tab:
   - For each color section, extract the section header → map to `color_categories`
   - For each row: Variety → `varieties` + `stem_varieties`, with stem = (rose, subcategory from Category column)
   - "Garden" in Category → `stem_subcategory = 'garden'`. Other categories (Premium, Super Premium, Novelties) are quality grades — ignore for now (deferred to vendor_logistics)
   - Available lengths (40, 50, 60, 70cm) → `stem_lengths` (only create entries where pricing exists, indicating availability)
   - Each variety+color+length combo → `product_items` with vendor = "Elite"
3. Process the **"S.O Fob Bog 2026 Other Product"** tab:
   - Section headers define `stem_category` (Spray Roses, Alstroemeria, Carnations, etc.)
   - Individual rows → variety + color where available
   - Spray roses: length-based entries (40, 50, 60cm)
   - Others: no length dimension
4. Process the **"Combo Box"** tab:
   - Category + Subcategory → validate/supplement `stems` entries
   - Location column → `vendor_locations` for Elite
5. **Confidence rules:**
   - Color section headers map directly to Poppy's color categories (CONFIDENT for exact matches, REVIEW for "Bicolor" or uncertain mappings)
   - Variety names are explicit (CONFIDENT)
   - Stem category/subcategory from section headers (CONFIDENT)

### Step 8: Process DV x Poppy RFP

1. Open the DV spreadsheet (URL #1 from spreadsheets.md) in the browser
2. Focus on the **"DV_Pricing_Request_Final combined"** tab:
   - **Stem Type** → parse into `stem_category` (+ subcategory if embedded, e.g., "Spray Rose")
   - **Vendor Product Name** → parse out color, variety, and length from the compound name (e.g., "Rose HPk Pk Floyd 60cm" → color: hot pink, variety: pink floyd, length: 60)
   - Apply the abbreviation dictionary from master-synthesis.md for name normalization
3. Also check the **"DV_ Additional"** tab for extra offerings
4. **Confidence rules:**
   - Stem Type is usually clean (CONFIDENT)
   - Vendor Product Name parsing is complex — names embed abbreviations, sizes, colors (MEDIUM confidence — log parsed components and insert if parser is confident, else REVIEW)
   - Matching to existing stems should be attempted: if a stem with same category+subcategory already exists, link to it; otherwise create new and flag for review as potentially duplicate

### Step 9: Process Magic Pricing

1. Open the Magic spreadsheet (URL #3 from spreadsheets.md) in the browser
2. Focus on **Tropical Flowers** and **Dried & Preserved** sections (these are individual stems)
3. Skip **Bouquets** and **Kits & Combos** sections (these are assembled products → deferred)
4. For each stem row:
   - Parse Product Name → stem_category, variety, color
   - Note: Magic names are relatively clean compared to DV
5. **Confidence rules:**
   - Section membership defines stem category (CONFIDENT)
   - Product names may need subcategory extraction (MEDIUM)
   - Two pricing tiers exist (standard vs high season) — defer pricing data per the todo plan

### Step 10: Process Stem Cost Database

1. Open the Stem Cost Database (URL #4 from spreadsheets.md) in the browser
2. Focus on the **Summary**, **Agrogana**, **Mayesh**, and **Magic** tabs
3. For each row:
   - Stem Type → `stem_category`
   - Variety → `varieties`
   - Cross-reference with existing stems to avoid duplicates
4. **Confidence rules:**
   - Summary tab entries are already normalized (HIGH confidence)
   - Agrogana/Mayesh tab variety names may use ALL CAPS or different naming conventions (MEDIUM — normalize and compare)
5. Skip RAW DATA tabs (unstructured)

### Step 11: Generate Population Summary

After processing all spreadsheets, generate a summary report:

1. Query the database for counts:
   ```sql
   SELECT 'stems' AS table_name, COUNT(*) FROM stems
   UNION ALL SELECT 'varieties', COUNT(*) FROM varieties
   UNION ALL SELECT 'stem_varieties', COUNT(*) FROM stem_varieties
   UNION ALL SELECT 'stem_color_categories', COUNT(*) FROM stem_color_categories
   UNION ALL SELECT 'stem_lengths', COUNT(*) FROM stem_lengths
   UNION ALL SELECT 'product_items', COUNT(*) FROM product_items;
   ```
2. Write `population-summary.md` with:
   - Total records per table
   - Coverage by vendor (how many product_items per vendor)
   - Coverage by category (how many stems per category)
   - Count of items in needs-review.md
   - Recommendations for next steps (manual review, matching verification)

### Step 12: Checkpoint — Present Results

Use `notify_user` to present:
1. The population summary report
2. The confident inserts log
3. The needs-review file for human verification

---

## Confidence Classification Rules

| Confidence | Threshold | Action |
|------------|-----------|--------|
| **HIGH** (insert) | Exact column mapping, unambiguous category, explicit variety name | Insert into database |
| **MEDIUM** (insert + flag) | Parsed from compound names, minor normalization needed, clear category match | Insert, but also log in confident-inserts.md with parsing details |
| **LOW** (review only) | Ambiguous parsing, potential duplicates, uncertain category/subcategory split, compound names that can't be reliably decomposed | Write to needs-review.md only |

## Error Handling

- If a spreadsheet URL fails to load, log the error and continue with other spreadsheets
- If a database insert fails due to constraint violation, log the row and continue
- If the browser times out during scrolling, note the last row processed and continue from there
- Never overwrite existing data without explicit user confirmation

## File Format: needs-review.md

```markdown
# Needs Review — Data Population

## Summary
- Total items needing review: {count}
- By source: ...

## Items

### Source: {spreadsheet name} — {tab name}

| Row | Raw Value | Parsed Category | Parsed Variety | Parsed Color | Issue |
|-----|-----------|-----------------|----------------|--------------|-------|
| 15  | "Rose HPk Pk Floyd 60cm" | rose | pink floyd | hot pink | Abbreviation parsing — verify color |
```
