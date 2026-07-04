function getFriendlyError(error) {

    if (error.message.includes("uq_batch_product")) {

        return "El mismo producto no puede agregarse dos veces en una producción.";

    }

    if (error.message.includes("foreign key")) {

        return "Existe un dato inválido en el formulario.";

    }

    return "Ocurrió un error inesperado.";
}