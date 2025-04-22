-- Hay que crear una bbdd que llamaremos rentingCars

CREATE DATABASE IF NOT EXISTS rentingCars;

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




