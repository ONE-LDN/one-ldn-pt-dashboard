-- ONE LDN PT Dashboard — Transaction-level PT revenue storage
-- Applied: 2026-06-30
--
-- WHY: previously each CSV upload stored only a per-line monthly TOTAL and the
-- upload OVERWROTE it, so a partial file would shrink the month and you had to
-- re-upload the whole month-to-date CSV every time.
--
-- This table stores each PT-relevant CSV line individually. pt_revenue and
-- pt_coach_transactions become DERIVED aggregates that the upload flow
-- recomputes from the full raw set for the month. Result:
--   • uploading only the new days ADDS correctly
--   • re-uploading the whole month is HARMLESS (rows upsert in place)
--   • a Scheduled→Settled state change updates the same row, no double count
--
-- The WodBoard income statement has no transaction ID and no time-of-day, so
-- the unique key is a composite of the identifying columns plus `seq`, an
-- ordinal that disambiguates genuinely-identical same-day rows within a file.

CREATE TABLE IF NOT EXISTS pt_revenue_txn (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month         DATE NOT NULL,
  line          TEXT NOT NULL CHECK (line IN ('pt_credits','pt_membership','pt_rent','new_model')),
  customer_id   TEXT NOT NULL DEFAULT '',   -- '' (not NULL) so the unique key dedupes blank-customer rows
  item          TEXT NOT NULL,
  txn_date      DATE NOT NULL,
  gross_amount  NUMERIC(10,2) NOT NULL,
  state         TEXT,                        -- WodBoard State: Settled / Scheduled / Written Off
  coach_name    TEXT,                        -- attributed coach (nullable)
  seq           INTEGER NOT NULL DEFAULT 0,  -- ordinal among identical same-day rows in one file
  source_file   TEXT,
  uploaded_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (month, line, customer_id, item, txn_date, gross_amount, seq)
);

CREATE INDEX IF NOT EXISTS idx_pt_revenue_txn_month ON pt_revenue_txn (month);

-- ── ROW LEVEL SECURITY (mirrors the existing tables) ──────────────
ALTER TABLE pt_revenue_txn ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_revenue_txn" ON pt_revenue_txn FOR SELECT USING (true);
CREATE POLICY "anon_insert_revenue_txn" ON pt_revenue_txn FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_update_revenue_txn" ON pt_revenue_txn FOR UPDATE USING (true);
CREATE POLICY "anon_delete_revenue_txn" ON pt_revenue_txn FOR DELETE USING (true);
