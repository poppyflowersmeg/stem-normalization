-- ============================================================
-- Migration: Simplified Product Catalog with Vendor Offerings
-- Reduces 10 tables → 6 tables
-- ============================================================

BEGIN;

-- ============================================================
-- PHASE 0: Fix stems sequence (it's behind the max id)
-- ============================================================
SELECT setval('stems_id_seq', (SELECT COALESCE(max(id), 0) FROM stems));

-- ============================================================
-- PHASE 1: Rebuild stems table
-- Add variety and name columns, populate from joined data
-- ============================================================

-- Add new columns
ALTER TABLE stems ADD COLUMN variety VARCHAR(100);
ALTER TABLE stems ADD COLUMN name VARCHAR(255);

-- Temporarily drop the unique index so we can restructure
DROP INDEX IF EXISTS idx_stems_category_subcategory;

-- Step 1a: Update existing stems that have exactly one variety via stem_varieties
-- (set variety and name from the variety data)
UPDATE stems s
SET variety = v.name,
    name = CASE
      WHEN s.stem_subcategory IS NOT NULL
        THEN s.stem_category || ' ' || s.stem_subcategory || ' ' || v.name
      ELSE s.stem_category || ' ' || v.name
    END
FROM stem_varieties sv
JOIN varieties v ON v.id = sv.variety_id
WHERE sv.stem_id = s.id
  -- Only for stems with exactly one variety (handled separately below for multi)
  AND (SELECT count(*) FROM stem_varieties sv2 WHERE sv2.stem_id = s.id) = 1;

-- Step 1b: For stems with MULTIPLE varieties, we need to create new stem rows.
-- First, create a temp table mapping old stem_variety combos to new stem rows.
CREATE TEMP TABLE stem_variety_map AS
SELECT
  sv.id AS old_stem_variety_id,
  sv.stem_id AS old_stem_id,
  sv.variety_id AS old_variety_id,
  s.stem_category,
  s.stem_subcategory,
  v.name AS variety_name,
  NULL::int AS new_stem_id
FROM stem_varieties sv
JOIN stems s ON s.id = sv.stem_id
JOIN varieties v ON v.id = sv.variety_id
WHERE (SELECT count(*) FROM stem_varieties sv2 WHERE sv2.stem_id = sv.stem_id) > 1;

-- Insert new stem rows for multi-variety stems
INSERT INTO stems (stem_category, stem_subcategory, variety, name)
SELECT DISTINCT
  svm.stem_category,
  svm.stem_subcategory,
  svm.variety_name,
  CASE
    WHEN svm.stem_subcategory IS NOT NULL
      THEN svm.stem_category || ' ' || svm.stem_subcategory || ' ' || svm.variety_name
    ELSE svm.stem_category || ' ' || svm.variety_name
  END
FROM stem_variety_map svm;

-- Update the map with the new stem IDs
UPDATE stem_variety_map svm
SET new_stem_id = ns.id
FROM stems ns
WHERE ns.stem_category = svm.stem_category
  AND COALESCE(ns.stem_subcategory, '') = COALESCE(svm.stem_subcategory, '')
  AND ns.variety = svm.variety_name;

-- Step 1c: Handle orphan varieties (in varieties table but NOT in stem_varieties)
-- that have color categories. We create stems for these too.
INSERT INTO stems (stem_category, variety, name)
SELECT DISTINCT
  'uncategorized',
  v.name,
  v.name
FROM varieties v
WHERE NOT EXISTS (SELECT 1 FROM stem_varieties sv WHERE sv.variety_id = v.id)
  AND EXISTS (SELECT 1 FROM variety_color_categories vcc WHERE vcc.variety_id = v.id);

-- Step 1d: Stems without ANY variety get name from stem_category
UPDATE stems
SET name = CASE
    WHEN stem_subcategory IS NOT NULL
      THEN stem_category || ' ' || stem_subcategory
    ELSE stem_category
  END
WHERE variety IS NULL AND name IS NULL;

-- Make name NOT NULL now that all rows have values
ALTER TABLE stems ALTER COLUMN name SET NOT NULL;

-- Rename columns: stem_category → category, stem_subcategory → subcategory
ALTER TABLE stems RENAME COLUMN stem_category TO category;
ALTER TABLE stems RENAME COLUMN stem_subcategory TO subcategory;

-- Create the new unique index
CREATE UNIQUE INDEX idx_stems_unique
  ON stems (category, COALESCE(subcategory, ''), COALESCE(variety, ''));


-- ============================================================
-- PHASE 2: Create stem_colors
-- Map variety_color_categories → stem_colors
-- ============================================================

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

-- Step 2a: Insert colors for stems that had single varieties (stem still has same ID)
INSERT INTO stem_colors (stem_id, color_type, primary_color_category_id, secondary_color_category_id, bicolor_type, secondary_color_searchable)
SELECT DISTINCT
  sv.stem_id,
  vcc.color_type,
  vcc.primary_color_category_id,
  vcc.secondary_color_category_id,
  vcc.bicolor_type,
  vcc.secondary_color_searchable
FROM variety_color_categories vcc
JOIN stem_varieties sv ON sv.variety_id = vcc.variety_id
WHERE (SELECT count(*) FROM stem_varieties sv2 WHERE sv2.stem_id = sv.stem_id) = 1
ON CONFLICT DO NOTHING;

-- Step 2b: Insert colors for multi-variety stems (need to use the new stem IDs)
INSERT INTO stem_colors (stem_id, color_type, primary_color_category_id, secondary_color_category_id, bicolor_type, secondary_color_searchable)
SELECT DISTINCT
  svm.new_stem_id,
  vcc.color_type,
  vcc.primary_color_category_id,
  vcc.secondary_color_category_id,
  vcc.bicolor_type,
  vcc.secondary_color_searchable
FROM variety_color_categories vcc
JOIN stem_variety_map svm ON svm.old_variety_id = vcc.variety_id
WHERE svm.new_stem_id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Step 2c: Insert colors for orphan varieties (mapped to 'uncategorized' stems)
INSERT INTO stem_colors (stem_id, color_type, primary_color_category_id, secondary_color_category_id, bicolor_type, secondary_color_searchable)
SELECT DISTINCT
  ns.id,
  vcc.color_type,
  vcc.primary_color_category_id,
  vcc.secondary_color_category_id,
  vcc.bicolor_type,
  vcc.secondary_color_searchable
FROM variety_color_categories vcc
JOIN varieties v ON v.id = vcc.variety_id
JOIN stems ns ON ns.category = 'uncategorized' AND ns.variety = v.name
WHERE NOT EXISTS (SELECT 1 FROM stem_varieties sv WHERE sv.variety_id = v.id)
ON CONFLICT DO NOTHING;


-- ============================================================
-- PHASE 3: Create vendor_offerings
-- Map product_items → vendor_offerings
-- ============================================================

CREATE TABLE vendor_offerings (
  id               SERIAL PRIMARY KEY,
  stem_id          INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  stem_color_id    INT REFERENCES stem_colors(id) ON DELETE SET NULL,
  vendor_id        INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  length_cm        INT,
  vendor_item_name VARCHAR(255) NOT NULL,
  vendor_sku       VARCHAR(50),
  is_active        BOOLEAN DEFAULT TRUE,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_vendor_offerings_stem ON vendor_offerings(stem_id);
CREATE INDEX idx_vendor_offerings_vendor ON vendor_offerings(vendor_id);
CREATE INDEX idx_vendor_offerings_color ON vendor_offerings(stem_color_id);

-- Step 3a: Product items with single-variety stems (stem_id unchanged)
INSERT INTO vendor_offerings (stem_id, stem_color_id, vendor_id, vendor_item_name, vendor_sku)
SELECT
  pi.stem_id,
  sc.id,
  pi.vendor_id,
  pi.product_item_name,
  pi.vendor_sku
FROM product_items pi
LEFT JOIN stem_colors sc ON sc.stem_id = pi.stem_id
  AND EXISTS (
    SELECT 1 FROM variety_color_categories vcc
    WHERE vcc.id = pi.variety_color_category_id
      AND vcc.color_type = sc.color_type
      AND vcc.primary_color_category_id = sc.primary_color_category_id
      AND COALESCE(vcc.secondary_color_category_id, 0) = COALESCE(sc.secondary_color_category_id, 0)
  )
WHERE pi.stem_variety_id IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM stem_varieties sv
    WHERE sv.id = pi.stem_variety_id
      AND (SELECT count(*) FROM stem_varieties sv2 WHERE sv2.stem_id = sv.stem_id) = 1
  );

-- Step 3b: Product items from multi-variety stems (need new stem IDs)
INSERT INTO vendor_offerings (stem_id, stem_color_id, vendor_id, vendor_item_name, vendor_sku)
SELECT
  svm.new_stem_id,
  sc.id,
  pi.vendor_id,
  pi.product_item_name,
  pi.vendor_sku
FROM product_items pi
JOIN stem_variety_map svm ON svm.old_stem_variety_id = pi.stem_variety_id
LEFT JOIN stem_colors sc ON sc.stem_id = svm.new_stem_id
  AND EXISTS (
    SELECT 1 FROM variety_color_categories vcc
    WHERE vcc.id = pi.variety_color_category_id
      AND vcc.color_type = sc.color_type
      AND vcc.primary_color_category_id = sc.primary_color_category_id
      AND COALESCE(vcc.secondary_color_category_id, 0) = COALESCE(sc.secondary_color_category_id, 0)
  )
WHERE svm.new_stem_id IS NOT NULL;

-- Step 3c: Product items with NO variety (stem_variety_id IS NULL)
-- These keep their original stem_id (which has variety=NULL)
INSERT INTO vendor_offerings (stem_id, stem_color_id, vendor_id, vendor_item_name, vendor_sku)
SELECT
  pi.stem_id,
  NULL,
  pi.vendor_id,
  pi.product_item_name,
  pi.vendor_sku
FROM product_items pi
WHERE pi.stem_variety_id IS NULL;

-- Note: No unique constraint on vendor_offerings — a vendor can have multiple offerings
-- for the same stem+color+length (e.g. different pack sizes, different names)


-- ============================================================
-- PHASE 4: Drop old tables
-- ============================================================

DROP TABLE IF EXISTS product_items CASCADE;
DROP TABLE IF EXISTS stem_lengths CASCADE;
DROP TABLE IF EXISTS stem_varieties CASCADE;
DROP TABLE IF EXISTS variety_color_categories CASCADE;
DROP TABLE IF EXISTS varieties CASCADE;
DROP TABLE IF EXISTS lengths CASCADE;

-- Clean up stems that are now empty (old multi-variety stems with no direct product items)
-- These are old stems that had multiple varieties and got split into new rows
DELETE FROM stems
WHERE variety IS NULL
  AND name IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM vendor_offerings vo WHERE vo.stem_id = stems.id)
  AND NOT EXISTS (SELECT 1 FROM stem_colors sc WHERE sc.stem_id = stems.id);


-- ============================================================
-- PHASE 5: RLS policies on new tables
-- ============================================================

ALTER TABLE stem_colors ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON stem_colors USING (true) WITH CHECK (true);

ALTER TABLE vendor_offerings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON vendor_offerings USING (true) WITH CHECK (true);

-- Drop temp table
DROP TABLE IF EXISTS stem_variety_map;

COMMIT;
