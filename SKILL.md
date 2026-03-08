# Skill: Product Stem Normalization

## Description
Advanced entity resolution and schema normalization for product catalogs across diverse distributors. This skill enables deep analysis of messy, heterogeneous spreadsheet data to identify, clean, and match product "stems" — the base product identity stripped of packaging variants and distributor-specific noise.

## Key Terminology
- **Stem**: Brand + product name + form factor + strength, stripped of size/count variants and promotional suffixes
- **Signal Column**: A column with cross-distributor matching value (UPC, Product Name, Brand, NDC)
- **Noise Column**: A distributor-specific artifact with no matching value (internal IDs, bin locations, sort numbers)
- **Canonical Schema**: The unified column structure all distributor data maps into

## Project Structure
```
stem-normalization/
├── .agent/workflows/
│   └── stem-normalization-process.md   ← orchestration workflow
├── prompts/
│   └── multi-agent-stem-matching.md    ← full prompt system with examples
├── outputs/                            ← analysis results (timestamped)
└── SKILL.md                            ← this file
```

## Instructions
- Always read `prompts/multi-agent-stem-matching.md` before starting any analysis
- Prioritize high-signal columns: UPC > Product Name > Brand > NDC
- Use the hierarchical multi-agent orchestration pattern (Orchestrator → Lead → Analyst → Verifier)
- Maintain a canonical schema for all normalization outputs
- Save all outputs to timestamped directories under `outputs/`
- Never guess when data is ambiguous — ask for clarification
- Always show reasoning with `<thinking>` blocks for complex decisions
- Track provenance: always note which distributor, file, and sheet data came from

## Common Distributor Data Patterns
- **Some distributors** split product catalogs across multiple tabs by category
- **Some distributors** include discontinued items in separate sheets
- **UPC coverage varies** widely — expect 60-95% fill rates
- **Product naming** is never consistent across distributors — abbreviations, casing, unit formats all differ
- **Watch for**: merged cells, hidden columns, header rows that aren't row 1, multiple header rows
