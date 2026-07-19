async function getRecentBatches(limit = 20) {

    // =====================
    // LOTES
    // =====================

    const { data: batches, error: batchesError } =
        await window.supabaseClient

            .from("dough_batches")

           .select(`
            id,
            production_date,
            created_at,
            updated_at,
            initial_weight_g,
            shift:shifts(name),
            recipe:recipes(display_name)
            `)

            .order("updated_at", { ascending: false })

            .limit(limit);

    if (batchesError) {

        console.error(batchesError);

        return [];

    }

    if (batches.length === 0)
        return [];

    const batchIds = batches.map(batch => batch.id);

    // =====================
    // OPERADORES
    // =====================

    const { data: batchOperators } =
        await window.supabaseClient

            .from("batch_operators")

            .select(`
                batch_id,
                operator:operators(full_name)
            `)

            .in("batch_id", batchIds);

    // =====================
    // PRODUCTOS
    // =====================

    const { data: productionItems } =
        await window.supabaseClient

            .from("production_items")

          .select(`
            batch_id,
            quantity,
            product:products(name)
            `)
    
    .in("batch_id", batchIds);

    // =====================
    // OBJETO FINAL
    // =====================

    return batches.map(batch => {

        const operators = batchOperators
            .filter(item => item.batch_id === batch.id)
            .map(item => item.operator.full_name);

        const totalProducts = productionItems
            .filter(item => item.batch_id === batch.id)
            .reduce((sum, item) => sum + item.quantity, 0);
        const manufacturedProducts = productionItems
            .filter(item => item.batch_id === batch.id)
            .map(item =>
                `${item.product.name} ×${item.quantity}`
            )
            .join(", ");
        
        return {

            id: batch.id,
            productionDate: batch.production_date,
            createdAt: batch.created_at,
            updatedAt: batch.updated_at,
            hour: batch.updated_at,
            shift: batch.shift?.name ?? "",
            manufacturedProducts,
            initialWeight: batch.initial_weight_g,
            operators,
            totalProducts
            
        };

    });

}