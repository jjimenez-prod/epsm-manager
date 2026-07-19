-- ============================================================================
-- EPIC 3
-- Task 3.5.5.1
--
-- Business Rule:
-- Only one active recipe may exist for each recipe_type.
--
-- This protects the business invariant at the database level.
-- ============================================================================

CREATE UNIQUE INDEX ux_recipes_one_active_per_type
ON public.recipes (recipe_type)
WHERE active = true;