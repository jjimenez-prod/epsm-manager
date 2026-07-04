async function getRecipes() {

    const { data, error } = await window.supabaseClient
        .from("recipes")
        .select("id, recipe_type, display_name, is_standard")
        .eq("active", true);

    if (error) {
        console.error(error);
        return [];
    }

    return data;

}