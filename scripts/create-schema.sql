-- Stem Normalization Database Schema
-- Based on the finalized Product Items Analysis

-- Drop tables in reverse dependency order (for clean re-runs)
DROP TABLE IF EXISTS product_items CASCADE;
DROP TABLE IF EXISTS stem_lengths CASCADE;
DROP TABLE IF EXISTS stem_varieties CASCADE;
DROP TABLE IF EXISTS variety_color_categories CASCADE;
DROP TABLE IF EXISTS vendor_locations CASCADE;
DROP TABLE IF EXISTS lengths CASCADE;
DROP TABLE IF EXISTS varieties CASCADE;
DROP TABLE IF EXISTS color_categories CASCADE;
DROP TABLE IF EXISTS stems CASCADE;
DROP TABLE IF EXISTS vendors CASCADE;

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

-- Unique index: prevent duplicate (category, subcategory) combos, treating NULL subcategory as equal
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
-- 5. variety_color_categories
-- ============================================================
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
  variety_color_category_id INT REFERENCES variety_color_categories(id),
  stem_variety_id         INT REFERENCES stem_varieties(id),
  stem_length_id          INT REFERENCES stem_lengths(id),
  product_item_name       VARCHAR(255) NOT NULL,
  vendor_sku              VARCHAR(50),
  created_at              TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_product_items_stem ON product_items(stem_id);
CREATE INDEX idx_product_items_vendor ON product_items(vendor_id);
CREATE INDEX idx_variety_color_categories_variety ON variety_color_categories(variety_id);
CREATE INDEX idx_stem_varieties_stem ON stem_varieties(stem_id);
CREATE INDEX idx_stem_lengths_stem ON stem_lengths(stem_id);
