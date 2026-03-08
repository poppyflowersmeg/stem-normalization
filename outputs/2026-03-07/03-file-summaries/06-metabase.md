# Phase 3: File Synthesis — Metabase Raw Data

**File:** metabase raw data - 2025 quarterly stem use
**Source:** Metabase export (multi-supplier)
**Total Sheets:** 1
**Total Rows:** ~3,316

---

## Sheet Relationships

Single-tab export. No internal relationships.

**Overall Assessment:** This is **consumption data, not catalog data**. It shows which stems were actually used, at what volume, and from which suppliers across 4 quarters. This is the largest dataset by row count but serves a different purpose than the catalog/pricing sheets.

---

## Primary Stem Columns

1. **stem_name** — richest identifier. ~500+ unique. Examples: "Rose Blush - Poma Rosa", "Rose Cream - Candlelight", "White Pine Tips"
2. **stem_type** — category grouping. ~30 unique.
3. **supplier** — vendor attribution. ~10 unique.

---

## Unique Value of This File

- **Volume weighting** — `total_stems` and `annual_total` allow prioritizing high-use stems for matching
- **Supplier validation** — confirms which vendors supply which stems in practice
- **Coverage testing** — stems appearing here should also appear in vendor catalogs; gaps indicate data issues
- **~5% blank suppliers** — products without vendor attribution may be custom/internal

---

## Normalization Challenges

- **"(CUSTOM)" tags** on some stem names — e.g., "Jasmine Hair Piece (CUSTOM)"
- **Size info embedded in names** — "Ruscus Italian Green 100 cm"
- **Supplier name variants** — "Shaw Lake Farm" vs "Shaw Lake Farms" (check against other files)
- **Quarterly granularity** — same stem appears up to 4 times (one per quarter); needs aggregation for annual view

---

## Recommended Schema Mapping → Database Tables

### → `stem_usage` table
| Field | Source | Transformation |
|-------|--------|---------------|
| stem_name | stem_name | Lowercase, strip "(CUSTOM)", strip size |
| stem_type | stem_type | Lowercase |
| supplier | supplier | Normalize vendor names |
| quarter | quarter | int |
| total_stems | total_stems | int |
| quarterly_events | quarterly_event | int |
| avg_stems_per_event | avg_stems_per | float |
| annual_total | annual_total | int |
| is_custom | (derived from "(CUSTOM)" in name) | boolean |
