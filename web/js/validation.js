/*
=========================================
EPSM Manager
Version: 0.5.1
File: validation.js
Sprint: 1
=========================================
*/

function validateProduction(formData) {

    const messages = [];

    // =====================
    // FECHA
    // =====================

    if (!formData.productionDate) {

        messages.push("Debe seleccionar una fecha.");

    }

    // =====================
    // TURNO
    // =====================

    if (!formData.shiftId) {

        messages.push("Debe seleccionar un turno.");

    }

    // =====================
    // OPERADORES
    // =====================

    if (formData.operators.length === 0) {

        messages.push("Debe seleccionar al menos un operador.");

    }

    // Operadores duplicados

    const uniqueOperators = new Set(formData.operators);

    if (uniqueOperators.size !== formData.operators.length) {

        messages.push("No puede repetir operadores.");

    }

    // =====================
    // RECETA
    // =====================

    if (!formData.recipeId) {

        messages.push("Debe seleccionar un tipo de masa.");

    }

    // =====================
    // PESO
    // =====================

    if (formData.initialWeight <= 0) {

        messages.push("El peso inicial debe ser mayor que cero.");

    }

    // =====================
    // PRODUCTOS
    // =====================

    if (formData.products.length === 0) {

        messages.push("Debe agregar al menos un producto.");

    }

    formData.products.forEach((product, index) => {

        if (!product.productId) {

            messages.push(
                `Producto ${index + 1}: debe seleccionar un producto.`
            );

        }

        if (product.quantity <= 0) {

            messages.push(
                `Producto ${index + 1}: la cantidad debe ser mayor que cero.`
            );

        }

    });

    // =====================

    return {

        valid: messages.length === 0,

        messages

    };

}