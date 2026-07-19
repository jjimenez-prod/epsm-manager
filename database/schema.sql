


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."create_production_batch"("payload" "jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."create_production_batch"("payload" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$

BEGIN

    NEW.updated_at = NOW();

    RETURN NEW;

END;

$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."audit_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "table_name" "text" NOT NULL,
    "record_id" "uuid" NOT NULL,
    "action" "text" NOT NULL,
    "modified_by" "uuid",
    "modified_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reason" "text",
    "old_values" "jsonb",
    "new_values" "jsonb",
    CONSTRAINT "audit_log_action_check" CHECK (("action" = ANY (ARRAY['INSERT'::"text", 'UPDATE'::"text", 'CANCEL'::"text"])))
);


ALTER TABLE "public"."audit_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."batch_operators" (
    "batch_id" "uuid" NOT NULL,
    "operator_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."batch_operators" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."dough_batches" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "production_date" "date" NOT NULL,
    "shift_id" "uuid" NOT NULL,
    "recipe_id" "uuid" NOT NULL,
    "initial_weight_g" integer NOT NULL,
    "leftover_added_g" integer DEFAULT 0 NOT NULL,
    "total_weight_g" integer GENERATED ALWAYS AS (("initial_weight_g" + "leftover_added_g")) STORED,
    "leftover_remaining_g" integer DEFAULT 0 NOT NULL,
    "notes" "text",
    "status" "text" DEFAULT 'ACTIVE'::"text" NOT NULL,
    "created_by" "uuid",
    "updated_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "other_ingredients_g" integer DEFAULT 0 NOT NULL,
    "flour_g" integer DEFAULT 0 NOT NULL,
    "water_g" integer DEFAULT 0 NOT NULL,
    "standard_dough_count" integer DEFAULT 1 NOT NULL,
    "recipe_version" integer,
    "recipe_display_name" "text",
    "recipe_type" "text",
    CONSTRAINT "dough_batches_check" CHECK (("leftover_remaining_g" <= "total_weight_g")),
    CONSTRAINT "dough_batches_initial_weight_g_check" CHECK (("initial_weight_g" > 0)),
    CONSTRAINT "dough_batches_leftover_added_g_check" CHECK (("leftover_added_g" >= 0)),
    CONSTRAINT "dough_batches_leftover_remaining_g_check" CHECK (("leftover_remaining_g" >= 0)),
    CONSTRAINT "dough_batches_status_check" CHECK (("status" = ANY (ARRAY['ACTIVE'::"text", 'CANCELLED'::"text"])))
);


ALTER TABLE "public"."dough_batches" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."operators" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "full_name" "text" NOT NULL,
    "role" "text" NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "operators_role_check" CHECK (("role" = ANY (ARRAY['ADMIN'::"text", 'OPERATOR'::"text"])))
);


ALTER TABLE "public"."operators" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."production_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "quantity" integer NOT NULL,
    "notes" "text",
    "created_by" "uuid",
    "updated_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "product_grammage_g" integer DEFAULT 0 NOT NULL,
    CONSTRAINT "production_items_quantity_check" CHECK (("quantity" > 0))
);


ALTER TABLE "public"."production_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "legacy_id" integer NOT NULL,
    "code" "text" NOT NULL,
    "name" "text" NOT NULL,
    "grammage_g" integer NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "products_grammage_g_check" CHECK (("grammage_g" > 0))
);


ALTER TABLE "public"."products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recipes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recipe_type" "text" NOT NULL,
    "display_name" "text" NOT NULL,
    "is_standard" boolean NOT NULL,
    "default_flour_g" integer NOT NULL,
    "default_water_g" integer NOT NULL,
    "default_other_ingredients_g" integer NOT NULL,
    "default_total_weight_g" integer NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "auto_calculate" boolean DEFAULT false,
    "fixed_extra_weight_g" integer DEFAULT 0,
    "default_initial_weight_g" integer,
    "show_initial_weight" boolean DEFAULT true,
    "version" integer DEFAULT 1 NOT NULL,
    CONSTRAINT "recipes_default_flour_g_check" CHECK (("default_flour_g" >= 0)),
    CONSTRAINT "recipes_default_other_ingredients_g_check" CHECK (("default_other_ingredients_g" >= 0)),
    CONSTRAINT "recipes_default_total_weight_g_check" CHECK (("default_total_weight_g" > 0)),
    CONSTRAINT "recipes_default_water_g_check" CHECK (("default_water_g" >= 0))
);


