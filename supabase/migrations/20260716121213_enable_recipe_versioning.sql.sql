-- ============================================================================
-- EPIC 3
-- Task 3.5.5.1b
--
-- Enable Recipe Versioning
--
-- Business Identity:
--   (recipe_type, version)
--
-- Business Rule:
--   - A recipe version is uniquely identified by (recipe_type, version)
--   - Only one active recipe may exist for each recipe_type
-- ============================================================================

-- Remove legacy business identity
ALTER TABLE public.recipes
DROP CONSTRAINT recipes_recipe_type_key;

-- Define the new business identity
ALTER TABLE public.recipes
ADD CONSTRAINT recipes_recipe_type_version_key
UNIQUE (recipe_type, version);