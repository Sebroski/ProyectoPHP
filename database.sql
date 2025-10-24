-- --- Creación de Tablas ---

-- Tabla para Monedas
CREATE TABLE tbl_monedas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    simbolo VARCHAR(5)
);

-- Tabla para Bodegas
CREATE TABLE tbl_bodegas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla para Sucursales (depende de Bodegas)
CREATE TABLE tbl_sucursales (
    id SERIAL PRIMARY KEY,
    id_bodega INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT fk_bodega
        FOREIGN KEY(id_bodega) 
        REFERENCES tbl_bodegas(id)
        ON DELETE CASCADE
);

-- Tabla principal de Productos
CREATE TABLE tbl_productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    id_bodega INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_moneda INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    materiales VARCHAR(255) NOT NULL, -- Almacenará los materiales como "Madera,Vidrio"
    descripcion VARCHAR(1000) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bodega_prod
        FOREIGN KEY(id_bodega) 
        REFERENCES tbl_bodegas(id),
    CONSTRAINT fk_sucursal_prod
        FOREIGN KEY(id_sucursal) 
        REFERENCES tbl_sucursales(id),
    CONSTRAINT fk_moneda_prod
        FOREIGN KEY(id_moneda) 
        REFERENCES tbl_monedas(id)
);

-- --- Inserción de Datos de Ejemplo ---

-- Monedas
INSERT INTO tbl_monedas (nombre, simbolo) VALUES 
('DÓLAR', '$'),
('PESO (CLP)', '$'),
('EURO', '€');

-- Bodegas
INSERT INTO tbl_bodegas (nombre) VALUES 
('Bodega 1'),
('Bodega 2'),
('Bodega Central');

-- Sucursales (asociadas a las bodegas)
-- Bodega 1
INSERT INTO tbl_sucursales (id_bodega, nombre) VALUES
(1, 'Sucursal 1-A'),
(1, 'Sucursal 1-B');

-- Bodega 2
INSERT INTO tbl_sucursales (id_bodega, nombre) VALUES
(2, 'Sucursal 2-A');

-- Bodega Central
INSERT INTO tbl_sucursales (id_bodega, nombre) VALUES
(3, 'Sucursal Central Norte'),
(3, 'Sucursal Central Sur'),
(3, 'Sucursal Central Oriente');