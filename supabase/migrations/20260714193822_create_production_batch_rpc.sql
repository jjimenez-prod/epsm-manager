-- =============================================================================
-- EPSM Manager
-- Migration: Create Production Batch RPC
-- Version: 1.0.3
-- =============================================================================

CREATE OR REPLACE FUNCTION public.create_production_batch(
    payload jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN jsonb_build_object(
        'success', true,
        'message', 'RPC created successfully.',
        'received_payload', payload
    );

END;
$$;