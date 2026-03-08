# Sheet Report: Elite x Poppy — Initial Program Specs (CORRECTED)

> **Note:** This replaces the previous analysis of `Elite_Colombia_Pricing_Feb2026` which was the wrong spreadsheet.

**File:** Copy of Elite x Poppy - Initial Program Specs
**Distributor:** Elite
**Spreadsheet ID:** `1lVfGUsMHOSVOK0W5GmvwHi4l5q1SheVFyy3agoAkJKA`

---

## Tab Overview

| # | Tab Name | ~Rows | Purpose |
|---|----------|------:|---------|
| 1 | Pack Sizes | ~25 | Packing standards by product type |
| 2 | Combo Box | ~26 | Which categories are combo-box eligible + location |
| 3 | Freight | ~8 | Box dimensions and freight costs |
| 4 | S.O Fob Bog 2026 Roses | ~150 | **Rose pricing by color, variety, category, and stem length** |
| 5 | S.O Fob Bog 2026 Other Product | ~160 | **Non-rose pricing (spray roses, alstro, carnations, fillers, greens)** |

---

## Tab 1: Pack Sizes

- **Row Count:** ~25
- **Purpose:** Defines packing standards per product type and box type
- **Structure:** Multi-section (not flat table) — separate sections for Bulk Carns/Minis, Bulk Wayuu Roses, Bulk Wayuu Spray Roses, Bulk Wayuu Carnation
- **Key columns:** Product type, Box type, stems per box by length/grade

### Signal Assessment
| Column | Signal | Notes |
|--------|--------|-------|
| Product Type | MEDIUM | Defines pack-level products |
| Box Type | NOISE | Logistics (→ vendor_logistics todo) |
| Stems per box | NOISE | Logistics |

**Assessment:** Logistics/packaging data. Relevant for `vendor_logistics` todo, not stem identity.

---

## Tab 2: Combo Box

- **Row Count:** ~26
- **Purpose:** Combo box eligibility by category/subcategory
- **Columns:** Category, Subcategory, Combo Box? (checkbox), Location

### Sample Data

| Category | Subcategory | Combo Box? | Location |
|----------|-------------|:---:|----------|
| Alstroemeria | Florincas - Spray Alstro | ❌ | |
| Alstroemeria | Standard | ✅ | Bogotá |
| Chrysanthemum | Button | ✅ | Bogotá |

**Assessment:** Contains useful category → subcategory mapping AND production location (Bogotá). The subcategory values here are Elite's internal terms ("Florincas - Spray Alstro", "Button", "Santini") — need to map to our schema's `stem_subcategory`.

---

## Tab 3: Freight

- **Row Count:** ~8
- **Purpose:** Box dimension and freight cost reference
- **Columns:** Box Size, dimensions, Freight Cost, Combo Box Stem Count, Approx Stem Cost

**Assessment:** Logistics only. → `vendor_freight` / `vendor_logistics` todo.

---

## Tab 4: S.O Fob Bog 2026 Roses ⭐

- **Row Count:** ~150
- **Purpose:** Master rose pricing — FOB Bogotá, Standing Order prices for 2026
- **Structure:** Color-grouped sections with inline color headers

### Column Analysis

| Column | Data Type | Fill Rate | Cardinality | Signal Rating | Match Key? |
|--------|-----------|-----------|-------------|---------------|------------|
| Color | string (section header) | ~100% | ~15 | **HIGH** | Yes — maps to `color_categories` |
| Variety | string | 100% | ~120 | **HIGH** | Yes — primary cultivar name |
| Category | string | 100% | ~5 | **HIGH** | Yes — maps to quality tier/subcategory |
| 40cm | currency | ~90% | HIGH | NOISE | No — pricing (→ todo) |
| 50cm | currency | ~95% | HIGH | NOISE | No — pricing |
| 60cm | currency | ~95% | HIGH | NOISE | No — pricing |
| 70cm | currency | ~60% | HIGH | NOISE | No — pricing (not all varieties available at 70cm) |

### Colors Enumerated
Red, White, Light Pink, Hot Pink, Orange, Peach, Cream, Yellow, Lavender, Bicolor, Green

### Category (Grade) Values
| Category | Type | Notes |
|----------|------|-------|
| Premium | Standard tier | Most common |
| Super Premium | Higher tier | Larger/better blooms |
| Novelties | Premium/unusual | Higher price point |
| Garden | Garden roses | Distinct subcategory — separate stem type |

### Stem Matching Candidates

| Column | Confidence | Rationale | Preprocessing |
|--------|------------|-----------|---------------|
| Variety | **HIGH** | Primary cultivar name (~120 unique) | Lowercase, trim |
| Color | **HIGH** | Section-level grouping, maps to Poppy's color categories | Lowercase, map to 30 color categories |
| Category | MEDIUM | Quality tier — "Garden" is identity-level, others are grade | Separate "Garden" as subcategory; others → `grade` on vendor_logistics |

### Data Quality Issues

| Type | Severity | Description |
|------|----------|-------------|
| section_headers | MEDIUM | Color values are section headers, not per-row — need to propagate down during import |
| mixed_semantics | MEDIUM | "Category" column conflates quality grades (Premium/Super Premium) with product types (Garden). Garden roses ARE a different stem subcategory; Premium/Super Premium are NOT. |
| missing_70cm | LOW | Not all varieties have 70cm pricing (~60% fill) — some varieties aren't grown that tall |

---

## Tab 5: S.O Fob Bog 2026 Other Product ⭐

- **Row Count:** ~160
- **Purpose:** Non-rose pricing — multi-section with changing columns per section
- **Structure:** Multiple product sections, each with different grade/size columns

### Sections

| Section | Products | Price Columns | ~Rows |
|---------|----------|--------------|------:|
| Spray Roses Wayuu | Spray rose varieties by color | 40cm, 50cm, 60cm | ~30 |
| Alstroemeria Wayuu | Alstro by color | Incredible, Premium, Select, Fancy | ~15 |
| Carnations Wayuu | Standard + spray carnations | Select, Fancy, Standard | ~20 |
| Summer Flowers | Snapdragon, Stock, Sunflower, etc. | Premium, Select, Fancy | ~40 |
| Fillers | Aster, Hypericum, Statice, etc. | Premium, Select, Fancy | ~30 |
| Greens | Ruscus, Eucalyptus, etc. | Premium, Select, Fancy | ~20 |

### Key Observations

1. **Spray roses are priced by length** (40/50/60cm) — same as standard roses
2. **All other products are priced by grade** (Incredible/Premium/Select/Fancy) — not by length
3. **"Solid Colors and Custom Pack" rows** — aggregate pricing for any solid color in a category
4. **Individual variety rows** — specific cultivar names with per-grade pricing
5. **"Wayuu" designation** — appears to be Elite's Bogotá farm brand/line

### Stem Matching Candidates

| Column | Confidence | Preprocessing |
|--------|------------|---------------|
| Product/Variety name | **HIGH** | Lowercase, strip "Wayuu" branding |
| Section header (stem category) | **HIGH** | Map sections → stem_category |
| Color (within spray roses) | **HIGH** | Same as roses tab |

### Data Quality Issues

| Type | Severity | Description |
|------|----------|-------------|
| section_dependent_columns | **CRITICAL** | Column headers change per section — grade columns differ between Alstro (4 grades) and Carnations (3 grades) |
| inline_headers | MEDIUM | Section names are inline rows, not separate columns |
| wayuu_branding | LOW | "Wayuu" is Elite-specific branding — strip for matching |
