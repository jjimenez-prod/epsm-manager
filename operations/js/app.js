let editingBatchId = null;

document.addEventListener("DOMContentLoaded", async () => {

    console.log("EPSM Manager iniciado");

    // =====================
    // CONFIGURACIÓN
    // =====================

    await loadSettings();

    console.log(window.appSettings);
    console.log(window.appSettings.system);

    // =====================
    // CARGAR CATÁLOGOS
    // =====================

    const catalogs = await loadCatalogs();

    document.getElementById("productionDate").value =
        new Date().toISOString().split("T")[0];

    fillSelect("shift", catalogs.shifts, "id", "name");
    fillSelect("recipe", catalogs.recipes, "id", "display_name");

    setOperatorsCatalog(catalogs.operators);
    setProductsCatalog(catalogs.products);
    setRecipesCatalog(catalogs.recipes);

    // =====================
    // BOTONES
    // =====================

    document
        .getElementById("addOperator")
        .addEventListener("click", addOperatorRow);

    document
        .getElementById("addProduct")
        .addEventListener("click", addProductionRow);

    document
        .getElementById("saveButton")
        .addEventListener("click", async () => {

            console.log("CLICK SAVE");
            console.log("editingBatchId:", editingBatchId);

            try {

                const formData = collectFormData();

                const validation = validateProduction(formData);

                if (!validation.valid) {

                    alert(validation.messages.join("\n"));

                    return;

                }

                // =====================
                // CREAR O ACTUALIZAR
                // =====================

                if (editingBatchId === null) {

                    await saveProduction(formData);

                    alert("Producción registrada correctamente.");

                }

                else {

                    await updateProduction(
                        editingBatchId,
                        formData
                    );

                    alert("Producción actualizada correctamente.");

                    editingBatchId = null;

                    document
                        .getElementById("saveButton")
                        .textContent = "Guardar Producción";

                }

                // =====================
                // LIMPIAR FORMULARIO
                // =====================

                resetForm();

                initializeEmptyForm();

                // =====================
                // ACTUALIZAR HISTORIAL
                // =====================

                await refreshHistory();

            }

            catch (error) {

                alert(getFriendlyError(error));

            }

        });

    // =====================
    // FILAS INICIALES
    // =====================

    addOperatorRow();

    addProductionRow();

    // =====================
    // INITIALIZE FORM
    // =====================

    initializeEmptyForm();

    // =====================
    // COMPORTAMIENTO FORMULARIO
    // =====================

    initializeRecipeBehaviour();

    // =====================
    // HISTORIAL
    // =====================

    await refreshHistory();

    // =====================
    // AUTO REFRESH HISTORY
    // =====================

    setInterval(refreshHistory, 30000);

});

// =====================
// REFRESH HISTORY
// =====================

async function refreshHistory() {

    try {

        const recent =
            await getRecentBatches();

        renderRecentBatches(recent);

    }

    catch (error) {

        console.error(
            "History refresh failed:",
            error
        );

    }

}

// =====================
// EDITAR
// =====================

window.editBatch = async function (batchId) {

    const batch =
        await getBatch(batchId);

    editingBatchId =
        batch.id;

    fillForm(batch);

    document
        .getElementById("saveButton")
        .textContent =
        "Actualizar Producción";

    document
        .querySelector(".page-header")
        ?.scrollIntoView({

            behavior: "smooth",

            block: "start"

        });

};