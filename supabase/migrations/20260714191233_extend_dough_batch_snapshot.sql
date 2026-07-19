-- =============================================================================

-- EPSM Manager

-- Migration: Extend Dough Batch Snapshot

-- Version: 1.0.3

-- =============================================================================

-- Store the number of standard doughs used to generate the batch.

ALTER TABLE public.dough_batches

ADD COLUMN standard_dough_count integer NOT NULL DEFAULT 1;

-- Snapshot of the recipe version used during production.

ALTER TABLE public.dough_batches

ADD COLUMN recipe_version integer;

-- Snapshot of the recipe display name.

ALTER TABLE public.dough_batches

ADD COLUMN recipe_display_name text;

-- Snapshot of the recipe type.

ALTER TABLE public.dough_batches

ADD COLUMN recipe_type text;