ALTER TABLE "public"."recipes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reference_ranges" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "grammage_g" integer NOT NULL,
    "min_units" integer NOT NULL,
    "max_units" integer NOT NULL,
    CONSTRAINT "reference_ranges_check" CHECK (("max_units" >= "min_units")),
    CONSTRAINT "reference_ranges_grammage_g_check" CHECK (("grammage_g" > 0)),
    CONSTRAINT "reference_ranges_min_units_check" CHECK (("min_units" >= 0))
);


ALTER TABLE "public"."reference_ranges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."settings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category" "text" NOT NULL,
    "key" "text" NOT NULL,
    "value" "text" NOT NULL,
    "data_type" "text" NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."shifts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shifts" OWNER TO "postgres";


ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."batch_operators"
    ADD CONSTRAINT "batch_operators_pkey" PRIMARY KEY ("batch_id", "operator_id");



ALTER TABLE ONLY "public"."dough_batches"
    ADD CONSTRAINT "dough_batches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."operators"
    ADD CONSTRAINT "operators_full_name_key" UNIQUE ("full_name");



ALTER TABLE ONLY "public"."operators"
    ADD CONSTRAINT "operators_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "production_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_legacy_id_key" UNIQUE ("legacy_id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."recipes"
    ADD CONSTRAINT "recipes_display_name_key" UNIQUE ("display_name");



ALTER TABLE ONLY "public"."recipes"
    ADD CONSTRAINT "recipes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."recipes"
    ADD CONSTRAINT "recipes_recipe_type_version_key" UNIQUE ("recipe_type", "version");



ALTER TABLE ONLY "public"."reference_ranges"
    ADD CONSTRAINT "reference_ranges_grammage_g_key" UNIQUE ("grammage_g");



ALTER TABLE ONLY "public"."reference_ranges"
    ADD CONSTRAINT "reference_ranges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."settings"
    ADD CONSTRAINT "settings_key_key" UNIQUE ("key");



ALTER TABLE ONLY "public"."settings"
    ADD CONSTRAINT "settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."shifts"
    ADD CONSTRAINT "shifts_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."shifts"
    ADD CONSTRAINT "shifts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "uq_batch_product" UNIQUE ("batch_id", "product_id");



CREATE INDEX "idx_audit_date" ON "public"."audit_log" USING "btree" ("modified_at");



CREATE INDEX "idx_audit_record" ON "public"."audit_log" USING "btree" ("table_name", "record_id");



CREATE INDEX "idx_batch_created_at" ON "public"."dough_batches" USING "btree" ("created_at");



CREATE INDEX "idx_batch_date" ON "public"."dough_batches" USING "btree" ("production_date");



CREATE INDEX "idx_batch_recipe" ON "public"."dough_batches" USING "btree" ("recipe_id");



CREATE INDEX "idx_batch_shift" ON "public"."dough_batches" USING "btree" ("shift_id");



CREATE INDEX "idx_batch_status" ON "public"."dough_batches" USING "btree" ("status");



CREATE INDEX "idx_operator_active" ON "public"."operators" USING "btree" ("active");



CREATE INDEX "idx_product_active" ON "public"."products" USING "btree" ("active");



CREATE INDEX "idx_product_legacy" ON "public"."products" USING "btree" ("legacy_id");



CREATE INDEX "idx_production_batch" ON "public"."production_items" USING "btree" ("batch_id");



CREATE INDEX "idx_production_product" ON "public"."production_items" USING "btree" ("product_id");



