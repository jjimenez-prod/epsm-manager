function getFriendlyError(error) {

    const code =
        error?.error_code ?? "";

    const message =
        error?.message ?? "";

    const field =
        error?.details?.field ?? "";

    // =====================
    // Business Errors
    // =====================

    switch (code) {

        case "DUPLICATE_PRODUCT":
            return "El mismo producto no puede agregarse dos veces en una producción.";

        case "DUPLICATE_OPERATOR":
            return "El mismo operador no puede agregarse dos veces en una producción.";

        case "INVALID_QUANTITY":
            return "Todas las cantidades deben ser mayores que cero.";

        case "PRODUCT_NOT_FOUND":
            return "Uno o más productos ya no existen o están inactivos.";

        case "OPERATOR_NOT_FOUND":
            return "Uno o más operadores ya no existen o están inactivos.";

        case "RECIPE_NOT_FOUND":
            return "La receta seleccionada no existe o está inactiva.";

        case "SHIFT_NOT_FOUND":
            return "El turno seleccionado no existe o está inactivo.";

        case "INVALID_BATCH_STATUS":
            return "Solo es posible editar producciones activas.";

        case "BATCH_NOT_FOUND":
            return "La producción que intentas editar ya no existe.";

        // =====================
        // Payload Validation
        // =====================

        case "INVALID_PAYLOAD":

            switch (field) {

                case "production_date":
                    return "Debe seleccionar una fecha de producción.";

                case "shift_id":
                    return "Debe seleccionar un turno.";

                case "recipe.recipe_id":
                    return "Debe seleccionar un tipo de masa.";

                case "recipe.standard_dough_count":
                    return "Debe indicar la cantidad de masas estándar.";

                case "recipe.flour_g":
                    return "Debe ingresar la cantidad de harina.";

                case "recipe.water_g":
                    return "Debe ingresar la cantidad de agua.";

                case "recipe.other_ingredients_g":
                    return "Debe ingresar la cantidad de otros ingredientes.";

                case "recipe.leftover_added_g":
                    return "Debe ingresar la masa sobrante agregada.";

                case "operators":
                    return "Debe seleccionar al menos un operador.";

                case "production_items":
                    return "Debe agregar al menos un producto.";

                default:
                    return "El formulario contiene datos incompletos o inválidos.";

            }

        default:
            break;

    }

    // =====================
    // Legacy Database Errors
    // =====================

    if (message.includes("uq_batch_product")) {

        return "El mismo producto no puede agregarse dos veces en una producción.";

    }

    if (message.includes("uq_batch_operator")) {

        return "El mismo operador no puede agregarse dos veces en una producción.";

    }

    if (message.includes("foreign key")) {

        return "Existe un dato inválido en el formulario.";

    }

    if (message.includes("duplicate key")) {

        return "Ya existe un registro con esos datos.";

    }

    if (message.includes("not-null")) {

        return "Faltan datos obligatorios en el formulario.";

    }

    // =====================
    // Unknown Error
    // =====================

    return message || "Ocurrió un error inesperado.";

}