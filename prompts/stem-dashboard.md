# Stem Normalization Dashboard — React App

Build a React dashboard for managing floral product data stored in a local PostgreSQL database called `stem_normalization`. The app should feel like a polished internal tool — think Retool or Notion-meets-Airtable — not a generic CRUD scaffold.

---

## Tech Stack

- **Frontend:** React 19 (Vite) + TypeScript
- **Styling:** Vanilla CSS — **must match the design system from `../supplier-dashboard/src/styles/styles.css`** (see Design section below)
- **Routing:** React Router v6
- **Data layer:** `@supabase/supabase-js` — connects directly to local Supabase (REST API), **no custom Express backend needed**
- **State:** React Query (TanStack Query v5) for server state
- **Database:** Local Supabase instance (`supabase start` from this project). Schema managed via `supabase/migrations/`. When ready for production, just swap the URL and key to point at hosted Supabase — no code changes.

---

## Database Schema

The database has 10 tables. Here is the complete schema:

```sql
-- vendors
CREATE TABLE vendors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  vendor_type VARCHAR(20) NOT NULL CHECK (vendor_type IN ('farm', 'wholesaler')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- vendor_locations
CREATE TABLE vendor_locations (
  id SERIAL PRIMARY KEY,
  vendor_id INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  location_name VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (vendor_id, location_name)
);

-- stems
CREATE TABLE stems (
  id SERIAL PRIMARY KEY,
  stem_category VARCHAR(100) NOT NULL,
  stem_subcategory VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_stems_category_subcategory
  ON stems (stem_category, COALESCE(stem_subcategory, ''));

-- color_categories
CREATE TABLE color_categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  hex_code VARCHAR(7),
  sort_order INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- stem_color_categories (junction: stem ↔ color)
CREATE TABLE stem_color_categories (
  id SERIAL PRIMARY KEY,
  stem_id INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  color_type VARCHAR(20) NOT NULL CHECK (color_type IN ('single', 'bicolor')),
  primary_color_category_id INT NOT NULL REFERENCES color_categories(id),
  secondary_color_category_id INT REFERENCES color_categories(id),
  bicolor_type VARCHAR(30) CHECK (bicolor_type IN ('variegated', 'fade', 'tipped', 'striped')),
  secondary_color_searchable BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT check_bicolor_has_secondary CHECK (
    (color_type = 'single' AND secondary_color_category_id IS NULL AND bicolor_type IS NULL)
    OR
    (color_type = 'bicolor' AND secondary_color_category_id IS NOT NULL AND bicolor_type IS NOT NULL)
  )
);

-- varieties
CREATE TABLE varieties (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- stem_varieties (junction: stem ↔ variety)
CREATE TABLE stem_varieties (
  id SERIAL PRIMARY KEY,
  stem_id INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  variety_id INT NOT NULL REFERENCES varieties(id) ON DELETE CASCADE,
  legacy_stem_id INT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (stem_id, variety_id)
);

-- lengths
CREATE TABLE lengths (
  id SERIAL PRIMARY KEY,
  cm INT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- stem_lengths (junction: stem ↔ length)
CREATE TABLE stem_lengths (
  id SERIAL PRIMARY KEY,
  stem_id INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  length_id INT NOT NULL REFERENCES lengths(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (stem_id, length_id)
);

-- product_items (the core entity — purchasable products)
CREATE TABLE product_items (
  id SERIAL PRIMARY KEY,
  stem_id INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,
  vendor_id INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  stem_color_category_id INT REFERENCES stem_color_categories(id),
  stem_variety_id INT REFERENCES stem_varieties(id),
  stem_length_id INT REFERENCES stem_lengths(id),
  product_item_name VARCHAR(255) NOT NULL,
  vendor_sku VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Current Data Volumes

| Table | Rows |
|-------|-----:|
| stems | 141 |
| color_categories | 30 |
| varieties | 1,214 |
| lengths | 7 |
| vendors | 8 |
| vendor_locations | 1 |
| stem_color_categories | 526 |
| stem_varieties | 1,197 |
| stem_lengths | 0 |
| product_items | 399 |

---

## App Structure

### Layout
- **Sidebar navigation** (collapsible) with links to each section:
  - 🌸 Product Items (main landing page)
  - 🌿 Stems
  - 🎨 Colors
  - 🌹 Varieties
  - 📏 Lengths
  - 🏢 Vendors
- **Top bar** with the app title "Poppy Stem Manager" and a global search
- **Main content area** that renders the selected page

### Page: Product Items (Main Dashboard)

This is the primary view — a rich, filterable table/card view of `product_items` with all related data joined for display.

**Data display per product item:**
- Product item name (primary text)
- Vendor name + type badge (farm/wholesaler)
- Stem category + subcategory
- Color category name (with a small colored dot using hex_code if available)
- Variety name
- Length (if applicable)
- Vendor SKU

**Filtering & Organization:**
- Filter by vendor (multi-select dropdown)
- Filter by stem category (multi-select dropdown)
- Filter by color category (multi-select with color swatches)
- Search by product name, variety, or SKU
- Sort by: name, vendor, category, date added
- Group by: stem_category, vendor, or color (toggle)

**CRUD:**
- **Create**: Modal form with dropdowns for stem, vendor, color, variety, length. Auto-compose `product_item_name` based on selections.
- **Edit**: Inline edit or modal. Same form as create, pre-filled.
- **Delete**: Confirmation dialog with soft warning.

### Page: Stems

Table view of all stems (category + subcategory). Each row is expandable to show:
- Associated varieties (from stem_varieties)
- Associated colors (from stem_color_categories)
- Associated lengths (from stem_lengths)
- Count of product_items using this stem

**CRUD:** Add/edit/delete stems. When editing, can also manage the junction tables (add/remove varieties, colors, lengths).

### Page: Colors

Grid of all 30 color categories, displayed as color swatches with names. Each card shows:
- Color name
- Hex code (editable)
- Sort order
- Number of stems using this color

**CRUD:** Edit hex codes and sort order primarily. Add/delete with caution (referential integrity).

### Page: Varieties

Searchable table of all 1,214 varieties. Columns:
- Name
- Associated stem(s) (from stem_varieties)
- Legacy stem ID (if set)

**CRUD:** Add/edit/delete. Show warning if variety is used by product_items.

### Page: Lengths

Simple table: cm values. Show how many stems/product_items use each length.

**CRUD:** Add/delete lengths.

### Page: Vendors

Table of vendors with:
- Name
- Type (farm/wholesaler) as a colored badge
- Locations (from vendor_locations, listed inline)
- Product item count
- Notes (expandable)

**CRUD:** Full create/edit/delete. Can manage locations inline.

---

## Data Layer — Supabase Client

Since this uses Supabase, there is **no Express backend**. All data access goes through `@supabase/supabase-js` directly from the React app.

### Supabase Client Setup

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)
```

