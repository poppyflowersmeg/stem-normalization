---
description: Execute multi-agent data analysis and product stem matching across multiple distributor spreadsheets.
---

// turbo-all

## Prerequisites
- The user has provided one or more spreadsheet links or file paths
- Read the full prompt system in [multi-agent-stem-matching.md](file:///Users/max/projects/stem-normalization/prompts/multi-agent-stem-matching.md) before starting

## Workflow Steps

1. **Validate Input**: Confirm you have received spreadsheet links or files. If none were provided, ask the user to supply them before proceeding.

2. **Read the Prompt**: Load and internalize the full prompt from `prompts/multi-agent-stem-matching.md`, including the system persona, definitions, workflow phases, rules, and examples.

3. **Create Output Directory**: Create an `outputs/` directory with a timestamped subdirectory (e.g., `outputs/2026-03-06/`) to store all analysis reports.

4. **Phase 1 — Reconnaissance**: For each spreadsheet, enumerate all sheets/tabs, record row/column counts, and flag any access issues. Save the inventory to `outputs/{date}/01-inventory.md`.

5. **Phase 2 — Deep Sheet Analysis**: For each sheet identified in Phase 1, produce a `<sheet_report>` following the schema in the prompt. Save individual reports to `outputs/{date}/02-sheets/`.

6. **Checkpoint — Review with User**: Present a summary of Phase 1 & 2 findings. Ask if there are any corrections, additional context, or clarifications before proceeding to synthesis.

7. **Phase 3 — File Synthesis**: Aggregate sheet reports into per-file `<file_summary>` reports. Save to `outputs/{date}/03-file-summaries/`.

8. **Phase 4 — Cross-Distributor Synthesis**: Produce the `<master_synthesis>` report including the proposed universal schema and matching strategy. Save to `outputs/{date}/04-master-synthesis.md`.

9. **Phase 5 — Self-Verification**: Run the `<verification>` audit (schema completeness, match key coverage, 3-product cross-check, confidence assessment). Save to `outputs/{date}/05-verification.md`.

10. **Checkpoint — Final Review**: Present the complete analysis to the user for review. Highlight any unresolved questions or low-confidence areas that need human input.

## Error Handling
- If a spreadsheet cannot be accessed or parsed, report the specific error and continue with remaining files
- If a sheet has no discernible column headers, flag it as `UNPARSEABLE` and skip to the next sheet
- If data is ambiguous, ask the user rather than guessing
