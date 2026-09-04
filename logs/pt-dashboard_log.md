# PT Dashboard — Conversation Log

Rolling log of Claude sessions on the PT Dashboard project. Newest entry at the top.

---

# Add Daniel Arase as new PAYG PT
**Date:** 2026-09-04
**Project:** PT Dashboard — Coach Breakdown / PAYG (Old Model) attribution
**Mode:** Rolling Log + Git Push
**Status:** Complete (pending one follow-up: WodBoard Customer ID for membership)

---

## Project Context
First entry in this log. Repo is a single-page static dashboard (`index.html`) backed
by Supabase, tracking ONE LDN's PT revenue/costs across two coach models: "New Model"
(PAYE, employed coaches, e.g. Craig Clout, Jess Donehue) and "Old Model" (PAYG,
self-employed PTs who rent PT hours/space and optionally pay a monthly "Personal
Trainer Membership" fee, e.g. Alice Farrow, Rich Harris). Coach attribution runs off
WodBoard CSV exports uploaded through the dashboard's upload flow, matched by
Customer Name (rental) or Customer ID (membership) against hardcoded lookup tables
in `index.html`.

## Session Goal
Add a new PAYG PT, Daniel Arase, to the dashboard so his WodBoard transactions
attribute correctly on the next CSV upload.

## State Before This Session
No PAYG-PT-specific work in flight. Existing PAYG roster (self-employed): Alice
Farrow, Adrian Canaveral, Rich Harris, Lucas Cloves, Aimee Jeffs, Luke Mehson, Sam
Pepys, Annie Hall, Adam Siddle, Max Wade (Max Wade transitioned PAYG→PAYE Apr 2026,
see `PAYG_PAYE_FROM`).

## What Was Done
Confirmed with Saffron (Evgenia) that Daniel Arase is PAYG and will pay both the
per-session/pack rental AND the monthly Personal Trainer Membership fee (not
rental-only like Rich Harris). His WodBoard Customer ID was not available this
session, so the membership attribution is stubbed with a TODO rather than guessed —
`PAYG_PT_MEMBER_IDS` is keyed by numeric WodBoard Customer ID and a wrong/guessed ID
would silently misattribute another customer's membership revenue.

Added Daniel Arase in three places in `index.html`:
1. `SELF_EMP` (~line 870) — the plain-text PAYG/self-employed roster array. This array
   is currently informational only (not read anywhere else in the file per a repo-wide
   grep) but is the canonical human-readable roster, so keeping it in sync matters for
   future edits.
2. `PAYG_PT_MAP` (~line 895) — lowercase name → display name, used to attribute "PT
   rental" line-item transactions from WodBoard CSV uploads (see `ITEM_MAP`'s `pt
   rental` rule and the upload handler around line 2471).
3. `PAYG_PT_MEMBER_IDS` (~line 880) — Customer ID → display name, used to attribute the
   "Personal Trainer Membership" monthly fee line. Left a TODO comment in place of a
   real entry since the ID isn't known yet.

Did not touch `PAYE_COACHES`, the `payeCoaches` array in `renderCoaches()`, or
`ITEM_MAP` — those are New Model (PAYE)-only structures and Daniel Arase is PAYG.

Verified the edits with a Node syntax check on the extracted `<script>` block (parses
clean) and manually re-read both lookup objects post-edit.

## Artifacts Produced / Modified

| File | What it is | Status | Location |
|------|------------|--------|----------|
| index.html | Dashboard app — PAYG roster/attribution tables | Modified | /home/user/one-ldn-pt-dashboard/index.html |
| logs/pt-dashboard_log.md | This log | Modified | /home/user/one-ldn-pt-dashboard/logs/pt-dashboard_log.md |

## Decisions & Reasoning
- **Did not guess a WodBoard Customer ID for the membership line**: `PAYG_PT_MEMBER_IDS`
  keys are opaque numeric IDs pulled from WodBoard exports and confirmed manually
  (see the "confirmed by Saffron 2026-04-21" comment already in the file for the
  existing entries). A wrong guess would silently attribute another PT's/member's
  revenue to Daniel Arase on the next upload with no error surfaced. Left a dated TODO
  comment instead so the gap is visible and searchable (`grep -n "TODO" index.html`).
- **Kept `SELF_EMP` in sync despite it being dead code (unused elsewhere)**: it's the
  only plain-English roster list in the file; leaving it stale would mislead the next
  person reading the source.
- **Did not add Daniel Arase to any PAYE (New Model) structure**: confirmed PAYG status
  explicitly with Saffron before editing, since PAYE vs PAYG attribution is
  mutually exclusive per coach in this codebase (`ITEM_MAP` vs `PAYG_PT_MAP` /
  `PAYG_PAYE_FROM`).

## Current State (end of session)
Working. Daniel Arase will attribute correctly on the next WodBoard CSV upload for
rental/pack revenue (matched case-insensitively against the "Name" column). His
membership fee will NOT attribute until his Customer ID is added to
`PAYG_PT_MEMBER_IDS` — until then, if he starts paying the membership, that revenue
will show up in aggregate `pt_membership` totals but not broken out under his name in
the Old Model PAYG credit-pack table (`renderCoaches()` / `paygCreditTbl`).

Committed as `071e16f` on branch `claude/new-pt-dashboard-payg-i7a4d9` and pushed to
origin. No PR opened (not requested this session).

## Next Steps
1. Once Daniel Arase's WodBoard Customer ID is known, add it to `PAYG_PT_MEMBER_IDS`
   in `index.html` (~line 890, replacing the TODO comment) in the same
   `'<id>': 'Daniel Arase',` format as the existing entries, then commit/push.
2. Re-upload or wait for the next monthly WodBoard CSV and check `paygCreditTbl` /
   `paygPackTbl` in the Coach Breakdown tab render correctly for Daniel Arase.
3. No Supabase schema changes are needed for this — `pt_coach_transactions.coach_name`
   is a free-text column, not an enum, so a new coach name just needs the JS-side
   lookup tables above.

## Open Questions / Blockers
- Daniel Arase's WodBoard Customer ID — needed to attribute his membership fee line.
  Unblocks by asking WodBoard/finance for the ID (same source as the "confirmed by
  Saffron 2026-04-21" IDs already in `PAYG_PT_MEMBER_IDS`).

## Environment & Config Notes
- Repo: `ONE-LDN/one-ldn-pt-dashboard`. Branch: `claude/new-pt-dashboard-payg-i7a4d9`
  (newly created this session, tracks `origin/claude/new-pt-dashboard-payg-i7a4d9`).
  No PR opened.
- No env vars, credentials, or schema/migration changes touched this session.

## Notes & Gotchas
- `PAYG_PT_MAP` keys must be lowercase — matching is case-insensitive against the raw
  WodBoard "Name" column, so a new PT's key should always be `.toLowerCase()`'d by
  hand when adding (already done for `'daniel arase'`).
- `PAYG_PT_MEMBER_IDS` keys are Customer IDs (strings of digits), not names — don't
  confuse this table's key/value order with `PAYG_PT_MAP`'s.
- If Daniel Arase ever transitions PAYG → PAYE (as Max Wade and Harry Sheppard did),
  the pattern to follow is: add him to `PAYE_COACHES`, `payeCoaches` (in
  `renderCoaches()`), and an `ITEM_MAP` regex rule; add a cutover date to
  `PAYG_PAYE_FROM`; and remove/comment his `PAYG_PT_MEMBER_IDS` entry (see how Max
  Wade and Harry Sheppard were handled for the exact pattern).
