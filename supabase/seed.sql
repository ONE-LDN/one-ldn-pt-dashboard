-- ONE LDN PT Dashboard — Seed Data
-- Historical data: Jan–Mar 2026 actuals + H1 forecast
-- Run once after initial schema migration

-- ── REVENUE ACTUALS (Jan–Mar 2026) ──────────────────────────────
INSERT INTO pt_revenue (month, line, amount, source_file) VALUES
  ('2026-01-01', 'pt_credits',    3240.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'pt_membership', 1500.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'pt_rent',       1740.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'new_model',     4429.99, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'pt_credits',    2680.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'pt_membership', 1350.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'pt_rent',       2000.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'new_model',     7654.86, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'pt_credits',    3100.00, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'pt_membership', 1272.00, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'pt_rent',       2000.00, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'new_model',     7158.29, 'PT_model_Original.xlsx')
ON CONFLICT (month, line) DO NOTHING;

-- ── H1 FORECAST TARGETS ─────────────────────────────────────────
INSERT INTO pt_forecast (month, line, amount) VALUES
  ('2026-01-01', 'pt_credits', 7380), ('2026-01-01', 'pt_membership', 1590), ('2026-01-01', 'pt_rent', 1740), ('2026-01-01', 'new_model', 0),
  ('2026-02-01', 'pt_credits', 9040), ('2026-02-01', 'pt_membership', 1590), ('2026-02-01', 'pt_rent', 1740), ('2026-02-01', 'new_model', 4158),
  ('2026-03-01', 'pt_credits', 9180), ('2026-03-01', 'pt_membership', 1590), ('2026-03-01', 'pt_rent', 1740), ('2026-03-01', 'new_model', 10395),
  ('2026-04-01', 'pt_credits', 8520), ('2026-04-01', 'pt_membership', 1272), ('2026-04-01', 'pt_rent', 1740), ('2026-04-01', 'new_model', 19127),
  ('2026-05-01', 'pt_credits', 6200), ('2026-05-01', 'pt_membership',  954), ('2026-05-01', 'pt_rent', 1740), ('2026-05-01', 'new_model', 29106),
  ('2026-06-01', 'pt_credits', 4500), ('2026-06-01', 'pt_membership',  636), ('2026-06-01', 'pt_rent', 1740), ('2026-06-01', 'new_model', 39085)
ON CONFLICT (month, line) DO NOTHING;

-- ── COST ACTUALS (Jan–Mar 2026) ─────────────────────────────────
INSERT INTO pt_costs (month, cost_line, amount, source_file) VALUES
  ('2026-01-01', 'head_of_fitness', 5000.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'craig_clout',      442.75, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'jess_donehue',       0.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'harry_sheppard',     0.00, 'PT_model_Original.xlsx'),
  ('2026-01-01', 'tax_ni',            816.41, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'head_of_fitness', 5000.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'craig_clout',     2096.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'jess_donehue',      93.51, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'harry_sheppard',   162.00, 'PT_model_Original.xlsx'),
  ('2026-02-01', 'tax_ni',          1102.73, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'head_of_fitness', 5000.00, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'craig_clout',     2886.75, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'jess_donehue',     534.30, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'harry_sheppard',   561.00, 'PT_model_Original.xlsx'),
  ('2026-03-01', 'tax_ni',          1347.31, 'PT_model_Original.xlsx')
ON CONFLICT (month, cost_line) DO NOTHING;

-- ── COACH TRANSACTIONS — March 2026 ─────────────────────────────
INSERT INTO pt_coach_transactions (month, coach_name, product_name, amount, quantity, source_file) VALUES
  ('2026-03-01', 'Craig Clout',    'Craig Clout - PT 20 pack',             2300.00, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Craig Clout',    'Craig Clout - PT 4 Pack',              1000.00, 2, 'WOD Board Actuals March'),
  ('2026-03-01', 'Craig Clout',    'Craig Clout - PT 8 Pack',               960.00, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Harry Sheppard', 'Harry Sheppard PT - 10 Pack',           361.29, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Harry Sheppard', 'Harry Shepard PT 5 Pack (Michael)',      339.00, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Jess Donehue',   'Jessica Donehue PT - 8 Pack',           608.00, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Mara Greenwood', 'Mara Greenwood PT - 12 Pack (reduced)', 960.00, 1, 'WOD Board Actuals March'),
  ('2026-03-01', 'Intro / Other',  'Joining Fee + Intro PT Session (New)',   330.00, 11,'WOD Board Actuals March'),
  ('2026-03-01', 'Intro / Other',  'PT Intro Offer - 3 Sessions',            300.00, 2, 'WOD Board Actuals March')
ON CONFLICT (month, product_name, coach_name) DO NOTHING;
