-- ONE LDN PT Dashboard — Supabase Schema
-- Project: PT Dashboard (ljjwssicvvyyueyznmou)
-- Region: eu-west-1
-- Applied: 2026-04-08

-- ── PT REVENUE ACTUALS ──────────────────────────────────────────
-- One row per month per revenue line. UPSERT-safe (deduplicates on month+line).
CREATE TABLE pt_revenue (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month         DATE NOT NULL,
  line          TEXT NOT NULL CHECK (line IN ('pt_credits','pt_membership','pt_rent','new_model')),
  amount        NUMERIC(10,2) NOT NULL,
  source_file   TEXT,
  uploaded_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (month, line)
);

-- ── PT COSTS ACTUALS ────────────────────────────────────────────
CREATE TABLE pt_costs (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month         DATE NOT NULL,
  cost_line     TEXT NOT NULL CHECK (cost_line IN ('head_of_fitness','craig_clout','jess_donehue','harry_sheppard','tax_ni')),
  amount        NUMERIC(10,2) NOT NULL,
  source_file   TEXT,
  uploaded_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (month, cost_line)
);

-- ── H1 FORECAST TARGETS ─────────────────────────────────────────
CREATE TABLE pt_forecast (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month         DATE NOT NULL,
  line          TEXT NOT NULL CHECK (line IN ('pt_credits','pt_membership','pt_rent','new_model')),
  amount        NUMERIC(10,2) NOT NULL,
  UNIQUE (month, line)
);

-- ── COACH TRANSACTIONS ──────────────────────────────────────────
CREATE TABLE pt_coach_transactions (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month         DATE NOT NULL,
  coach_name    TEXT NOT NULL,
  product_name  TEXT NOT NULL,
  amount        NUMERIC(10,2) NOT NULL,
  quantity      INTEGER DEFAULT 1,
  source_file   TEXT,
  uploaded_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (month, product_name, coach_name)
);

-- ── UPLOAD LOG ──────────────────────────────────────────────────
CREATE TABLE pt_upload_log (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  filename        TEXT NOT NULL,
  month_covered   DATE,
  uploaded_at     TIMESTAMPTZ DEFAULT NOW(),
  rows_inserted   INTEGER DEFAULT 0,
  rows_skipped    INTEGER DEFAULT 0,
  uploaded_by     TEXT DEFAULT 'anonymous'
);

-- ── ROW LEVEL SECURITY ──────────────────────────────────────────
ALTER TABLE pt_revenue            ENABLE ROW LEVEL SECURITY;
ALTER TABLE pt_costs              ENABLE ROW LEVEL SECURITY;
ALTER TABLE pt_forecast           ENABLE ROW LEVEL SECURITY;
ALTER TABLE pt_coach_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE pt_upload_log         ENABLE ROW LEVEL SECURITY;

-- Public read (no login required)
CREATE POLICY "public_read_revenue"       ON pt_revenue            FOR SELECT USING (true);
CREATE POLICY "public_read_costs"         ON pt_costs              FOR SELECT USING (true);
CREATE POLICY "public_read_forecast"      ON pt_forecast           FOR SELECT USING (true);
CREATE POLICY "public_read_coach_txns"    ON pt_coach_transactions FOR SELECT USING (true);
CREATE POLICY "public_read_upload_log"    ON pt_upload_log         FOR SELECT USING (true);

-- Anon insert/update (upload flow)
CREATE POLICY "anon_insert_revenue"       ON pt_revenue            FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_insert_costs"         ON pt_costs              FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_insert_coach_txns"    ON pt_coach_transactions FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_insert_upload_log"    ON pt_upload_log         FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_upsert_revenue"       ON pt_revenue            FOR UPDATE USING (true);
CREATE POLICY "anon_upsert_costs"         ON pt_costs              FOR UPDATE USING (true);
CREATE POLICY "anon_upsert_coach_txns"    ON pt_coach_transactions FOR UPDATE USING (true);
