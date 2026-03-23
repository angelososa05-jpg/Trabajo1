-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-03-2026 a las 00:53:50
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
-- Base de datos: `biblioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_socio` (IN `id` INT, IN `nueva_direccion` VARCHAR(255), IN `nuevo_telefono` VARCHAR(15))   BEGIN
    UPDATE socio
    SET soc_direccion = nueva_direccion,
        soc_telefono = nuevo_telefono
    WHERE soc_numero = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_libro` (IN `nombre_libro` VARCHAR(100))   BEGIN
    SELECT * 
    FROM libro
    WHERE lib_titulo LIKE CONCAT('%', nombre_libro, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_libro` (IN `isbn` BIGINT)   BEGIN
    IF NOT EXISTS (
        SELECT * FROM prestamo WHERE lib_copiaISBN = isbn
    ) THEN
        DELETE FROM libro WHERE lib_isbn = isbn;
    ELSE
        SELECT 'No se puede eliminar, el libro está en préstamo' AS mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_socio` (IN `id` INT, IN `nombre` VARCHAR(50), IN `apellido` VARCHAR(50), IN `direccion` VARCHAR(255), IN `telefono` VARCHAR(15))   BEGIN
    INSERT INTO socio VALUES (id, nombre, apellido, direccion, telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `libros_en_prestamo` ()   BEGIN
    SELECT s.soc_nombre, s.soc_apellido, l.lib_titulo
    FROM prestamo p
    INNER JOIN socio s ON p.soc_copiaNumero = s.soc_numero
    INNER JOIN libro l ON p.lib_copiaISBN = l.lib_isbn;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_socios_prestamos` ()   BEGIN
    SELECT s.soc_nombre, s.soc_apellido, p.pres_id, p.pres_fechaPrestamo
    FROM socio s
    LEFT JOIN prestamo p 
    ON s.soc_numero = p.soc_copiaNumero;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `dias_prestamo` (`id_libro` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE dias INT;

    SELECT DATEDIFF(pres_fechaDevolucion, pres_fechaPrestamo)
    INTO dias
    FROM prestamo
    WHERE lib_copiaISBN = id_libro
    LIMIT 1;

    RETURN dias;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_socios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*) INTO cantidad FROM socio;

    RETURN cantidad;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(10) NOT NULL,
  `socNumero_audi` int(11) DEFAULT NULL,
  `socNombre_anterior` varchar(45) DEFAULT NULL,
  `socApellido_anterior` varchar(45) DEFAULT NULL,
  `socDireccion_anterior` varchar(255) DEFAULT NULL,
  `socTelefono_anterior` varchar(10) DEFAULT NULL,
  `socNombre_nuevo` varchar(45) DEFAULT NULL,
  `socApellido_nuevo` varchar(45) DEFAULT NULL,
  `socDireccion_nuevo` varchar(255) DEFAULT NULL,
  `socTelefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL,
  `accion` varchar(20) DEFAULT NULL,
  `isbn` bigint(20) DEFAULT NULL,
  `titulo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_socio`
--

INSERT INTO `audi_socio` (`id_audi`, `socNumero_audi`, `socNombre_anterior`, `socApellido_anterior`, `socDireccion_anterior`, `socTelefono_anterior`, `socNombre_nuevo`, `socApellido_nuevo`, `socDireccion_nuevo`, `socTelefono_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`, `accion`, `isbn`, `titulo`) VALUES
(1, 1, 'Ana', 'Ruiz', 'Barcelona', '9123456780', 'Ana', 'Ruiz', 'Calle 72 #\r\n\r\n2', '2928088', '2026-03-23 18:05:53', 'root@local', 'Actualización', NULL, NULL, NULL),
(2, 1, 'Ana', 'Ruiz', 'Calle 72 #\r\n\r\n2', '2928088', 'Ana', 'Ruiz', 'Calle 72 #\r\n\r\n2', '2928088', '2026-03-23 18:06:01', 'root@local', 'Actualización', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `aut_codigo` int(11) NOT NULL,
  `aut_apellido` varchar(50) DEFAULT NULL,
  `aut_nacimiento` date DEFAULT NULL,
  `aut_muerte` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`aut_codigo`, `aut_apellido`, `aut_nacimiento`, `aut_muerte`) VALUES
(98, 'Smith', '1974-12-21', '2018-07-21'),
(123, 'Taylor', '1980-04-15', NULL),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', NULL),
(432, 'Miller', '1981-10-26', NULL),
(456, 'García', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', NULL),
(765, 'López', '1976-07-08', NULL),
(789, 'Rodríguez', '1985-12-10', NULL),
(890, 'Brown', '1982-11-17', NULL),
(901, 'Soto', '1979-05-13', '2015-11-05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `lib_isbn` bigint(20) NOT NULL,
  `lib_titulo` varchar(100) DEFAULT NULL,
  `lib_genero` varchar(50) DEFAULT NULL,
  `lib_numeroPaginas` int(11) DEFAULT NULL,
  `lib_diasPrestamo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`lib_isbn`, `lib_titulo`, `lib_genero`, `lib_numeroPaginas`, `lib_diasPrestamo`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 7),
