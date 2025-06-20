# 📚 PROYECTO DWH BIBLIOTECA

Este proyecto implementa un **Data Warehouse (DWH)** orientado a la gestión de datos bibliotecarios y académicos, integrando múltiples fuentes de datos: **MongoDB**, **MySQL** y **Oracle**. Se utilizan procesos ETL automatizados para la extracción, transformación y carga de la información.

---

## 🚀 Objetivos del proyecto

- Integrar diferentes fuentes de datos en un único Data Warehouse.
- Automatizar la carga de datos con scripts Python y SQL.
- Organizar y transformar datos de una biblioteca académica (estudiantes, calificaciones, becas, materiales, etc.).

---

## 🧰 Tecnologías utilizadas

- **Python**: para los scripts ETL.
- **SQL (MySQL & Oracle)**: definición de tablas e inserción de datos.
- **MongoDB**: como fuente de datos no relacional.
- **JSON**: estructuras de datos para MongoDB.

---

## 📂 Estructura del repositorio

```
PROYECTO_DWH_BIBLIOTECA/
│
├── ELTS y JOBs/
│   ├── ETLs_Mongo_a_Oracle.py
│   ├── ETLs_y_JOBs_Mysql__Oracle.sql
│   └── Job_mongo.py
│
├── Inserts Oracle y mysql/
│   ├── insert_Mysql.sql
│   ├── Insert_oracle.sql
│   └── inserts_Oracle_randomizados.py
│
├── Tablas/
│   ├── Tablas_DWH.sql
│   ├── Tablas_Mysql.sql
│   ├── Tablas_oracle_vm.sql
│   └── Tablas_e_insert_mongo/
│       ├── tablasmongo.Asignaturas.json
│       ├── tablasmongo.Aulas.json
│       ├── tablasmongo.Becas.json
│       ├── tablasmongo.Calificaciones.json
│       ├── tablasmongo.Clases.json
│       ├── tablasmongo.Estudiantes.json
│       ├── tablasmongo.Grado.json
│       ├── tablasmongo.Grados.json
│       ├── tablasmongo.Horarios.json
│       ├── tablasmongo.Material.json
│       └── tablasmongo.Profesores.json
```

---

## ⚙️ Cómo usar el proyecto

1. **Cargar datos en MongoDB:**
   - Asegúrate de tener MongoDB instalado y en ejecución.
   - Usa herramientas como `mongoimport` o un script en Python para cargar los archivos `.json` que están en `Tablas/Tablas_e_insert_mongo/`.

2. **Crear las bases de datos en MySQL y Oracle:**
   - Ejecuta los scripts `Tablas_Mysql.sql` y `Tablas_oracle_vm.sql` para crear las estructuras necesarias en ambas bases de datos.
   - Luego, ejecuta los scripts en la carpeta `Inserts Oracle y mysql/` para insertar datos de prueba.

3. **Crear el Data Warehouse (DWH):**
   - Ejecuta `Tablas_DWH.sql` para generar las tablas del DWH en Oracle.

4. **Ejecutar los procesos ETL:**
   - Ejecuta los scripts Python desde la carpeta `ELTS y JOBs/`:
     - `ETLs_Mongo_a_Oracle.py` — Transfiere datos desde MongoDB hacia Oracle.
     - `Job_mongo.py` — Puede tener tareas adicionales o de agendamiento.
   - También puedes ejecutar el script `ETLs_y_JOBs_Mysql__Oracle.sql` para mover datos de MySQL a Oracle.

5. **Verifica los datos:**
   - Una vez finalizados los ETL, revisa las tablas del DWH para verificar que la información haya sido cargada correctamente.

---

## 👨‍💻 Autor

- **Jairo Raudales**

---

## 📄 Licencia

Este proyecto está disponible bajo la licencia MIT.
