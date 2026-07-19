/******************************************************************************
------------------------------------------------------------------------------
 Project
------------------------------------------------------------------------------
 EPSM Manager

------------------------------------------------------------------------------
 Epic
------------------------------------------------------------------------------
 EPIC 3 - Production Engine

------------------------------------------------------------------------------
 Task
------------------------------------------------------------------------------
 3.5.6 - Production Engine v1

------------------------------------------------------------------------------
 Migration
------------------------------------------------------------------------------
 20260716_epic3_task356_production_engine_v1.sql

------------------------------------------------------------------------------
 Function
------------------------------------------------------------------------------
 public.create_production_batch(payload jsonb)

------------------------------------------------------------------------------
 Purpose
------------------------------------------------------------------------------
 Creates a complete Production Batch from the approved payload contract.

------------------------------------------------------------------------------
 Responsibilities
------------------------------------------------------------------------------
 - Read Payload
 - Validate Payload
 - Validate Business Rules
 - Build Production Snapshot
 - Persist Aggregate
 - Return Operation Result

------------------------------------------------------------------------------
 Architectural Principles
------------------------------------------------------------------------------
 - Business First
 - Database as Single Source of Truth
 - Thin Frontend
 - Historical Data Integrity
 - Future Proof
 - KISS

------------------------------------------------------------------------------
 Payload Contract
------------------------------------------------------------------------------
 {
   "production_date": "...",
   "shift_id": "...",

   "recipe": {
      "recipe_id": "...",
      "standard_dough_count": 2,
      "leftover_added_g": 500,
      "leftover_remaining_g": 100
      "flour_g": 24000,
      "water_g": 13000,
      "other_ingredients_g": 1000,
   },

   "operators":[...],

   "production_items":[...],

   "notes":"..."
 }

------------------------------------------------------------------------------
 Return Contract
------------------------------------------------------------------------------
 Success

 {
    "success": true,
    "batch_id": "uuid"
 }

 Error

 {
    "success": false,
    "error_code": "...",
    "message": "...",
    "details": { ... }
 }

------------------------------------------------------------------------------
 Change Log
------------------------------------------------------------------------------
 v1.0.3 RC1
 2026-07-16
 Initial Production Engine implementation.
-------------------------------------------------------------------------------
------------------------------------------------------------------------------
 Future Work
------------------------------------------------------------------------------
 - Audit Log
 - Update Production Batch
 - Batch Cancellation
 - Stock Consumption
------------------------------------------------------------------------------
******************************************************************************/

CREATE OR REPLACE FUNCTION public.create_production_batch(payload jsonb)
RETURNS jsonb

LANGUAGE plpgsql

AS $$

DECLARE

    --------------------------------------------------------------------------
    -- Payload
    --------------------------------------------------------------------------

    v_production_date date;
    v_shift_id uuid;
    v_notes text;

    v_recipe_id uuid;
    v_standard_dough_count integer;
    v_leftover_added_g integer;
    v_leftover_remaining_g integer;

    v_operators jsonb;
    v_production_items jsonb;

    --------------------------------------------------------------------------
    -- Recipe
    --------------------------------------------------------------------------

    v_recipe recipes%ROWTYPE;

    --------------------------------------------------------------------------
    -- Snapshot
    --------------------------------------------------------------------------

    v_flour_g integer;
    v_water_g integer;
    v_other_ingredients_g integer;
    v_initial_weight_g integer;

    --------------------------------------------------------------------------
    -- Persistence
    --------------------------------------------------------------------------

    v_batch_id uuid;

