# Phase 1: Reconnaissance & Inventory
**Run Date:** 2026-03-07

---

## Spreadsheet 1: DV x Poppy RFP
- **Source/Distributor:** DV (vendor) × Poppy (buyer)
- **File Title:** Copy of DV x Poppy RFP - Meg
- **Format:** Google Sheets
- **Tabs:** 4

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| DV_Pricing_Request_Final combined | Combined pricing request | ~800 | Stem Type, Poppy Product ID, Poppy Product Name, 2025 Overall Purchase Qty, Vendor Product Code, Vendor Product Name, Grade/Length, Price Per Stem, Price Per Bunch |
| Orig. Poppy list | Original Poppy product list | ~446 | Stem Type, Product ID, Product Name, Purchase Qty, Price Per Stem, Price Per Bunch, Pack Size |
| DV_ Additional | Additional DV offerings | ~1100 | Stem Type, Vendor Code, Vendor Name, Grade/Length, Price Per Stem, Price Per Bunch, Pack Size, Min Order |
| DV_Pricing_Request_FINAL not updated | Older version of pricing request | ~800 | Stem Type, Poppy Product ID, Poppy Product Name, 2025 Overall Purchase Qty, Vendor Product Code, Vendor Product Name, Grade/Length, Price Per Stem, Price Per Bunch, Bunch Size |

**Access Issues:** None.

---

## Spreadsheet 2: Elite x Poppy — Initial Program Specs (CORRECTED)
- **Source/Distributor:** Elite
- **File Title:** Copy of Elite x Poppy - Initial Program Specs
- **Format:** Google Sheets
- **Tabs:** 5

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| Pack Sizes | Packing standards by product type | ~25 | Product Type, Box Type, stems per box by length/grade |
| Combo Box | Combo box eligibility + location | ~26 | Category, Subcategory, Combo Box? (checkbox), Location |
| Freight | Box dimensions and freight costs | ~8 | Box Size, dimensions, Freight Cost, Combo Box Stem Count, Approx Stem Cost |
| S.O Fob Bog 2026 Roses | Rose pricing by color, variety, grade, length | ~150 | Color, Variety, Category (grade), 40cm, 50cm, 60cm, 70cm |
| S.O Fob Bog 2026 Other Product | Non-rose pricing (spray roses, alstro, carnations, fillers, greens) | ~160 | Section headers, Product/Variety, grade columns (vary by section) |

**Notes:** Roses tab has ~120 unique varieties organized by color (Red, White, Light Pink, Hot Pink, Orange, Peach, Cream, Yellow, Lavender, Bicolor, Green) with tiered pricing by stem length. Other Product tab has multiple sections with changing column semantics per product type.

**Access Issues:** None.

---

## Spreadsheet 3: Magic Pricing
- **Source/Distributor:** Magic (floral supplier — tropicals, bouquets, dried)
- **File Title:** Magic Pricing
- **Format:** Google Sheets
- **Tabs:** 1

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| Sheet1 | Multi-section pricing list | ~876 | Category (Bouquets/Tropical/Kits/Dried), Product Name, Design, Stem Length/cm, Length/inches, Box Type, Stems/Box, Stems/Bunch, Price By, DSD Fedex, DSD Fedex HIGH SEASON |

**Notes:** Sheet has 4 logical sections with slightly varying column semantics: Bouquets (~47 rows), Tropical Flowers (~372 rows), Kits & Combos (~391 rows), Dried & Preserved (~64 rows). Column headers change meaning by section (e.g., Column G = "units/Box" in Bouquets, "Stems/Box" in Tropicals).

**Access Issues:** None.

---

## Spreadsheet 4: Stem Cost Database
- **Source/Distributor:** Multi-distributor (Agrogana, Mayesh, Magic)
- **File Title:** Copy of Stem Cost Database - Meg
- **Format:** Google Sheets
- **Tabs:** 9

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| Summary | Cross-distributor cost comparison | ~67 | Stem Type, Agrogana $/Stem, Mayesh $/Stem, Magic $/Stem, Combined Cost |
| Agrogana | Agrogana product list | ~73 | Stem Type, VARIETY - GS, PRICE/UNIT - GS, PRICE/UNIT $, Last Updated |
| Mayesh | Mayesh product list (multi-branch) | >168 | Branch - GS, Stem Type, VARIETY - GS, PRICE/UNIT - GS, PRICE/UNIT $, Last Updated |
| Magic | Magic product list | ~38 | Species, Product, PRICE/UNIT - GS, Rate Per Units (USD $), Last Updated |
| Mayesh Freight Cost - WIP | Freight cost calculation | ~10 | Branch, Total Shipment Cost, Total Weight, Cost Per LB |
| Agrogana Availability 2025 | Availability feed | large | Date, Flower Category, Flower Variety |
| Agrogana Sub Request 2025 | Substitution requests | >26 | Week, Issue Stem Type, Issue Stem, Proposed stem 1, Proposed stem 2, Approval |
| RAW DATA - 2025 AVAILABILITY EMAILS | Unstructured email imports | >73 | (unstructured — variety lists from emails) |
| RAW DATA 2 - 2025 AVAILABILITY EMAILS | Secondary email imports | >73 | (unstructured — date/quantity/variety format) |

