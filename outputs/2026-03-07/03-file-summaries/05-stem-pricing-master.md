# Phase 3: File Synthesis — Stem Pricing Master 2026

**File:** Copy of STEM PRICING_MASTER 2026
**Distributors:** Multi (Agrogana, Golden, Mayesh, Shaw Lake, Magic, Elite, etc.)
**Total Sheets:** 11
**Total Data Rows:** ~300+ (structured) + templates/metadata

---

## Sheet Relationships

```
✅ FLOWERS - MASTER (200 rows) ← Canonical source of truth
  ← Fed by:
  │   ├── Agrogana Master List (70 rows)
  │   ├── WIP - Q4 Stem Audit (hundreds of rows)
  │   └── Freight Costs (fee structure)
  │
  ├── Standard Order Minimums (10 rows) — vendor rules
  ├── Premium Order Minimums — packaging specs
  │
  └── Utility tabs:
      ├── Coversheet_2026 (title page only)
      ├── Lists (dropdown reference)
      ├── Freight Costs ($/stem per vendor)
      ├── Bulk Stem Tech Update Template
      └── Sheet50 (empty)
```

**Overall Assessment:** This is the **gold standard** file. The FLOWERS - MASTER tab contains the team's curated, normalized stem list with IDs — the closest thing to a canonical stem registry. The Q4 Audit tab provides the widest cross-vendor comparison. This file should inform (not just feed into) the universal schema.

---

## Primary Stem Columns

| Tab | ID Col | Category Col | Name Col | Extra |
|-----|--------|-------------|----------|-------|
| FLOWERS - MASTER | Stem ID | Stem Category | Stem Name | Preferred Vendor |
| Agrogana Master List | — | Category | Item/Variety | Stem Cost, Shipping, Total |
| Q4 Audit | Stem ID | Stem Category | Stem Name | Multi-vendor cost columns |

---

## Normalization Opportunities

- **Stem ID system already exists** — the team has assigned numeric IDs to ~200 products. These should become the seed for the `stems` table primary key.
- **MASTER tab has "Preferred Vendor"** — directly maps to a vendor preference relationship
- **Q4 Audit cross-references** the same Stem IDs against Agrogana, Golden, Mayesh, Shaw Lake, etc. — this is pre-built vendor-product mapping
- **Freight Costs tab** provides per-vendor $/stem rates — feed into a `vendor_freight` table

---

## Recommended Schema Mapping → Database Tables

### FLOWERS - MASTER → `stems` table (seed data)
| Field | Source | Transformation |
|-------|--------|---------------|
| stem_id | Stem ID | int (use as PK or seed) |
| stem_category | Stem Category | Lowercase |
| stem_name | Stem Name | Lowercase, trim |
| preferred_vendor | Preferred Vendor | FK → vendors |

### Q4 Audit → `vendor_offerings` (bulk join)
| Field | Source | Transformation |
|-------|--------|---------------|
| stem_id | Stem ID | FK → stems |
| vendor | (from column header) | One row per vendor per stem |
| price | (vendor column value) | float |
| basis | Basis | Normalize |

### Freight Costs → `vendor_freight` table
| Field | Source | Transformation |
|-------|--------|---------------|
| vendor | Vendor | Lowercase |
| freight_per_stem | $/stem | float |

### Order Minimums → `vendor_order_rules` table
| Field | Source | Transformation |
|-------|--------|---------------|
| vendor | Vendor Name | Lowercase |
| min_stems | Stems Min | int |
| min_boxes | Boxes Min | int |
| notes | Notes | Trim |
