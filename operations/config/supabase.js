const SUPABASE_URL = "https://tzowxuqgujnuqvtkzrnp.supabase.co";

const SUPABASE_ANON_KEY = "sb_publishable_JWJS7A9HXtzoUUZ-T7Bdtg_L9PbMfV6";

window.supabaseClient = window.supabase.createClient(
    SUPABASE_URL,
    SUPABASE_ANON_KEY
);

console.log("Supabase conectado");