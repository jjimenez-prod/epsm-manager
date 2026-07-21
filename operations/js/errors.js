function getFriendlyError(error) {

    const code =
        error?.error_code ?? "";

    const message =
        error?.message ?? "";

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

        case "INVALID_PAYLOAD":
            return message;

        default:
            break;

    }

    // =====================
    // Legacy Database Errors
    // =====================

    if (message.includes("uq_batch_product")) {

        return "El mismo producto no puede agregarse dos veces en una producción.";

    }

    if (message.includes("foreign key")) {

        return "Existe un dato inválido en el formulario.";

    }

    // =====================
    // Unknown Error
    // =====================

    return message || "Ocurrió un error inesperado.";

}