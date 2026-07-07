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

    // =====================
    // OBJETO DE NEGOCIO
    // =====================

    return {

        id: batch.id,

        productionDate: batch.production_date,

        shiftId: batch.shift_id,

        recipeId: batch.recipe_id,

        initialWeight: batch.initial_weight_g,

        flour: batch.flour_g,

        water: batch.water_g,
        
        leftoverAdded: batch.leftover_added_g,
        
        otherIngredients: batch.other_ingredients_g,

        notes: batch.notes,

        operators:
            operators.map(o => o.operator_id),

        products:
            products.map(p => ({

                productId: p.product_id,

                quantity: p.quantity

            }))

    };

}