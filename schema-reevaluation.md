# Schema Redesign: Simplified Product Catalog with Vendor Offerings

## Context

The current schema has too many tables and indirection. `product_items` treats each vendor's listing as a separate product, `varieties` is a separate table joined through `stem_varieties`, and colors live on a `variety_color_categories` junction table. The user wants a simpler model where `stems` IS the product catalog, variety is denormalized onto stems, and vendors link to products through offerings.

Key domain insight: varieties commonly come in multiple colors (e.g., "reef" comes in 7 colors), so color must remain a separate relationship, not a column on stems.

## New Schema (6 tables, down from 10)

### `stems` — the product catalog
```sql
CREATE TABLE stems (
  id               SERIAL PRIMARY KEY,
  category         VARCHAR(100) NOT NULL,
  subcategory      VARCHAR(100),
  variety          VARCHAR(100),
  name             VARCHAR(255) NOT NULL,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_stems_unique
  ON stems (category, COALESCE(subcategory, ''), COALESCE(variety, ''));
```
- Denormalizes variety as a column (was separate `varieties` + `stem_varieties` tables)
- `name` is a display name for the catalog entry
- `variety` is nullable (some items are just "greenery" with no cultivar)

### `color_categories` — unchanged reference table
```sql
CREATE TABLE color_categories (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(50) NOT NULL UNIQUE,
  hex_code   VARCHAR(7),
  sort_order INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### `stem_colors` — which colors each stem comes in
```sql
CREATE TABLE stem_colors (
  id                          SERIAL PRIMARY KEY,
  stem_id                     INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  color_type                  VARCHAR(20) NOT NULL CHECK (color_type IN ('single', 'bicolor')),
  primary_color_category_id   INT NOT NULL REFERENCES color_categories(id),
  secondary_color_category_id INT REFERENCES color_categories(id),
  bicolor_type                VARCHAR(30) CHECK (bicolor_type IN ('variegated', 'fade', 'tipped', 'striped')),
  secondary_color_searchable  BOOLEAN DEFAULT FALSE,
  created_at                  TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT check_bicolor CHECK (
    (color_type = 'single' AND secondary_color_category_id IS NULL AND bicolor_type IS NULL)
    OR
    (color_type = 'bicolor' AND secondary_color_category_id IS NOT NULL AND bicolor_type IS NOT NULL)
  )
);
CREATE UNIQUE INDEX idx_stem_colors_unique
  ON stem_colors (stem_id, color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0));
