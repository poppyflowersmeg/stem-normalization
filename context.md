# Context: Stem Normalization Project

This document provides state and context for any AI agent picking up this task.

## Project Goal
Normalize product data across multiple distributor spreadsheets and perform "stem matching" (identifying the base product identity across heterogeneous names and structures).

## Current Status
- [x] Initial research on prompting best practices completed.
- [x] Refined hierarchical multi-agent prompt system created.
- [x] Antigravity Workflow established for automated orchestration.
- [x] Project Skill (SKILL.md) established for persistent domain context.
- [x] All initial 8 improvements/fixes applied (XML structures, definitions, self-verification, etc.).

## Directory Structure
```text
/Users/max/projects/stem-normalization/
├── .agent/
│   └── workflows/
│       └── stem-normalization-process.md   # The orchestration workflow
├── prompts/
│   └── multi-agent-stem-matching.md    # The core, research-backed prompt system
├── outputs/                            # Placeholder for future analysis runs (timestamped)
├── SKILL.md                            # Domain-specific instructions and patterns
└── context.md                          # This file
```

## How to Proceed
The orchestration system is ready. The next agent should:
1.  **Receive spreadsheet links** from the user.
2.  **Trigger the workflow** by running the `/stem-normalization-process` command (or following the steps in `.agent/workflows/stem-normalization-process.md`).
3.  **Follow the hierarchical agent pattern** (Orchestrator → Lead → Analyst → Verifier) defined in the prompt.
4.  **Ensure output persistence** to the `outputs/` directory as specified in the workflow.

## Key Terminology
- **Stem**: Brand + product name + form factor + strength (normalized).
- **Match Strategy**: Tiered approach starting with UPC, then fuzzy name matching, then component extraction.

## Brain Artifacts (Reference)
- [task.md](file:///Users/max/.gemini/antigravity/brain/14429a14-2230-4adb-834b-808e081c2646/task.md)
- [walkthrough.md](file:///Users/max/.gemini/antigravity/brain/14429a14-2230-4adb-834b-808e081c2646/walkthrough.md)
