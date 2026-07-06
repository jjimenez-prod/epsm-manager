let productsCatalog = [];

function fillSelect(selectId, data, valueField, textField) {

    const select = document.getElementById(selectId);

    if (!select) return;

    select.innerHTML = "";

    data.forEach(item => {

        const option = document.createElement("option");

        option.value = item[valueField];
        option.textContent = item[textField];

        select.appendChild(option);

    });

}

function setProductsCatalog(products){

    productsCatalog = products;

}

function addProductionRow(){

    const tbody = document.getElementById("productionTable");

    const tr = document.createElement("tr");

    // PRODUCTO

    const tdProduct = document.createElement("td");

    const select = document.createElement("select");

    productsCatalog.forEach(product => {

        const option = document.createElement("option");

        option.value = product.id;
        option.textContent = product.name;

        select.appendChild(option);

    });

    tdProduct.appendChild(select);

    // CANTIDAD

    const tdQuantity = document.createElement("td");

    const quantity = document.createElement("input");

    quantity.type = "number";
    quantity.min = 1;

    tdQuantity.appendChild(quantity);

    // ELIMINAR

    const tdDelete = document.createElement("td");

    const button = document.createElement("button");

    button.textContent = "🗑";

    button.onclick = () => {

    const tbody = document.getElementById("productionTable");

    if (tbody.rows.length === 1) {

        alert("Debe existir al menos un producto.");

        return;

    }

    tr.remove();

};

    tdDelete.appendChild(button);

    tr.appendChild(tdProduct);
    tr.appendChild(tdQuantity);
    tr.appendChild(tdDelete);

    tbody.appendChild(tr);

}
function collectFormData() {

    // =====================
    // PRODUCTOS
    // =====================

    const productRows =
        document.querySelectorAll("#productionTable tr");

    const products = [];

    productRows.forEach(row => {

        const productSelect =
            row.querySelector("select");

        const quantityInput =
            row.querySelector("input");

        products.push({

            productId: productSelect.value,

            quantity: Number(quantityInput.value)

        });

    });

    // =====================
    // OPERADORES
    // =====================

    const operatorRows =
        document.querySelectorAll("#operatorTable tr");

    const operators = [];

    operatorRows.forEach(row => {

        const select =
            row.querySelector("select");

        operators.push(select.value);

    });

    // =====================
    // FORMULARIO
    // =====================

    return {

        productionDate:
            document.getElementById("productionDate").value,

        shiftId:
            document.getElementById("shift").value,

        operators,

        recipeId:
            document.getElementById("recipe").value,

        initialWeight:
            Number(document.getElementById("initialWeight").value),

        leftoverAdded:
            Number(document.getElementById("leftoverAdded").value),

        notes:
            document.getElementById("notes").value,

        products

    };

}
let operatorsCatalog = [];

function setOperatorsCatalog(operators){

    operatorsCatalog = operators;

}

function addOperatorRow(){

    const tbody =
        document.getElementById("operatorTable");

    const tr =
        document.createElement("tr");

    // SELECT

    const tdOperator =
        document.createElement("td");

    const select =
        document.createElement("select");

    operatorsCatalog.forEach(operator => {

        const option =
            document.createElement("option");

        option.value = operator.id;

        option.textContent = operator.full_name;

        select.appendChild(option);

    });

    tdOperator.appendChild(select);

    // DELETE

    const tdDelete =
        document.createElement("td");

    const button =
        document.createElement("button");

    button.textContent = "🗑";

    button.onclick = () => {

        if(tbody.rows.length === 1){

            alert(
                "Debe existir al menos un operador."
            );

            return;

        }

        tr.remove();

    };

    tdDelete.appendChild(button);

    tr.appendChild(tdOperator);

    tr.appendChild(tdDelete);

    tbody.appendChild(tr);

}
function resetForm() {

    // =====================
    // FECHA
    // =====================

    const today = new Date().toISOString().split("T")[0];

    document.getElementById("productionDate").value = today;

    // =====================
    // CAMPOS
    // =====================

    document.getElementById("shift").selectedIndex = -1;

    document.getElementById("recipe").selectedIndex = -1;

    document.getElementById("initialWeight").value = "";

    document.getElementById("leftoverAdded").value = 0;

    document.getElementById("notes").value = "";

    document.getElementById("flour").value = "";

    document.getElementById("water").value = "";

    document.getElementById("specialRecipe").style.display = "none";

    // =====================
    // OPERADORES
    // =====================

    const operatorTable =
        document.getElementById("operatorTable");

    operatorTable.innerHTML = "";

    addOperatorRow();

    // =====================
    // PRODUCTOS
    // =====================

    const productionTable =
        document.getElementById("productionTable");

    productionTable.innerHTML = "";

    addProductionRow();

}
function renderRecentBatches(batches) {

    const tbody =
        document.getElementById("tablaRegistros");

    tbody.innerHTML = "";

    batches.forEach(batch => {

        const tr = document.createElement("tr");

        // =====================
        // FECHA
        // =====================

        const tdDate =
            document.createElement("td");

        tdDate.textContent =
            batch.productionDate;

        // =====================
        // TURNO
        // =====================

        const tdShift =
            document.createElement("td");

        tdShift.textContent =
            batch.shift;

        // =====================
        // OPERADORES
        // =====================

        const tdOperators =
            document.createElement("td");

        tdOperators.textContent =
            batch.operators.join(", ");

        // =====================
        // PRODUCTOS
        // =====================

        const tdProducts =
            document.createElement("td");

        tdProducts.textContent =
            batch.totalProducts;

        // =====================
        // EDITAR
        // =====================

        const tdEdit =
            document.createElement("td");

        const button =
            document.createElement("button");

        button.textContent = "✏️";

        button.onclick = () => {

            editBatch(batch.id);

        };

        tdEdit.appendChild(button);

        tr.appendChild(tdDate);
        tr.appendChild(tdShift);
        tr.appendChild(tdOperators);
        tr.appendChild(tdProducts);
        tr.appendChild(tdEdit);

        tbody.appendChild(tr);

    });

}
function fillForm(batch) {

    // =====================
    // DATOS GENERALES
    // =====================

    document.getElementById("productionDate").value =
        batch.productionDate;

    document.getElementById("shift").value =
        batch.shiftId;

    document.getElementById("recipe").value =
        batch.recipeId;

    document.getElementById("initialWeight").value =
        batch.initialWeight;

    document.getElementById("leftoverAdded").value =
        batch.leftoverAdded;

    document.getElementById("notes").value =
        batch.notes ?? "";

    // Mostrar / ocultar receta especial

    updateRecipeBehaviour();

    // =====================
    // OPERADORES
    // =====================

    const operatorTable =
        document.getElementById("operatorTable");

    operatorTable.innerHTML = "";

    batch.operators.forEach(operatorId => {

        addOperatorRow();

        const lastRow =
            operatorTable.lastElementChild;

        lastRow.querySelector("select").value =
            operatorId;

    });

    // =====================
    // PRODUCTOS
    // =====================

    const productionTable =
        document.getElementById("productionTable");

    productionTable.innerHTML = "";

    batch.products.forEach(product => {

        addProductionRow();

        const lastRow =
            productionTable.lastElementChild;

        const select =
            lastRow.querySelector("select");

        const quantity =
            lastRow.querySelector("input");

        select.value = product.productId;

        quantity.value = product.quantity;

    });

}