# PT Dashboard

Personal Trainer Dashboard for ONE LDN — coach breakdown, PT performance, and related
reporting, deployed as a static site (`index.html`) backed by Supabase.

## Files & Architecture

- `index.html` — the dashboard application (single-page).
- `supabase/` — schema migrations and seed data for the Supabase backend.
- `.claude/skills/` — repo-local Claude skills (session logging, progress/doc writers).
- `logs/pt-dashboard_log.md` — rolling session log, newest first. **Read the top entry
  at the start of every session** — it says exactly where things stand.

## Session Logging (always on)

Log file: `logs/pt-dashboard_log.md` — rolling log, newest entry at top, committed and
pushed on the session's working branch.

At the end of **every** session — or whenever asked ("save this conversation", "log this
session", "capture this", "save notes from this", "create a conversation log") — invoke
the **`repo-session-log`** skill and follow it exactly. Do not skip this, even for short
sessions. The skill owns the entry template and the prepend/commit workflow — it is the
single source of truth for the log format.

The standard: a future Claude session with zero memory of this conversation must be able
to pick up and continue without asking for re-explanation. Err on the side of more
detail, not less.

This is a technical, git-committed log scoped to this repo — separate from the
Notion-based progress reporting (`docs-manager`, `progress-update-writer`) used
elsewhere in ONE LDN's workflow. Use both where a session needs stakeholder-facing
reporting as well as an in-repo technical record.
