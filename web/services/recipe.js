async function getRecipes() {

    const { data, error } = await window.supabaseClient
        .from("recipes")
        .select(`
            id,
            recipe_type,
            display_name,
            is_standard,
            auto_calculate,
            fixed_extra_weight_g,
            default_initial_weight_g,
            show_initial_weight
        `)
        .eq("active", true);

    if (error) {

        console.error(error);

        return [];

    }

    return data;

}