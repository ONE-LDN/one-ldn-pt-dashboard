# PT Dashboard — Conversation Log

Rolling log of Claude sessions on the PT Dashboard project. Newest entry at the top.

---

# PT Roster Master (Sep 2026): PAYE/PAYG relabel, roster reclassification, £159 membership collection table
**Date:** 2026-09-08
**Project:** PT Dashboard — Coach Breakdown / model labels / PAYG membership
**Mode:** Rolling Log + Git Push
**Status:** Complete (pending: 3 WodBoard Customer IDs, confirm Sep 2026 cutover month, confirm "PAYE" vs "PAYEE" label)

---

## Project Context
See 2026-09-04 entry for the codebase overview (single `index.html`, Supabase-backed, two
coach models, WodBoard CSV attribution via hardcoded lookup tables). This session applied
Evgenia's "ONE LDN | PT Roster Master" sheet (screenshot supplied) as the new source of
truth for which PT is on which model.

## Session Goal
1. Rename the "New Model" / "Old Model" labels to PAYE / PAYG everywhere on the dashboard.
2. Load the roster master classification: 4 PAYE, 11 PAYG, 1 class exchange, 1 rent.
3. Make the £159/month PAYG PT membership an explicit expectation: 11 × £159 = £1,749
   expected per month, and show who has / hasn't paid.

## State Before This Session
Dashboard still labelled the models "New Model (PAYE)" / "Old Model (PAYG)". Craig Clout
and Max Wade were treated as PAYE for all months from their cutovers; roster master now
has them as PAYG. Harry Sheppard, Rich Harris and Luke Mehson (no longer on roster) were
still in the active lists. Forecast `pt_membership` for Sep–Dec 2026 was 0. Daniel Arase
membership ID TODO outstanding (see 2026-09-04).

## What Was Done
- **Relabel**: sed over display strings only. "New Model (PAYE)" → "PAYE Model", "Old
  Model (PAYG)" → "PAYG Model", "New Model"/"Old Model" → "PAYE Model"/"PAYG Model",
  section headers, chart legends, P&L rows, overview row labels, upload log labels.
  Internal keys (`new_model`, `newModelRev`, `oldModelRev`, `dot-new`, `dot-old`) untouched.
- **Roster master block** (replaced `SELF_EMP` / `PAYG_PAYE_FROM` section, ~line 870):
  `PT_MEMBERSHIP_FEE = 159`, `PAYE_ROSTER` (Jess Donehue, Mara Greenwood, Grace G, Kayla
  Joll — internal names), `PAYG_ROSTER` (Craig Clout, Max Wade, Alice Farrow, Aimee Jeffs,
  Adrian Canaveral, Sam Pepys, Adam Siddle, Lucas Cloves, Annie Hall, Daniel Arase, Pelé
  Zac), `OTHER_ROSTER` (Chris Barker class exchange £0; Rickel White rent £1,000),
  `PAYG_MEMBERSHIP_EXPECTED` (= 1,749), `COACH_LABEL` (internal coach_name → roster display
  name, e.g. 'Jess Donehue' → 'Jessica Donehue', 'Grace G' → 'Grace India Gordon'),
  `FORMER_PAYG` / `FORMER_PAYE` / `NO_MEMBERSHIP` (Rich Harris never on membership).
- **Month-aware model**: `MODEL_HISTORY` + `coachModelAt(name, mk)` replaces the one-way
  `PAYG_PAYE_FROM`. Craig Clout PAYE → PAYG from 2026-09; Max Wade PAYG → PAYE 2026-04 →
  PAYG 2026-09; Harry Sheppard PAYG → PAYE 2026-02. Used in: upload handler PAYG rental
  attribution, `paygCreditTbl`, `renderPaygPackTable`, PAYE coach cards/table (cells show
  "PAYG" for PAYG months; cards for transitioned coaches only appear in PAYE months with
  revenue). `paygRosterAt(mk)` returns who owed the £159 in a given month.
- **Lookup tables**: `PAYG_PT_MAP` gained craig clout, dan arase, pelé zac / pele zac;
  kept rich harris / luke mehson for history. `PAYG_PT_MEMBER_IDS` re-added Max Wade
  (64599), kept Luke Mehson / Harry Sheppard as historical, TODOs for Craig Clout, Daniel
  Arase, Pelé Zac. `PAYG_MEMBER_ID_MISSING` derived from the gap.
