import cx_Oracle
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker('es_ES')

conn = cx_Oracle.connect("C##TABLASO", "oracle", "192.168.0.100")
cursor = conn.cursor()

def insert_with_ids(table, fields, values_list, start_id=1):
    for i, values in enumerate(values_list, start=start_id):
        cursor.execute(
            f"INSERT INTO {table} (id, {', '.join(fields)}) VALUES (:1, {', '.join([':' + str(j+2) for j in range(len(fields))])})",
            [i] + list(values)
        )

# === TABLAS AUXILIARES ===
# Proveedores
insert_with_ids("Proveedores", ["nombre"], [(fake.company(),) for _ in range(50)])

# Editoriales
insert_with_ids("Editoriales", ["nombre"], [(fake.company(),) for _ in range(50)])

# Categorias
insert_with_ids("Categorias", ["nombre"], [(fake.word(),) for _ in range(30)])

# Subcategorias
insert_with_ids("Subcategorias", ["nombre", "id_categoria", "descripcion"], [
    (fake.word(), random.randint(1, 30), fake.text(200)) for _ in range(30)
])

# Versiones
insert_with_ids("Versiones", ["version", "fecha_lanzamiento"], [
    (f"v{random.randint(1,5)}.{random.randint(0,9)}", fake.date_between('-10y', 'today')) for _ in range(30)
])

# Salas
insert_with_ids("Salas", ["nombre"], [(f"Sala {i}",) for i in range(1, 21)])

# Escuelas
insert_with_ids("Escuelas", ["nombre"], [(fake.company(),) for _ in range(30)])

# === PRINCIPALES (1000) ===
# Libros
insert_with_ids("Libros", ["titulo", "id_editorial", "id_categoria", "id_version", "id_sub_categoria", "id_proveedor"], [
    (fake.sentence(nb_words=4), random.randint(1, 50), random.randint(1, 30), random.randint(1, 30),
     random.randint(1, 30), random.randint(1, 50)) for _ in range(1000)
])

# Autores
insert_with_ids("Autores", ["nombre"], [(fake.name(),) for _ in range(200)])

# Libro_Autor
for libro_id in range(1, 1001):
    autor_ids = random.sample(range(1, 201), random.randint(1, 3))
    for autor_id in autor_ids:
        cursor.execute("INSERT INTO Libro_Autor (id_libro, id_autor) VALUES (:1, :2)", (libro_id, autor_id))

# Usuarios
insert_with_ids("Usuarios", ["nombre", "id_escuela"], [
    (fake.name(), random.randint(1, 30)) for _ in range(1000)
])

# Ejemplares
insert_with_ids("Ejemplares", ["id_libro", "codigo", "estado"], [
    (random.randint(1, 1000), fake.uuid4(), random.choice(["Disponible", "Prestado", "Dañado"])) for _ in range(1000)
])

# Prestamos
insert_with_ids("Prestamos", ["id_usuario", "id_ejemplar", "fecha_prestamo", "fecha_devolucion"], [
    (
        random.randint(1, 1000),
        random.randint(1, 1000),
        (prestamo := fake.date_between('-1y', 'today')),
        prestamo + timedelta(days=random.randint(1, 30))
    ) for _ in range(1000)
])

# Devoluciones
insert_with_ids("Devoluciones", ["id_prestamo", "fecha", "estado"], [
    (
        pid := i,
        fake.date_between(start_date='-1y', end_date='today'),
        random.choice(["Devuelto", "Retrasado"])
    ) for i in range(1, 1001)
])

# Multas
insert_with_ids("Multas", ["id_usuario", "monto", "pagada"], [
    (random.randint(1, 1000), round(random.uniform(5, 100), 2), random.choice(["Y", "N"])) for _ in range(100)
])

# Sanciones
insert_with_ids("Sanciones", ["id_usuario", "descripcion"], [
    (random.randint(1, 1000), fake.sentence(nb_words=6)) for _ in range(100)
])

