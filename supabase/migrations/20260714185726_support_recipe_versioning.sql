-- =============================================================================

-- EPSM Manager

-- Migration: Support Recipe Versioning

-- Version: 1.0.3

-- =============================================================================

ALTER TABLE public.recipes

ADD COLUMN version integer NOT NULL DEFAULT 1;
