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

SELECT nombre_cliente AS 'Nombre de cliente', count(nombre_cliente) AS 'Cantidad de repeticiones' FROM clientes GROUP BY nombre_cliente;


