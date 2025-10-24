<?php
// Configuración de la Base de Datos (PostgreSQL)
define('DB_HOST', 'localhost');
define('DB_PORT', '5432'); // Puerto por defecto de PostgreSQL
define('DB_NAME', 'tu_base_de_datos');
define('DB_USER', 'tu_usuario');
define('DB_PASS', 'tu_contraseña');

function getDBConnection() {
    $dsn = "pgsql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME;
    
    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch (PDOException $e) {
        // En un entorno real, no deberías imprimir el error detallado
        // Deberías devolver un mensaje genérico y loguear el error.
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'Error de conexión a la base de datos.']);
        exit;
    }
}
?>