-- Seed stem_colors by parsing color category names from vendor_offering item names.
-- For each offering, find the longest-matching color_category name in vendor_item_name,
-- create a single-type stem_color if one doesn't exist, and link the offering to it.

-- Step 1: Find the best (longest) color match per vendor_offering
CREATE TEMP TABLE offering_color_matches AS
SELECT DISTINCT ON (vo.id)
  vo.id as offering_id,
  vo.stem_id,
  cc.id as color_category_id
FROM vendor_offerings vo
JOIN color_categories cc ON lower(vo.vendor_item_name) LIKE '%' || lower(cc.name) || '%'
WHERE vo.stem_color_id IS NULL
ORDER BY vo.id, length(cc.name) DESC;

-- Step 2: Create stem_colors for each unique (stem_id, color_category_id) that doesn't exist yet
INSERT INTO stem_colors (stem_id, color_type, primary_color_category_id, secondary_color_searchable)
SELECT DISTINCT ocm.stem_id, 'single', ocm.color_category_id, false
FROM offering_color_matches ocm
WHERE NOT EXISTS (
  SELECT 1 FROM stem_colors sc
  WHERE sc.stem_id = ocm.stem_id
    AND sc.primary_color_category_id = ocm.color_category_id
    AND sc.color_type = 'single'
);

-- Step 3: Link vendor_offerings to their stem_colors
UPDATE vendor_offerings vo
SET stem_color_id = sc.id
FROM offering_color_matches ocm
JOIN stem_colors sc ON sc.stem_id = ocm.stem_id
  AND sc.primary_color_category_id = ocm.color_category_id
  AND sc.color_type = 'single'
WHERE vo.id = ocm.offering_id
  AND vo.stem_color_id IS NULL;

DROP TABLE offering_color_matches;

-- Step 4: Clean up orphan stem_colors that no offering references.
-- Colors should be inferred through vendor_offerings, so stem_colors
-- with no linked offerings are stale data from the old migration.
DELETE FROM stem_colors sc
WHERE NOT EXISTS (SELECT 1 FROM vendor_offerings vo WHERE vo.stem_color_id = sc.id);
