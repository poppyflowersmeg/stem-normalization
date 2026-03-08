# Sheet Report: Magic Pricing

## File: Magic Pricing
**Distributor:** Magic

---

## Tab: Sheet1

- **Row Count:** ~876
- **Column Count:** 11
- **Apparent Purpose:** Multi-section pricing catalog covering Bouquets, Tropical Flowers, Kits/Combos, and Dried/Preserved products
- **Granularity:** One row = one product variant (within a section)

### Structural Complexity: HIGH

This sheet has **4 logical sections** sharing the same columns but with **different column semantics per section**:

| Section | Row Range | Products | Price Basis |
|---------|-----------|----------|-------------|
| Bouquets | ~1–47 | Round Bouquets, Flat Bouquets | Price per bouquet |
| Tropical Flowers | ~48–420 | Gingers, Musas, Heliconia, Anthurium, etc. | Price per stem |
| Kits & Combos | ~421–812 | Rouge Kit, Combo Box Fiesta, etc. | Price per box |
| Dried & Preserved | ~813–876 | Pampas, Palm, Jungle Apple, etc. | Price per stem |

### Column Analysis

| Column | Data Type | Fill Rate | Sample Values | Signal Rating | Match Key? |
|--------|-----------|-----------|---------------|---------------|------------|
| Category (A) | string | 100% | Bouquets, Tropical Flowers, Dried & Preserve, Kits | **HIGH** | Yes — section-level grouping |
| Product Name (B) | string | 100% | Ginger Nicole Pink, Musa Royal, Heliconia Sexy Pink, Dried Pampas Natural | **HIGH** | Yes — primary stem identifier |
| Design (C) | string | ~40% | See Catalog for, Mix Box, Best seller | LOW | No — marketing descriptor |
| Length cm (D) | numeric | ~80% | 55, 90, 15 | MEDIUM | Partial — size attribute for some matches |
| Length inches (E) | numeric | ~80% | 21.8, 35.7, 6.0 | NOISE | No — derived from cm |
| Box type (F) | string | ~90% | HB, HB-P16, BB, QB | NOISE | No — packaging |
| Units/Box or Stems/Box (G) | numeric | ~90% | 8, 36, 12, 150 | LOW | No — packaging |
| Stems/Bouquet or stems/bunch (H) | numeric | ~80% | 22-32, 3, 1, 10 | LOW | No — packaging |
| Price by (I) | string | 100% | "Price by bouquet", "Price by stem", "Price by box" | MEDIUM | No — but critical for price normalization |
| DSD Fedex (J) | currency | 100% | $18.88, $4.37, $10.25, $1.28 | NOISE | No — pricing |
| DSD Fedex HIGH SEASON (K) | currency | 100% | $21.31, $4.95, $11.52, $1.44 | NOISE | No — pricing |

### Data Quality Issues

| Type | Severity | Description | Affected Columns | Suggested Fix |
|------|----------|-------------|------------------|---------------|
| inconsistent_format | **CRITICAL** | Same columns (G, H) have different meanings across sections (Stems/Box vs units/Box vs stems/bunch) | G, H | Parse section headers to determine context; or split into separate tables by section |
| inconsistent_format | **HIGH** | Category names in column A change to section headers (e.g., "Tropical Flowers" appears as a header AND a category) | A | Distinguish section headers from product names during parsing |
| mixed_granularity | **HIGH** | Rows mix single stems (Tropical) with assembled bouquets and kit boxes — different levels of product abstraction | All | Separate by section; mark granularity level |

### Stem Matching Candidates

| Column | Confidence | Rationale | Preprocessing Needed |
|--------|------------|-----------|---------------------|
| Product Name | **HIGH** | Rich stem identifier with variety names | Lowercase, strip "Dried", "Fresh" prefixes, expand abbreviations |
| Category | MEDIUM | Section-level grouping; some overlap with other distributors' stem types | Map to canonical stem types (Ginger→Gingers, etc.) |

### Open Questions
- Are "Kits & Combos" in scope for stem matching? They contain assembled products, not individual stems.
- Some products span multiple sections — e.g., Pampas appears in both Dried and possibly Tropical. Is deduplication needed?
- Two pricing tiers (standard vs high season) — which should be used for cost comparison?