BEGIN

    --------------------------------------------------------------------------
    -- SECTION 1
    -- Read Payload
    --------------------------------------------------------------------------

    v_production_date :=
        (payload ->> 'production_date')::date;

    v_shift_id :=
        (payload ->> 'shift_id')::uuid;

    v_notes :=
        payload ->> 'notes';

    v_recipe_id :=
        (payload -> 'recipe' ->> 'recipe_id')::uuid;

    v_standard_dough_count :=
    COALESCE(
        (payload -> 'recipe' ->> 'standard_dough_count')::integer,
        1
    );

    v_flour_g :=
    (payload -> 'recipe' ->> 'flour_g')::integer;

    v_water_g :=
    (payload -> 'recipe' ->> 'water_g')::integer;

    v_other_ingredients_g :=
    (payload -> 'recipe' ->> 'other_ingredients_g')::integer;

    v_leftover_added_g :=
    COALESCE(
        (payload -> 'recipe' ->> 'leftover_added_g')::integer,
        0
    );

    v_leftover_remaining_g :=
        COALESCE(
            (payload -> 'recipe' ->> 'leftover_remaining_g')::integer,
            0
        );

    v_operators :=
        payload -> 'operators';

    v_production_items :=
        payload -> 'production_items';

    --------------------------------------------------------------------------
    -- SECTION 2
    -- Payload Validation
    --------------------------------------------------------------------------

    IF v_production_date IS NULL THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'production_date is required.',
            'details', jsonb_build_object(
                'field', 'production_date'
            )
        );

    END IF;

    IF v_shift_id IS NULL THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'shift_id is required.',
            'details', jsonb_build_object(
                'field', 'shift_id'
            )
        );

    END IF;

    IF v_recipe_id IS NULL THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'recipe.recipe_id is required.',
            'details', jsonb_build_object(
                'field', 'recipe.recipe_id'
            )
        );

    END IF;

    IF v_standard_dough_count <= 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'standard_dough_count must be greater than zero.',
            'details', jsonb_build_object(
                'field', 'recipe.standard_dough_count'
            )
        );

    END IF;

    IF v_leftover_added_g < 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'leftover_added_g cannot be negative.',
            'details', jsonb_build_object(
                'field', 'recipe.leftover_added_g'
            )
        );

    END IF;

    IF v_leftover_remaining_g < 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'leftover_remaining_g cannot be negative.',
            'details', jsonb_build_object(
                'field', 'recipe.leftover_remaining_g'
            )
        );

    END IF;

    IF v_operators IS NULL
       OR jsonb_typeof(v_operators) <> 'array'
       OR jsonb_array_length(v_operators) = 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'At least one operator is required.',
            'details', jsonb_build_object(
                'field', 'operators'
            )
        );

    END IF;

    IF v_production_items IS NULL
       OR jsonb_typeof(v_production_items) <> 'array'
       OR jsonb_array_length(v_production_items) = 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'At least one production item is required.',
            'details', jsonb_build_object(
                'field', 'production_items'
            )
        );

    END IF;

    --------------------------------------------------------------------------
    -- SECTION 3
    -- Business Validation
    --------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Validate Shift
    --------------------------------------------------------------------------

    IF NOT EXISTS (
        SELECT 1
          FROM public.shifts
         WHERE id = v_shift_id
           AND active = true
    ) THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'SHIFT_NOT_FOUND',
            'message', 'Shift not found or inactive.',
            'details', jsonb_build_object(
                'field', 'shift_id',
                'shift_id', v_shift_id
            )
        );

    END IF;

    --------------------------------------------------------------------------
    -- Read Recipe
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
            'message', 'Recipe not found or inactive.',
            'details', jsonb_build_object(
                'field', 'recipe.recipe_id',
                'recipe_id', v_recipe_id
            )
        );

    END IF;

--------------------------------------------------------------------------
-- Validate Special Recipe Payload
--------------------------------------------------------------------------

IF v_recipe.recipe_type = 'SPECIAL' THEN

    IF v_flour_g IS NULL OR v_flour_g <= 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'recipe.flour_g is required.',
            'details', jsonb_build_object(
                'field', 'recipe.flour_g'
            )
        );

    END IF;

    IF v_water_g IS NULL OR v_water_g <= 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'recipe.water_g is required.',
            'details', jsonb_build_object(
                'field', 'recipe.water_g'
            )
        );

    END IF;

    IF v_other_ingredients_g IS NULL
       OR v_other_ingredients_g < 0 THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'INVALID_PAYLOAD',
            'message', 'recipe.other_ingredients_g is required.',
            'details', jsonb_build_object(
                'field', 'recipe.other_ingredients_g'
            )
        );

    END IF;