```
- Replaces `variety_color_categories` (same structure, references stems instead of varieties)
- Preserves bicolor support (type, primary, secondary, pattern)

### `vendors` — unchanged
```sql
CREATE TABLE vendors (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL UNIQUE,
  vendor_type VARCHAR(20) NOT NULL CHECK (vendor_type IN ('farm', 'wholesaler')),
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### `vendor_locations` — unchanged
```sql
CREATE TABLE vendor_locations (
  id            SERIAL PRIMARY KEY,
  vendor_id     INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  location_name VARCHAR(100) NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (vendor_id, location_name)
);
```

### `vendor_offerings` — what each vendor sells
```sql
CREATE TABLE vendor_offerings (
  id               SERIAL PRIMARY KEY,
  stem_id          INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  stem_color_id    INT REFERENCES stem_colors(id) ON DELETE SET NULL,
  vendor_id        INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  length_cm        INT,
  vendor_item_name VARCHAR(255) NOT NULL,
  vendor_sku       VARCHAR(50),
  is_active        BOOLEAN DEFAULT TRUE,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (stem_id, vendor_id, COALESCE(stem_color_id, 0), COALESCE(length_cm, 0))
);
CREATE INDEX idx_vendor_offerings_stem ON vendor_offerings(stem_id);
CREATE INDEX idx_vendor_offerings_vendor ON vendor_offerings(vendor_id);
CREATE INDEX idx_vendor_offerings_color ON vendor_offerings(stem_color_id);
```
- `length_cm` is a raw integer (no FK to lengths table)
- `stem_color_id` references which color variant the vendor carries
- Unique constraint prevents duplicate offerings for the same stem+vendor+color+length

### Tables DROPPED (5)
| Table | Reason |
|-------|--------|
| `varieties` | Denormalized as column on `stems` |
| `stem_varieties` | No longer needed (was junction table) |
| `variety_color_categories` | Replaced by `stem_colors` |
| `stem_lengths` | Was empty; lengths now raw int on `vendor_offerings` |
| `lengths` | No longer needed; `length_cm` is a raw integer |
| `product_items` | Replaced by `vendor_offerings` |

## Migration Strategy

Single migration file: `supabase/migrations/20260310000000_simplified_catalog.sql`

### Phase 1: Rebuild `stems` table
- Add `variety` and `name` columns to `stems`
- Populate `variety` from `stem_varieties` → `varieties` join
- Populate `name` from the most common `product_item_name` or construct as "category variety"
- Remove duplicates (same category+subcategory+variety)

### Phase 2: Create `stem_colors`
- Create table with same structure as `variety_color_categories`
- Populate by mapping old `variety_color_categories.variety_id` → `stem_varieties.stem_id` → new `stems.id`

### Phase 3: Create `vendor_offerings`
- Create table
- Populate from `product_items`, mapping old `stem_id` + `stem_variety_id` to new merged `stems.id`
- Map `variety_color_category_id` to new `stem_color_id`
- Set `length_cm` from any parseable length in product names (or NULL)

### Phase 4: Drop old tables
- Drop `product_items`, `stem_lengths`, `lengths`, `stem_varieties`, `varieties`, `variety_color_categories`

### Phase 5: RLS policies on new tables

## Frontend Updates

### Files to modify

| File | Changes |
|------|---------|
| `src/lib/types.ts` | Remove: ProductItem, ProductItemWithRelations, StemLength, StemVariety, Variety, VarietyColorCategory, Length, LengthWithCount, VarietyWithStems, VarietyWithColors. Add: StemColor, VendorOffering, VendorOfferingWithRelations. Update: Stem (add variety, name), StemWithCounts (vendor_offerings count) |
| `src/hooks/useProductItems.ts` | Rewrite as `useVendorOfferings.ts` — query `vendor_offerings` with nested `stems`, `stem_colors → color_categories`, `vendors` |
| `src/hooks/useStems.ts` | Update to include variety, name columns; count `vendor_offerings` instead of `product_items` |
| `src/hooks/useColors.ts` | Change `variety_color_categories` count to `stem_colors` count |
| `src/hooks/useVendors.ts` | Change `product_items` count to `vendor_offerings` count |
| `src/hooks/useVarieties.ts` | DELETE — varieties are now on stems |
| `src/hooks/useLengths.ts` | DELETE — lengths table removed |
| `src/pages/ProductItems.tsx` | Rewrite as `Products.tsx` — shows vendor_offerings grouped/filterable by stem, color, vendor, length |
| `src/pages/Stems.tsx` | Update to show variety column, vendor_offerings count |
| `src/pages/Varieties.tsx` | DELETE — merged into Stems page |
| `src/pages/Lengths.tsx` | DELETE — no longer a standalone entity |
| `src/pages/Colors.tsx` | Update count reference from `variety_color_categories` to `stem_colors` |
| `src/pages/Vendors.tsx` | Update count reference from `product_items` to `vendor_offerings` |
| `src/App.tsx` | Remove Varieties and Lengths routes; rename ProductItems route |
| `src/components/Layout.tsx` | Remove Varieties and Lengths nav links; rename "Product Items" to "Products" |

## Implementation Order

1. Backup current database (`db-dump-pre-migration.sql`)
2. Write and run the database migration
3. Verify migration: row counts, data integrity
4. Backup post-migration database
5. Update TypeScript types (`types.ts`)
6. Update/create hooks (useVendorOfferings, useStems, useColors, useVendors)
7. Delete unused hooks (useVarieties, useLengths, useProductItems)
8. Update/create pages (Products, Stems, Colors, Vendors)
9. Delete unused pages (Varieties, Lengths)
10. Update App.tsx routing and Layout.tsx navigation
11. Verify in browser — navigate all pages, test search/filter/CRUD

## Verification

- Migration: `SELECT count(*) FROM vendor_offerings` should equal 2628 (old product_items count)
- `SELECT count(*) FROM stems` should be <= old stems count + old varieties count (deduplicated)
- `SELECT count(*) FROM stem_colors` should approximate old `variety_color_categories` count (637)
- Start dev server, navigate each page, confirm data loads
- Test search/filter on Products page (by stem, color, vendor)
- Test CRUD operations
- Verify Stems page shows varieties inline with color dots
