import { createClient } from 'https://esm.sh/@supabase/supabase-js'

let registroEditando = null;

const SUPABASE_URL = "https://imtzrlvrjipqdrmulurt.supabase.co";
const SUPABASE_KEY = "sb_publishable_PaDJ06WWKFivwjodP3NCug_jsXQmjbX";

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

document.getElementById("guardar")
    .addEventListener("click", guardarRegistro);

// =====================
// CARGAR PRODUCTOS
// =====================

async function cargarProductos() {

    const { data, error } = await supabase
        .from("productos")
        .select("*")
        .eq("activo", true)
        .order("nombre");

    if (error) {
        console.log(error);
        return;
    }

    const select = document.getElementById("producto");

    select.innerHTML = "";

    data.forEach(producto => {

        select.innerHTML += `
            <option value="${producto.nombre}">
                ${producto.nombre}
            </option>
        `;

    });

}

// =====================
// GUARDAR / ACTUALIZAR
// =====================

async function guardarRegistro() {

    const fecha = document.getElementById("fecha").value;
    const producto = document.getElementById("producto").value;
    const cantidad = Number(document.getElementById("cantidad").value);

    let error;

    if (registroEditando == null) {

        ({ error } = await supabase
            .from("produccion")
            .insert([{
                fecha: fecha,
                producto_id: producto,
                cantidad: cantidad
            }]));

    } else {

        ({ error } = await supabase
            .from("produccion")
            .update({
                fecha: fecha,
                producto_id: producto,
                cantidad: cantidad
            })
            .eq("id", registroEditando));

    }

    if (error) {
        alert(error.message);
        return;
    }

    registroEditando = null;

    document.getElementById("guardar").textContent = "Guardar";

    document.getElementById("cantidad").value = "";

    cargarRegistros();

}

// =====================
// CARGAR REGISTROS
// =====================

async function cargarRegistros() {

    const { data, error } = await supabase
        .from("produccion")
        .select("*")
        .order("id", { ascending: false });

    if (error) {
        console.log(error);
        return;
    }

    const tabla = document.getElementById("tablaRegistros");

    tabla.innerHTML = "";

    data.forEach(registro => {

        tabla.innerHTML += `
        <tr>

            <td>${registro.fecha}</td>

            <td>${registro.producto_id}</td>

            <td>${registro.cantidad}</td>

            <td>
                <button onclick="editarRegistro(${registro.id})">
                    Editar
                </button>
            </td>

        </tr>
        `;

    });

}

// =====================
// EDITAR
// =====================

window.editarRegistro = async function(id){

    const { data, error } = await supabase
        .from("produccion")
        .select("*")
        .eq("id", id)
        .single();

    if(error){
        console.log(error);
        return;
    }

    registroEditando = id;

    document.getElementById("fecha").value = data.fecha;
    document.getElementById("producto").value = data.producto_id;
    document.getElementById("cantidad").value = data.cantidad;

    document.getElementById("guardar").textContent = "Actualizar";

}

// =====================

cargarProductos();
cargarRegistros();