(2718281828, 'El Bosque de los Suspiros', 'novela', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `trg_delete_libro` AFTER DELETE ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_socio(
        accion,
        isbn,
        titulo,
        audi_fechaModificacion,
        audi_accion
    )
    VALUES (
        'DELETE',
        OLD.lib_isbn,
        OLD.lib_titulo,
        NOW(),
        'Eliminación libro'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_insert_libro` AFTER INSERT ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_socio(
        accion,
        isbn,
        titulo,
        audi_fechaModificacion,
        audi_accion
    )
    VALUES (
        'INSERT',
        NEW.lib_isbn,
        NEW.lib_titulo,
        NOW(),
        'Inserción libro'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_update_libro` AFTER UPDATE ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_socio(
        accion,
        isbn,
        titulo,
        audi_fechaModificacion,
        audi_accion
    )
    VALUES (
        'UPDATE',
        NEW.lib_isbn,
        NEW.lib_titulo,
        NOW(),
        'Actualización libro'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `pres_id` varchar(10) NOT NULL,
  `pres_fechaPrestamo` date DEFAULT NULL,
  `pres_fechaDevolucion` date DEFAULT NULL,
  `soc_copiaNumero` int(11) DEFAULT NULL,
  `lib_copiaISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`pres_id`, `pres_fechaPrestamo`, `pres_fechaDevolucion`, `soc_copiaNumero`, `lib_copiaISBN`) VALUES
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999),
('pres9', '2023-12-29', '2023-12-30', 8, 5555555555);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `soc_numero` int(11) NOT NULL,
  `soc_nombre` varchar(50) DEFAULT NULL,
  `soc_apellido` varchar(50) DEFAULT NULL,
  `soc_direccion` varchar(255) DEFAULT NULL,
  `soc_telefono` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`soc_numero`, `soc_nombre`, `soc_apellido`, `soc_direccion`, `soc_telefono`) VALUES
(1, 'Ana', 'Ruiz', 'Calle 72 #\r\n\r\n2', '2928088'),
(2, 'Andrés', 'Galindo', 'Madrid', '2123456789'),
(3, 'Juan', 'González', 'Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Málaga', '1234567812'),
(6, 'Ana', 'López', 'Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Palma', '1312345678'),
(9, 'Luis', 'Hernández', 'Granada', '6101234567'),
(10, 'Andrea', 'García', 'Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Gijón', '5512345678');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `socios_after_delete` AFTER DELETE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
socNumero_audi,
socNombre_anterior,
socApellido_anterior,
socDireccion_anterior,
socTelefono_anterior,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
old.soc_numero,
old.soc_nombre,
old.soc_apellido,
old.soc_direccion,
old.soc_telefono,
NOW(),
CURRENT_USER(),
'Registro eliminado')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
socNumero_audi,
socNombre_anterior,
socApellido_anterior,
socDireccion_anterior,
socTelefono_anterior,
socNombre_nuevo,
socApellido_nuevo,
socDireccion_nuevo,
socTelefono_nuevo,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
new.soc_numero,
old.soc_nombre,
old.soc_apellido,
old.soc_direccion,
old.soc_telefono,
new.soc_nombre,
new.soc_apellido,
new.soc_direccion,
new.soc_telefono,
NOW(),
CURRENT_USER(),
'Actualización')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_autores`
--

CREATE TABLE `tipo_autores` (
  `copiaISBN` bigint(20) DEFAULT NULL,
  `copiaAutor` int(11) DEFAULT NULL,
  `tipoAutor` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_autores`
--

INSERT INTO `tipo_autores` (`copiaISBN`, `copiaAutor`, `tipoAutor`) VALUES
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(2718281828, 789, 'Traductor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`aut_codigo`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`lib_isbn`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`pres_id`),
  ADD KEY `soc_copiaNumero` (`soc_copiaNumero`),
  ADD KEY `lib_copiaISBN` (`lib_copiaISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`soc_numero`);

--
-- Indices de la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD KEY `copiaISBN` (`copiaISBN`),
  ADD KEY `copiaAutor` (`copiaAutor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`soc_copiaNumero`) REFERENCES `socio` (`soc_numero`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`lib_copiaISBN`) REFERENCES `libro` (`lib_isbn`);

--
-- Filtros para la tabla `tipo_autores`
--
ALTER TABLE `tipo_autores`
  ADD CONSTRAINT `tipo_autores_ibfk_1` FOREIGN KEY (`copiaISBN`) REFERENCES `libro` (`lib_isbn`),
  ADD CONSTRAINT `tipo_autores_ibfk_2` FOREIGN KEY (`copiaAutor`) REFERENCES `autor` (`aut_codigo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
