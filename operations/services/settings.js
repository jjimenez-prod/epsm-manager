// ==========================================================================
// SETTINGS
// ==========================================================================
//
// Loads application settings from Supabase.
//
// Database structure:
//
// category
// key
// value
// data_type
//
// The backend stores categories in UPPERCASE:
//
// SYSTEM
// BONUS
//
// The frontend uses camel/lowercase:
//
// appSettings.system
// appSettings.bonus
//
// Data types are also normalized from the database
// before exposing them to the application.
// ==========================================================================

let appSettings = {};

async function loadSettings() {

    const { data, error } =
        await window.supabaseClient
            .from("settings")
            .select("*");

    if (error) {

        console.error(error);

        return;

    }

    const settings = {};

    data.forEach(setting => {

        // =====================
        // CATEGORY
        // =====================

        const category =
            setting.category.toLowerCase();

        if (!settings[category]) {

            settings[category] = {};

        }

        // =====================
        // VALUE
        // =====================

        let value = setting.value;

        switch (setting.data_type.toUpperCase()) {

            case "INTEGER":

                value = Number(value);

                break;

            case "DECIMAL":

                value = Number(value);

                break;

            case "BOOLEAN":

                value = value === "true";

                break;

        }

        settings[category][setting.key] = value;

    });

    window.appSettings = settings;

}