### Data Access Patterns

Use the Supabase JS client for all CRUD. Examples:

```typescript
// Fetch product items with all relations
const { data } = await supabase
  .from('product_items')
  .select(`
    *,
    stems (*),
    vendors (*),
    stem_color_categories (*, color_categories:primary_color_category_id (*)),
    stem_varieties (*, varieties (*)),
    stem_lengths (*, lengths (*))
  `)
  .order('product_item_name')

// Create a new stem
const { data } = await supabase
  .from('stems')
  .insert({ stem_category: 'rose', stem_subcategory: 'garden' })
  .select()
  .single()

// Update a variety
const { data } = await supabase
  .from('varieties')
  .update({ name: 'new name' })
  .eq('id', varietyId)
  .select()
  .single()

// Delete with cascade
const { error } = await supabase
  .from('stems')
  .delete()
  .eq('id', stemId)

// Junction table: link a variety to a stem
const { data } = await supabase
  .from('stem_varieties')
  .insert({ stem_id: stemId, variety_id: varietyId })
  .select()
  .single()

// Junction table: unlink
const { error } = await supabase
  .from('stem_varieties')
  .delete()
  .eq('stem_id', stemId)
  .eq('variety_id', varietyId)
```

### React Query Hooks

Wrap all Supabase calls in TanStack Query hooks (like the supplier-dashboard does with `useSuppliers.ts` and `useCatalog.ts`):

```typescript
// src/hooks/useStems.ts
export function useStems() {
  return useQuery({
    queryKey: ['stems'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select('*, stem_varieties(count), stem_color_categories(count)')
        .order('stem_category')
      if (error) throw error
      return data
    }
  })
}
```

Follow this same pattern for all tables: `useProductItems`, `useStems`, `useColors`, `useVarieties`, `useLengths`, `useVendors`.

---

## Design System — Poppy Brand (match `../supplier-dashboard`)

This app must use the **exact same visual language** as the existing supplier-dashboard. Copy or import the design tokens and component patterns from `../supplier-dashboard/src/styles/styles.css`.

### CSS Tokens (`:root`)

```css
:root {
  --poppy: #eb4b32;        /* Primary accent — Poppy red */
  --poppy-hover: #d43d26;
  --poppy-pale: #fdf0ee;
  --stem: #5e5929;         /* Secondary — olive green (section headers, table headers) */
  --stem-pale: #edeade;
  --amber: #a0720a;        /* Warning/caution accent */
  --amber-pale: #fdf3dc;
  --bg: #f2f1ea;           /* Page background — warm off-white */
  --card: #ffffff;
  --border: #dddbd3;
  --text: #231f20;         /* Primary text — near-black */
  --muted: #737373;        /* Secondary text */
  --radius: 8px;
  --shadow: 0 1px 3px rgba(35,31,32,.07), 0 4px 14px rgba(35,31,32,.06);
}
```

