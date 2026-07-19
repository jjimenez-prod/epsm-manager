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
            calculateInitialWeight
        );

    document
        .getElementById("water")
        .addEventListener(
            "input",
            calculateInitialWeight
        );
    document
        .getElementById("otherIngredients")
        .addEventListener(
            "input",
            calculateInitialWeight
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
    
    const standardDiv =
        document.getElementById("standardRecipe");

    const initialWeight =
        document.getElementById("initialWeight");

if (recipe.auto_calculate) {

    standardDiv.style.display = "none";
    specialDiv.style.display = "grid";

    initialWeight.readOnly = true;

    calculateInitialWeight();

}
else {

    standardDiv.style.display = "block";
    specialDiv.style.display = "none";

    initialWeight.readOnly = true;

    initialWeight.value =
        recipe.default_initial_weight_g ?? "";

}

}

// =====================
// CALCULATIONS
// =====================

function calculateInitialWeight() {

    const recipe = getSelectedRecipe();

    if (!recipe) return;

    const flour =
        Number(document.getElementById("flour").value) || 0;

    const water =
        Number(document.getElementById("water").value) || 0;
        
    const otherIngredients =
        Number(document.getElementById("otherIngredients").value) || 0;

    document.getElementById("initialWeight").value =
        flour +
        water +
        otherIngredients +
        (recipe.fixed_extra_weight_g ?? 0);

}