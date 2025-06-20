from pymongo import MongoClient
import oracledb
#import datetime

client = MongoClient("mongodb://localhost:27017/")
mongo_db = client["tablasmongo"]

asignaturas_col = mongo_db["Asignaturas"]
calificaciones_col = mongo_db["Calificaciones"]
estudiantes_col = mongo_db["Estudiantes"]
profesores_col = mongo_db["Profesores"]


oracle_conn = oracledb.connect(
    user="C##DATAW",
    password="oracle",
    dsn="localhost:1521/xe"
)
cursor = oracle_conn.cursor()

for cal in calificaciones_col.find():
    cursor.execute("""
        MERGE INTO Calificaciones t
        USING (SELECT :id AS ID_CALIFICACIONES FROM dual) s
        ON (t.ID_CALIFICACIONES = s.ID_CALIFICACIONES)
        WHEN MATCHED THEN
            UPDATE SET NOTA = :nota, FECHA = :fecha, ID_ESTUDIANTES = :id_estudiante, ID_ASIGNATURAS = :id_asignatura
        WHEN NOT MATCHED THEN
            INSERT (ID_CALIFICACIONES, NOTA, FECHA, ID_ESTUDIANTES, ID_ASIGNATURAS)
            VALUES (:id, :nota, :fecha, :id_estudiante, :id_asignatura)
    """, {
        "id": cal["id"],
        "nota": cal["nota"],
        "fecha": cal["fecha"],
        "id_estudiante": cal["id_estudiante"],
        "id_asignatura": cal["id_asignatura"]
    })




cursor.execute("""DELETE FROM Asignaturas""")
for asig in asignaturas_col.find():
    cursor.execute("""
        INSERT INTO Asignaturas (ID_ASIGNATURAS, NOMBRE_ASIGNATURA, ID_PROFESOR)
        VALUES (:1, :2, :3)
    """, (
        asig["id"],
        asig["nombre_asignatura"],
        asig["id_profesor"]
    ))



cursor.execute("""DELETE FROM Estudiantes""")
for est in estudiantes_col.find():
        cursor.execute("""
            INSERT INTO Estudiantes (ID_ESTUDIANTES, NOMBRE, APELLIDO, FECHA_NACIMIENTO, DIRECCION)
            VALUES (:1, :2, :3, :4, :5)
        """, (
            est["id"],
            est["nombre"],
            est["apellido"],
            est["fecha_nacimiento"],
            est["direccion"]
        ))


cursor.execute("""DELETE FROM Profesores""")
for prof in profesores_col.find():
        cursor.execute("""
            INSERT INTO Profesores (ID_PROFESORES, NOMBRE, APELLIDO, TELEFONO, ESPECIALIDAD)
            VALUES (:1, :2, :3, :4, :5)
        """, (
            prof["id"],
            prof["nombre"],
            prof["apellido"],
            prof["telefono"],
            prof["especialidad"]
        ))


oracle_conn.commit()
cursor.close()
oracle_conn.close()
client.close()

print("ETL completado correctamente.")


