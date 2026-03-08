# Phase 3: File Synthesis — Elite x Poppy (CORRECTED)

> **Note:** Replaces previous synthesis of wrong spreadsheet (`Elite_Colombia_Pricing_Feb2026`).

**File:** Copy of Elite x Poppy - Initial Program Specs
**Distributor:** Elite
**Total Sheets:** 5
**Total Rows:** ~370

---

## Sheet Relationships

```
Pack Sizes (25 rows) — Packing standards
Combo Box (26 rows) — Combo eligibility + location
Freight (8 rows) — Box costs
S.O Fob Bog 2026 Roses (150 rows) ← Main rose catalog
S.O Fob Bog 2026 Other Product (160 rows) ← Non-rose catalog
```

**Overall Assessment:** This spreadsheet is structured as a **program spec** (not a raw catalog). It defines what Elite offers Poppy specifically, organized by product type with tiered pricing. The rose tab is the richest source, with ~120 unique varieties organized by color with per-length pricing. The "Other Product" tab covers spray roses, alstroemeria, carnations, summer flowers, fillers, and greens.

---

## Primary Stem Data (for initial migration)

### From Roses tab → `stems`, `stem_varieties`, `stem_color_categories`, `stem_lengths`, `product_items`

| Field | Source | Transformation |
|-------|--------|---------------|
| stem_category | (hardcoded: "rose") | All rows are roses |
| stem_subcategory | Category column | Map: "Garden" → subcategory. "Premium"/"Super Premium"/"Novelties" → grade (deferred to vendor_logistics) |
| variety_name | Variety column | Lowercase, trim |
| color_category | Color section header | Map to Poppy's 30 color categories |
| stem_length | 40cm, 50cm, 60cm, 70cm | One `stem_length` entry per available size |
| product_item_name | (compose) | e.g., "Red Freedom Rose 60cm" |
| vendor | (hardcoded: "Elite") | — |

### From Other Product tab → same tables

| Field | Source | Transformation |
|-------|--------|---------------|
| stem_category | Section header | Map: "Spray Roses Wayuu" → spray rose, "Alstroemeria Wayuu" → alstroemeria, etc. |
| stem_subcategory | (varies) | May need per-section logic |
| variety_name | Product/Variety name | Lowercase, strip "Wayuu" branding |
| color_category | (varies by section) | Spray roses: by color. Others: from product name |
| stem_length | 40/50/60cm (spray roses only) | Others don't have length |

### From Combo Box tab → `vendor_locations`

| Field | Source | Transformation |
|-------|--------|---------------|
| location_name | Location column | "Bogotá" → vendor_locations for Elite |

---

## Key Differences from Incorrect Spreadsheet

| Aspect | Old (wrong) | New (correct) |
|--------|------------|---------------|
| File name | Elite_Colombia_Pricing_Feb2026 | Elite x Poppy - Initial Program Specs |
| Structure | Single flat tab, 565 rows, 14 columns | 5 tabs, section-based pricing |
| Tabs | 1 | 5 (Pack Sizes, Combo Box, Freight, Roses, Other Product) |
| Rose varieties | Mixed into one table | ~120 varieties organized by color with per-length pricing |
| Non-roses | Mixed into same table | Separate tab with section-based layout |
| Pricing | Single price column | **Tiered by length** (roses/spray roses) or **by grade** (all others) |
| Grades | "Premium" / "Select" columns | Premium, Super Premium, Novelties, Garden, Incredible, Select, Fancy |
| Logistics | In same table | Dedicated Pack Sizes + Freight tabs |
