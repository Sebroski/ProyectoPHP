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
        sucursalSelect.innerHTML = '<option value=""></option>';
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
        
        saveButton.disabled = true;
        saveButton.textContent = 'Validando...';
        hideFormMessage();

        // 1. Validar en el cliente (sincrónico, con alertas)
        const syncValidationPassed = validateForm();
        
        if (!syncValidationPassed) {
            // Validación falló. El alert() ya se mostró en validateForm()
            saveButton.disabled = false;
            saveButton.textContent = 'Guardar Producto';
            return;
        }

        // 2. Validación Asíncrona (Unicidad del Código)
        const codigo = document.getElementById('codigo').value.trim();
        const isUnique = await checkCodigoUnico(codigo);

        if (!isUnique) {
            alert("El código del producto ya está registrado.");
            saveButton.disabled = false;
            saveButton.textContent = 'Guardar Producto';
            return;
        }

        // 3. Si todo es exitoso, enviar por AJAX
        saveButton.textContent = 'Guardando...';

        try {
            const formData = new FormData(form);
            const response = await fetch('api.php', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) throw new Error('Error en el servidor: ' + response.statusText);

            const result = await response.json();

            // 4. Respuesta al Usuario
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
                showFormMessage('error', result.message || 'Ocurrió un error desconocido.');
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

    /**
     * Valida el formulario de forma sincrónica.
     * Muestra un alert() y retorna false al primer error encontrado.
     * Retorna true si todas las validaciones pasan.
     */
    function validateForm() {
        // Obtener valores (usamos trim() para eliminar espacios en blanco)
        const codigo = document.getElementById('codigo').value.trim();
        const nombre = document.getElementById('nombre').value.trim();
        const bodega = bodegaSelect.value;
        const sucursal = sucursalSelect.value;
        const moneda = monedaSelect.value;
        const precio = document.getElementById('precio').value.trim();
        const descripcion = document.getElementById('descripcion').value.trim();
        const materialesChecked = document.querySelectorAll('input[name="materiales[]"]:checked').length;

        // 1. Código del Producto
        if (codigo === "") {
            alert("El código del producto no puede estar en blanco.");
            return false;
        }
        if (codigo.length < 5 || codigo.length > 15) {
            alert("El código del producto debe tener entre 5 y 15 caracteres.");
            return false;
        }
        // Regex: al menos una letra, al menos un número, y solo caracteres alfanuméricos
        const hasLetter = /[A-Za-z]/.test(codigo);
        const hasNumber = /\d/.test(codigo);
        const hasOnlyAlphanumeric = /^[A-Za-z\d]+$/.test(codigo);
        
        if (!hasOnlyAlphanumeric || !hasLetter || !hasNumber) {
            alert("El código del producto debe contener letras y números");
            return false;
        }
        // La unicidad se comprueba de forma asíncrona fuera de esta función

        // 2. Nombre del Producto
        if (nombre === "") {
            alert("El nombre del producto no puede estar en blanco.");
            return false;
        }
        if (nombre.length < 2 || nombre.length > 50) {
            alert("El nombre del producto debe tener entre 2 y 50 caracteres.");
            return false;
        }
        
        // 3. Bodega
        if (bodega === "") {
            alert("Debe seleccionar una bodega.");
            return false;
        }

        // 4. Sucursal (Depende de bodega)
        if (sucursal === "") {
            alert("Debe seleccionar una sucursal para la bodega seleccionada.");
            return false;
        }

        // 5. Moneda
        if (moneda === "") {
            alert("Debe seleccionar una moneda para el producto.");
            return false;
        }

        // 6. Precio del Producto
        if (precio === "") {
            alert("El precio del producto no puede estar en blanco.");
            return false;
        }
        // Regex: número positivo con hasta dos decimales
        const precioRegex = /^\d+(\.\d{1,2})?$/;
        if (!precioRegex.test(precio) || parseFloat(precio) <= 0) {
            alert("El precio del producto debe ser un número positivo con hasta dos decimales.");
            return false;
        }

        // 7. Material del Producto
        if (materialesChecked < 2) {
            alert("Debe seleccionar al menos dos materiales para el producto.");
            return false;
        }

        // 8. Descripción del Producto
        if (descripcion === "") {
            alert("La descripción del producto no puede estar en blanco.");
            return false;
        }
        if (descripcion.length < 10 || descripcion.length > 1000) {
            alert("La descripción del producto debe tener entre 10 y 1000 caracteres.");
            return false;
        }

        // Si todas las validaciones pasan
        return true;
    }

    // Función auxiliar para chequear código (AJAX)
    async function checkCodigoUnico(codigo) {
        try {
            const response = await fetch(`api.php?action=check_codigo&codigo=${codigo}`);
            if (!response.ok) {
                 console.error('Error de red al verificar código');
                 return false; // Asumir no único si hay error de red
            }
            const data = await response.json();
            return data.isUnique;
        } catch (error) {
            console.error('Error al verificar código:', error);
            return false; // Asumir no único si hay error
        }
    }

    // --- Funciones de UI (Mensajes de éxito/error del servidor) ---

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