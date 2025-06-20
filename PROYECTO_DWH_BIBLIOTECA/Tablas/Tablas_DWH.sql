CREATE TABLE dwh_Editorial (
    id_editorial INT PRIMARY KEY,
    nombre VARCHAR2(255),
    nombre_proovedor VARCHAR2(255),
    contacto_proovedor VARCHAR2(255),
    pais VARCHAR2(255),
    telefono VARCHAR2(255)
);

CREATE TABLE dwh_Personas (
    id_persona INT PRIMARY KEY,
    nombre VARCHAR2(255),
    correo VARCHAR2(255),
    telefono VARCHAR2(255),
    cargo VARCHAR2(255),
    salario DECIMAL(10,2)
);

CREATE TABLE dwh_Libro (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR2(255),
    nombre_categoria VARCHAR2(255),
    resena VARCHAR2(255),
    precio DECIMAL(10,2),
    stock INT,
    id_editorial INT 
);

CREATE TABLE dwh_Facturas (
    id_factura INT PRIMARY KEY,
    Metodo_pago VARCHAR2(255),
    cantidad INT,
    fecha DATE,
    total DECIMAL(10,2),
    id_persona INT,
    id_editorial INT,
    id_libro INT
);

CREATE TABLE dwh_Devoluciones (
    id_devolucion INT PRIMARY KEY,
    motivo CLOB,
    estado VARCHAR2(50),
    id_factura INT
);

CREATE TABLE dwh_Autor (
    id_autor INT PRIMARY KEY,
    nombre VARCHAR2(255),
    nacionalidad VARCHAR2(255),
    fecha_nacimiento DATE,
    id_editorial INT
);

CREATE TABLE dwh_Libros_Detalle (
    id_libroDet INT PRIMARY KEY,
    titulo VARCHAR2(255),
    categoria_nombre VARCHAR2(255),
    subcategoria_nombre VARCHAR2(255),
    version VARCHAR2(255),
    proveedor_nombre VARCHAR2(255),
    autores VARCHAR2(255),
    codigo VARCHAR2(255),
    estado VARCHAR2(255),
    id_editorial INT
);

CREATE TABLE dwh_Historial_Prestamos (
    id_HistorialPres INT PRIMARY KEY,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    estado_prestamo VARCHAR2(255),
    id_persona INT,
    id_libro INT
);

CREATE TABLE dwh_Usuarios_Detalle (
    id_usuarioDet INT PRIMARY KEY,
    nombre VARCHAR2(255),
    escuela_nombre VARCHAR2(255)
);

CREATE TABLE dwh_Usuarios_Sanciones (
    id_UsuariosSan INT PRIMARY KEY,
    monto DECIMAL(10,2),
    pagada CHAR(1), 
    descripcion VARCHAR2(255),
    id_persona INT
);

CREATE TABLE dwh_Historial_Usuarios (
    id_historialU INT PRIMARY KEY,
    tipo_accion VARCHAR2(255),
    fecha DATE,
    descripcion VARCHAR2(255),
    id_persona INT,
    id_libro INT
);

CREATE TABLE dwh_Estudiantes (
    id_estudiantes INT PRIMARY KEY,
    nombre VARCHAR2(255),
    apellido VARCHAR2(255),
    fecha_nacimiento DATE,
    direccion VARCHAR2(255),
    beca CHAR(1)
);

CREATE TABLE dwh_Profesores (
    id_profesores INT PRIMARY KEY,
    nombre VARCHAR2(255),
    apellido VARCHAR2(255),
    telefono VARCHAR2(255),
    especialidad VARCHAR2(255)
);

CREATE TABLE dwh_Asignaturas (
    id_asignaturas INT PRIMARY KEY,
    nombre_asignatura VARCHAR2(255),
    libro_texto VARCHAR2(255),
    id_profesor INT
);

CREATE TABLE dwh_Calificaciones (
    id_calificaciones INT PRIMARY KEY,
    nota INT,
    fecha DATE,
    id_estudiantes INT,
    id_asignaturas INT
);

CREATE TABLE dwh_log_etl (
    id_log_etl INT PRIMARY KEY,
    nombre_procedimiento VARCHAR2(100),
    tipo_carga VARCHAR2(20),
    fecha_ejecucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR2(20),
    mensaje_error VARCHAR2(4000)
);
