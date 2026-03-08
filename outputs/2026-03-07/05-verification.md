# Phase 5: Self-Verification

**Verification Date:** 2026-03-07

---

## 1. Schema Completeness Audit

### Columns Mapped vs Excluded

| Distributor | Total Cols | Mapped | Excluded | Excluded Columns & Reason |
|-------------|-----------|--------|----------|--------------------------|
| DV | 14 | 10 | 4 | Grade/Length (5% fill), Source Country (5% fill), Notes (misc), MOQ (→ vendor_offerings) |
| Elite | 14 | 12 | 2 | Combo_Box (binary flag → box_type), Notes (misc) |
| Magic | 11 | 9 | 2 | Length/inches (derived from cm), Design (marketing) |
| Agrogana | 5 | 5 | 0 | All mapped |
| Mayesh | 6 | 6 | 0 | All mapped |
| Magic (Cost DB) | 5 | 5 | 0 | All mapped |
| Metabase | 8 | 8 | 0 | All mapped |
| Master | 10+ | 10+ | 0 | All mapped (utility tabs properly skipped) |

**Verdict:** ✅ No meaningful data columns were excluded from the schema. Excluded columns are either derived (inches from cm), extremely sparse (<5% fill), or miscellaneous notes.

---

## 2. Match Key Coverage

### Primary match key: `stem_category` + `stem_name` (normalized)

| Distributor | stem_category fill | stem_name fill | Combined usable % |
|-------------|-------------------|----------------|-------------------|
| DV | ~100% (Stem Type) | ~95% (Vendor Product Name) | **~95%** ✅ |
| Elite | 100% (Category) | 100% (Variety) | **100%** ✅ |
| Magic | ~100% (Category/section) | ~100% (Product Name) | **~100%** ✅ |
| Agrogana | 100% (Stem Type) | 100% (VARIETY - GS) | **100%** ✅ |
| Mayesh | 100% (Stem Type) | 100% (VARIETY - GS) | **100%** ✅ |
| Metabase | 100% (stem_type) | 100% (stem_name) | **100%** ✅ |
| Master | ~100% (Stem Category) | ~100% (Stem Name) | **~100%** ✅ |

**Verdict:** ✅ All distributors have >95% coverage on primary match keys. No distributor falls below the 80% threshold.

### Secondary/fallback keys: `color`, `size_cm`

| Distributor | color available | size_cm available |
|-------------|----------------|-------------------|
| DV | Embedded in name (~50%) | Embedded in name (~30%) |
| Elite | 100% (dedicated column) | ~40% (roses only) |
| Magic | Embedded in name (~40%) | ~80% (Length cm) |
| Agrogana | Embedded in name (~30%) | Rarely |
| Mayesh | Embedded in name (~30%) | Embedded in name (~20%) |
| Metabase | Embedded in name (~30%) | Embedded in name (~10%) |

**Verdict:** ⚠️ Color and size are secondary keys. They're mostly embedded in product names and must be extracted via regex. Only Elite has a dedicated `Color` column.

---

## 3. Cross-Check: 3-Product Trace

### Product 1: Amaranthus Hanging Green

**How it appears in each source:**

| Source | Raw Value | After Preprocessing |
|--------|-----------|-------------------|
| DV (Tab 3) | "Amaranthus Hanging Green" | amaranthus hanging green |
| Stem Cost DB (Agrogana) | "AMARANTHUS HANGING GREEN" | amaranthus hanging green |
| Stem Cost DB (Mayesh) | "Amaranthus Hanging Green" | amaranthus hanging green |
| Stem Cost DB (Magic) | "AMARANTHUS HANGING GREEN 60CM" | amaranthus hanging green |
| Metabase | "Amaranthus Hanging Green" | amaranthus hanging green |

**Match result:** ✅ **Tier 1 exact match** after preprocessing (lowercase + strip size suffix "60CM"). All 5 sources converge. Confidence: **98**.

---

### Product 2: Rose (a specific variety)

**How "Rose Cream - Candlelight" appears:**

