async function testConnection() {

    const { data, error } = await supabase
        .from("operators")
        .select("*");

    if (error) {
        console.error(error);
        return;
    }

    console.table(data);

}

testConnection();