CREATE INDEX "idx_settings_category" ON "public"."settings" USING "btree" ("category");



CREATE UNIQUE INDEX "ux_recipes_one_active_per_type" ON "public"."recipes" USING "btree" ("recipe_type") WHERE ("active" = true);



CREATE OR REPLACE TRIGGER "trg_update_dough_batches_updated_at" BEFORE UPDATE ON "public"."dough_batches" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_modified_by_fkey" FOREIGN KEY ("modified_by") REFERENCES "public"."operators"("id");



ALTER TABLE ONLY "public"."batch_operators"
    ADD CONSTRAINT "batch_operators_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."dough_batches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."batch_operators"
    ADD CONSTRAINT "batch_operators_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "public"."operators"("id");



ALTER TABLE ONLY "public"."dough_batches"
    ADD CONSTRAINT "dough_batches_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."operators"("id");



ALTER TABLE ONLY "public"."dough_batches"
    ADD CONSTRAINT "dough_batches_recipe_id_fkey" FOREIGN KEY ("recipe_id") REFERENCES "public"."recipes"("id");



ALTER TABLE ONLY "public"."dough_batches"
    ADD CONSTRAINT "dough_batches_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "public"."shifts"("id");



ALTER TABLE ONLY "public"."dough_batches"
    ADD CONSTRAINT "dough_batches_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."operators"("id");



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "production_items_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."dough_batches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "production_items_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."operators"("id");



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "production_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."production_items"
    ADD CONSTRAINT "production_items_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."operators"("id");



ALTER TABLE "public"."operators" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "operators_select_anon" ON "public"."operators" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "products_select_anon" ON "public"."products" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."recipes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "recipes_select_anon" ON "public"."recipes" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."reference_ranges" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "reference_ranges_select_anon" ON "public"."reference_ranges" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."settings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "settings_select_anon" ON "public"."settings" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."shifts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "shifts_select_anon" ON "public"."shifts" FOR SELECT TO "anon" USING (true);



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."create_production_batch"("payload" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."create_production_batch"("payload" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_production_batch"("payload" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";



GRANT ALL ON TABLE "public"."audit_log" TO "anon";
GRANT ALL ON TABLE "public"."audit_log" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_log" TO "service_role";



GRANT ALL ON TABLE "public"."batch_operators" TO "anon";
GRANT ALL ON TABLE "public"."batch_operators" TO "authenticated";
GRANT ALL ON TABLE "public"."batch_operators" TO "service_role";



GRANT ALL ON TABLE "public"."dough_batches" TO "anon";
GRANT ALL ON TABLE "public"."dough_batches" TO "authenticated";
GRANT ALL ON TABLE "public"."dough_batches" TO "service_role";



GRANT ALL ON TABLE "public"."operators" TO "anon";
GRANT ALL ON TABLE "public"."operators" TO "authenticated";
GRANT ALL ON TABLE "public"."operators" TO "service_role";



GRANT ALL ON TABLE "public"."production_items" TO "anon";
GRANT ALL ON TABLE "public"."production_items" TO "authenticated";
GRANT ALL ON TABLE "public"."production_items" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."recipes" TO "anon";
GRANT ALL ON TABLE "public"."recipes" TO "authenticated";
GRANT ALL ON TABLE "public"."recipes" TO "service_role";



GRANT ALL ON TABLE "public"."reference_ranges" TO "anon";
GRANT ALL ON TABLE "public"."reference_ranges" TO "authenticated";
GRANT ALL ON TABLE "public"."reference_ranges" TO "service_role";



GRANT ALL ON TABLE "public"."settings" TO "anon";
GRANT ALL ON TABLE "public"."settings" TO "authenticated";
GRANT ALL ON TABLE "public"."settings" TO "service_role";



GRANT ALL ON TABLE "public"."shifts" TO "anon";
GRANT ALL ON TABLE "public"."shifts" TO "authenticated";
GRANT ALL ON TABLE "public"."shifts" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







