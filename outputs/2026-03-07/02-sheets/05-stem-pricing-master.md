# Sheet Report: Stem Pricing Master 2026

## File: Copy of STEM PRICING_MASTER 2026
**Distributors:** Multi-vendor (Agrogana, Golden, Mayesh, Shaw Lake, Magic, Elite, etc.)

---

## Tab 1: ✅ FLOWERS - MASTER

- **Row Count:** ~200
- **Column Count:** ~10+
- **Apparent Purpose:** Synthesized master stem list — the "source of truth" with calculated costs including freight
- **Granularity:** One row = one preferred stem product

### Column Analysis

| Column | Data Type | Fill Rate | Signal Rating | Match Key? |
|--------|-----------|-----------|---------------|------------|
| Stem ID | numeric | ~100% | **HIGH** | Yes — internal product ID system |
| Stem Category | string | ~100% | **HIGH** | Yes — product grouping |
| Stem Name | string | ~100% | **HIGH** | Yes — primary product identity |
| Preferred Vendor | string | ~100% | MEDIUM | No — vendor preference, not identity |
| Agrogana (Cost) | numeric | varies | NOISE | No |
| Agrogana + Freight | numeric | varies | NOISE | No |
| Golden (Cost) | numeric | varies | NOISE | No |
| Golden + Freight | numeric | varies | NOISE | No |
| (Other vendor columns) | numeric | varies | NOISE | No |

**Assessment:** This is the **most valuable cross-reference** in the entire dataset. It already contains normalized stem names with IDs. Use as a **gold standard** for validating matches and as a canonical seed for the normalized schema.

---

## Tab 2: Agrogana Master List

- **Row Count:** ~70
- **Apparent Purpose:** Agrogana pricing input feed
- **Key signal columns:** Supplier, Category, Item/Variety, Stem Cost, Shipping Cost/Stem, Total Cost/Stem, Min Stem Count
- **Assessment:** Source data feeding into the MASTER tab. Match candidates: Category + Item/Variety.

---

## Tab 3: WIP - Q4 Stem Audit_December'25

- **Row Count:** Hundreds
- **Apparent Purpose:** Wide-format cross-vendor audit comparing costs
- **Key signal columns:** Stem ID, Stem Category, Stem Name, Basis, Preferred Vendor, then one column per vendor (Agrogana, Golden, Mayesh, Shaw Lake, etc.)
- **Assessment:** **Very high value** — contains the widest vendor coverage and explicit multi-vendor pricing for the same stems. The Stem ID column can link to the MASTER tab.

---

## Tab 4: Standard Order Minimums

- **Row Count:** ~10
- **Purpose:** Vendor ordering rules
- **Assessment:** Operational data. Not relevant for stem matching. Skip.

---

## Tab 5: Premium Order Minimums

- **Purpose:** Packaging/repack specs by product type
- **Assessment:** May help disambiguate pack-level vs stem-level products. Reference only.

---

## Tabs 6–11: Utility Tabs

| Tab | Purpose | Matching Value |
|-----|---------|---------------|
| Coversheet_2026 | Title page | None |
| Lists | Vendor/freight base dropdowns | Reference for vendor name standardization |
| Freight Costs | Per-vendor $/stem freight | Reference only |
| Bulk Stem Tech Update Template | Import template | Structure reference only |
| Sheet50 | Empty | None |

---

### Data Quality Issues

| Type | Severity | Description | Affected Tabs |
|------|----------|-------------|---------------|
| data_overlap | **HIGH** | MASTER tab and Q4 Audit tab contain overlapping but not identical stem lists | MASTER, Q4 Audit |
| naming_inconsistency | MEDIUM | Stem names may differ slightly between MASTER and vendor-specific lists | All vendor tabs |
| missing_coverage | MEDIUM | Some vendors have limited data in this file (vendor columns mostly blank) | Q4 Audit |
