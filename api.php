<?php
header('Content-Type: application/json');
require 'db_config.php';

$pdo = getDBConnection();
$method = $_SERVER['REQUEST_METHOD'];

$response = ['status' => 'error', 'message' => 'Solicitud no válida'];

try {
    if ($method === 'GET') {
        // --- MANEJO DE SOLICITUDES GET (Cargar datos) ---
        if (isset($_GET['action'])) {
            $action = $_GET['action'];
            
            switch ($action) {
                case 'get_bodegas':
                    $stmt = $pdo->query("SELECT id, nombre FROM tbl_bodegas ORDER BY nombre");
                    $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
                    break;
                
                case 'get_monedas':
                    $stmt = $pdo->query("SELECT id, nombre FROM tbl_monedas ORDER BY nombre");
                    $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
                    break;
                
                case 'get_sucursales':
                    if (isset($_GET['bodega_id'])) {
                        $stmt = $pdo->prepare("SELECT id, nombre FROM tbl_sucursales WHERE id_bodega = ? ORDER BY nombre");
                        $stmt->execute([$_GET['bodega_id']]);
                        $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
                    }
                    break;

                case 'check_codigo':
                    if (isset($_GET['codigo'])) {
                        $stmt = $pdo->prepare("SELECT COUNT(*) FROM tbl_productos WHERE codigo = ?");
                        $stmt->execute([$_GET['codigo']]);
                        $count = $stmt->fetchColumn();
                        $response = ['isUnique' => $count == 0];
                    }
                    break;
            }
        }
    } 
    elseif ($method === 'POST') {
        // --- MANEJO DE SOLICITUD POST (Guardar producto) ---
        
        // 1. Recoger datos
        $codigo = $_POST['codigo'] ?? null;
        $nombre = $_POST['nombre'] ?? null;
        $bodega = $_POST['bodega'] ?? null;
        $sucursal = $_POST['sucursal'] ?? null;
        $moneda = $_POST['moneda'] ?? null;
        $precio = $_POST['precio'] ?? null;
        $materiales = $_POST['materiales'] ?? []; // Es un array
        $descripcion = $_POST['descripcion'] ?? null;

        // 2. Validación del lado del servidor (¡Muy importante!)
        $errors = [];

        // Código: Obligatorio, 5-15 chars, alfanumérico
        if (empty($codigo)) {
            $errors[] = "El código es obligatorio.";
        } elseif (strlen($codigo) < 5 || strlen($codigo) > 15) {
            $errors[] = "El código debe tener entre 5 y 15 caracteres.";
        } elseif (!preg_match('/^[a-zA-Z0-9]+$/', $codigo)) {
            $errors[] = "El código solo debe contener letras y números.";
        } else {
            // Verificar unicidad (redundante con JS, pero necesario por seguridad)
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM tbl_productos WHERE codigo = ?");
            $stmt->execute([$codigo]);
            if ($stmt->fetchColumn() > 0) {
                $errors[] = "El código '$codigo' ya existe en la base de datos.";
            }
        }

        // Nombre: Obligatorio, 2-50 chars
        if (empty($nombre)) {
            $errors[] = "El nombre es obligatorio.";
        } elseif (strlen($nombre) < 2 || strlen($nombre) > 50) {
            $errors[] = "El nombre debe tener entre 2 y 50 caracteres.";
        }

        // Bodega, Sucursal, Moneda: Obligatorios (deben ser un ID válido)
        if (empty($bodega) || !filter_var($bodega, FILTER_VALIDATE_INT)) $errors[] = "Debe seleccionar una bodega.";
        if (empty($sucursal) || !filter_var($sucursal, FILTER_VALIDATE_INT)) $errors[] = "Debe seleccionar una sucursal.";
        if (empty($moneda) || !filter_var($moneda, FILTER_VALIDATE_INT)) $errors[] = "Debe seleccionar una moneda.";

        // Precio: Obligatorio, número positivo con hasta 2 decimales
        if (empty($precio)) {
            $errors[] = "El precio es obligatorio.";
        } elseif (!is_numeric($precio) || $precio <= 0) {
            $errors[] = "El precio debe ser un número positivo.";
        } elseif (!preg_match('/^\d+(\.\d{1,2})?$/', $precio)) {
            $errors[] = "El precio debe ser un número con hasta dos decimales.";
        }

        // Materiales: Al menos 2
        if (count($materiales) < 2) {
            $errors[] = "Debe seleccionar al menos dos materiales.";
        }

        // Descripción: Obligatoria, 10-1000 chars
        if (empty($descripcion)) {
            $errors[] = "La descripción es obligatoria.";
        } elseif (strlen($descripcion) < 10 || strlen($descripcion) > 1000) {
            $errors[] = "La descripción debe tener entre 10 y 1000 caracteres.";
        }

        // 3. Procesar
        if (empty($errors)) {
            // No hay errores, procedemos a insertar en la DB
            $materiales_str = implode(',', $materiales); // Convertir array a string
            
            try {
                $pdo->beginTransaction();
                
                $sql = "INSERT INTO tbl_productos (codigo, nombre, id_bodega, id_sucursal, id_moneda, precio, materiales, descripcion) 
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                
                $stmt = $pdo->prepare($sql);
                $stmt->execute([
                    $codigo,
                    $nombre,
                    (int)$bodega,
                    (int)$sucursal,
                    (int)$moneda,
                    (float)$precio,
                    $materiales_str,
                    $descripcion
                ]);
                
                $pdo->commit();
                $response = ['status' => 'success', 'message' => 'Producto guardado exitosamente.'];

            } catch (Exception $e) {
                $pdo->rollBack();
                $response = ['status' => 'error', 'message' => 'Error al guardar en la base de datos: ' . $e->getMessage()];
            }

        } else {
            // Hay errores de validación
            $response = ['status' => 'validation_error', 'messages' => $errors];
        }
    }

} catch (PDOException $e) {
    http_response_code(500);
    $response = ['status' => 'error', 'message' => 'Error de base de datos: ' . $e->getMessage()];
}

echo json_encode($response);
?>