-- Move colors from stems to varieties
-- Colors belong to varieties (e.g., "Freedom rose is red"), not stems (e.g., "rose has red")

-- A. Create new table
CREATE TABLE variety_color_categories (
  id                           SERIAL PRIMARY KEY,
  variety_id                   INT NOT NULL REFERENCES varieties(id) ON DELETE CASCADE,
  color_type                   VARCHAR(20) NOT NULL CHECK (color_type IN ('single', 'bicolor')),
  primary_color_category_id    INT NOT NULL REFERENCES color_categories(id),
  secondary_color_category_id  INT REFERENCES color_categories(id),
  bicolor_type                 VARCHAR(30) CHECK (bicolor_type IN ('variegated', 'fade', 'tipped', 'striped')),
  secondary_color_searchable   BOOLEAN DEFAULT FALSE,
  created_at                   TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT check_bicolor_has_secondary CHECK (
    (color_type = 'single' AND secondary_color_category_id IS NULL AND bicolor_type IS NULL)
    OR
    (color_type = 'bicolor' AND secondary_color_category_id IS NOT NULL AND bicolor_type IS NOT NULL)
  )
);
CREATE UNIQUE INDEX idx_variety_color_unique
  ON variety_color_categories (variety_id, color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0));
CREATE INDEX idx_variety_color_categories_variety ON variety_color_categories(variety_id);

-- B. Add new FK column to product_items
ALTER TABLE product_items ADD COLUMN variety_color_category_id INT REFERENCES variety_color_categories(id);

-- C. Drop old FK column and table
ALTER TABLE product_items DROP COLUMN stem_color_category_id;
DROP TABLE stem_color_categories CASCADE;

-- D. RLS + policy
ALTER TABLE variety_color_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON variety_color_categories FOR ALL USING (true) WITH CHECK (true);
