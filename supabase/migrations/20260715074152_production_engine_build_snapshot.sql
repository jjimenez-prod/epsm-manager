-- =============================================================================
-- EPSM Manager
-- Migration: Production Engine - Build Snapshot
-- Version: 1.0.3
-- =============================================================================

CREATE OR REPLACE FUNCTION public.create_production_batch(
    payload jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
AS
$$
DECLARE
    v_recipe_id uuid;
    v_recipe recipes%ROWTYPE;

    v_standard_dough_count integer;
    v_leftover_added_g integer;

    v_flour_g integer;
    v_water_g integer;
    v_osther_ingredients_g integer;
    v_initial_weight_g integer;
    v_total_weight_g integer;

BEGIN

    --------------------------------------------------------------------------
    -- Read payload
    --------------------------------------------------------------------------

    v_recipe_id := (payload ->> 'recipe_id')::uuid;

    v_standard_dough_count :=
        COALESCE((payload ->> 'standard_dough_count')::integer, 1);

    v_leftover_added_g :=
        COALESCE((payload ->> 'leftover_added_g')::integer, 0);

    --------------------------------------------------------------------------
    -- Read recipe
    --------------------------------------------------------------------------

    SELECT *
    INTO v_recipe
    FROM public.recipes
    WHERE id = v_recipe_id
      AND active = true;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'RECIPE_NOT_FOUND',
            'message', 'Recipe not found or inactive.'
        );
    END IF;

    --------------------------------------------------------------------------
    -- Build Production Snapshot
    --------------------------------------------------------------------------

    v_flour_g :=
        v_recipe.default_flour_g * v_standard_dough_count;

    v_water_g :=
        v_recipe.default_water_g * v_standard_dough_count;

    v_other_ingredients_g :=
        v_recipe.default_other_ingredients_g * v_standard_dough_count;

    v_initial_weight_g :=
        v_recipe.default_initial_weight_g * v_standard_dough_count;

    v_total_weight_g :=
        v_initial_weight_g + v_leftover_added_g;

    --------------------------------------------------------------------------
    -- Return Snapshot (temporary)
    --------------------------------------------------------------------------

    RETURN jsonb_build_object(

        'success', true,

        'snapshot',

        jsonb_build_object(

            'recipe_version', v_recipe.version,

            'recipe_display_name', v_recipe.display_name,

            'recipe_type', v_recipe.recipe_type,

            'standard_dough_count', v_standard_dough_count,

            'flour_g', v_flour_g,

            'water_g', v_water_g,

            'other_ingredients_g', v_other_ingredients_g,

            'initial_weight_g', v_initial_weight_g,

            'leftover_added_g', v_leftover_added_g,

            'total_weight_g', v_total_weight_g

        )

    );

END;
$$;