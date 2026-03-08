# Todo: Vendor Operations

Deferred from initial stem + product_items migration. To be built on top of the core schema.

---

## Vendor Logistics

Packaging, box types, and ordering restrictions.

```sql
vendor_logistics (
  id              serial PK,
  vendor_id       int FK → vendors,
  stem_id         int FK → stems,          -- NULL = vendor-wide rule
  product_item_id int FK → product_items,  -- NULL = applies to all items for this stem/vendor
  bunch_size      int,
  moq             int,
  pack_quantity   int,
  box_type        varchar(20),  -- "QB", "EB", "HB"
  unit_of_measure varchar(20),  -- "stem", "bunch", "weighted"
  basis           varchar(20),  -- "stem", "bunch", "box"
  grade           varchar(20),  -- "premium", "select"
  notes           text
)
```

Can be scoped at vendor-wide, per-stem, or per-product_item level.

---

## Pricing

Decoupled from product_items to support multiple pricing tiers (standard, high_season).

```sql
pricing (
  id              serial PK,
  product_item_id int FK → product_items,
  pricing_tier    varchar(30),      -- "standard", "high_season"
  price_per_unit  decimal(10,4),
  price_basis     varchar(20),      -- "per_stem", "per_bunch", "per_box"
  currency        varchar(3),       -- "USD"
  effective_date  date,
  last_updated    date
)
```

**Tier support by vendor:**

| Vendor | standard | high_season |
|--------|----------|-------------|
| DV | ✅ | ❌ |
| Elite | ✅ | ❌ |
| Magic | ✅ | ✅ |
| Agrogana | ✅ | ❌ |
| Mayesh | ✅ | ❌ |

---

## Vendor Freight

Per-vendor shipping costs. Source: STEM PRICING MASTER → Freight Costs tab.

```sql
vendor_freight (
  id               serial PK,
  vendor_id        int FK → vendors,
  freight_per_stem decimal(10,4),
  freight_basis    varchar(20)
)
```

---

## Vendor Order Rules

Minimum order requirements. Source: STEM PRICING MASTER → Order Minimum tabs.

```sql
vendor_order_rules (
  id         serial PK,
  vendor_id  int FK → vendors,
  order_type varchar(20),  -- "standard", "premium"
  min_stems  int,
  min_boxes  int,
  notes      text
)
```
