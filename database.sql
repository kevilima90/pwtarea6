-- Base de datos para el Sistema de Gestión de Restaurante Online
-- Importar este archivo desde phpMyAdmin.
CREATE DATABASE IF NOT EXISTS restaurante_online
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE restaurante_online;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO roles (name)
VALUES ('Administrator'), ('Chef'), ('Waiter'), ('Client');

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

CREATE TABLE dishes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    dish_id INT NOT NULL,
    quantity INT NOT NULL,
    status ENUM('Pending', 'Preparing', 'Ready to serve', 'Served') NOT NULL DEFAULT 'Pending',
    waiter_id INT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_client FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_orders_dish FOREIGN KEY (dish_id) REFERENCES dishes(id),
    CONSTRAINT fk_orders_waiter FOREIGN KEY (waiter_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_order_quantity CHECK (quantity BETWEEN 1 AND 50)
) ENGINE=InnoDB;

INSERT INTO dishes (name, description, price) VALUES
('Encebollado', 'Pescado, yuca, cebolla curtida y hierbas frescas.', 3.50),
('Seco de pollo', 'Pollo guisado acompañado de arroz y maduro.', 4.75),
('Arroz marinero', 'Arroz con mariscos y vegetales salteados.', 6.50),
('Bolón mixto', 'Verde majado con queso y chicharrón.', 3.00),
('Jugo natural', 'Jugo de fruta de temporada.', 1.50);
