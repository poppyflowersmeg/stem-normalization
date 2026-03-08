# Sheet Report: DV x Poppy RFP

## File: Copy of DV x Poppy RFP - Meg
**Distributor:** DV (vendor) / Poppy (buyer)

---

## Tab 1: DV_Pricing_Request_Final combined

- **Row Count:** 1,598
- **Column Count:** 14
- **Apparent Purpose:** Combined pricing request mapping Poppy products to DV vendor products
- **Granularity:** One row = one product variant (stem type + vendor offering)

### Column Analysis

| Column | Data Type | Fill Rate | Cardinality | Sample Values | Signal Rating | Signal Rationale | Match Key? |
|--------|-----------|-----------|-------------|---------------|---------------|------------------|------------|
| Stem Type | string | ~100% | LOW (~60) | Acacia, Alstroemeria, Rose, Lisianthus, Waxflower | **HIGH** | Product category — essential for grouping before matching | Yes |
| Poppy Product ID | numeric | ~60% | MEDIUM (~400) | 10007, 14788, 32 | MEDIUM | Buyer-side ID; useful for Poppy cross-reference but not cross-distributor | No |
| Poppy Product Name | string | ~60% | MEDIUM (~400) | Alstroemeria White, Amaranthus - Hanging Bronze | **HIGH** | Contains stem identity; only populated where Poppy has an existing product | Yes |
| 2025 Overall Purchase Qty | numeric | ~30% | LOW | 220, 50, 75 | LOW | Historical demand — useful for prioritization but not matching | No |
| Vendor Product Code | string | ~95% | HIGH (~1400) | G1203, G2037, 35473 | MEDIUM | DV-internal SKU; not usable cross-distributor without mapping | No |
| Vendor Product Name | string | ~95% | HIGH (~1200) | Acacia Knifeblade, Acacia Pearl, Rose HPk Pk Floyd 60cm | **HIGH** | Primary product identity from DV side; richest name data | Yes |
| Grade/Length | string | ~5% | LOW | (mostly empty) | LOW | Extremely sparse; minimal matching value | No |
| Price Per Stem | numeric | ~95% | HIGH | 0.9, 1.998, 0.61, 29.99, 0.799 | NOISE | Pricing — not identity data | No |
| Price Per Bunch | numeric | ~95% | HIGH | 9, 9.99, 6.1, 29.99, 7.99 | NOISE | Pricing — not identity data | No |
| Bunch Size | numeric | ~90% | LOW (~8) | 1, 5, 10, 25 | LOW | Packaging info; variant-level, not stem-level | No |
| MOQ | numeric | ~60% | LOW | 1, 50, 100 | NOISE | Order logistics | No |
| Source Country | string | ~5% | LOW | (mostly empty) | NOISE | Too sparse | No |
| Notes | string | ~10% | LOW | "WEIGHTED" | NOISE | Miscellaneous | No |
| unit of measure | string | ~90% | LOW (~4) | Stem, stem, bunch, Bu, weighted | LOW | Useful context for price interpretation but inconsistent | No |

### Data Quality Issues

| Type | Severity | Description | Affected Columns | Suggested Fix |
|------|----------|-------------|------------------|---------------|
| inconsistent_format | **HIGH** | Unit of measure uses 4+ variants for same concept: "Stem", "stem", "bunch", "Bu", "weighted" | unit of measure | Standardize to controlled vocabulary: {stem, bunch, weighted} |
| missing_values | MEDIUM | Poppy Product ID/Name are blank for ~40% of rows (items without existing Poppy mapping) | Poppy Product ID, Poppy Product Name | Expected — these are "Additional" vendor offerings. Use Vendor Product Name for matching |
| inconsistent_format | MEDIUM | Some vendor names include size info (e.g., "Rose HPk Pk Floyd 60cm Cs5") while others don't | Vendor Product Name | Parse out size/count suffixes during normalization |
| missing_values | LOW | Grade/Length and Source Country are almost entirely empty | Grade/Length, Source Country | Drop from canonical schema unless other distributors populate these |
| scattered_blanks | LOW | Blank rows at ~rows 48-50 and 1361-1365 | All | Strip blank rows during preprocessing |

### Stem Matching Candidates

| Column | Confidence | Rationale | Preprocessing Needed |
|--------|------------|-----------|---------------------|
| Stem Type | **HIGH** | Category grouping enables blocking (only compare within same stem type) | Lowercase, trim whitespace |
| Vendor Product Name | **HIGH** | Richest descriptor — contains stem identity, variety, sometimes color/size | Lowercase, strip size suffixes (e.g., "60cm", "Cs5"), expand abbreviations (HPk→Hot Pink) |
| Poppy Product Name | **HIGH** | Where populated, provides clean stem name matching | Lowercase, trim |

### Open Questions
- Are "Poppy Product ID" values stable across seasons, or do they change? This affects whether they can be used as a join key to other Poppy data.
- The "weighted" unit of measure appears on a few rows — what does this mean? Is it a pricing basis or a product type?

---

## Tab 2: Orig. Poppy list

- **Row Count:** ~446
- **Column Count:** ~10
- **Apparent Purpose:** Original Poppy product list (buyer's catalog before vendor mapping)
- **Granularity:** One row = one Poppy product
- **Note:** No explicit header row — headers inferred from data alignment with Tab 1

### Column Analysis (Abbreviated)

| Column | Signal Rating | Notes |
|--------|---------------|-------|
| Stem Type (A) | HIGH | Product category |
| Poppy Product ID (B) | MEDIUM | Buyer-side ID; ~100% populated here |
| Poppy Product Name (C) | HIGH | Clean stem names (e.g., "Acacia Foliage - Pearl Silver", "Amaranthus - Hanging Bronze") |
| 2025 Purchase Qty (D) | LOW | Demand quantity |
| Remaining cols (E-J) | LOW/NOISE | Mostly empty or price data |

### Data Quality Issues
- **No header row** — CRITICAL: requires manual header assignment before processing
- Data appears to be the original Poppy demand list before vendor mapping was done

---

## Tab 3: DV_ Additional

- **Row Count:** 1,150
- **Column Count:** 14 (inferred; no header row)
- **Apparent Purpose:** Supplementary DV vendor offerings not yet mapped to Poppy products
- **Granularity:** One row = one DV product offering

### Column Analysis (Abbreviated)

| Column | Signal Rating | Notes |
|--------|---------------|-------|
| Stem Type (A) | HIGH | ~100% fill; same categories as Tab 1 |
| B, C, D | NOISE | Entirely blank |
| Vendor Product Code (E) | MEDIUM | ~100% fill; DV-internal codes |
| Vendor Product Name (F) | **HIGH** | Primary product identifier (e.g., "Rose HPk Pk Floyd 60cm Cs5") |
| Price/Stem (H), Price/Bunch (I) | NOISE | Pricing data; mathematically consistent (H × J = I) |
| Bunch Size (J) | LOW | Pack info |
| Unit of measure (N) | LOW | Same inconsistency as Tab 1 |

### Data Quality Issues
- **No header row** — CRITICAL
- **Columns B-D entirely blank** — suggests this is a vendor-only extract without Poppy product mapping
- Significant overlap with Tab 1 expected but not confirmed

---

## Tab 4: DV_Pricing_Request_FINAL not updated

- **Row Count:** ~800
- **Apparent Purpose:** Older version of the pricing request (before the "combined" version)
- **Assessment:** Likely superseded by Tab 1. Should be used for reference only, not primary analysis.
- **Signal:** Skip for stem matching — use Tab 1 instead.
