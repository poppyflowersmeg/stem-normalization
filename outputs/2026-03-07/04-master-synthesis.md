# Phase 4: Cross-Distributor Master Synthesis

**Analysis Date:** 2026-03-07
**Total Distributors Analyzed:** 7 primary vendors + Poppy (buyer)
**Total Spreadsheets:** 6
**Total Data Rows:** ~8,000+

---

## Distributors Analyzed

| Distributor | Files | ~Total Rows | Complexity | Key Observation |
|-------------|------:|------------:|------------|-----------------|
| **DV** | 1 | ~2,748 | HIGH | Largest catalog; names embed size/abbreviations; no UPC |
| **Elite** | 1 | 565 | LOW | Cleanest structure; Category→Subcategory→Variety hierarchy; no SKU |
| **Magic** | 2 | ~914 | HIGH | Section-dependent semantics; two pricing tiers; mixed product types (stems + assembled) |
| **Agrogana** | 3 | ~216 | MEDIUM | UPPERCASE naming; multiple file appearances with different scopes |
| **Mayesh** | 2 | ~238 | MEDIUM | Branch-level duplication; size info in names |
| **Golden** | 1 | reference | LOW | Only appears as columns in the Q4 Audit; no standalone catalog |
| **Shaw Lake** | 1 | reference | LOW | Only in Q4 Audit + Metabase; niche supplier |
| **Vivek Flowers** | 1 | reference | LOW | Only in Metabase usage data; specialty items |

---

## Database Schema (Initial Migration Scope)

> See [Product Items Analysis](file:///Users/max/.gemini/antigravity/brain/994ebbfb-11ee-431d-9613-91c6b285a683/product_items_analysis.md) for full table definitions and ER diagram.

### Core Tables

| Table | Purpose |
|-------|---------|
| `stems` | Abstract product identity (category + subcategory) |
| `color_categories` | Poppy's 30 business-level color classifications |
| `stem_color_categories` | Junction: stem ↔ color (with bicolor support) |
| `varieties` | Named cultivars |
| `stem_varieties` | Junction: stem ↔ variety |
| `lengths` | Standard stem lengths (cm) |
| `stem_lengths` | Junction: stem ↔ length |
| `product_items` | Specific purchasable product (stem + color + variety + length + vendor) |
| `vendors` | Vendor registry (with vendor_type: farm/wholesaler) |
| `vendor_locations` | Vendor locations (Bogotá, Medellín, Miami, etc.) |

### Deferred (Todos)

| Todo | Tables | Link |
|------|--------|------|
| Vendor Operations | vendor_logistics, pricing, vendor_freight, vendor_order_rules | [vendor-operations.md](file:///Users/max/projects/stem-normalization/todos/vendor-operations.md) |
| Catalog & Display | category_display_rules, assembled_products | [catalog-display.md](file:///Users/max/projects/stem-normalization/todos/catalog-display.md) |
| Usage & Matching Data | stem_usage, stem_substitutions, buyer_demand | [usage-matching-data.md](file:///Users/max/projects/stem-normalization/todos/usage-matching-data.md) |

---

## Stem Matching Strategy

### The Challenge
No universal identifier (UPC, NDC, internal ID) exists across distributors. Matching depends entirely on **fuzzy name matching** aided by **category blocking**.

### Recommended Approach: Tiered Matching

#### Tier 1: Exact Category + Normalized Name Match
- Block by `stem_category` (only compare stems within the same category)
- Normalize names: lowercase, expand abbreviations, strip size/count/promotional suffixes
- Exact string match after normalization
- **Expected yield:** ~40-50% of matches
- **Confidence:** 95+ (auto-accept)

#### Tier 2: Fuzzy Name Match within Category
- TF-IDF cosine similarity on normalized product names, blocked by category
- Threshold ≥ 0.85 → auto-accept
- Threshold 0.70–0.84 → manual review
- **Expected yield:** ~25-30% additional matches
- **Confidence:** 80-94

#### Tier 3: Component Extraction Match
- Parse product names into structured components: `{category, variety, color, size}`
- Match on ≥3/4 components agreeing
- **Expected yield:** ~10-15% additional
- **Confidence:** 70-89

#### Tier 4: Substitution-Informed Match
- Use `stem_substitutions` table to link products the team already considers equivalent
- **Expected yield:** Small but high-confidence

#### Tier 5: Usage-Informed Cross-Reference
- If a stem appears in `stem_usage` from Supplier X, it should also appear in Supplier X's catalog
- Gaps suggest missing matches or unlisted products
- **Expected yield:** Validation, not new matches

### Preprocessing Pipeline

| Step | Operation | Example |
|------|-----------|---------|
| 1 | Strip whitespace, normalize Unicode | " Rose  " → "Rose" |
| 2 | Lowercase all text | "ASTER WHITE" → "aster white" |
| 3 | Expand abbreviations | "HPk" → "hot pink", "Bu" → "bunch" |
| 4 | Strip size suffixes | "60cm", "100 cm", "Cs5" → removed |
| 5 | Strip promotional/count suffixes | "Value Pack", "120ct" → removed |
| 6 | Normalize color terms | "Pk" → "pink", "Wh" → "white" |
| 7 | Standardize category names | "Chrysanthemum" ↔ "Mum", "Greenery" ↔ "Green" |
| 8 | Extract structured components | "Rose Cream Candlelight 60cm" → {rose, candlelight, cream, 60} |

### Abbreviation Dictionary (domain-specific)

| Abbreviation | Expansion |
|-------------|-----------|
| HPk / Hpk | Hot Pink |
| Pk | Pink |
| Wh | White |
| Cs / CS | Case |
| Bu | Bunch |
| Mum | Chrysanthemum |
| Alstro | Alstroemeria |
| Snap | Snapdragon |
| Hyp | Hypericum |

### Confidence Scoring

| Score | Action | Criteria |
|-------|--------|----------|
| 95–100 | Auto-accept | Exact name match after normalization |
| 85–94 | Auto-accept | TF-IDF ≥ 0.85 AND category match |
| 70–84 | Manual review | TF-IDF 0.70–0.84 OR component match with 1 mismatch |
| Below 70 | Reject | Insufficient evidence |

---

## Action Items

| Priority | Item |
|----------|------|
| 1 | Seed `stems` table from STEM PRICING MASTER → FLOWERS - MASTER (~200 rows) |
| 2 | Seed `color_categories` with 30 Poppy color categories |
| 3 | Import Elite Colombia catalog (cleanest data, well-structured) |
| 4 | Import DV catalog (largest, needs most preprocessing) |
| 5 | Import Magic individual stems (Tropical + Dried sections) |
| 6 | Import Agrogana/Mayesh from Stem Cost Database |
| 7 | Run Tier 1–3 matching to populate `stem_id` foreign keys |
| 8 | Manual review of Tier 2/3 matches with human input |
