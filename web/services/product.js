async function getProducts() {

    const { data, error } = await window.supabaseClient
        .from("products")
        .select("id, name, grammage_g")
        .eq("active", true)
        .order("legacy_id");

    if (error) {
        console.error(error);
        return [];
    }

    return data;

}