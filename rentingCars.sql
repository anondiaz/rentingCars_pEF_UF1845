-- Hay que crear una bbdd que llamaremos rentingCars

-- CREATE DATABASE IF NOT EXISTS rentingCars;

-- Borrar la BD rentingCars

DROP DATABASE IF EXISTS rentingcars;

-- Hay que crear una bbdd que llamaremos rentingCars

CREATE DATABASE IF NOT EXISTS rentingCars
DEFAULT CHARACTER SET utf8mb3
COLLATE utf8_general_ci
;

USE rentingcars;

-- Crear una tabla 'alquileres' que tenga:
-- id_alquiler pk
-- id_cliente
-- id_vehiculo
-- fecha_recogida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- fecha_entrega TIMESTAMP
-- facturacion decimal(10,2) NOT NULL DEFAULT 0.00

CREATE TABLE IF NOT EXISTS alquileres (
id_alquiler INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_cliente INT NOT NULL,
id_vehiculo INT NOT NULL,
fecha_recogida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_entrega TIMESTAMP,
facturacion DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

-- Crear una tabla 'clientes' que tenga:
-- id_cliente
-- nombre_cliente VARCHAR(50) NOT NULL
-- apellido_cliente  VARCHAR(100) NOT NULL
-- carnet_conducir VARCHAR(12) UNIQUE NOT NULL
-- telefono VARCHAR(12) NOT NULL
-- email VARCHAR(100) NOT NULL

CREATE TABLE IF NOT EXISTS clientes (
id_cliente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_cliente VARCHAR(50) NOT NULL,
apellido_cliente  VARCHAR(100) NOT NULL,
carnet_conducir VARCHAR(12) UNIQUE NOT NULL,
telefono VARCHAR(12) NOT NULL,
email VARCHAR(100) NOT NULL
);

-- Crear una tabla 'vehiculos' que tenga:
-- id_cliente
-- id_marca
-- nombre_modelo
-- unidades_totales
-- unidades_alquiladas
-- plazas
-- puertas
-- cambio
-- matricula
-- precioDia

CREATE TABLE IF NOT EXISTS vehiculos (
id_vehiculo INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
-- id_marca INT NOT NULL,
nombre_modelo VARCHAR(50) NOT NULL,
unidades_totales INT NOT NULL,
unidades_disponibles INT NOT NULL,
personas  SMALLINT NOT NULL,
puertas SMALLINT NOT NULL,
cambio ENUM("manual", "automático", "-") NOT NULL,
matricula VARCHAR(7) UNIQUE NOT NULL,
precioDia DECIMAL(5,2) NOT NULL DEFAULT 0.00
);

-- Crear una restricción entre la tabla clientes y alquileres
ALTER TABLE alquileres
ADD CONSTRAINT fk_alquileres_clientes
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

-- Crear una restricción entre la tabla vehiculos y alquileres

ALTER TABLE alquileres
ADD CONSTRAINT fk_alquileres_vehiculos
FOREIGN KEY (id_vehiculo)
REFERENCES vehiculos(id_vehiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

-- Añadir una columna para el tipo de vehiculo
--  "moto", "coche", "bicicleta", "patinete"
ALTER TABLE vehiculos
ADD COLUMN tipo_vehiculo
ENUM("moto", "coche", "bicicleta", "patinete", "-") NOT NULL
;

-- Añadir vehiculos a la tabla
INSERT INTO vehiculos (
nombre_modelo,
unidades_totales,
unidades_disponibles,
personas,
puertas,
cambio,
matricula,
precioDia,
tipo_vehiculo
)
VALUES (
'Fiat Panda', 5, 5, 4, 3, "manual", "1111BBB", 49.5, 'coche')
;

INSERT INTO vehiculos (
nombre_modelo,
unidades_totales,
unidades_disponibles,
personas,
puertas,
cambio,
matricula,
precioDia,
tipo_vehiculo
)
VALUES (
'Nissan Primastar', 2, 2, 9, 3, "automatico", "1111BBC", 150.65, 'furgoneta')
;

-- Añadir el tipo furgoneta en la columna tipo
--  "moto", "coche", "bicicleta", "patinete", "furgoneta"
ALTER TABLE vehiculos
MODIFY COLUMN tipo_vehiculo
ENUM("moto", "coche", "bicicleta", "patinete", "furgoneta", "-") NOT NULL
;

INSERT INTO vehiculos (
nombre_modelo,
unidades_totales,
unidades_disponibles,
personas,
puertas,
cambio,
matricula,
precioDia,
tipo_vehiculo
)
VALUES 
('Nissan Micra', 3, 3, 4, 3, "manual", "1111CCC", 49.5, "coche"),
('Piaggio Vespa', 5, 5, 2, 0, "manual", "1111DDD", 55.4, "moto"),
('Piaggio Beverly', 1, 1, 2, 0, "manual", "1111EEE", 60, "moto")
;

-- Necesitamos saber cuantos vehiculos tenemos en total
-- lo mostraremos como 'total vehiculos'

SELECT sum(unidades_totales) AS 'total vehiculos' FROM vehiculos;

-- Necesitamos saber cuales son los vehiculos más baratos de alquilar
-- lo mostraremos como 'vehículos económicos', con el precio

SELECT nombre_modelo AS 'vehículos económicos', precioDia FROM vehiculos WHERE precioDia = (
-- SELECT precioDia FROM vehiculos LIMIT 1
SELECT min(precioDia) FROM vehiculos
);

-- ¿En un dia cuanto podriamos facturar?
-- Es el producto (*) de unidades_totales x precioDia

SELECT sum(unidades_totales * precioDia) FROM vehiculos;

-- Introducir clientes
-- ('Steve','Ballmer','1111','111111111','steve@ballmer.com'),
-- ('Clint','Eastwood','2222','222222222','clint@eastwood.com'),
-- ('Luciano','Pavarotti','3333','333333333',''),
-- ('Lionel','Messi','4444','444444444','')
-- ('Lionel','Ritchie','5555','555555555','lionel@ritchie.cat')

INSERT INTO clientes
(nombre_cliente, apellido_cliente, carnet_conducir, telefono, email)
VALUES
('Steve','Ballmer','1111','111111111','steve@ballmer.com'),
('Clint','Eastwood','2222','222222222','clint@eastwood.com'),
('Luciano','Pavarotti','3333','333333333',''),
('Lionel','Messi','4444','444444444',''),
('Lionel','Ritchie','5555','555555555','lionel@ritchie.cat')
;

-- Añadir este email --> lionel@antonella.ar
UPDATE clientes
SET email = 'lionel@antonella.ar'
WHERE nombre_cliente = "Lionel"
AND apellido_cliente = "Messi"
;

-- Queremos saber de que cliente no tenemos el email
SELECT nombre_cliente, apellido_cliente FROM clientes WHERE email = '';

-- ¿Cuántos clientes se llaman Lionel?
SELECT count(nombre_cliente) AS 'Nombre "Lionel"' FROM clientes WHERE nombre_cliente = 'Lionel';

-- ¿Cuántos clientes tenemos de cada nombre que hay en la tabla?
-- con el nombre del cliente

SELECT nombre_cliente AS 'Nombre de cliente', count(nombre_cliente) AS 'Cantidad de repeticiones' FROM clientes GROUP BY nombre_cliente ORDER BY 'Cantidad de repeticiones' DESC;

-- Para realizar un alquiler:
-- nombre_cliente, apellido_cliente, carnet_conducir, telefono, email
-- modelo, fecha_alquiler
-- Si el cliente no figura en la bbdd hay que añadirlo
-- Con un Procedimiento Almacenado --> alquiler_vehiculo
-- nombre_cliente, apellido_cliente, carnet_conducir, telefono, email, modelo, fecha_alquiler

-- ----- Inicio version Profe -----
DELIMITER //
CREATE PROCEDURE alquiler_vehiculo(
sp_nombre_cliente VARCHAR(50),
sp_apellido_cliente VARCHAR(100),
sp_carnet VARCHAR(12),
sp_telefono VARCHAR(12),
sp_email VARCHAR(100),
sp_modelo VARCHAR(50),
sp_fecha_recogida TIMESTAMP)
BEGIN
	DECLARE idCliente INT;
    DECLARE idVehiculo INT;
    DECLARE disponibilidad INT;
    
    SELECT id_cliente INTO idCliente
    FROM clientes
    WHERE carnet_conducir = sp_carnet;
    
    IF idCliente IS NULL THEN
		INSERT INTO clientes (nombre_cliente, apellido_cliente, carnet_conducir, telefono, email)
 		VALUES (sp_nombre_cliente, sp_apellido_cliente, sp_carnet, sp_telefono, sp_email);
        SELECT id_cliente INTO idCliente
		FROM clientes
		WHERE carnet_conducir = sp_carnet;
    END IF;
    
    SELECT unidades_disponibles INTO disponibilidad
    FROM vehiculos
    WHERE nombre_modelo = sp_modelo;
    
    SELECT id_vehiculo INTO idVehiculo
    FROM vehiculos
    WHERE nombre_modelo = sp_modelo;
    
    IF disponibilidad = 0 THEN
		SELECT "No hay vehiculos disponibles de este modelo, no se puede alquilar";
    ELSE
        INSERT INTO alquileres (id_cliente, id_vehiculo, fecha_recogida)
		VALUES (idCliente, idVehiculo, sp_fecha_recogida);
		SELECT id_vehiculo INTO idVehiculo
		FROM vehiculos
		WHERE nombre_modelo = sp_modelo;
    	UPDATE vehiculos SET unidades_disponibles = unidades_disponibles - 1 WHERE id_vehiculo = idVehiculo;
        SELECT "Alquiler realizado correctamente";
    END IF;
    
END //
DELIMITER ;
-- DROP PROCEDURE alquiler_vehiculo;
-- ----- Fin version Profe -----

-- ----- Inicio mi version Profe -----
-- DELIMITER //
-- CREATE PROCEDURE alquiler_vehiculo(
-- sp_nombre_cliente VARCHAR(50),
-- sp_apellido_cliente VARCHAR(100),
-- sp_carnet VARCHAR(12),
-- sp_telefono VARCHAR(12),
-- sp_email VARCHAR(100),
-- sp_modelo VARCHAR(50),
-- sp_fecha_recogida TIMESTAMP)
-- BEGIN
-- 	DECLARE idCliente INT;
--     DECLARE idVehiculo INT;
--     DECLARE disponibilidad INT;
--     
--     SELECT id_cliente INTO idCliente
--     FROM clientes
--     WHERE carnet_conducir = sp_carnet;
--     
--     IF idCliente IS NULL THEN
-- 		INSERT INTO clientes (nombre_cliente, apellido_cliente, carnet_conducir, telefono, email)
--  		VALUES (sp_nombre_cliente, sp_apellido_cliente, sp_carnet, sp_telefono, sp_email);
--         SELECT id_cliente INTO idCliente
-- 		FROM clientes
-- 		WHERE carnet_conducir = sp_carnet;
--     END IF;
--     
-- 	SELECT id_vehiculo INTO idVehiculo
--     FROM vehiculos
--     WHERE nombre_modelo = sp_modelo;
--     
--     SELECT unidades_disponibles INTO disponibilidad
--     FROM vehiculos
--     WHERE nombre_modelo = sp_modelo;
--     
--  	IF disponibilidad IS NULL THEN
-- -- 		Mostramos un mensaje de que no hay vehiculos disponibles
--  		SELECT "No hay vehiculos disponibles de este modelo, no se puede alquilar";
--     ELSE
-- -- 		Hacemos un insert del alquiler
-- 		INSERT INTO alquileres (id_cliente, id_vehiculo, fecha_recogida)
-- 		VALUES (idCliente, idVehiculo, sp_fecha_recogida);
--         
--         UPDATE vehiculos SET unidades_disponibles = unidades_disponibles - 1 WHERE nombre_modelo = sp_modelo;
--     
-- 		SELECT "Alquiler realizado correctamente";
--     END IF;
--     
-- END //
-- DELIMITER ;
-- DROP PROCEDURE alquiler_vehiculo;
-- ----- Fin mi version Profe -----

-- ----- Inicio mi versión -----
-- DELIMITER $$
-- CREATE PROCEDURE insertAlquiler(nombreCliente VARCHAR(50),
-- 								apellidoCliente VARCHAR(100),
-- 								carnetConducir VARCHAR(12),
--                                 numeroTelefono VARCHAR(12),
--                                 direccionEmail VARCHAR(100),
--                                 marcaModelo VARCHAR(50),
--                                 fechaAlquiler TIMESTAMP)
-- BEGIN
-- 	SET @idCliente = (SELECT id_cliente FROM clientes cl WHERE cl.carnet_conducir = carnetConducir);
--     SET @idVehiculo = (SELECT id_vehiculo FROM vehiculos ve WHERE ve.nombre_modelo = marcaModelo);
-- --  Comprobamos si existe el cliente si no existe lo creamos
-- 	IF @idCliente IS NULL THEN
-- -- 		Hacemos un insert del nuevo cliente
-- 		INSERT INTO clientes (nombre_cliente, apellido_cliente, carnet_conducir, telefono, email)
-- 		VALUES (nombreCliente, apellidoCliente, carnetConducir, numeroTelefono, direccionEmail);
-- 		SET @idCliente = (SELECT id_cliente FROM clientes cl WHERE cl.carnet_conducir = carnetConducir);
-- 	END IF;
-- -- 	Comprobamos si hay vehiculos disponibles
-- 	IF @disponibilidadVehiculo IS NULL THEN
-- -- 		Mostramos un mensaje de que no hay vehiculos disponibles
-- -- 			SELECT concat("Ese libro no existe, no se puede prestar");
-- -- 			SIGNAL SQLSTATE '45000'
--  			SET MESSAGE_TEXT = "No hay vehiculos disponibles de este modelo, no se puede alquilar";
--     ELSE
-- -- 		Hacemos un insert del alquiler
-- 		INSERT INTO alquileres (id_cliente, id_vehiculo, fecha_recogida, fecha_entrega, facturacion)
-- 		VALUES (idCliente, idVehiculo, fechaAlquiler, '')
--     END IF;
-- END ;
--  DELIMITER ;
 
-- DROP PROCEDURE insertAlquiler;
-- ----- Fin mi versión -----

CALL alquiler_vehiculo ("Clark", "Kent", "6666", "666666666", "super@man.com", "Nissan Micra", "2024-12-25");
CALL alquiler_vehiculo ("Clint", "Eastwood", "2222", "222222222", "clint@eastwood.com", "Fiat Panda", "2025-04-20");

