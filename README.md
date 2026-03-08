# Stem Normalization

Normalize product data across multiple distributor spreadsheets and perform **stem matching** — identifying the base product identity (brand + product name + form factor + strength) across heterogeneous naming conventions and data structures.

## Quick Start

### Option 1: Reference a spreadsheets file

Create a `spreadsheets.md` file with one Google Sheets link per line:

```
https://docs.google.com/spreadsheets/d/abc123/edit
https://docs.google.com/spreadsheets/d/def456/edit
https://docs.google.com/spreadsheets/d/ghi789/edit
```

Then trigger the workflow:

```
Run /stem-normalization-process. The spreadsheet links are in spreadsheets.md.
Load context.md for project state.
```

### Option 2: Provide links directly

```
Run /stem-normalization-process with these spreadsheets:
- https://docs.google.com/spreadsheets/d/abc123/edit
- https://docs.google.com/spreadsheets/d/def456/edit
```

## Local Database Development

This project uses **Supabase CLI** for local database management.

### Starting the Local Stack
To start the local database and apply migrations:
```bash
supabase start
```

### Creating a Database Dump
To backup the local database schema and data:
```bash
# Export schema and data separately
supabase db dump --local -f backups/supabase_schema_$(date +%Y%m%d).sql
supabase db dump --local --data-only -f backups/supabase_data_$(date +%Y%m%d).sql
```

### Restoring from a Backup
To restore a dump to your local instance:
```bash
# Restore schema
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f backups/supabase_schema_YYYYMMDD.sql

# Restore data
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f backups/supabase_data_YYYYMMDD.sql
```

## What Happens

The workflow runs a 5-phase hierarchical analysis:

| Phase | What it does | Output |
|-------|-------------|--------|
| **1. Reconnaissance** | Enumerates all sheets/tabs, records row/column counts | `outputs/{date}/01-inventory.md` |
| **2. Deep Sheet Analysis** | Column-level profiling, signal/noise rating, data quality audit | `outputs/{date}/02-sheets/` |
| **⏸ Checkpoint** | Pauses for your review before synthesis | — |
| **3. File Synthesis** | Per-file summaries with recommended canonical schemas | `outputs/{date}/03-file-summaries/` |
| **4. Cross-Distributor Synthesis** | Universal schema + stem matching strategy | `outputs/{date}/04-master-synthesis.md` |
| **5. Self-Verification** | Schema completeness audit, 3-product cross-check, confidence scoring | `outputs/{date}/05-verification.md` |

## Project Structure

```
stem-normalization/
├── .agent/workflows/
│   └── stem-normalization-process.md   # Orchestration workflow
├── prompts/
│   └── multi-agent-stem-matching.md    # Core prompt system (roles, phases, examples)
├── outputs/                            # Analysis results (timestamped per run)
├── spreadsheets.md                     # Your spreadsheet links
├── context.md                          # Project state for agent continuity
├── SKILL.md                            # Domain-specific instructions
└── README.md                           # This file
```

## Key Concepts

- **Stem**: The base product identity — e.g. *"NOW Foods Vitamin D3 5000IU Softgel"* — stripped of count, packaging variants, and promotional suffixes.
- **Signal Column**: Carries cross-distributor matching value (UPC, Product Name, Brand).
- **Noise Column**: Distributor-specific artifact with no matching value (internal IDs, bin locations).
- **Match Strategy**: Tiered — exact UPC match → fuzzy product name (TF-IDF) → component extraction (brand + ingredient + strength + form).
