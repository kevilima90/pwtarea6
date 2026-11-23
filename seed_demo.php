<?php
declare(strict_types=1);

/*
 * Ejecutar desde la carpeta raíz del proyecto:
 * php scripts/seed_demo.php
 *
 * Crea cuatro cuentas demostrativas. Cambie las contraseñas después de ingresar.
 */
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit('Este instalador solo puede ejecutarse desde la terminal.');
}

require_once __DIR__ . '/../config/database.php';

$accounts = [
    ['Administrador', 'admin@restaurante.local', 'Admin123!', 'Administrator'],
    ['Chef', 'chef@restaurante.local', 'Chef123!', 'Chef'],
    ['Camarero', 'camarero@restaurante.local', 'Camarero123!', 'Waiter'],
    ['Cliente', 'cliente@restaurante.local', 'Cliente123!', 'Client'],
];

$roleLookup = $pdo->prepare('SELECT id FROM roles WHERE name = ? LIMIT 1');
$userLookup = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
$userInsert = $pdo->prepare('INSERT INTO users (username, email, password, role_id, is_active) VALUES (?, ?, ?, ?, 1)');

foreach ($accounts as [$name, $email, $plainPassword, $roleName]) {
    $roleLookup->execute([$roleName]);
    $role = $roleLookup->fetch();

    if (!$role) {
        echo "No existe el rol {$roleName}. Importe primero database.sql.\n";
        exit(1);
    }

    $userLookup->execute([$email]);
    if (!$userLookup->fetch()) {
        $userInsert->execute([$name, $email, password_hash($plainPassword, PASSWORD_DEFAULT), $role['id']]);
        echo "Cuenta creada: {$email}\n";
    } else {
        echo "Cuenta existente: {$email}\n";
    }
}

echo "\nCuentas de demostración:\n";
echo "admin@restaurante.local / Admin123!\n";
echo "chef@restaurante.local / Chef123!\n";
echo "camarero@restaurante.local / Camarero123!\n";
echo "cliente@restaurante.local / Cliente123!\n";
echo "\nCambie las contraseñas antes de publicar el sistema en Internet.\n";
