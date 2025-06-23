-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-06-2025 a las 02:55:33
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto_bd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

CREATE TABLE `articulos` (
  `id` int(11) NOT NULL,
  `codigo` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `precio` float NOT NULL DEFAULT 0,
  `descripcion` text DEFAULT NULL,
  `categoria` enum('ropa','accesorios','cosmeticos','calzado','otro/a') NOT NULL DEFAULT 'otro/a',
  `imagen_url` varchar(255) DEFAULT 'assets/images/no-image.jpeg',
  `imagen_public_id` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `articulos`
--

INSERT INTO `articulos` (`id`, `codigo`, `nombre`, `cantidad`, `precio`, `descripcion`, `categoria`, `imagen_url`, `imagen_public_id`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
(2, '1234', 'Rolex', 2, 100000, 'Reloj dorado', 'accesorios', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750545422/proyecto_articulos/1750545420383-44.jpg', 'proyecto_articulos/1750545420383-44', '2025-06-21 22:37:01', '2025-06-21 22:37:24', NULL),
(3, '2397', 'Labial Dior', 25, 900, 'Labail Dior rosa', 'cosmeticos', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750545477/proyecto_articulos/1750545475735-40.jpg', 'proyecto_articulos/1750545475735-40', '2025-06-21 22:37:56', '2025-06-21 22:37:56', NULL),
(4, '912383', 'Bolso', 5, 1200, 'bolso negro de dama', 'accesorios', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750545512/proyecto_articulos/1750545510461-42.jpg', 'proyecto_articulos/1750545510461-42', '2025-06-21 22:38:31', '2025-06-21 22:38:31', NULL),
(5, '1236', 'Pantalon Cargo de Hombre', 20, 600, 'Pantalon Cargo de hombre', 'ropa', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750545551/proyecto_articulos/1750545549660-41.jpg', 'proyecto_articulos/1750545549660-41', '2025-06-21 22:39:10', '2025-06-21 22:39:10', NULL),
(11, 'd123', 'Pulsera de Hombre', 20, 50, '6 unidades de pulseras de piedras volcanicasasdasdasdasd', 'accesorios', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750546052/proyecto_articulos/1750546051159-39.jpg', 'proyecto_articulos/1750546051159-39', '2025-06-21 22:47:32', '2025-06-22 01:01:13', NULL),
(12, '123345', 'producto nuevo', 10, 100, 'saddasdas', 'cosmeticos', 'assets/images/no-image.jpeg', NULL, '2025-06-22 00:58:42', '2025-06-22 00:58:42', NULL),
(13, '12387', 'tenis', 1000, 123871000, 'tenis blancos', 'calzado', 'https://res.cloudinary.com/dmpknohvy/image/upload/v1750554000/proyecto_articulos/1750553998397-43.jpg', 'proyecto_articulos/1750553998397-43', '2025-06-22 01:00:00', '2025-06-22 01:00:00', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD UNIQUE KEY `codigo_2` (`codigo`),
  ADD UNIQUE KEY `codigo_3` (`codigo`),
  ADD UNIQUE KEY `codigo_4` (`codigo`),
  ADD UNIQUE KEY `codigo_5` (`codigo`),
  ADD KEY `deletedAt` (`deletedAt`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulos`
--
ALTER TABLE `articulos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
