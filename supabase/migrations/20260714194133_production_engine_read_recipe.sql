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
BEGIN

    -- Obtener recipe_id desde el payload
    v_recipe_id := (payload ->> 'recipe_id')::uuid;

    -- Buscar la receta
    SELECT *
    INTO v_recipe
    FROM public.recipes
    WHERE id = v_recipe_id
      AND active = true;

    -- Validar existencia
    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'RECIPE_NOT_FOUND',
            'message', 'Recipe not found or inactive.'
        );
    END IF;

    -- Devolver información para validar la lectura
    RETURN jsonb_build_object(
        'success', true,
        'recipe', jsonb_build_object(
            'id', v_recipe.id,
            'version', v_recipe.version,
            'recipe_type', v_recipe.recipe_type,
            'display_name', v_recipe.display_name,
            'default_flour_g', v_recipe.default_flour_g,
            'default_water_g', v_recipe.default_water_g,
            'default_other_ingredients_g', v_recipe.default_other_ingredients_g,
            'default_initial_weight_g', v_recipe.default_initial_weight_g,
            'fixed_extra_weight_g', v_recipe.fixed_extra_weight_g,
            'auto_calculate', v_recipe.auto_calculate
        )
    );

END;
$$;