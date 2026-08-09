# dashboard-doc-updater

You are updating the Notion system document for the **Personal Trainer Dashboard** (`one-ldn-pt-dashboard` repo).

**Target Notion page:** https://www.notion.so/3680164f7fc6814788dac817348a80f5
**Page ID:** `3680164f-7fc6-8147-88da-c817348a80f5`

## What this skill does

Reads the current `index.html`, compares its state against the Notion system document, and updates any sections that are out of date. Run after any meaningful code change to keep documentation in sync.

## Steps

1. **Read the source file**
   - Read `index.html` from the repository root
   - Because the file is large (~130KB), extract key sections with `grep` or `jq` rather than reading the whole file at once:
     ```bash
     # Extract JS constants block
     grep -n 'const FORECAST\|const COST_FORECAST\|const FIXED_PT_RENT\|const PAYE_COACHES\|const PAYG_PT_MAP\|const PAYG_PAYE_FROM\|hofDefault' index.html

     # Extract ITEM_MAP
     grep -n 'ITEM_MAP\|pt_credits\|pt_membership\|pt_rent\|new_model' index.html | head -60

     # List all named functions
     grep -n 'function [a-zA-Z]\+(' index.html

     # Extract Supabase table names
     grep -n "supabase\.from\|sbGet\|sbUpsert\|sbInsert\|sbDelete" index.html | head -40
     ```

2. **Identify what has changed** compared to the documented state. Focus on:
   - New or renamed JavaScript functions
   - Changes to `FORECAST`, `COST_FORECAST`, `FIXED_PT_RENT` constants
   - Changes to `PAYE_COACHES`, `PAYG_PT_MAP`, `PAYG_PT_MEMBER_IDS`, `PAYG_PAYE_FROM`
   - New tabs or renamed UI sections
   - New or changed Supabase tables or columns
   - Changes to `ITEM_MAP` regex rules
   - Changes to `hofDefault()` logic
   - Any new charts (new `canvas` elements)
   - Any new known limitations or changed troubleshooting steps

3. **Fetch the current Notion page** to read its content:
   Use `notion-fetch` with id `3680164f-7fc6-8147-88da-c817348a80f5`

4. **Update changed sections** using `notion-update-page`.
   - Only update sections that have actually changed
   - Preserve the page structure (13 numbered sections)
   - Use the same Notion-flavored Markdown format as the existing page
   - Always update the `> Last updated:` date at the top to today's date

5. **Report what changed** — list each section updated and a one-line summary of what changed.

## Section map (for targeted updates)

| Section | What to check in index.html |
| --- | --- |
| 1. Purpose | No change expected unless business model changes |
| 2. Tech Stack | CDN library versions in `<script src=...>` tags |
| 3. Architecture | `init()`, `loadData()`, `loadFallback()` flow |
| 4. Database Schema | Supabase table definitions (check against `supabase/migrations/`) |
| 5. Business Logic | `ITEM_MAP`, `FIXED_PT_RENT`, `hofDefault()`, RAG thresholds |
| 6. Dashboard Views | Tab panel IDs and their content |
| 7. Configuration Constants | All `const` declarations at top of `<script>` |
| 8. Key Functions | All `function` declarations |
| 9. Charts | All `<canvas id=...>` elements and `new Chart(...)` calls |
| 10. State Management | Global `let`/`var` declarations, `localStorage` keys |
| 11. UI Colour System | CSS custom properties or colour constants |
| 12. Known Limitations | No code check needed — update when known issues change |
| 13. Maintenance Guide | No code check needed — update when workflows change |

## Notes

- Do **not** update the page if nothing has changed
- If a section is completely rewritten, replace it entirely rather than patching
- The Supabase migrations in `supabase/migrations/` are the authoritative schema source
- The pipeline tab (Tab 5) data is hardcoded — note any changes to `PIPELINE_JF_NEW`, `PIPELINE_REDEEMED`, `PIPELINE_D14`, `PIPELINE_STATS` constants
