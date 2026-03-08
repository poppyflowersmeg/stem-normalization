# Phase 3: File Synthesis — DV x Poppy RFP

**File:** Copy of DV x Poppy RFP - Meg
**Distributor:** DV (vendor side)
**Total Sheets:** 4
**Total Rows Across Sheets:** ~3,994

---

## Sheet Relationships

```
Tab 1: DV_Pricing_Request_Final combined (1,598 rows)
  ← Merges data from Tab 2 + Tab 3
  ← Supersedes Tab 4 (outdated version)

Tab 2: Orig. Poppy list (446 rows)
  = Poppy's demand/catalog (buyer-side)
  → Feeds into Tab 1 cols B-D

Tab 3: DV_ Additional (1,150 rows)
  = DV's full vendor offering (seller-side, no Poppy mapping)
  → Feeds into Tab 1 cols E-N

Tab 4: DV_Pricing_Request_FINAL not updated (800 rows)
  = DEPRECATED — older version of Tab 1
```

**Overall Assessment:** Tabs represent two sides of a buyer-seller negotiation. Tab 1 is the working join. Tab 3 is the richest source of DV products. Tab 2 shows Poppy's demand. Tab 4 should be ignored.

---

## Primary Stem Columns (ranked)

1. **Vendor Product Name** (Tab 1 col F, Tab 3 col F) — richest, most granular. ~1,200 unique. Examples: "Acacia Knifeblade", "Rose HPk Pk Floyd 60cm Cs5"
2. **Stem Type** (Tab 1 col A, Tab 3 col A) — category grouping, ~60 unique. Examples: "Acacia", "Rose", "Lisianthus"
3. **Poppy Product Name** (Tab 1 col C) — ~400 unique, but only 60% populated. Clean names where available.

---

## Normalization Challenges

- **No header row** on Tabs 2 and 3 — must infer from Tab 1 alignment
- **"unit of measure" inconsistency** — "Stem", "stem", "bunch", "Bu", "weighted" all present
- **Vendor names embed size info** — "Rose HPk Pk Floyd 60cm Cs5" needs parsing
- **Packed abbreviations** — "HPk" = Hot Pink, "Cs5" = Case of 5
- **Significant overlap** between Tab 1 and Tab 3 — need dedup strategy

---

## Recommended Schema Mapping → Database Tables

### → `stems` table
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| stem_category | Stem Type (A) | Lowercase, trim |
| stem_name | Vendor Product Name (F) | Lowercase, strip size/case suffixes, expand abbreviations |
| color | (extracted from name) | Regex: match color keywords |
| size_cm | (extracted from name) | Regex: extract "NNcm" pattern |

### → `vendor_offerings` table
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| vendor | (hardcoded: "DV") | — |
| vendor_sku | Vendor Product Code (E) | Trim |
| bunch_size | Bunch Size (J) | int |
| moq | MOQ (K) | int |
| unit_of_measure | unit of measure (N) | Normalize to: stem, bunch, weighted |
| source_country | Source Country (L) | Trim where available |

### → `pricing` table
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| price_per_stem | Price Per Stem (H) | float |
| price_per_bunch | Price Per Bunch (I) | float |
| pricing_tier | (hardcoded: "standard") | DV doesn't have seasonal tiers |

### → `buyer_demand` table (Poppy-specific)
| Field | Source Column | Transformation |
|-------|-------------|---------------|
| buyer_product_id | Poppy Product ID (B) | int |
| buyer_product_name | Poppy Product Name (C) | Trim |
| annual_purchase_qty | 2025 Overall Purchase Qty (D) | int |