### Typography
- **Font:** `'Josefin Sans', 'brandon-grotesque', sans-serif` (via Google Fonts)
- **Base size:** `15px`
- **Labels:** uppercase, `.76rem`, `letter-spacing: .04em`, `font-weight: 700`, `color: var(--muted)`
- **Table headers:** uppercase, `.74rem`, `letter-spacing: .05em`, `color: rgba(255,255,255,.8)`, `background: var(--stem)`

### Component Patterns to Reuse

| Component | Pattern |
|-----------|---------|
| **Top nav** | `background: var(--text)` (dark), `border-bottom: 3px solid var(--poppy)`, sticky, white text |
| **Buttons** | `.btn-primary`: poppy-red pill (`border-radius: 20px`), uppercase. `.btn-secondary`: white w/ border. `.btn-ghost`: transparent. `.btn-danger`: poppy-pale bg w/ poppy text |
| **Badges** | `.badge-farm`: stem-pale bg + stem text. `.badge-wholesaler`: poppy-pale bg + poppy text |
| **Cards** | White bg, 1px border, `border-top: 3px solid var(--poppy)`, shadow, `border-radius: var(--radius)` |
| **Tables** | `.catalog-table` — olive green (`var(--stem)`) header, white rows, subtle hover (`#faf9f5`), poppy left-border on hover |
| **Section headers** | `background: var(--stem)`, white text, uppercase, collapsible with chevron |
| **Modals** | Centered, `border-radius: 14px`, shadow, slide-in animation, header/body/footer pattern |
| **Forms** | `border: 1px solid var(--border)`, `border-radius: 7px`, poppy focus ring |
| **Toasts** | Fixed bottom-center, dark bg, slide-up animation |
| **Search** | Input with search icon, `max-width: 320px` |
| **Filters** | Custom `<select>` with chevron SVG |
| **Empty states** | Centered text, muted color, `.88rem` |
| **Group rows** | Same olive header style as table thead |
| **Scrollbars** | `6px` thin, `var(--border)` thumb |

### Layout Adaptation for Multi-Page App

The supplier-dashboard is a single-page app. This stem dashboard needs **sidebar navigation** for multiple pages. Adapt as follows:
- **Sidebar**: `background: var(--text)` (same as nav bar), poppy accent on active item, white text, icons + labels
- **Top bar**: Same sticky nav pattern, but narrower (no brand logo — use text "Poppy Stem Manager")
- **Content area**: Same `max-width: 1300px`, `padding: 24px`, `background: var(--bg)` page wrapper

---

## Project Structure

```
stem-dashboard/
├── .env.local             (VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY)
├── package.json
├── vite.config.ts
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── index.css          (global styles — copy tokens from supplier-dashboard)
│   ├── lib/
│   │   ├── supabase.ts    (Supabase client init)
│   │   └── types.ts       (TypeScript interfaces matching DB schema)
│   ├── components/
│   │   ├── Layout.tsx     (sidebar + topbar + content)
│   │   ├── DataTable.tsx  (reusable table with sort/filter)
│   │   ├── Modal.tsx
│   │   ├── Toast.tsx
│   │   ├── ColorSwatch.tsx
│   │   ├── Badge.tsx
│   │   └── SearchInput.tsx
│   ├── pages/
│   │   ├── ProductItems.tsx
│   │   ├── Stems.tsx
│   │   ├── Colors.tsx
│   │   ├── Varieties.tsx
│   │   ├── Lengths.tsx
│   │   └── Vendors.tsx
│   └── hooks/
│       ├── useProductItems.ts
│       ├── useStems.ts
│       ├── useColors.ts
│       ├── useVarieties.ts
│       ├── useLengths.ts
│       └── useVendors.ts
```

---

## Environment Variables (`.env.local`)

```bash
# Local Supabase (from `supabase status` in the stem-normalization project)
VITE_SUPABASE_URL=http://127.0.0.1:54321
VITE_SUPABASE_ANON_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
```

When deploying to production, swap these with the hosted Supabase project URL and anon key.

---

## Prerequisites

Before running the dashboard, ensure the local Supabase is running:

```bash
cd /Users/max/projects/stem-normalization
supabase start
```

Supabase Studio is available at http://127.0.0.1:54323 for direct database inspection.

---

## Getting Started

1. Initialize the Vite + React + TypeScript project in a `stem-dashboard/` directory inside the stem-normalization project
2. Install dependencies: `@supabase/supabase-js`, `@tanstack/react-query`, `react-router-dom`
3. Create `.env.local` with the Supabase connection details above
4. Build the React frontend with all pages
5. Run with `npm run dev`
