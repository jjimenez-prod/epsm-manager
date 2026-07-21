const SUPABASE_URL = "https://rqshcnfruzhgzwtlwxwp.supabase.co";

const SUPABASE_ANON_KEY = "sb_publishable_IIykBL0BZJ4KWu4-lKYvww_RmRo1xJQ";

window.supabaseClient = window.supabase.createClient(
    SUPABASE_URL,
    SUPABASE_ANON_KEY
);

console.log("Supabase conectado");