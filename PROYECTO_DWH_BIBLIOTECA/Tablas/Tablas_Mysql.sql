CREATE TABLE Editorial (
    id_editorial NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    pais VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE Autor (
    id_autor NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    nacionalidad VARCHAR(100),
    fecha_nacimiento DATE
);

CREATE TABLE Categoria (
    id_categoria NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Libro (
    id_libro NUMERIC PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    id_categoria NUMERIC,
    precio DECIMAL(10,2),
    stock NUMERIC,
    id_editorial NUMERIC,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial)
);

CREATE TABLE Cliente (
    id_cliente NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE Empleado (
    id_empleado NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cargo VARCHAR(100),
    salario DECIMAL(10,2)
);

CREATE TABLE Proveedor (
    id_proveedor NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    contacto VARCHAR(100)
);

CREATE TABLE Venta (
    id_venta NUMERIC PRIMARY KEY,
    id_cliente NUMERIC,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Detalle_Venta (
    id_detalle NUMERIC PRIMARY KEY,
    id_venta NUMERIC,
    id_libro NUMERIC,
    cantidad NUMERIC,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Inventario (
    id_inventario NUMERIC PRIMARY KEY,
    id_libro NUMERIC,
    cantidad NUMERIC,
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Pedido (
    id_pedido NUMERIC PRIMARY KEY,
    id_proveedor NUMERIC,
    fecha_pedido DATE,
    estado VARCHAR(50),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Detalle_Pedido (
    id_detalle NUMERIC PRIMARY KEY,
    id_pedido NUMERIC,
    id_libro NUMERIC,
    cantidad NUMERIC,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Pago (
    id_pago NUMERIC PRIMARY KEY,
    id_venta NUMERIC,
    monto DECIMAL(10,2),
    fecha DATE,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Metodo_Pago (
    id_metodo NUMERIC PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Suscripcion (
    id_suscripcion NUMERIC PRIMARY KEY,
    id_cliente NUMERIC,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Rol (
    id_rol NUMERIC PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Usuario (
    id_usuario NUMERIC PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE,
    id_rol NUMERIC,
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

CREATE TABLE Reseña (
    id_resena NUMERIC PRIMARY KEY,
    id_libro NUMERIC,
    id_cliente NUMERIC,
    comentario TEXT,
    calificacion NUMERIC,
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Envio (
    id_envio NUMERIC PRIMARY KEY,
    id_venta NUMERIC,
    direccion VARCHAR(255),
    fecha_envio DATE,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Factura (
    id_factura NUMERIC PRIMARY KEY,
    id_venta NUMERIC,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Devolucion (
    id_devolucion NUMERIC PRIMARY KEY,
    id_venta NUMERIC,
    motivo TEXT,
    estado VARCHAR(50),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Estado_Devolucion (
    id_estado NUMERIC PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Historial_Editorial (
    id_historial NUMERIC PRIMARY KEY,
    id_editorial NUMERIC,
    cambio TEXT,
    fecha DATE,
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial)
);

CREATE TABLE Editorial_Autor (
    id_editorial NUMERIC,
    id_autor NUMERIC,
    PRIMARY KEY (id_editorial, id_autor),
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial),
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

CREATE TABLE Prestamo_Libro (
    id_prestamo NUMERIC PRIMARY KEY,
    id_cliente NUMERIC,
    id_libro NUMERIC,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Descuento (
    id_descuento NUMERIC PRIMARY KEY,
    descripcion VARCHAR(255),
    porcentaje DECIMAL(5,2)
);

CREATE TABLE Publicidad (
    id_publicidad NUMERIC PRIMARY KEY,
    descripcion VARCHAR(255),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE Comentario (
    id_comentario NUMERIC PRIMARY KEY,
    id_resena NUMERIC,
    texto VARCHAR(255),
    FOREIGN KEY (id_resena) REFERENCES Reseña(id_resena)
);

CREATE TABLE Configuracion (
    id_configuracion NUMERIC PRIMARY KEY,
    clave VARCHAR(255),
    valor VARCHAR(255)
);

CREATE TABLE Seguimiento_Pedido (
    id_seguimiento NUMERIC PRIMARY KEY,
    id_pedido NUMERIC,
    estado VARCHAR(255),
    fecha DATE,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);
