# Phase 3: File Synthesis — Stem Cost Database

**File:** Copy of Stem Cost Database - Meg
**Distributors:** Agrogana, Mayesh, Magic
**Total Sheets:** 9
**Total Data Rows:** ~500+ (structured tabs) + unstructured RAW DATA

---

## Sheet Relationships

```
Summary (67 rows)
  ← Aggregates from ↓
  ├── Agrogana tab (73 rows)
  ├── Mayesh tab (168+ rows)
  └── Magic tab (38 rows)

Supporting data:
  ├── Mayesh Freight Cost - WIP (10 rows)
  ├── Agrogana Availability 2025 (large)
  ├── Agrogana Sub Request 2025 (26+ rows)
  └── RAW DATA tabs × 2 (UNPARSEABLE)
```

**Overall Assessment:** This is a **working comparison tool** built by the team. The Summary tab already attempts cross-distributor normalization manually. The vendor-specific tabs (Agrogana, Mayesh, Magic) are the raw inputs. The Agrogana Sub Request tab has unique value — it contains explicit substitution pairs that can validate stem matching.

---

## Primary Stem Columns per Vendor Tab

| Tab | Category Col | Name Col | Name Style |
|-----|-------------|----------|------------|
| Agrogana | Stem Type | VARIETY - GS | UPPERCASE: "ASTER WHITE" |
| Mayesh | Stem Type | VARIETY - GS | Mixed case: "Amaranthus Hanging Green" |
| Magic | Species | Product | UPPERCASE w/ size: "AMARANTHUS HANGING GREEN 60CM" |

---

## Normalization Challenges

- **Three different naming conventions** for the same products across tabs
- **Mayesh has branch-level duplication** — same product listed per branch location (Carlsbad, Miami)
- **"- GS" suffix** on column names suggests Google Sheets-specific formula/import system
- **Summary tab is derived data** — use vendor tabs as primary sources
- **Magic tab here has only 38 rows** vs the full Magic Pricing spreadsheet (876 rows) — this is a curated subset

---

## Recommended Schema Mapping → Database Tables

### Agrogana tab → `vendor_offerings` + `pricing`
| Field | Source | Transformation |
|-------|--------|---------------|
| vendor | (hardcoded: "Agrogana") | — |
| stem_category | Stem Type | Lowercase |
| stem_name | VARIETY - GS | Lowercase, trim |
| price_per_unit_local | PRICE/UNIT - GS | Original currency |
| price_per_unit_usd | PRICE/UNIT $ | float |
| last_updated | Last Updated | date |

### Mayesh tab → `vendor_offerings` + `pricing`
| Field | Source | Transformation |
|-------|--------|---------------|
| vendor | (hardcoded: "Mayesh") | — |
| branch | Branch - GS | Trim |
| stem_category | Stem Type | Lowercase |
| stem_name | VARIETY - GS | Lowercase, strip size suffixes |
| price_per_unit_usd | PRICE/UNIT $ | float |
| last_updated | Last Updated | date |

### Agrogana Sub Request → `stem_substitutions` table
| Field | Source | Transformation |
|-------|--------|---------------|
| week | Week | int |
| issue_stem_type | Issue Stem Type | Lowercase |
| issue_stem_name | Issue Stem | Lowercase |
| substitute_1 | Proposed stem 1 | Lowercase |
| substitute_2 | Proposed stem 2 | Lowercase |
| approved | Approval | boolean (OK → true) |

### RAW DATA tabs
**Status:** `UNPARSEABLE` — unstructured email imports. Skip for automated processing.
