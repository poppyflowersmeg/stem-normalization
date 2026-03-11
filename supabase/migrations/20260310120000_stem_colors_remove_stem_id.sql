-- stem_colors are now global color combos, not per-stem.
-- Deduplicate to one row per unique (color_type, primary, secondary), repoint offerings, then drop stem_id.

-- Step 1: For each unique combo, find the canonical (lowest id) stem_color
CREATE TEMP TABLE canonical_stem_colors AS
SELECT DISTINCT ON (color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0))
  id as canonical_id,
  color_type,
  primary_color_category_id,
  COALESCE(secondary_color_category_id, 0) as sec_key
FROM stem_colors
ORDER BY color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0), id;

-- Step 2: Build a mapping from every stem_color id to its canonical id
CREATE TEMP TABLE sc_mapping AS
SELECT sc.id as old_id, c.canonical_id
FROM stem_colors sc
JOIN canonical_stem_colors c
  ON sc.color_type = c.color_type
  AND sc.primary_color_category_id = c.primary_color_category_id
  AND COALESCE(sc.secondary_color_category_id, 0) = c.sec_key;

-- Step 3: Repoint vendor_offerings to canonical stem_colors
UPDATE vendor_offerings vo
SET stem_color_id = m.canonical_id
FROM sc_mapping m
WHERE vo.stem_color_id = m.old_id
  AND m.old_id != m.canonical_id;

-- Step 4: Delete non-canonical stem_colors
DELETE FROM stem_colors
WHERE id NOT IN (SELECT canonical_id FROM canonical_stem_colors);

-- Step 5: Drop stem_id column and its constraints
ALTER TABLE stem_colors DROP CONSTRAINT IF EXISTS stem_colors_stem_id_fkey;
DROP INDEX IF EXISTS idx_stem_colors_unique;
ALTER TABLE stem_colors DROP COLUMN stem_id;

-- Step 6: Recreate unique index without stem_id (includes bicolor_type)
CREATE UNIQUE INDEX idx_stem_colors_unique
  ON stem_colors (color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0), COALESCE(bicolor_type, ''));

DROP TABLE canonical_stem_colors;
DROP TABLE sc_mapping;
