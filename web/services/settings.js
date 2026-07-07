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

    settings = {};

    data.forEach(setting => {

        if (!settings[setting.category]) {

            settings[setting.category] = {};

        }

        let value = setting.value;

        switch (setting.data_type) {

            case "integer":
                value = Number(value);
                break;

            case "boolean":
                value = value === "true";
                break;

        }

        settings[setting.category][setting.key] = value;

    });
    
    window.appSettings = settings;
}