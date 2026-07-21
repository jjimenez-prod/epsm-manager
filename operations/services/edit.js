async function getBatch(batchId) {

    // =====================
    // LOTE
    // =====================

    const { data: batch, error: batchError } =
        await window.supabaseClient

            .from("dough_batches")

            .select("*")

            .eq("id", batchId)

            .single();

    if (batchError) {

        console.error(batchError);

        throw batchError;

    }

    // =====================
    // OPERADORES
    // =====================

    const { data: operators, error: operatorsError } =
        await window.supabaseClient

            .from("batch_operators")

            .select("operator_id")

            .eq("batch_id", batchId);

    if (operatorsError) {

        console.error(operatorsError);

        throw operatorsError;

    }

    // =====================
    // PRODUCTOS
    // =====================

    const { data: products, error: productsError } =
        await window.supabaseClient

            .from("production_items")

            .select("product_id, quantity")

            .eq("batch_id", batchId);

    if (productsError) {

        console.error(productsError);

        throw productsError;

    }

// ==========================================================================
// STEP 4
// Build Form Payload
// ==========================================================================
//
// Converts database entities into the canonical payload
// expected by fillForm().
//
// The returned object mirrors the same structure used by
// create_production_batch() and update_production_batch().
// ==========================================================================

return {

    id: batch.id,

    productionDate: batch.production_date,

    shiftId: batch.shift_id,

    initialWeight: batch.initial_weight_g,

recipe: {

    recipe_id: batch.recipe_id,

    recipe_type:
        batch.recipe_type,

    standard_dough_count:
        batch.standard_dough_count,

    flour_g:
        batch.flour_g,

    water_g:
        batch.water_g,

    other_ingredients_g:
        batch.other_ingredients_g,

    leftover_added_g:
        batch.leftover_added_g,

    leftover_remaining_g:
        batch.leftover_remaining_g

},

    notes:
        batch.notes,

    operators:
        operators.map(o => o.operator_id),

    production_items:

        products.map(p => ({

            product_id:
                p.product_id,

            quantity:
                p.quantity

        }))

};
}