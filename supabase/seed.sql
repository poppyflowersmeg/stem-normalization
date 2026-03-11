-- Seed data for stem_normalization database
-- Run after migrations with: supabase db reset

-- ============================================================
-- Color Categories (from Poppy's color_categories.jpg)
-- ============================================================
INSERT INTO color_categories (name, hex_code, sort_order) VALUES
  ('white',        '#F5F0ED', 1),
  ('cream',        '#C8B99A', 2),
  ('tan',          '#A67B5B', 3),
  ('light yellow', '#FDF5D6', 4),
  ('yellow',       '#E8C840', 5),
  ('dark yellow',  '#C69C30', 6),
  ('peach',        '#F5C3A0', 7),
  ('blush',        '#E6D0CC', 8),
  ('light pink',   '#F5C6D0', 9),
  ('coral',        '#E85040', 10),
  ('orange',       '#F58A1F', 11),
  ('terracotta',   '#C07858', 12),
  ('rust',         '#8B4513', 13),
  ('red',          '#A01020', 14),
  ('pink',         '#F06090', 15),
  ('hot pink',     '#E82068', 16),
  ('mauve',        '#B07888', 17),
  ('burgundy',     '#6B1028', 18),
  ('berry',        '#3E1025', 19),
  ('plum',         '#2E0A28', 20),
  ('lavender',     '#C0B8D8', 21),
  ('purple',       '#6B3FA0', 22),
  ('eggplant',     '#3E1848', 23),
  ('sage',         '#A8B090', 24),
  ('dark green',   '#3E5828', 25),
  ('light blue',   '#A8BEE0', 26),
  ('blue',         '#0A2878', 27),
  ('gray',         '#C0BAB5', 28),
  ('dark brown',   '#5E3020', 29),
  ('lime green',   '#A8B848', 30)
ON CONFLICT (name) DO UPDATE SET
  hex_code = EXCLUDED.hex_code,
  sort_order = EXCLUDED.sort_order;

-- ============================================================
-- Single stem_colors — one per color category
-- ============================================================
INSERT INTO stem_colors (color_type, primary_color_category_id, secondary_color_searchable)
SELECT 'single', cc.id, false
FROM color_categories cc
ON CONFLICT (color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0), COALESCE(bicolor_type, '')) DO NOTHING;

-- ============================================================
-- Known Vendors
-- ============================================================
INSERT INTO vendors (name, vendor_type) VALUES
  ('DV', 'wholesaler'),
  ('Elite', 'farm'),
  ('Magic', 'wholesaler'),
  ('Agrogana', 'farm'),
  ('Mayesh', 'wholesaler'),
  ('Golden', 'farm'),
  ('Shaw Lake', 'farm'),
  ('Vivek Flowers', 'wholesaler')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- Known Vendor Locations
-- ============================================================
INSERT INTO vendor_locations (vendor_id, location_name)
SELECT v.id, loc.location_name
FROM vendors v
CROSS JOIN (VALUES ('Bogotá')) AS loc(location_name)
WHERE v.name = 'Elite'
ON CONFLICT (vendor_id, location_name) DO NOTHING;