END IF;

    --------------------------------------------------------------------------
    -- Validate Duplicate Operators
    --------------------------------------------------------------------------

    IF EXISTS (

        SELECT 1
          FROM (
                SELECT (value->>'operator_id')::uuid AS operator_id
                  FROM jsonb_array_elements(v_operators)
               ) t
         GROUP BY operator_id
        HAVING COUNT(*) > 1

    ) THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'DUPLICATE_OPERATOR',
            'message', 'Duplicate operators are not allowed.',
            'details', jsonb_build_object(
                'field', 'operators'
            )
        );

    END IF;

    --------------------------------------------------------------------------
    -- Validate Operators
    --------------------------------------------------------------------------

    IF EXISTS (

        SELECT 1

          FROM (
                SELECT (value->>'operator_id')::uuid AS operator_id
                  FROM jsonb_array_elements(v_operators)
               ) o

          LEFT JOIN public.operators op
                 ON op.id = o.operator_id

         WHERE op.id IS NULL
            OR op.active = false

    ) THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'OPERATOR_NOT_FOUND',
            'message', 'One or more operators do not exist or are inactive.',
            'details',

                (
                    SELECT jsonb_build_object(
                        'field','operators',
                        'operator_id', o.operator_id
                    )

                    FROM (

                        SELECT (value->>'operator_id')::uuid AS operator_id
                        FROM jsonb_array_elements(v_operators)

                    ) o

                    LEFT JOIN public.operators op
                           ON op.id = o.operator_id

                    WHERE op.id IS NULL
                       OR op.active = false

                    LIMIT 1
                )

        );

    END IF;

    --------------------------------------------------------------------------
    -- Validate Duplicate Products
    --------------------------------------------------------------------------

    IF EXISTS (

        SELECT 1
          FROM (
                SELECT (value->>'product_id')::uuid AS product_id
                  FROM jsonb_array_elements(v_production_items)
               ) p
         GROUP BY product_id
        HAVING COUNT(*) > 1

    ) THEN

        RETURN jsonb_build_object(
            'success', false,
            'error_code', 'DUPLICATE_PRODUCT',
            'message', 'Duplicate products are not allowed.',
            'details', jsonb_build_object(
                'field','production_items'
            )
        );

    END IF;

    --------------------------------------------------------------------------
    -- Validate Products
    --------------------------------------------------------------------------

    IF EXISTS (

        SELECT 1

          FROM (

                SELECT
                    (value->>'product_id')::uuid AS product_id

                FROM jsonb_array_elements(v_production_items)

          ) p

          LEFT JOIN public.products pr
                 ON pr.id = p.product_id

         WHERE pr.id IS NULL
            OR pr.active = false

    ) THEN

        RETURN jsonb_build_object(

            'success', false,
            'error_code', 'PRODUCT_NOT_FOUND',
            'message', 'One or more products do not exist or are inactive.',

            'details',

                (
                    SELECT jsonb_build_object(
                        'field','production_items',
                        'product_id', p.product_id
                    )

                    FROM (

                        SELECT
                            (value->>'product_id')::uuid AS product_id

                        FROM jsonb_array_elements(v_production_items)

                    ) p

                    LEFT JOIN public.products pr
                           ON pr.id = p.product_id

                    WHERE pr.id IS NULL
                       OR pr.active = false

                    LIMIT 1
                )

        );

    END IF;

    --------------------------------------------------------------------------
    -- Validate Quantities
    --------------------------------------------------------------------------

    IF EXISTS (

        SELECT 1

          FROM (

                SELECT

                    (value->>'product_id')::uuid AS product_id,
                    (value->>'quantity')::integer AS quantity

                FROM jsonb_array_elements(v_production_items)

          ) p

         WHERE quantity <= 0

    ) THEN

        RETURN jsonb_build_object(

            'success', false,
            'error_code', 'INVALID_QUANTITY',
            'message', 'Quantity must be greater than zero.',

            'details',

                (
                    SELECT jsonb_build_object(
                        'field','production_items.quantity',
                        'product_id', product_id,
                        'quantity', quantity
                    )

                    FROM (

                        SELECT

                            (value->>'product_id')::uuid AS product_id,
                            (value->>'quantity')::integer AS quantity

                        FROM jsonb_array_elements(v_production_items)

                    ) q

                    WHERE quantity <= 0

                    LIMIT 1
                )

        );

    END IF;

