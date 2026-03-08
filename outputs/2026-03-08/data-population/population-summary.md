# Population Summary — 2026-03-08

## Database Counts

| Table | Count | Notes |
|-------|------:|-------|
| stems | 141 | Unique (stem_category, stem_subcategory) combos |
| color_categories | 30 | Poppy's 30-color classification (seed data) |
| varieties | 1,214 | Named cultivars across all sources |
| lengths | 7 | 40, 50, 60, 70, 80, 90, 100 cm (seed data) |
| vendors | 8 | DV, Elite, Magic, Agrogana, Mayesh, Golden, Shaw Lake, Vivek (seed) |
| vendor_locations | 1 | Elite → Bogotá |
| stem_varieties | 1,197 | Stem ↔ variety links |
| stem_color_categories | 526 | Stem ↔ color links |
| stem_lengths | 0 | Not yet populated (requires per-stem length mapping) |
| product_items | 399 | Purchasable products (DV vendor) |

## Coverage by Source

| Source | Stems | Varieties | Colors | Product Items |
|--------|------:|----------:|-------:|--------------:|
| Stem Pricing Master (FLOWERS) | 32 | 199 | 98 | — |
| Elite Roses | +roses (merged) | +85 | +colors | 0 (FK issue) |
| Elite Other Product | +64 categories | +64 | varies | 0 (FK issue) |
| DV x Poppy RFP | +~100 categories | +~900 | +~400 | 399 |
| Stem Cost Summary | 0 (empty CSV) | — | — | — |

## Top Stem Categories (by variety count)

| Category | Subcategory | Variety Count |
|----------|-------------|-------------:|
| rose | — | 281 |
| carnation | — | 78 |
| greenery | — | 77 |
| pompon | — | 72 |
| lily | — | 64 |
| rose | spray | 63 |
| chrysanthemum | — | 46 |
| hydrangea | — | 40 |
| gerbera | — | 40 |
| specialty ranunculus | — | 30 |
| rose | garden | 29 |
| delphinum | — | 29 |
| dendrobium | — | 18 |

## Confidence Report

| Rating | Count | Action |
|--------|------:|--------|
| **Confident** | 1,746 | Inserted into database |
| **Needs Review** | 9 | Written to needs-review.md |

## Known Issues

1. **Elite product_items = 0**: The product_item INSERT uses JOINs on stem_color_categories that require an exact match. Elite roses were inserted as stems/varieties/colors, but the product_item multi-table JOIN didn't resolve correctly. Fix: simplify the INSERT or use a two-pass approach.
2. **stem_lengths = 0**: Length data exists in the spreadsheets (40/50/60/70cm pricing columns) but the processing pipeline skipped stem_length linking. This is lower priority since lengths are simple to add.
3. **Stem Cost Summary = 0 rows**: The Summary CSV had a different structure than expected. Needs investigation.
4. **DV naming normalization**: DV product names embed abbreviations (HPk = Hot Pink, Wht = White). Some color/variety parsing may be inaccurate.
5. **Bicolor roses**: 9 Elite varieties in bicolor sections (Bicolor White-Pink, etc.) were flagged for review rather than inserted.

## Next Steps

1. Fix Elite product_item inserts (simplify FK resolution)
2. Populate `stem_lengths` from pricing column headers
3. Process remaining CSVs: `Orig_Poppy_list`, `DV_Additional`, `Agrogana`, `Mayesh`, `Magic`
4. Run deduplication pass on varieties (e.g., "freedom" from DV and "freedom" from Elite = same variety)
5. Manual review of 9 flagged items
6. Migrate to Supabase once data is validated
