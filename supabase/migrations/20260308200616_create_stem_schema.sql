-- Stem Normalization Database Schema
-- 10 tables for managing floral product data

-- ============================================================
-- 1. vendors
-- ============================================================
CREATE TABLE vendors (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL UNIQUE,
  vendor_type VARCHAR(20) NOT NULL CHECK (vendor_type IN ('farm', 'wholesaler')),
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. vendor_locations
-- ============================================================
CREATE TABLE vendor_locations (
  id            SERIAL PRIMARY KEY,
  vendor_id     INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  location_name VARCHAR(100) NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (vendor_id, location_name)
);

-- ============================================================
-- 3. stems
-- ============================================================
CREATE TABLE stems (
  id               SERIAL PRIMARY KEY,
  stem_category    VARCHAR(100) NOT NULL,
  stem_subcategory VARCHAR(100),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_stems_category_subcategory
  ON stems (stem_category, COALESCE(stem_subcategory, ''));

-- ============================================================
-- 4. color_categories
-- ============================================================
CREATE TABLE color_categories (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(50) NOT NULL UNIQUE,
  hex_code   VARCHAR(7),
  sort_order INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. stem_color_categories
-- ============================================================
CREATE TABLE stem_color_categories (
  id                           SERIAL PRIMARY KEY,
  stem_id                      INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
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

-- ============================================================
-- 6. varieties
-- ============================================================
CREATE TABLE varieties (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 7. stem_varieties
-- ============================================================
CREATE TABLE stem_varieties (
  id              SERIAL PRIMARY KEY,
  stem_id         INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  variety_id      INT NOT NULL REFERENCES varieties(id) ON DELETE CASCADE,
  legacy_stem_id  INT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (stem_id, variety_id)
);

-- ============================================================
-- 8. lengths
-- ============================================================
CREATE TABLE lengths (
  id         SERIAL PRIMARY KEY,
  cm         INT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 9. stem_lengths
-- ============================================================
CREATE TABLE stem_lengths (
  id         SERIAL PRIMARY KEY,
  stem_id    INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  length_id  INT NOT NULL REFERENCES lengths(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (stem_id, length_id)
);

-- ============================================================
-- 10. product_items
-- ============================================================
CREATE TABLE product_items (
  id                      SERIAL PRIMARY KEY,
  stem_id                 INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  vendor_id               INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  stem_color_category_id  INT REFERENCES stem_color_categories(id),
  stem_variety_id         INT REFERENCES stem_varieties(id),
  stem_length_id          INT REFERENCES stem_lengths(id),
  product_item_name       VARCHAR(255) NOT NULL,
  vendor_sku              VARCHAR(50),
  created_at              TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_product_items_stem ON product_items(stem_id);
CREATE INDEX idx_product_items_vendor ON product_items(vendor_id);
CREATE INDEX idx_stem_color_categories_stem ON stem_color_categories(stem_id);
CREATE INDEX idx_stem_varieties_stem ON stem_varieties(stem_id);
CREATE INDEX idx_stem_lengths_stem ON stem_lengths(stem_id);

-- ============================================================
-- Enable RLS (required for Supabase, but allow all for now)
-- ============================================================
ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stems ENABLE ROW LEVEL SECURITY;
ALTER TABLE color_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE stem_color_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE varieties ENABLE ROW LEVEL SECURITY;
ALTER TABLE stem_varieties ENABLE ROW LEVEL SECURITY;
ALTER TABLE lengths ENABLE ROW LEVEL SECURITY;
ALTER TABLE stem_lengths ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_items ENABLE ROW LEVEL SECURITY;

-- Allow all operations for authenticated and anon users (internal tool)
CREATE POLICY "Allow all" ON vendors FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON vendor_locations FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON stems FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON color_categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON stem_color_categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON varieties FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON stem_varieties FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON lengths FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON stem_lengths FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON product_items FOR ALL USING (true) WITH CHECK (true);
