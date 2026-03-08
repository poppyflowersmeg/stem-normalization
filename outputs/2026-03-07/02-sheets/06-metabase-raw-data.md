# Sheet Report: Metabase Raw Data — Quarterly Stem Use

## File: metabase raw data - 2025 quarterly stem use
**Source:** Metabase export (multi-supplier usage data)

---

## Tab: Sheet1

- **Row Count:** ~3,316
- **Column Count:** 8
- **Apparent Purpose:** Quarterly stem usage/consumption data across all suppliers
- **Granularity:** One row = one stem type per quarter per supplier

### Column Analysis

| Column | Data Type | Fill Rate | Cardinality | Sample Values | Signal Rating | Match Key? |
|--------|-----------|-----------|-------------|---------------|---------------|------------|
| quarter | numeric | 100% | 4 | 1, 2, 3, 4 | LOW | No — time dimension |
| supplier | string | ~95% | ~10 | Agrogana, Shaw Lake Farm, Vivek Flowers, Southern Smilax, (blank) | **HIGH** | Yes — maps to distributor |
| stem_name | string | 100% | HIGH (~500+) | Rose Blush - Poma Rosa, Rose Cream - Candlelight, White Pine Tips, Jasmine Hair Piece (CUSTOM) | **HIGH** | Yes — primary stem identifier |
| stem_type | string | 100% | LOW (~30) | Rose, Greenery, Garland | **HIGH** | Yes — category |
| total_stems | numeric | 100% | HIGH | 195, 1015, 20, 3, 2 | MEDIUM | No — but useful for weighting |
| quarterly_event | numeric | 100% | LOW | 641, 181, 672, 720 | LOW | No — event count |
| avg_stems_per | numeric | 100% | HIGH | 0.3042, 5.6077, 0.0312 | LOW | No — derived metric |
| annual_total | numeric | 100% | HIGH | 195, 9870, 20, 3, 2 | MEDIUM | No — but indicates product importance |

### Data Quality Issues

| Type | Severity | Description | Affected Columns | Suggested Fix |
|------|----------|-------------|------------------|---------------|
| missing_values | MEDIUM | ~5% of rows have blank/empty `supplier` | supplier | Investigate — may be internal/unassigned items |
| naming_inconsistency | MEDIUM | Stem names include custom modifiers like "(CUSTOM)" and sizing like "100 cm" | stem_name | Strip custom tags and size during normalization |
| duplicates | LOW | Same stem appears across multiple quarters (by design), and sometimes across multiple suppliers | stem_name | Expected — group by stem_name for deduplication |

### Stem Matching Candidates

| Column | Confidence | Rationale | Preprocessing Needed |
|--------|------------|-----------|---------------------|
| stem_name | **HIGH** | Contains variety-level product names; most detailed of the three signal columns | Lowercase, strip "(CUSTOM)", strip size info, trim |
| stem_type | **HIGH** | Category grouping; enables blocking during matching | Lowercase, map synonyms |
| supplier | MEDIUM | Useful for validating which distributors carry which stems | Standardize names (e.g., "Shaw Lake Farm" vs "Shaw Lake Farms") |

### Open Questions
- What causes blank `supplier` values? Are these internal/house products?
- The `quarterly_event` column meaning is unclear — is it the number of events in that quarter?
- Are "(CUSTOM)" tagged stems special orders that should be excluded from standard matching?

### Strategic Note
This is **consumption data, not catalog data**. It shows what stems are actually used and in what volume. This is extremely valuable for:
1. **Prioritizing matching** — focus on high-volume stems first
2. **Validating matches** — if a stem appears from Supplier X here but not in Supplier X's catalog, something is off
3. **Weighting confidence** — high-volume items warrant manual review if matching is uncertain
