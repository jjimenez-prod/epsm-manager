/*
===============================================================================
Function
===============================================================================

resolve_comparison_period()

===============================================================================
Purpose
===============================================================================

Resolve the current analysis period and its comparison period.

This helper is shared by every Analytics RPC.

===============================================================================
Responsibilities
===============================================================================

✓ Resolve the comparison period.

✓ Return both periods.

===============================================================================
Does NOT
===============================================================================

✗ Read database tables.

✗ Calculate KPIs.

✗ Build JSON.

✗ Perform business logic.

===============================================================================
Supported comparison modes (v1)
===============================================================================

- previous_period

===============================================================================
*/

CREATE OR REPLACE FUNCTION public.resolve_comparison_period(

    p_date_from date,
    p_date_to date,
    p_comparison_mode text

)

RETURNS TABLE (

    current_from date,
    current_to date,

    previous_from date,
    previous_to date

)

LANGUAGE plpgsql

AS
$$

DECLARE

    v_days integer;

BEGIN

    --------------------------------------------------------------------------
    -- SECTION 1
    -- Resolve Comparison Strategy
    --------------------------------------------------------------------------

    CASE p_comparison_mode

        ----------------------------------------------------------------------
        -- Previous equivalent period
        ----------------------------------------------------------------------

        WHEN 'previous_period' THEN

            ------------------------------------------------------------------
            -- Full Calendar Year
            ------------------------------------------------------------------

            IF
                p_date_from = make_date(EXTRACT(YEAR FROM p_date_from)::integer, 1, 1)
                AND
                p_date_to = make_date(EXTRACT(YEAR FROM p_date_to)::integer, 12, 31)
            THEN

                RETURN QUERY

                SELECT

                    p_date_from,
                    p_date_to,

                    make_date(EXTRACT(YEAR FROM p_date_from)::integer - 1, 1, 1),

                    make_date(EXTRACT(YEAR FROM p_date_from)::integer - 1, 12, 31);

            ------------------------------------------------------------------
            -- Full Calendar Month
            ------------------------------------------------------------------

            ELSIF
                p_date_from = date_trunc('month', p_date_from)::date
                AND
                p_date_to =
                    (
                        date_trunc('month', p_date_to)
                        + interval '1 month'
                        - interval '1 day'
                    )::date
            THEN

                RETURN QUERY

                SELECT

                    p_date_from,
                    p_date_to,

                    date_trunc(
                        'month',
                        p_date_from - interval '1 month'
                    )::date,

                    (
                        date_trunc(
                            'month',
                            p_date_from
                        ) - interval '1 day'
                    )::date;

            ------------------------------------------------------------------
            -- Generic Equivalent Period
            ------------------------------------------------------------------

            ELSE

                v_days :=
                    (p_date_to - p_date_from) + 1;

                RETURN QUERY

                SELECT

                    p_date_from,
                    p_date_to,

                    (p_date_from - v_days),

                    (p_date_from - 1);

            END IF;

        ----------------------------------------------------------------------
        -- Future comparison strategies
        ----------------------------------------------------------------------

        WHEN 'same_period_last_year' THEN

            RAISE EXCEPTION
                USING ERRCODE = '0A000';

        WHEN 'none' THEN

            RETURN QUERY

            SELECT

                p_date_from,
                p_date_to,

                NULL::date,
                NULL::date;

        ----------------------------------------------------------------------
        -- Unsupported strategy
        ----------------------------------------------------------------------

        ELSE

            RAISE EXCEPTION
                USING ERRCODE = '22023';

    END CASE;

END;

$$;