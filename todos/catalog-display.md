# Todo: Catalog & Display

Deferred from initial stem + product_items migration. To be built for the Poppy product catalog.

---

## Category Display Rules

Controls how categories/subcategories appear in the Poppy product catalog navigation.

```sql
category_display_rules (
  id               serial PK,
  stem_category    varchar(100),
  stem_subcategory varchar(100),   -- NULL = applies to whole category
  display_level    varchar(20),    -- "top_level", "grouped", "hidden"
  display_name     varchar(100),   -- customer-facing label (e.g., "Spray Roses")
  sort_order       int,
  description      text
)
```

**Rationale:** Subcategories stay flat on `stems`, but this table controls catalog display. "Spray Rose" and "Garden Rose" show as top-level categories, while all Delphinium subcategories are grouped under one heading.

**Sample data:**

| category | subcategory | display_level | display_name |
|----------|-------------|:---:|---|
| rose | spray | top_level | Spray Roses |
| rose | garden | top_level | Garden Roses |
| rose | standard | top_level | Standard Roses |
| carnation | spray | top_level | Spray Carnations |
| delphinium | NULL | top_level | Delphinium |
| delphinium | belladonna | hidden | — |

---

## Assembled Products

Bouquets, kits, combos — assembled from individual stems. Source: Magic Pricing (Bouquets + Kits/Combos sections).

```sql
assembled_products (
  id             serial PK,
  product_name   varchar(255),
  product_type   varchar(20),   -- "bouquet", "kit", "combo"
  design         varchar(255),
  stems_per_unit int,
  vendor_id      int FK → vendors
)
```
