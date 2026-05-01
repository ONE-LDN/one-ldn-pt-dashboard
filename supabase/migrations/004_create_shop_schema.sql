-- Migration: create_shop_schema
-- Adds shop_product_lookup and shop_deliveries tables

CREATE TABLE public.shop_product_lookup (
  product_name_raw text    NOT NULL,
  brand            text    NOT NULL,
  category         text    NOT NULL,
  subcategory      text,
  display_name     text,
  collection       text,
  product_type     text,
  colourway        text,
  size             text,
  active           boolean NOT NULL DEFAULT true,
  CONSTRAINT shop_product_lookup_pkey PRIMARY KEY (product_name_raw)
);

ALTER TABLE public.shop_product_lookup ENABLE ROW LEVEL SECURITY;

CREATE POLICY anon_read_shop_product_lookup ON public.shop_product_lookup
  FOR SELECT TO anon USING (true);

CREATE POLICY auth_all_shop_product_lookup ON public.shop_product_lookup
  FOR ALL TO authenticated USING (true);


CREATE TABLE public.shop_deliveries (
  id                uuid        NOT NULL DEFAULT gen_random_uuid(),
  delivery_date     date        NOT NULL,
  product_name_raw  text        NOT NULL,
  quantity_received integer     NOT NULL,
  notes             text,
  created_at        timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT shop_deliveries_pkey PRIMARY KEY (id)
);

ALTER TABLE public.shop_deliveries ENABLE ROW LEVEL SECURITY;

CREATE POLICY anon_select_shop_deliveries ON public.shop_deliveries
  FOR SELECT TO anon USING (true);

CREATE POLICY anon_insert_shop_deliveries ON public.shop_deliveries
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY auth_all_shop_deliveries ON public.shop_deliveries
  FOR ALL TO authenticated USING (true);
