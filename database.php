<?php
declare(strict_types=1);

/*
 * Configuración de conexión MySQL.
 * En XAMPP/Laragon normalmente se usa:
 * host=localhost, usuario=root, contraseña vacía.
 * Cambie estos valores según su servidor de alojamiento.
 */
$host = getenv('DB_HOST') ?: 'localhost';
$dbname = getenv('DB_NAME') ?: 'restaurante_online';
$username = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASS') ?: '';

$dsn = "mysql:host={$host};dbname={$dbname};charset=utf8mb4";

try {
    $pdo = new PDO($dsn, $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
} catch (PDOException $exception) {
    error_log('Error de conexión a MySQL: ' . $exception->getMessage());
    http_response_code(500);
    exit('No se pudo conectar con la base de datos. Revise config/database.php y confirme que MySQL esté iniciado.');
}
