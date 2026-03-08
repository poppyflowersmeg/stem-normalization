# Sheet Report: Stem Cost Database

## File: Copy of Stem Cost Database - Meg
**Distributors:** Agrogana, Mayesh, Magic (multi-source)

---

## Tab 1: Summary

- **Row Count:** ~67
- **Column Count:** ~12 (grouped by distributor)
- **Apparent Purpose:** Cross-distributor cost comparison dashboard
- **Granularity:** One row = one stem type (aggregated)

### Column Analysis

| Column | Signal Rating | Notes |
|--------|---------------|-------|
| Stem Type (B) | **HIGH** | Category-level product grouping |
| Agrogana $/Stem (C) | NOISE | Pricing |
| Mayesh $/Stem (F) | NOISE | Pricing |
| Magic $/Stem (I) | NOISE | Pricing |
| Combined Cost (L) | NOISE | Calculated pricing |

**Assessment:** This is a **derived summary** tab — not raw data. Useful as a cross-reference/validation tool, but NOT a primary source for matching. The stem types listed here can serve as a controlled vocabulary.

---

## Tab 2: Agrogana

- **Row Count:** ~73
- **Column Count:** 5
- **Apparent Purpose:** Agrogana-specific product list with pricing
- **Granularity:** One row = one product variety

### Column Analysis

| Column | Data Type | Fill Rate | Signal Rating | Match Key? |
|--------|-----------|-----------|---------------|------------|
| Stem Type | string | 100% | **HIGH** | Yes |
| VARIETY - GS | string | 100% | **HIGH** | Yes — primary stem name (e.g., "ASTER WHITE", "GREEN WICKY") |
| PRICE/UNIT - GS | string | ~95% | NOISE | No — original currency |
| PRICE/UNIT $ | numeric | ~95% | NOISE | No — USD pricing |
| Last Updated | date | ~80% | NOISE | No — metadata |

**Data Quality:** Names are UPPERCASE and may include size info. Needs case normalization and parsing.

---

## Tab 3: Mayesh

- **Row Count:** >168
- **Column Count:** 6
- **Apparent Purpose:** Mayesh product list with branch-level detail
- **Granularity:** One row = one product variety per branch

### Column Analysis

| Column | Data Type | Fill Rate | Signal Rating | Match Key? |
|--------|-----------|-----------|---------------|------------|
| Branch - GS | string | 100% | LOW | No — logistics |
| Stem Type | string | 100% | **HIGH** | Yes |
| VARIETY - GS | string | 100% | **HIGH** | Yes — e.g., "Amaranthus Hanging Green", "Ruscus Italian Green 100 cm" |
| PRICE/UNIT - GS | string | ~95% | NOISE | No |
| PRICE/UNIT $ | numeric | ~95% | NOISE | No |
| Last Updated | date | ~80% | NOISE | No |

**Data Quality:** Branch creates duplicate rows for same product at different locations. Needs deduplication for matching. Names include size info (e.g., "100 cm").

---

## Tab 4: Magic

- **Row Count:** ~38
- **Column Count:** 5
- **Apparent Purpose:** Magic-specific product list
- **Granularity:** One row = one product

### Column Analysis

| Column | Data Type | Fill Rate | Signal Rating | Match Key? |
|--------|-----------|-----------|---------------|------------|
| Species | string | 100% | **HIGH** | Yes — maps to Stem Type |
| Product | string | 100% | **HIGH** | Yes — e.g., "AMARANTHUS HANGING GREEN 60CM", "ANTHURIUM ACROPOLIS WHITE LARGE 50CM" |
| PRICE/UNIT - GS | string | ~95% | NOISE | No |
| Rate Per Units (USD $) | numeric | ~95% | NOISE | No |
| Last Updated | date | ~80% | NOISE | No |

**Data Quality:** ALL CAPS product names with embedded size info. Needs case normalization and size extraction.

---

## Tab 5: Mayesh Freight Cost - WIP

- **Row Count:** ~10
- **Purpose:** Freight cost reference
- **Assessment:** Operational/logistics data. **Not relevant for stem matching.** Skip.

---

## Tab 6: Agrogana Availability 2025

- **Purpose:** Availability feed by date
- **Key Columns:** Date, Flower Category, Flower Variety
- **Assessment:** Time-series availability data. May be useful for validating which products are actively offered. Not primary matching data.

---

## Tab 7: Agrogana Sub Request 2025

- **Purpose:** Substitution tracking
- **Key Columns:** Week, Issue Stem, Proposed stem 1, Proposed stem 2, Approval
- **Assessment:** **High secondary value** — substitution pairs explicitly connect equivalent/similar stems. Can validate matching results.

---

## Tabs 8–9: RAW DATA - 2025 AVAILABILITY EMAILS

- **Purpose:** Unstructured email imports
- **Assessment:** `UNPARSEABLE` — no consistent column structure. Raw text with embedded variety lists. Skip for automated processing; may be useful for manual verification only.
