# Todo: Usage & Matching Data

Deferred from initial stem + product_items migration. Supports analytics, matching validation, and demand forecasting.

---

## Stem Usage

Historical consumption data from Metabase. Useful for prioritizing matching (high-volume stems first) and validating vendor catalogs.

```sql
stem_usage (
  id                  serial PK,
  stem_id             int FK → stems,       -- linked after matching
  raw_stem_name       varchar(255),
  stem_type           varchar(100),
  supplier            varchar(100),
  quarter             int,                   -- 1-4
  year                int,                   -- 2025
  total_stems         int,
  quarterly_events    int,
  avg_stems_per_event decimal(10,4),
  annual_total        int,
  is_custom           boolean               -- "(CUSTOM)" tag present
)
```

**Source:** Metabase raw data (~3,316 rows)

---

## Stem Substitutions

Known product substitution pairs. Validates matching and connects equivalent stems.

```sql
stem_substitutions (
  id               serial PK,
  week             int,
  issue_stem_type  varchar(100),
  issue_stem_name  varchar(255),
  substitute_1     varchar(255),
  substitute_2     varchar(255),
  approved         boolean
)
```

**Source:** Stem Cost Database → Agrogana Sub Request 2025

---

## Buyer Demand (Poppy-specific)

Buyer-side product catalog and demand forecasts.

```sql
buyer_demand (
  id                  serial PK,
  buyer_product_id    int,
  buyer_product_name  varchar(255),
  stem_id             int FK → stems,       -- linked after matching
  annual_purchase_qty int
)
```

**Source:** DV x Poppy RFP → Orig. Poppy list tab