- **Forecast**: `FORECAST` Sep–Dec 2026 `pt_membership` 0 → 1749 and `pt_rent` 0 → 1000
  (matches `FIXED_PT_RENT`). Jul/Aug left as they were.
- **New card + `renderPaygMembershipTable()`** (Coach Breakdown tab, after credit packs):
  per PAYG PT per uploaded month: £159 paid (green) / Unpaid (red) / ID needed (amber) /
  — (not PAYG that month); footer rows Expected (active PAYG × £159), Collected, Gap.
  Called from `renderCoaches()`.
- **Footnote** added under PAYE coach table re Craig/Max Sep 2026 transition.
- **Verification**: `node --check` on extracted script; headless Chromium render with
  Chart.js served locally and synthetic Aug/Sep transactions injected — all tables render,
  Sep expected shows £1,749, Craig shows PAYE Aug / PAYG Sep correctly.

## Artifacts Produced / Modified

| File | What it is | Status | Location |
|------|------------|--------|----------|
| index.html | Dashboard app — labels, roster block, model history, membership table | Modified | /home/claude/one-ldn-pt-dashboard/index.html |
| logs/pt-dashboard_log.md | This log | Modified | /home/claude/one-ldn-pt-dashboard/logs/pt-dashboard_log.md |

## Decisions & Reasoning
- **Label "PAYE" not "PAYEE"**: Evgenia's message said "PAYEE" but the roster sheet says
  PAYE and PAYE is the HMRC term. Flagged to her; one sed if she wants "PAYEE".
- **Cutover 2026-09 for Craig Clout / Max Wade PAYE → PAYG**: not given; chosen because the
  roster master is dated Sep 2026 and Aug data already sits under PAYE. Change
  `MODEL_HISTORY` if the real month differs. Historical PAYE revenue is preserved.
- **Kept PAYE product-name rules in `ITEM_MAP` for Craig/Max**: if a "Craig Clout - PT
  pack" product still sells after Sep it is still ONE LDN revenue, so it stays `new_model`.
  Their PT rental purchases (Name column) now attribute as PAYG.
- **Kept internal coach_name values unchanged, added `COACH_LABEL`**: Supabase
  `pt_coach_transactions.coach_name` already holds 'Jess Donehue' / 'Grace G'; renaming
  would orphan stored rows.
- **Did not guess Customer IDs** (same reasoning as 2026-09-04); the table shows "ID needed"
  so the gap is visible on the dashboard rather than silently reading as Unpaid.
- **Forecast membership only from Sep 2026**: Jul/Aug forecasts predate the roster; Aug
  may already have actuals.

## Current State (end of session)
Working. Branch `claude/pt-roster-paye-payg-sep26`, PR opened against main. Membership
table will show Craig Clout, Dan Arase, Pelé Zac as "ID needed" until their WodBoard
Customer IDs are added.

## Next Steps
1. Add WodBoard Customer IDs for Craig Clout, Daniel Arase, Pelé Zac to
   `PAYG_PT_MEMBER_IDS` (format `'<id>': 'Name',`), commit, push.
2. Confirm the Sep 2026 cutover for Craig Clout and Max Wade; adjust `MODEL_HISTORY`.
3. Upload the Sep 2026 WodBoard CSV and check the "PAYG PT Membership — £159/month
   Collection" table against the £1,749 expectation.
4. If Evgenia wants the label literally "PAYEE": `sed -i 's/PAYE Model/PAYEE Model/g'` plus
   the badge/table "PAYE" strings.

## Open Questions / Blockers
- Customer IDs (3) as above.
- Cutover month for Craig Clout / Max Wade.
- Rickel White's £1,000 rent is modelled via `FIXED_PT_RENT`, not from CSV — confirm still
  correct for H2.

## Environment & Config Notes
- Repo `ONE-LDN/one-ldn-pt-dashboard`, branch `claude/pt-roster-paye-payg-sep26`. No
  Supabase schema changes. No env vars touched.

## Notes & Gotchas
- `FORECAST` is defined before the roster block, so it cannot reference
  `PAYG_MEMBERSHIP_EXPECTED` (const TDZ) — the 1749 is a literal with a comment. Keep in
  sync if the PAYG roster count changes.
- `paygRosterAt(mk)` includes `FORMER_PAYG` only for months before `ROSTER_MASTER_FROM`
  ('2026-09'); after that only `PAYG_ROSTER` members count toward Expected.
- `PAYG_PT_MAP` keys must stay lowercase; 'pelé zac' and 'pele zac' both included because
  WodBoard may strip the accent.

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
