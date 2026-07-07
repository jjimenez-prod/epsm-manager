async function getOperators() {

    const { data, error } = await window.supabaseClient
        .from("operators")
        .select("id, full_name")
        .eq("active", true)
        .eq("role", "OPERATOR")
        .order("full_name");

    if (error) {
        console.error(error);
        return [];
    }

    return data;

}