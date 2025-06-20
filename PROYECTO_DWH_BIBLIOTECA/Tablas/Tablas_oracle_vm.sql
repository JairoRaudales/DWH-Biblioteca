CREATE TABLE Libros (
    id NUMBER PRIMARY KEY,
    titulo VARCHAR2(255),
    id_editorial NUMBER,
    id_categoria NUMBER,
    id_version NUMBER,
    id_sub_categoria NUMBER,
    id_proveedor NUMBER
);

CREATE TABLE Autores (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Libro_Autor (
    id_libro NUMBER,
    id_autor NUMBER,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES Libros(id),
    FOREIGN KEY (id_autor) REFERENCES Autores(id)
);

CREATE TABLE Editoriales (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Categorias (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Ejemplares (
    id NUMBER PRIMARY KEY,
    id_libro NUMBER,
    codigo VARCHAR2(50),
    estado VARCHAR2(50),
    FOREIGN KEY (id_libro) REFERENCES Libros(id)
);

CREATE TABLE Usuarios (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    id_escuela NUMBER
);

CREATE TABLE Escuelas (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Prestamos (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    id_ejemplar NUMBER,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    FOREIGN KEY (id_ejemplar) REFERENCES Ejemplares(id)
);

CREATE TABLE Devoluciones (
    id NUMBER PRIMARY KEY,
    id_prestamo NUMBER,
    fecha DATE,
    estado VARCHAR2(50),
    FOREIGN KEY (id_prestamo) REFERENCES Prestamos(id)
);

CREATE TABLE Multas (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    monto NUMBER(10,2),
    pagada CHAR(1) CHECK (pagada IN ('Y', 'N')),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id)
);

CREATE TABLE Sanciones (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    descripcion VARCHAR2(500),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id)
);

CREATE TABLE Reservas (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    id_ejemplar NUMBER,
    fecha_reserva DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    FOREIGN KEY (id_ejemplar) REFERENCES Ejemplares(id)
);

CREATE TABLE Donaciones (
    id NUMBER PRIMARY KEY,
    id_libro NUMBER,
    donante VARCHAR2(255),
    FOREIGN KEY (id_libro) REFERENCES Libros(id)
);

CREATE TABLE Equipos (
    id NUMBER PRIMARY KEY,
    id_proveedor NUMBER,
    nombre VARCHAR2(255),
    estado VARCHAR2(50),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id)
);

CREATE TABLE Salas (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Eventos (
    id NUMBER PRIMARY KEY,
    id_sala NUMBER,
    nombre VARCHAR2(255),
    fecha DATE,
    FOREIGN KEY (id_sala) REFERENCES Salas(id)
);

CREATE TABLE Sugerencias (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    titulo_libro VARCHAR2(255),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id)
);

CREATE TABLE Material_Audiovisual (
    id NUMBER PRIMARY KEY,
    id_proveedor NUMBER,
    titulo VARCHAR2(255),
    tipo VARCHAR2(100),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id)
);

CREATE TABLE Proveedores (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Mobiliario (
    id NUMBER PRIMARY KEY,
    id_sala NUMBER,
    id_proveedor NUMBER,
    nombre VARCHAR2(255),
    estado VARCHAR2(50),
    FOREIGN KEY (id_sala) REFERENCES Salas(id),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id)
);

CREATE TABLE Reclamos (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    descripcion VARCHAR2(500),
    fecha DATE,
    estado VARCHAR2(50),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id)
);

CREATE TABLE Inscripciones (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    id_evento NUMBER,
    fecha_inscripcion DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    FOREIGN KEY (id_evento) REFERENCES Eventos(id)
);

CREATE TABLE Perdidas (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    id_ejemplar NUMBER,
    id_equipo NUMBER,
    fecha DATE,
    descripcion VARCHAR2(500),
    estado VARCHAR2(50),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    FOREIGN KEY (id_ejemplar) REFERENCES Ejemplares(id),
    FOREIGN KEY (id_equipo) REFERENCES Equipos(id)
);

CREATE TABLE Reparaciones (
    id NUMBER PRIMARY KEY,
    id_ejemplar NUMBER,
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion VARCHAR2(500),
    estado VARCHAR2(50),
    FOREIGN KEY (id_ejemplar) REFERENCES Ejemplares(id)
);

CREATE TABLE Calificaciones (
    id NUMBER PRIMARY KEY,
    id_usuario NUMBER,
    id_libro NUMBER,
    comentario VARCHAR2(500),
    calificacion NUMBER CHECK (calificacion BETWEEN 1 AND 5),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    FOREIGN KEY (id_libro) REFERENCES Libros(id)
);

CREATE TABLE Mantenimientos (
    id NUMBER PRIMARY KEY,
    id_sala NUMBER,
    descripcion VARCHAR2(500),
    fecha DATE,
    estado VARCHAR2(50),
    FOREIGN KEY (id_sala) REFERENCES Salas(id)
);

CREATE TABLE Licencias (
    id NUMBER PRIMARY KEY,
    id_material NUMBER,
    fecha_adquisicion DATE,
    fecha_expiracion DATE,
    costo NUMBER(10,2),
    FOREIGN KEY (id_material) REFERENCES Material_Audiovisual(id)
);

CREATE TABLE Subcategorias (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    id_categoria NUMBER,
    descripcion CLOB,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id)
);

CREATE TABLE Versiones (
    id NUMBER PRIMARY KEY,
    version VARCHAR2(50),
    fecha_lanzamiento DATE
);