| Source | Raw Value | After Preprocessing |
|--------|-----------|-------------------|
| DV (Tab 1) | "Rose Cream Candlelight 60cm" | rose cream candlelight |
| Metabase | "Rose Cream - Candlelight" | rose cream candlelight |
| Master | "Rose Cream - Candlelight" | rose cream candlelight |
| Elite | Category: "Rose", Variety: "Candlelight", Color: "Cream" | {rose, candlelight, cream} |

**Match result:**
- DV ↔ Metabase ↔ Master: ✅ **Tier 1** after stripping size suffix and dash. Confidence: **95**.
- DV ↔ Elite: ✅ **Tier 3 component match** — 3/3 components match (category=rose, variety=candlelight, color=cream). Confidence: **88**.
- Note: Elite's structured format (separate Variety + Color columns) requires component extraction from other sources' concatenated names.

---

### Product 3: Heliconia Sexy Pink

**How it appears:**

| Source | Raw Value | After Preprocessing |
|--------|-----------|-------------------|
| Magic (Pricing) | "Heliconia Sexy Pink" (Tropical section) | heliconia sexy pink |
| DV (Tab 1) | "Heliconia Sexy Pink" | heliconia sexy pink |

**Match result:** ✅ **Tier 1 exact match**. Confidence: **98**.

**Not found in:** Elite (they don't carry tropicals), Agrogana, Mayesh (may not carry tropicals).

**Gap analysis:** This product's absence from Stem Cost Database and Master suggests it's a newer or niche item. The Metabase usage data should be checked to see if it has purchase history.

---

## 4. Confidence Assessment

### Overall Confidence: **MEDIUM-HIGH**

| Aspect | Confidence | Rationale |
|--------|------------|-----------|
| Schema design | **HIGH** | 10-table design covers all identified data types; relational structure supports the user's database goal |
| Column mapping completeness | **HIGH** | >95% of meaningful columns mapped; nothing important excluded |
| Match key coverage | **HIGH** | All distributors >95% fill on primary match keys |
| Matching strategy | **MEDIUM** | No UPC/universal IDs means relying on fuzzy name matching; works well for common stems (Tier 1) but will produce uncertain results for ambiguous names |
| Name normalization | **MEDIUM** | Abbreviation dictionary is preliminary; needs expansion as real matching reveals missed patterns |
| Assembled products separation | **HIGH** | Clean separation via `product_type` field and `assembled_products` table |
| Pricing tiers | **HIGH** | `pricing` table correctly decouples tiers; only Magic has `high_season` currently |

### What Would Increase Confidence

1. **Access to UPC/barcode data** from any vendor → would enable Tier 0 exact ID matching
2. **Running a pilot match** on 50 stems to calibrate TF-IDF threshold and abbreviation dictionary
3. **Feedback on Elite's Subcategory terms** — are "Elevate", "Garden" industry-standard or proprietary?
4. **Resolving blank suppliers** in Metabase data (~5% of rows)
5. **Confirming overlap** between DV Tabs 1 and 3 — do they share products, or are they strictly complementary?

---

## 5. Unresolved Questions

| # | Question | Impact | Blocking? |
|---|----------|--------|-----------|
| 1 | What does "weighted" mean as a unit of measure in DV data? | Affects price normalization | No |
| 2 | Are Poppy Product IDs stable across seasons? | Affects buyer_demand table longevity | No |
| 3 | Are Elite Subcategory terms ("Elevate", "Garden") industry terms or proprietary? | Affects cross-distributor category mapping | No |
| 4 | Should "(CUSTOM)" items in Metabase be excluded from standard matching? | Affects matching scope | No |
| 5 | Is there overlap between DV Tab 1 and Tab 3? | Affects dedup strategy | Minor |
| 6 | The "- GS" suffix on Stem Cost DB column names — is this a Google Sheets format indicator? | Minor — doesn't affect data | No |
| 7 | Will additional distributors be added in the future? | Affects schema extensibility (currently extensible) | No |

**None of the unresolved questions are blocking.** All can be addressed during implementation.
