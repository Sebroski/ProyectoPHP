document.addEventListener('DOMContentLoaded', () => {

    // --- Selección de Elementos del DOM ---
    const form = document.getElementById('productForm');
    const bodegaSelect = document.getElementById('bodega');
    const sucursalSelect = document.getElementById('sucursal');
    const monedaSelect = document.getElementById('moneda');
    const saveButton = document.getElementById('saveButton');
    const formMessages = document.getElementById('form-messages');

    // --- Funciones de Carga de Datos (AJAX) ---

    // Función genérica para fetch y poblar selects
    async function fetchAndPopulate(url, selectElement) {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error('Error en la red');
            const data = await response.json();

            // Limpiar opciones previas (excepto la primera)
            selectElement.innerHTML = '<option value="">' + selectElement.firstElementChild.textContent + '</option>';
            
            data.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.nombre;
                selectElement.appendChild(option);
            });
        } catch (error) {
            console.error('Error al cargar datos:', error);
            showFormMessage('error', 'No se pudieron cargar los datos para los campos de selección.');
        }
    }

    // Cargar Bodegas y Monedas al iniciar
    function loadInitialData() {
        fetchAndPopulate('api.php?action=get_bodegas', bodegaSelect);
        fetchAndPopulate('api.php?action=get_monedas', monedaSelect);
    }

    // Cargar Sucursales cuando cambia la Bodega
    bodegaSelect.addEventListener('change', () => {
        const bodegaId = bodegaSelect.value;
        // Limpiar y deshabilitar sucursales
        sucursalSelect.innerHTML = '<option value="">Seleccione una sucursal...</option>';
        sucursalSelect.disabled = true;

        if (bodegaId) {
            // Si se seleccionó una bodega, buscar sus sucursales
            fetchAndPopulate(`api.php?action=get_sucursales&bodega_id=${bodegaId}`, sucursalSelect)
                .then(() => {
                    sucursalSelect.disabled = false; // Habilitar al cargar
                });
        }
    });

    // --- Manejo del Envío del Formulario ---
    form.addEventListener('submit', async (e) => {
        e.preventDefault(); // Evitar el envío tradicional
        
        // Deshabilitar botón para evitar doble envío
        saveButton.disabled = true;
        saveButton.textContent = 'Guardando...';
        hideFormMessage();

        // 1. Validar en el cliente
        const validationErrors = await validateForm();
        
        if (validationErrors.length > 0) {
            // Mostrar errores de validación
            showFormMessage('error', 'Por favor corrija los siguientes errores:', validationErrors);
            saveButton.disabled = false;
            saveButton.textContent = 'Guardar Producto';
            return;
        }

        // 2. Si la validación es exitosa, enviar por AJAX
        try {
            const formData = new FormData(form);
            const response = await fetch('api.php', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) throw new Error('Error en el servidor: ' + response.statusText);

            const result = await response.json();

            if (result.status === 'success') {
                showFormMessage('success', result.message);
                form.reset(); // Limpiar formulario
                // Resetear el select de sucursales
                sucursalSelect.innerHTML = '<option value="">Seleccione una sucursal...</option>';
                sucursalSelect.disabled = true;
            } else if (result.status === 'validation_error') {
                // Errores de validación del servidor
                showFormMessage('error', 'Error de validación del servidor:', result.messages);
            } else {
                // Otros errores del servidor
                showFormMessage('error', result.message);
            }

        } catch (error) {
            console.error('Error en el envío:', error);
            showFormMessage('error', 'Ocurrió un error inesperado al enviar el formulario.');
        } finally {
            // Reactivar el botón
            saveButton.disabled = false;
            saveButton.textContent = 'Guardar Producto';
        }
    });

    // --- Funciones de Validación (Cliente) ---

    async function validateForm() {
        const errors = [];
        const codigo = document.getElementById('codigo').value;
        const nombre = document.getElementById('nombre').value;
        const precio = document.getElementById('precio').value;
        const descripcion = document.getElementById('descripcion').value;
        const materialesChecked = document.querySelectorAll('input[name="materiales[]"]:checked').length;

        // Validaciones obligatorias
        if (!codigo) errors.push('El código es obligatorio.');
        if (!nombre) errors.push('El nombre es obligatorio.');
        if (!bodegaSelect.value) errors.push('La bodega es obligatoria.');
        if (!sucursalSelect.value) errors.push('La sucursal es obligatoria.');
        if (!monedaSelect.value) errors.push('La moneda es obligatoria.');
        if (!precio) errors.push('El precio es obligatorio.');
        if (!descripcion) errors.push('La descripción es obligatoria.');

        // Código: 5-15 chars, alfanumérico
        if (codigo && (codigo.length < 5 || codigo.length > 15)) {
            errors.push('El código debe tener entre 5 y 15 caracteres.');
        }
        if (codigo && !/^[a-zA-Z0-9]+$/.test(codigo)) {
            errors.push('El código solo debe contener letras y números.');
        }
        
        // Código: Validación Asíncrona de Unicidad
        if (codigo && errors.length === 0) { // Solo chequear si el formato es correcto
            const isUnique = await checkCodigoUnico(codigo);
            if (!isUnique) {
                errors.push('El código ingresado ya existe.');
            }
        }

        // Nombre: 2-50 chars
        if (nombre && (nombre.length < 2 || nombre.length > 50)) {
            errors.push('El nombre debe tener entre 2 y 50 caracteres.');
        }

        // Precio: Número positivo, hasta 2 decimales
        if (precio && (!/^\d+(\.\d{1,2})?$/.test(precio) || parseFloat(precio) <= 0)) {
            errors.push('El precio debe ser un número positivo (ej: 1500 o 1500.50).');
        }

        // Materiales: Al menos 2
        if (materialesChecked < 2) {
            errors.push('Debe seleccionar al menos dos materiales.');
        }

        // Descripción: 10-1000 chars
        if (descripcion && (descripcion.length < 10 || descripcion.length > 1000)) {
            errors.push('La descripción debe tener entre 10 y 1000 caracteres.');
        }

        return errors;
    }

    // Función auxiliar para chequear código (AJAX)
    async function checkCodigoUnico(codigo) {
        try {
            const response = await fetch(`api.php?action=check_codigo&codigo=${codigo}`);
            const data = await response.json();
            return data.isUnique;
        } catch (error) {
            console.error('Error al verificar código:', error);
            return false; // Asumir no único si hay error
        }
    }

    // --- Funciones de UI (Mensajes) ---

    function showFormMessage(type, mainMessage, details = []) {
        formMessages.className = type; // 'success' o 'error'
        
        let html = `<strong>${mainMessage}</strong>`;
        if (details.length > 0) {
            html += '<ul>';
            details.forEach(detail => {
                html += `<li>${detail}</li>`;
            });
            html += '</ul>';
        }
        formMessages.innerHTML = html;
        formMessages.style.display = 'block';
    }

    function hideFormMessage() {
        formMessages.style.display = 'none';
        formMessages.innerHTML = '';
    }

    // --- Iniciar la aplicación ---
    loadInitialData();

});