# Reservas
insert_with_ids("Reservas", ["id_usuario", "id_ejemplar", "fecha_reserva"], [
    (random.randint(1, 1000), random.randint(1, 1000), fake.date_between('-1y', 'today')) for _ in range(100)
])

# Donaciones
insert_with_ids("Donaciones", ["id_libro", "donante"], [
    (random.randint(1, 1000), fake.name()) for _ in range(100)
])

# Equipos
insert_with_ids("Equipos", ["id_proveedor", "nombre", "estado"], [
    (random.randint(1, 50), fake.word(), random.choice(["Nuevo", "Usado", "Dañado"])) for _ in range(100)
])

# Eventos
insert_with_ids("Eventos", ["id_sala", "nombre", "fecha"], [
    (random.randint(1, 20), fake.catch_phrase(), fake.date_between('-1y', 'today')) for _ in range(100)
])

# Sugerencias
insert_with_ids("Sugerencias", ["id_usuario", "titulo_libro"], [
    (random.randint(1, 1000), fake.sentence(nb_words=3)) for _ in range(100)
])

# Material Audiovisual
insert_with_ids("Material_Audiovisual", ["id_proveedor", "titulo", "tipo"], [
    (random.randint(1, 50), fake.catch_phrase(), random.choice(["DVD", "Blu-Ray", "CD", "Digital"])) for _ in range(100)
])

# Mobiliario
insert_with_ids("Mobiliario", ["id_sala", "id_proveedor", "nombre", "estado"], [
    (random.randint(1, 20), random.randint(1, 50), fake.word(), random.choice(["Nuevo", "Usado"])) for _ in range(100)
])

# Reclamos
insert_with_ids("Reclamos", ["id_usuario", "descripcion", "fecha", "estado"], [
    (random.randint(1, 1000), fake.text(100), fake.date_between('-1y', 'today'), random.choice(["Abierto", "Cerrado"])) for _ in range(100)
])

# Inscripciones
insert_with_ids("Inscripciones", ["id_usuario", "id_evento", "fecha_inscripcion"], [
    (random.randint(1, 1000), random.randint(1, 100), fake.date_between('-1y', 'today')) for _ in range(100)
])

# Perdidas
insert_with_ids("Perdidas", ["id_usuario", "id_ejemplar", "id_equipo", "fecha", "descripcion", "estado"], [
    (
        random.randint(1, 1000),
        random.randint(1, 1000),
        random.randint(1, 100),
        fake.date_between('-1y', 'today'),
        fake.sentence(),
        random.choice(["Reportado", "No encontrado", "Recuperado"])
    ) for _ in range(100)
])

# Reparaciones
insert_with_ids("Reparaciones", ["id_ejemplar", "fecha_inicio", "fecha_fin", "descripcion", "estado"], [
    (
        eid := random.randint(1, 1000),
        (start := fake.date_between('-1y', 'today')),
        start + timedelta(days=random.randint(1, 10)),
        fake.sentence(),
        random.choice(["En proceso", "Completado"])
    ) for _ in range(100)
])

# Calificaciones
insert_with_ids("Calificaciones", ["id_usuario", "id_libro", "comentario", "calificacion"], [
    (
        random.randint(1, 1000),
        random.randint(1, 1000),
        fake.sentence(),
        random.randint(1, 5)
    ) for _ in range(100)
])

# Mantenimientos
insert_with_ids("Mantenimientos", ["id_sala", "descripcion", "fecha", "estado"], [
    (
        random.randint(1, 20),
        fake.sentence(),
        fake.date_between('-1y', 'today'),
        random.choice(["Pendiente", "Finalizado"])
    ) for _ in range(50)
])

# Licencias
insert_with_ids("Licencias", ["id_material", "fecha_adquisicion", "fecha_expiracion", "costo"], [
    (
        mid := i,
        (fecha := fake.date_between('-3y', 'today')),
        fecha + timedelta(days=random.randint(90, 365)),
        round(random.uniform(20, 300), 2)
    ) for i in range(1, 101)
])

# Finalizar
conn.commit()
cursor.close()
conn.close()

print("✅ Registros insertados correctamente en todas las tablas.")
