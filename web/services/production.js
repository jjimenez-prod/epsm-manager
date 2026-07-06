async function saveProduction(formData) {

    // =====================
    // CREAR LOTE
    // =====================

    const { data: batch, error: batchError } =
        await window.supabaseClient
            .from("dough_batches")
            .insert([{

                production_date: formData.productionDate,

                shift_id: formData.shiftId,

                recipe_id: formData.recipeId,

                initial_weight_g: formData.initialWeight,

                leftover_added_g: formData.leftoverAdded,

                notes: formData.notes

            }])
            .select()
            .single();

    if (batchError)
        throw batchError;

    // =====================
    // OPERADORES
    // =====================

    const operators = formData.operators.map(operatorId => ({

        batch_id: batch.id,

        operator_id: operatorId

    }));

    const { error: operatorsError } =
        await window.supabaseClient
            .from("batch_operators")
            .insert(operators);

    if (operatorsError)
        throw operatorsError;

    // =====================
    // PRODUCTOS
    // =====================

    const items = formData.products.map(product => ({

        batch_id: batch.id,

        product_id: product.productId,

        quantity: product.quantity

    }));

    const { error: itemsError } =
        await window.supabaseClient
            .from("production_items")
            .insert(items);

    if (itemsError)
        throw itemsError;

    return batch.id;

}

async function updateProduction(batchId, formData) {

    // =====================
    // ACTUALIZAR LOTE
    // =====================

    const { error: batchError } =
        await window.supabaseClient
            .from("dough_batches")
            .update({

                production_date: formData.productionDate,

                shift_id: formData.shiftId,

                recipe_id: formData.recipeId,

                initial_weight_g: formData.initialWeight,

                leftover_added_g: formData.leftoverAdded,

                notes: formData.notes

            })
            .eq("id", batchId);

    if (batchError)
        throw batchError;

    // =====================
    // ELIMINAR OPERADORES
    // =====================

    const { error: deleteOperatorsError } =
        await window.supabaseClient
            .from("batch_operators")
            .delete()
            .eq("batch_id", batchId);

    if (deleteOperatorsError)
        throw deleteOperatorsError;

    // =====================
    // INSERTAR OPERADORES
    // =====================

    const operators = formData.operators.map(operatorId => ({

        batch_id: batchId,

        operator_id: operatorId

    }));

    const { error: operatorsError } =
        await window.supabaseClient
            .from("batch_operators")
            .insert(operators);

    if (operatorsError)
        throw operatorsError;

    // =====================
    // ELIMINAR PRODUCTOS
    // =====================

    const { error: deleteProductsError } =
        await window.supabaseClient
            .from("production_items")
            .delete()
            .eq("batch_id", batchId);

    if (deleteProductsError)
        throw deleteProductsError;

    // =====================
    // INSERTAR PRODUCTOS
    // =====================

    const items = formData.products.map(product => ({

        batch_id: batchId,

        product_id: product.productId,

        quantity: product.quantity

    }));

    const { error: itemsError } =
        await window.supabaseClient
            .from("production_items")
            .insert(items);

    if (itemsError)
        throw itemsError;

}