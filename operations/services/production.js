async function saveProduction(payload) {

    const { data, error } =
        await window.supabaseClient.rpc(

            "create_production_batch",

            {
                payload
            }

        );

    if (error) {

        throw error;

    }

    if (!data.success) {

        throw data;

    }

    return data.batch_id;

}

// ==========================================================================
// STEP 1
// Update Production Batch
// ==========================================================================
//
// Architecture v1.1
//
// The backend is now responsible for:
//
// - Payload validation
// - Business validation
// - Recipe snapshot generation
// - History creation
// - Revision management
// - Persistence
//
// The frontend only sends the payload.
// ==========================================================================

async function updateProduction(batchId, payload) {

    const { data, error } =
        await window.supabaseClient.rpc(

            "update_production_batch",

            {
                p_batch_id: batchId,
                payload
            }

        );

    if (error)
        throw error;

    if (!data.success)
        throw data;

    return data;

}