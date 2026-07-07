async function loadCatalogs() {

    const operators = await getOperators();
    const products = await getProducts();
    const shifts = await getShifts();
    const recipes = await getRecipes();

    return {
        operators,
        products,
        shifts,
        recipes
    };

}