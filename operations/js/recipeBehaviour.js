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

    document
        .getElementById("standardDoughCount")
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

    // ==========================================================================
    // STEP 2
    // Toggle Recipe Layout
    // ==========================================================================
    //
    // STANDARD
    //     • Shows dough count.
    //
    // SPECIAL
    //     • Shows manual ingredient inputs.
    //
    // ==========================================================================

    if (recipe.recipe_type === "SPECIAL") {

        standardDiv.style.display = "none";
        specialDiv.style.display = "grid";

        initialWeight.readOnly = true;

        calculateInitialWeight();

    } else {

        standardDiv.style.display = "block";
        specialDiv.style.display = "none";

        initialWeight.readOnly = true;

        calculateInitialWeight();

    }

}

// =====================
// CALCULATIONS
// =====================

function calculateInitialWeight() {

    if (isLoadingForm) {

        return;

    }

    const recipe = getSelectedRecipe();

    if (!recipe) return;

    const initialWeight =
        document.getElementById("initialWeight");

    // =====================================================
    // STANDARD
    // =====================================================

    if (recipe.recipe_type === "STANDARD") {

        const doughCount =
            Number(
                document.getElementById("standardDoughCount").value
            ) || 1;

        initialWeight.value =
            recipe.default_total_weight_g * doughCount;

        return;

    }

    // =====================================================
    // SPECIAL
    // =====================================================

    const flour =
        Number(document.getElementById("flour").value) || 0;

    const water =
        Number(document.getElementById("water").value) || 0;

    const otherIngredients =
        Number(document.getElementById("otherIngredients").value) || 0;

    initialWeight.value =
        flour
        + water
        + otherIngredients
        + (recipe.fixed_extra_weight_g ?? 0);

}