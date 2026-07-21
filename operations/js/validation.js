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

    if (!formData.production_date) {

        messages.push("Debe seleccionar una fecha.");

    }

    // =====================
    // TURNO
    // =====================

    if (!formData.shift_id) {

        messages.push("Debe seleccionar un turno.");

    }

    // =====================
    // OPERADORES
    // =====================

    if (formData.operators.length === 0) {

        messages.push("Debe seleccionar al menos un operador.");

    }

    // Operadores duplicados

    const uniqueOperators = new Set(

    formData.operators.map(o => o.operator_id)

);

    if (uniqueOperators.size !== formData.operators.length) {

        messages.push("No puede repetir operadores.");

    }

    // =====================
    // RECETA
    // =====================

    if (!formData.recipe?.recipe_id) {

        messages.push("Debe seleccionar un tipo de masa.");

    }

    // =====================
    // PRODUCTOS
    // =====================

    if (formData.production_items.length === 0) {

        messages.push("Debe agregar al menos un producto.");

    }

    formData.production_items.forEach((product, index) => {

        if (!product.product_id) {

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