const SUPABASE_URL = "https://imtzrlvrjipqdrmulurt.supabase.co";

const SUPABASE_ANON_KEY = "sb_publishable_PaDJ06WWKFivwjodP3NCug_jsXQmjbX";

window.supabaseClient = window.supabase.createClient(
    SUPABASE_URL,
    SUPABASE_ANON_KEY
);

console.log("Supabase conectado");