# Phase 3: File Synthesis — Magic Pricing

**File:** Magic Pricing
**Distributor:** Magic
**Total Sheets:** 1
**Total Rows:** ~876

---

## Sheet Relationships

Single-tab, but with **4 logical sections** using inline section headers:

| Section | Row Range | ~Rows | Product Type | Price Basis |
|---------|-----------|-------|-------------|-------------|
| Bouquets | 1–47 | ~47 | Assembled product | Per bouquet |
| Tropical Flowers | 48–420 | ~372 | Individual stems | Per stem |
| Kits & Combos | 421–812 | ~391 | Assembled product | Per box |
| Dried & Preserved | 813–876 | ~64 | Individual stems | Per stem |

**Overall Assessment:** Structurally the most complex file. Section headers are embedded inline. Column semantics change per section. Two pricing tiers (standard + high season). Contains both individual stems AND assembled products — per user direction, these should be broken out into separate tables.

---

## Primary Stem Columns (ranked)

1. **Product Name** — primary identifier. "Ginger Nicole Pink", "Heliconia Sexy Pink", "Dried Pampas Fat Natural"
2. **Category** — section-level grouping. "Tropical Flowers", "Bouquets", "Dried & Preserve"
3. **Length cm** — size attribute. 55, 90, 15

---

## Normalization Challenges

- **Section-dependent column semantics** — Column G = "units/Box" in Bouquets, "Stems/Box" in Tropicals
- **Mixed product granularity** — rows describe individual stems, assembled bouquets, AND kit boxes
- **Inline section headers** — some rows are headers, not data; need to filter during import
- **Two pricing tiers** — standard (DSD Fedex) and HIGH SEASON

---

## Recommended Schema Mapping → Database Tables

### → `stems` table (Tropical + Dried sections only)
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| stem_category | Category (A) | Lowercase |
| stem_name | Product Name (B) | Lowercase, strip "Dried" prefix for cross-matching |
| size_cm | Length cm (D) | int |
| product_type | (derived from section) | "stem" for Tropical/Dried, "assembled" for Bouquets/Kits |

### → `assembled_products` table (Bouquets + Kits sections)
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| product_name | Product Name (B) | Lowercase |
| product_type | (derived from section) | "bouquet" or "kit" |
| design | Design (C) | Trim |
| stems_per_unit | stems/bouquet (H) | int |
| units_per_box | units/Box (G) | int |

### → `vendor_offerings` table
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| vendor | (hardcoded: "Magic") | — |
| box_type | Box type (F) | Trim |
| stems_per_box | Stems/Box (G) | int (context-dependent) |
| stems_per_bunch | stems/bunch (H) | int (context-dependent) |
| price_basis | Price by (I) | Normalize: stem, bouquet, box |

### → `pricing` table (two rows per product)
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| price | DSD Fedex (J) | float for "standard" tier |
| price | DSD Fedex HIGH SEASON (K) | float for "high_season" tier |
| pricing_tier | — | "standard" or "high_season" |
