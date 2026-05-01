-- Migration: add_shop_dashboard_tables
-- Adds shop_sales and shop_upload_log tables

CREATE TABLE public.shop_sales (
  id               uuid        NOT NULL DEFAULT gen_random_uuid(),
  order_no         text        NOT NULL,
  order_line       integer     NOT NULL DEFAULT 1,
  customer         text,
  email            text,
  product_name_raw text        NOT NULL,
  quantity         integer     NOT NULL DEFAULT 1,
  gross_revenue    numeric     NOT NULL DEFAULT 0,
  revenue_per_unit numeric     NOT NULL DEFAULT 0,
  state            text        NOT NULL,
  fulfilled        text,
  date             timestamptz NOT NULL,
  week_start       date        NOT NULL,
  inserted_at      timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT shop_sales_pkey PRIMARY KEY (id),
  CONSTRAINT shop_sales_order_line_unique UNIQUE (order_no, order_line)
);

ALTER TABLE public.shop_sales ENABLE ROW LEVEL SECURITY;

CREATE POLICY anon_select_shop_sales ON public.shop_sales
  FOR SELECT TO anon USING (true);

CREATE POLICY anon_insert_shop_sales ON public.shop_sales
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY auth_all_shop_sales ON public.shop_sales
  FOR ALL TO authenticated USING (true);


CREATE TABLE public.shop_upload_log (
  id               uuid        NOT NULL DEFAULT gen_random_uuid(),
  filename         text        NOT NULL,
  uploaded_at      timestamptz NOT NULL DEFAULT now(),
  rows_inserted    integer     NOT NULL DEFAULT 0,
  rows_skipped     integer     NOT NULL DEFAULT 0,
  date_range_start date,
  date_range_end   date,
  uploaded_by      text        DEFAULT 'anonymous',
  CONSTRAINT shop_upload_log_pkey PRIMARY KEY (id)
);

ALTER TABLE public.shop_upload_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY anon_select_shop_upload_log ON public.shop_upload_log
  FOR SELECT TO anon USING (true);

CREATE POLICY anon_insert_shop_upload_log ON public.shop_upload_log
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY auth_all_shop_upload_log ON public.shop_upload_log
  FOR ALL TO authenticated USING (true);
