async function getShifts() {

    const { data, error } = await window.supabaseClient
        .from("shifts")
        .select("id, name")
        .eq("active", true);

    if (error) {
        console.error(error);
        return [];
    }

    return data;

}