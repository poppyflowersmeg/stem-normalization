# Backup — Colors Moved to Varieties (2026-03-09)

## What Changed

Colors were moved from stems to varieties. Previously `stem_color_categories` linked colors to stems (e.g., "rose has red"). Now `variety_color_categories` links colors to varieties (e.g., "Freedom rose is red, Vendela rose is white").

### Schema Changes
- **Created** `variety_color_categories` table (FK to `varieties` + `color_categories`)
- **Dropped** `stem_color_categories` table
- **Changed** `product_items.stem_color_category_id` → `product_items.variety_color_category_id`
- Migration: `supabase/migrations/20260309000000_move_colors_to_varieties.sql`

### Data Pipeline Changes
- `scripts/process-csvs.py`: `ensure_stem_color()` → `ensure_variety_color()`, updated all 7 processors
- Elite Roses bicolor sections now parsed (previously skipped) — 8 bicolor varieties extracted
- `ensure_product_item()` FK resolution updated to join through `variety_color_categories`

### Dashboard Changes
- Stems page: removed "Colors" column, variety chips now show inline color dot swatches
- Colors page: count label changed from "X stems" to "X varieties"
- Product Items page: color cell reads from `variety_color_categories`
- Varieties page: color swatches displayed next to variety names
- New CSS: `.color-dot` (8px inline swatch), `.variety-chip` (flex container)

## Database Counts (post-migration)

| Table | Count |
|-------|------:|
| stems | 212 |
| varieties | 1,868 |
| stem_varieties | 1,916 |
| variety_color_categories | 637 |
| product_items | 2,636 |
| color_categories | 30 (seed) |
| lengths | 7 (seed) |
| vendors | 8 (seed) |

## Verification Checks
- Freedom rose → red (single) ✅
- 8 bicolor varieties parsed from Elite (e.g., Paloma → white/pink, High & Magic → yellow/red) ✅
- TypeScript compiles with no errors ✅
- Migration applies cleanly on `supabase db reset` ✅

## Commit
- Hash: `752eaaa`
- Message: "Move colors from stems to varieties"
- Pushed to `origin/main`

## Files Modified

| File | Change |
|------|--------|
| `supabase/migrations/20260309000000_*` | New migration |
| `scripts/create-schema.sql` | `stem_color_categories` → `variety_color_categories` |
| `scripts/process-csvs.py` | `ensure_stem_color` → `ensure_variety_color`, bicolor handling |
| `scripts/insert-all-sources.sql` | Regenerated SQL |
| `stem-dashboard/src/lib/types.ts` | `StemColorCategory` → `VarietyColorCategory`, updated joined types |
| `stem-dashboard/src/hooks/useStems.ts` | Nested colors inside varieties in detail query |
| `stem-dashboard/src/hooks/useColors.ts` | Count relation updated |
| `stem-dashboard/src/hooks/useProductItems.ts` | FK and join references updated |
| `stem-dashboard/src/hooks/useVarieties.ts` | Added color data to variety queries |
| `stem-dashboard/src/pages/Stems.tsx` | Removed Colors column, variety chips with color dots |
| `stem-dashboard/src/pages/Colors.tsx` | "X varieties" label |
| `stem-dashboard/src/pages/ProductItems.tsx` | Color cell reads from new relation |
| `stem-dashboard/src/pages/Varieties.tsx` | Color swatches next to names |
| `stem-dashboard/src/index.css` | `.color-dot`, `.variety-chip` styles |
| `CLAUDE.md` | Added docker exec instructions for local DB |

## Known Issues / Next Steps
1. **Schema simplification under discussion**: Merging `stems` and `product_items` — stems *are* product items, with a `conventional_name` field for the generic name
2. `stem_lengths` still not populated (0 rows)
3. DV naming normalization (abbreviations like HPk, Wht) still imperfect
4. `scripts/parse-master-stems.py` and `scripts/insert-stems-master.sql` still reference old `stem_color_categories` (standalone scripts, not in main pipeline)
