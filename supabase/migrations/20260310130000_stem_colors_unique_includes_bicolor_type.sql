-- Include bicolor_type in the unique index so that the same primary/secondary
-- pair can exist with different bicolor types (e.g. variegated vs tipped).
DROP INDEX idx_stem_colors_unique;
CREATE UNIQUE INDEX idx_stem_colors_unique
  ON stem_colors (color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0), COALESCE(bicolor_type, ''));