**Access Issues:** None. RAW DATA tabs are unstructured and may need special handling.

---

## Spreadsheet 5: Stem Pricing Master 2026
- **Source/Distributor:** Multi-distributor (Agrogana, Golden, Mayesh, Shaw Lake, Magic, etc.)
- **File Title:** Copy of STEM PRICING_MASTER 2026
- **Format:** Google Sheets
- **Tabs:** 11

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| ✅ FLOWERS - MASTER | Synthesized master stem list with costs | ~200 | Stem ID, Stem Category, Stem Name, Preferred Vendor, Agrogana Cost, Agrogana + Freight, Golden Cost, Golden + Freight |
| Agrogana Master List | Agrogana-specific pricing | ~70 | Supplier, Category, Item/Variety, Stem Cost, Shipping Cost/Stem, Total Cost/Stem, Min Stem Count |
| WIP - Q4 Stem Audit_December'25 | Cross-vendor audit workbook | hundreds | Stem ID, Stem Category, Stem Name, Basis, Preferred Vendor, Agrogana, Golden, Mayesh, Shaw Lake Farms, etc. |
| Standard Order Minimums | Vendor ordering rules | ~10 | Vendor, Stems Min, Boxes Min, Order Cost, Notes |
| Premium Order Minimums | Packaging/repack specs | small | Product, Vendor, Box Packs, Repack Available, Bunch Size, Bulk Discount |
| Coversheet_2026 | Title page | 1 | "Master Stem List As of January 2026" |
| Lists | Reference dropdowns | small | Vendors, Freight Bases |
| Freight Costs | Fee structure | small | Vendor, $/stem (~$0.33 for most) |
| Bulk Stem Tech Update Template | Import template | small | (template fields) |
| Sheet50 | Empty | 0 | — |
| (Coversheet) | Duplicate/alt title | — | — |

**Access Issues:** None. Sheet50 is empty (skip). Coversheet is metadata only.

---

## Spreadsheet 6: Metabase Raw Data — Quarterly Stem Use
- **Source/Distributor:** Multi-distributor (Agrogana, Shaw Lake Farm, Southern Smilax, Vivek Flowers, etc.)
- **File Title:** metabase raw data - 2025 quarterly stem use
- **Format:** Google Sheets
- **Tabs:** 1

| Tab | Purpose | ~Rows | Key Columns |
|-----|---------|------:|-------------|
| Sheet1 | Quarterly stem usage data export | ~3,316 | quarter, supplier, stem_name, stem_type, total_stems, quarterly_event, avg_stems_per, annual_total |

**Access Issues:** None. Some rows have blank `supplier` values.

---

## Inventory Summary

| # | Spreadsheet | Distributor(s) | Tabs | ~Total Rows | Type |
|---|-------------|----------------|-----:|------------:|------|
| 1 | DV x Poppy RFP | DV / Poppy | 4 | ~3,146 | Pricing request / catalog |
| 2 | Elite x Poppy Program Specs | Elite | 5 | ~370 | Program specs / pricing |
| 3 | Magic Pricing | Magic | 1 | ~876 | Pricing list (multi-section) |
| 4 | Stem Cost Database | Multi (Agrogana, Mayesh, Magic) | 9 | ~500+ | Cost comparison / availability |
| 5 | Stem Pricing Master 2026 | Multi (Agrogana, Golden, Mayesh, etc.) | 11 | ~300+ | Master pricing / audit |
| 6 | Metabase Raw Data | Multi (Agrogana, Shaw Lake, Vivek, etc.) | 1 | ~3,316 | Usage/consumption data |

**Total sheets to analyze:** 27 (excluding empty/metadata tabs)
**Total data rows (approx.):** ~8,000+
**Distributors identified:** DV, Poppy, Elite, Magic, Agrogana, Mayesh, Golden, Shaw Lake Farm, Southern Smilax, Vivek Flowers

---

## Observations & Flags

1. **Structural heterogeneity is high** — formats range from structured catalogs (Elite) to unstructured email dumps (Stem Cost DB RAW DATA tabs)
2. **Spreadsheets 4 & 5 are meta-files** — they already attempt cross-distributor comparison, meaning some normalization work has been done manually
3. **Spreadsheet 6 is usage data, not catalog data** — represents consumption patterns rather than available products; useful for weighting stem matches by importance
4. **Multiple naming conventions** for the same products across distributors (e.g., "Acacia Knifeblade" vs "Acacia Foliage - Pearl Silver")
5. **Magic Pricing has section-dependent column semantics** — the same column means different things in different rows
6. **RAW DATA tabs are unstructured** — will require special parsing or should be flagged as `UNPARSEABLE`
