-- Migration: add_pt_target_override
-- Monthly revenue target overrides, shared across devices.
--
-- Previously the override typed into the decision header was written to browser
-- localStorage, so it only existed on the machine that set it. This table makes
-- it a single shared value: one row per month, absent row = use the FORECAST total.

CREATE TABLE public.pt_target_override (
  month       DATE          NOT NULL,
  amount      NUMERIC(10,2) NOT NULL CHECK (amount > 0),
  updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_by  TEXT          DEFAULT 'anonymous',
  CONSTRAINT pt_target_override_pkey PRIMARY KEY (month)
);

ALTER TABLE public.pt_target_override ENABLE ROW LEVEL SECURITY;

-- Public read (no login required), anon write — same posture as pt_revenue/pt_costs.
CREATE POLICY "public_read_target_override"  ON public.pt_target_override FOR SELECT USING (true);
CREATE POLICY "anon_insert_target_override"  ON public.pt_target_override FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_update_target_override"  ON public.pt_target_override FOR UPDATE USING (true);
-- DELETE is needed so a target can be cleared back to the forecast value.
CREATE POLICY "anon_delete_target_override"  ON public.pt_target_override FOR DELETE USING (true);
