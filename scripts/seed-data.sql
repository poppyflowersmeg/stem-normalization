-- Seed data for stem_normalization database
-- Run AFTER create-schema.sql

-- ============================================================
-- Color Categories (from Poppy's color_categories.jpg)
-- ============================================================
INSERT INTO color_categories (name, sort_order) VALUES
  ('white', 1),
  ('cream', 2),
  ('tan', 3),
  ('light yellow', 4),
  ('yellow', 5),
  ('dark yellow', 6),
  ('peach', 7),
  ('blush', 8),
  ('light pink', 9),
  ('coral', 10),
  ('orange', 11),
  ('terracotta', 12),
  ('rust', 13),
  ('red', 14),
  ('pink', 15),
  ('hot pink', 16),
  ('mauve', 17),
  ('burgundy', 18),
  ('berry', 19),
  ('plum', 20),
  ('lavender', 21),
  ('purple', 22),
  ('eggplant', 23),
  ('sage', 24),
  ('dark green', 25),
  ('light blue', 26),
  ('blue', 27),
  ('gray', 28),
  ('dark brown', 29),
  ('lime green', 30)
ON CONFLICT (name) DO NOTHING;

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
-- Known Vendor Locations (from spreadsheet analysis)
-- ============================================================
INSERT INTO vendor_locations (vendor_id, location_name)
SELECT v.id, loc.location_name
FROM vendors v
CROSS JOIN (VALUES ('Bogotá')) AS loc(location_name)
WHERE v.name = 'Elite'
ON CONFLICT (vendor_id, location_name) DO NOTHING;

-- ============================================================
-- Common Stem Lengths (cm)
-- ============================================================
INSERT INTO lengths (cm) VALUES
  (40), (50), (60), (70), (80), (90), (100)
ON CONFLICT (cm) DO NOTHING;
