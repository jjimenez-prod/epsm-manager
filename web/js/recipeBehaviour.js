// =====================
// RECIPES CATALOG
// =====================

let recipesCatalog = [];

function setRecipesCatalog(recipes) {

    recipesCatalog = recipes;

}

function getSelectedRecipe() {

    const recipeId =
        document.getElementById("recipe").value;

    return recipesCatalog.find(r => r.id === recipeId);

}

// =====================
// INITIALIZATION
// =====================

function initializeRecipeBehaviour() {

    const recipe =
        document.getElementById("recipe");

    recipe.addEventListener(
        "change",
        updateRecipeBehaviour
    );

    document
        .getElementById("flour")
        .addEventListener(
            "input",
            calculateRecipeWeight
        );

    document
        .getElementById("water")
        .addEventListener(
            "input",
            calculateRecipeWeight
        );

    updateRecipeBehaviour();

}

// =====================
// UI
// =====================

function updateRecipeBehaviour() {

    const recipe = getSelectedRecipe();

    if (!recipe) return;

    const specialDiv =
        document.getElementById("specialRecipe");

    const initialWeight =
        document.getElementById("initialWeight");

    if (recipe.auto_calculate) {

        specialDiv.style.display = "block";

        initialWeight.readOnly = true;

        calculateRecipeWeight();

    }
    else {

        specialDiv.style.display = "none";

        initialWeight.readOnly = true;

        initialWeight.value =
            recipe.default_initial_weight_g ?? "";

    }

}

// =====================
// CALCULATIONS
// =====================

function calculateRecipeWeight() {

    const recipe = getSelectedRecipe();

    if (!recipe) return;

    const flour =
        Number(document.getElementById("flour").value) || 0;

    const water =
        Number(document.getElementById("water").value) || 0;

    document.getElementById("initialWeight").value =
        flour +
        water +
        (recipe.fixed_extra_weight_g ?? 0);

}