--------------------------------------------------------------------------
-- SECTION 4
-- Build Production Snapshot
--------------------------------------------------------------------------

IF v_recipe.recipe_type = 'STANDARD' THEN

    v_flour_g :=
        v_recipe.default_flour_g * v_standard_dough_count;

    v_water_g :=
        v_recipe.default_water_g * v_standard_dough_count;

    v_other_ingredients_g :=
        v_recipe.default_other_ingredients_g * v_standard_dough_count;

ELSE

    -- SPECIAL
    -- Values come directly from payload.

END IF;

v_initial_weight_g :=
      v_flour_g
    + v_water_g
    + v_other_ingredients_g;

--------------------------------------------------------------------------
-- total_weight_g is automatically calculated by PostgreSQL
-- as a generated column:
--
-- total_weight_g = initial_weight_g + leftover_added_g
--------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- SECTION 5
    -- Persist Aggregate
    -- (PART 3)
    --------------------------------------------------------------------------
    --------------------------------------------------------------------------
    -- Insert Dough Batch
    --------------------------------------------------------------------------

    INSERT INTO public.dough_batches (

        production_date,
        shift_id,
        recipe_id,

        standard_dough_count,

        flour_g,
        water_g,
        other_ingredients_g,

        initial_weight_g,
        leftover_added_g,
        leftover_remaining_g,

        notes,

        recipe_version,
        recipe_display_name,
        recipe_type

    )

    VALUES (

        v_production_date,
        v_shift_id,
        v_recipe.id,

        v_standard_dough_count,

        v_flour_g,
        v_water_g,
        v_other_ingredients_g,

        v_initial_weight_g,
        v_leftover_added_g,
        v_leftover_remaining_g,

        v_notes,

        v_recipe.version,
        v_recipe.display_name,
        v_recipe.recipe_type

    )

    RETURNING id
      INTO v_batch_id;

    --------------------------------------------------------------------------
    -- Insert Batch Operators
    --------------------------------------------------------------------------

    INSERT INTO public.batch_operators (

        batch_id,
        operator_id

    )

    SELECT

        v_batch_id,

        (value ->> 'operator_id')::uuid

    FROM jsonb_array_elements(v_operators);
    
    --------------------------------------------------------------------------
    -- SECTION 6
    -- Persist Production Items
    -- (PART 4)
    --------------------------------------------------------------------------
    --------------------------------------------------------------------------
    -- Insert Production Items
    --------------------------------------------------------------------------

    INSERT INTO public.production_items (

        batch_id,
        product_id,
        quantity,
        product_grammage_g

    )

    SELECT

        v_batch_id,

        p.id,

        i.quantity,

        p.grammage_g

    FROM (

        SELECT

            (value ->> 'product_id')::uuid    AS product_id,
            (value ->> 'quantity')::integer   AS quantity

        FROM jsonb_array_elements(v_production_items)

    ) i

    INNER JOIN public.products p
            ON p.id = i.product_id;

    --------------------------------------------------------------------------
    -- SECTION 7
    -- Return Response
    --------------------------------------------------------------------------

    RETURN jsonb_build_object(

        'success', true,

        'batch_id', v_batch_id

    );

END;

$$;