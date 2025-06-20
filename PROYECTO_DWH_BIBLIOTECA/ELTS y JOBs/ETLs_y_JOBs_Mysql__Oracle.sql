

▒█▀▄▀█ ▒█░░▒█ ▒█▀▀▀█ ▒█▀▀█ ▒█░░░ 
▒█▒█▒█ ▒█▄▄▄█ ░▀▀▀▄▄ ▒█░▒█ ▒█░░░ 
▒█░░▒█ ░░▒█░░ ▒█▄▄▄█ ░▀▀█▄ ▒█▄▄█
----------------------------------------------------------
---------------------------------------------
CREATE OR REPLACE
PROCEDURE Autor_etl IS
BEGIN
    MERGE INTO Autor tgt
    USING (
        SELECT 
            a."id_autor",
            a."nombre",
            a."nacionalidad",
            a."fecha_nacimiento"
        FROM autormysql_view a  
    ) src
    ON (tgt.id_autor = src."id_autor")
    WHEN MATCHED THEN
        UPDATE SET 
            tgt.id_editorial = 1,
            tgt.nombre = src."nombre",
            tgt.nacionalidad = src."nacionalidad",
            tgt.fecha_nacimiento = src."fecha_nacimiento"
    WHEN NOT MATCHED THEN
        INSERT (
            id_autor, id_editorial, nombre, nacionalidad, fecha_nacimiento
        ) VALUES (
            src."id_autor", 1, src."nombre", src."nacionalidad", src."fecha_nacimiento"
        );

    COMMIT;
END;
----------------------------------------------------------
-------------------------------------------------------------------------------------------------------
---------------------------------------------
CREATE OR REPLACE
PROCEDURE Devoluciones_etl IS
BEGIN
    MERGE INTO Devoluciones tgt
    USING (
        SELECT *
        FROM (
            SELECT 
                d."id_devolucion", 
                f."id_factura", 
                d."motivo", 
                d."estado",
                ROW_NUMBER() OVER (PARTITION BY d."id_devolucion" ORDER BY f."id_factura") AS rn
            FROM Devolucionmysql_view d
            JOIN Facturamysql_view f ON d."id_venta" = f."id_venta"
        )
        WHERE rn = 1
    ) src
    ON (tgt.id_devolucion = src."id_devolucion")
    WHEN MATCHED THEN
        UPDATE SET
            tgt.id_factura = src."id_factura",
            tgt.motivo = src."motivo",
            tgt.estado = src."estado"
    WHEN NOT MATCHED THEN
        INSERT (
            id_devolucion, id_factura, motivo, estado
        ) VALUES (
            src."id_devolucion", src."id_factura", src."motivo", src."estado"
        );

    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE Facturas_etl IS
BEGIN
    MERGE INTO Facturas d
    USING (
        SELECT 
            f."id_factura",
            e."id_empleado",
            l."id_editorial",
            l."id_libro",
            mp."nombre",
            dpe."cantidad",
            f."total"
        FROM facturamysql_view f
        JOIN empleadomysql_view e ON f."id_venta" = e."id_empleado"
        JOIN Detalle_Pedidomysql_view dpe ON f."id_venta" = dpe."id_pedido"
        JOIN Libromysql_view l ON dpe."id_libro" = l."id_libro"
        JOIN Metodo_Pagomysql_view mp ON mp."id_metodo" = f."id_venta"
    ) me
    ON (d.id_factura = me."id_factura")
    

    
    WHEN MATCHED THEN
        UPDATE SET 
            d.id_persona = me."id_empleado",
            d.id_editorial = me."id_editorial",
            d.id_libro = me."id_libro",
            d.metodo_pago = me."nombre",
            d.cantidad = me."cantidad",
            d.fecha = SYSDATE,
            d.total = me."total"

    WHEN NOT MATCHED THEN
        INSERT (
            id_factura, id_persona, id_editorial, id_libro, 
            metodo_pago, cantidad, fecha, total
        )
        VALUES (
            me."id_factura", me."id_empleado", me."id_editorial", me."id_libro",
            me."nombre", me."cantidad", SYSDATE, me."total"
        );
    
    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE Editorial_etl IS
BEGIN

    DELETE FROM Editorial;


    INSERT INTO Editorial (
        id_editorial, nombre, pais, telefono
    )
    SELECT 
        e."id_editorial",
        e."nombre",
        e."pais",
        e."telefono"
    FROM editorialmysql_view e;

    COMMIT;
END;
----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------
CREATE OR REPLACE
PROCEDURE Facturas_etl IS
BEGIN
    MERGE INTO Facturas d
    USING (
        SELECT 
            f."id_factura",
            e."id_empleado",
            l."id_editorial",
            l."id_libro",
            mp."nombre",
            dpe."cantidad",
            f."total"
        FROM facturamysql_view f
        JOIN empleadomysql_view e ON f."id_venta" = e."id_empleado"
        JOIN Detalle_Pedidomysql_view dpe ON f."id_venta" = dpe."id_pedido"
        JOIN Libromysql_view l ON dpe."id_libro" = l."id_libro"
        JOIN Metodo_Pagomysql_view mp ON mp."id_metodo" = f."id_venta"
    ) me
    ON (d.id_factura = me."id_factura")
    

    
    WHEN MATCHED THEN
        UPDATE SET 
            d.id_persona = me."id_empleado",
            d.id_editorial = me."id_editorial",
            d.id_libro = me."id_libro",
            d.metodo_pago = me."nombre",
            d.cantidad = me."cantidad",
            d.fecha = SYSDATE,
            d.total = me."total"

    WHEN NOT MATCHED THEN
        INSERT (
            id_factura, id_persona, id_editorial, id_libro, 
            metodo_pago, cantidad, fecha, total
        )
        VALUES (
            me."id_factura", me."id_empleado", me."id_editorial", me."id_libro",
            me."nombre", me."cantidad", SYSDATE, me."total"
        );
    
    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------

▒█▀▀▀█ ▒█▀▀█ ░█▀▀█ ▒█▀▀█ ▒█░░░ ▒█▀▀▀ 
▒█░░▒█ ▒█▄▄▀ ▒█▄▄█ ▒█░░░ ▒█░░░ ▒█▀▀▀ 
▒█▄▄▄█ ▒█░▒█ ▒█░▒█ ▒█▄▄█ ▒█▄▄█ ▒█▄▄▄

----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE etl_cargar_dwh_historial_prestamos IS

    v_error_msg VARCHAR2(4000);
    v_estado    VARCHAR2(20);

BEGIN
    BEGIN

        INSERT INTO Historial_Prestamos (
            id_HistorialPres,
            fecha_prestamo,
            fecha_devolucion,
            estado_prestamo,
            id_persona,
            id_libro
        )
        SELECT
            dwh_historial_pres_seq.NEXTVAL,
            p.fecha_prestamo,
            p.fecha_devolucion,
            e.estado,
            p.id_usuario,
            e.id_libro
        FROM Prestamos@link_proyecto_bases p
        JOIN Ejemplares@link_proyecto_bases e ON p.id_ejemplar = e.id
        WHERE NOT EXISTS (
            SELECT 1
            FROM Historial_Prestamos d
            WHERE d.fecha_prestamo = p.fecha_prestamo
              AND d.fecha_devolucion = p.fecha_devolucion
              AND d.id_persona = p.id_usuario
              AND d.id_libro = e.id_libro
        );

        COMMIT;
        v_estado := 'ÉXITO';
        v_error_msg := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            v_estado := 'ERROR';
            v_error_msg := SQLERRM;
            ROLLBACK;
    END;


    INSERT INTO log_etl (
        id_log_etl,
        nombre_procedimiento,
        tipo_carga,
        fecha_ejecucion,
        estado,
        mensaje_error
    ) VALUES (
        log_etl_seq.NEXTVAL,
        'etl_cargar_dwh_historial_prestamos',
        'INCREMENTAL',
        SYSTIMESTAMP,
        v_estado,
        v_error_msg
    );

    COMMIT;

END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------
CREATE OR REPLACE
PROCEDURE etl_cargar_dwh_historial_usuarios IS
    v_estado     VARCHAR2(20);
    v_error_msg  VARCHAR2(4000);
BEGIN
    BEGIN

        DELETE FROM Historial_Usuarios;


        INSERT INTO Historial_Usuarios (
            id_historialU,
            tipo_accion,
            fecha,
            descripcion,
            id_persona,
            id_libro
        )
        SELECT
            dwh_historial_usuarios_seq.NEXTVAL,
            'Préstamo',
            p.fecha_prestamo,
            'El usuario solicitó un préstamo',
            p.id_usuario,
            e.id_libro
        FROM Prestamos@link_proyecto_bases p
        JOIN Ejemplares@link_proyecto_bases e ON p.id_ejemplar = e.id;


        INSERT INTO Historial_Usuarios (
            id_historialU,
            tipo_accion,
            fecha,
            descripcion,
            id_persona,
            id_libro
        )
        SELECT
            dwh_historial_usuarios_seq.NEXTVAL,
            'Devolución',
            p.fecha_devolucion,
            'El usuario devolvió el libro',
            p.id_usuario,
            e.id_libro
        FROM Prestamos@link_proyecto_bases p
        JOIN Ejemplares@link_proyecto_bases e ON p.id_ejemplar = e.id
        WHERE p.fecha_devolucion IS NOT NULL;


        INSERT INTO Historial_Usuarios (
            id_historialU,
            tipo_accion,
            fecha,
            descripcion,
            id_persona,
            id_libro
        )
        SELECT
            dwh_historial_usuarios_seq.NEXTVAL,
            'Calificación',
            SYSDATE, 
            comentario,
            id_usuario,
            id_libro
        FROM Calificaciones@link_proyecto_bases;

        COMMIT;
        v_estado := 'ÉXITO';
        v_error_msg := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            v_estado := 'ERROR';
            v_error_msg := SQLERRM;
            ROLLBACK;
    END;


    INSERT INTO log_etl (
        id_log_etl,
        nombre_procedimiento,
        tipo_carga,
        fecha_ejecucion,
        estado,
        mensaje_error
    ) VALUES (
        log_etl_seq.NEXTVAL,
        'etl_cargar_dwh_historial_usuarios',
        'VOLÁTIL',
        SYSTIMESTAMP,
        v_estado,
        v_error_msg
    );

    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE etl_cargar_dwh_usuarios_detalle IS
    v_estado     VARCHAR2(20);
    v_error_msg  VARCHAR2(4000);
BEGIN
    BEGIN

        INSERT INTO Usuarios_Detalle (
            id_usuarioDet,
            nombre,
            escuela_nombre
        )
        SELECT
            dwh_usuarios_detalle_seq.NEXTVAL,
            u.nombre,
            e.nombre
        FROM Usuarios@link_proyecto_bases u
        JOIN Escuelas@link_proyecto_bases e ON u.id_escuela = e.id
        WHERE NOT EXISTS (
            SELECT 1
            FROM Usuarios_Detalle d
            WHERE d.nombre = u.nombre
              AND d.escuela_nombre = e.nombre
        );

        COMMIT;
        v_estado := 'ÉXITO';
        v_error_msg := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            v_estado := 'ERROR';
            v_error_msg := SQLERRM;
            ROLLBACK;
    END;

    INSERT INTO log_etl (
        id_log_etl,
        nombre_procedimiento,
        tipo_carga,
        fecha_ejecucion,
        estado,
        mensaje_error
    ) VALUES (
        log_etl_seq.NEXTVAL,
        'etl_cargar_dwh_usuarios_detalle',
        'INCREMENTAL',
        SYSTIMESTAMP,
        v_estado,
        v_error_msg
    );

    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE etl_cargar_dwh_usuarios_sanciones IS
    v_estado     VARCHAR2(20);
    v_error_msg  VARCHAR2(4000);
BEGIN
    BEGIN
       
        DELETE FROM Usuarios_Sanciones;

        INSERT INTO Usuarios_Sanciones (
            id_UsuariosSan,
            monto,
            pagada,
            descripcion,
            id_persona
        )
        SELECT
            dwh_usuarios_sanciones_seq.NEXTVAL,
            NVL(m.monto, 0),
            NVL(m.pagada, 'N'),
            s.descripcion,
            s.id_usuario
        FROM Sanciones@link_proyecto_bases s
        LEFT JOIN Multas@link_proyecto_bases m ON s.id_usuario = m.id_usuario;

        COMMIT;
        v_estado := 'ÉXITO';
        v_error_msg := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            v_estado := 'ERROR';
            v_error_msg := SQLERRM;
            ROLLBACK;
    END;

    INSERT INTO log_etl (
        id_log_etl,
        nombre_procedimiento,
        tipo_carga,
        fecha_ejecucion,
        estado,
        mensaje_error
    ) VALUES (
        log_etl_seq.NEXTVAL,
        'etl_cargar_dwh_usuarios_sanciones',
        'VOLÁTIL',
        SYSTIMESTAMP,
        v_estado,
        v_error_msg
    );

    COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------

CREATE OR REPLACE
PROCEDURE etl_cargar_libros_detalle IS
    v_error_msg VARCHAR2(4000);
BEGIN
    DELETE FROM Libros_Detalle;
    COMMIT;

    INSERT INTO Libros_Detalle (
        id_libroDet,
        titulo,
        categoria_nombre,
        subcategoria_nombre,
        version,
        proveedor_nombre,
        autores,
        codigo,
        estado,
        id_editorial
    )
    SELECT 
        libros_detalle_seq.NEXTVAL AS id_libroDet,
        l.titulo,
        c.nombre AS categoria_nombre,
        sc.nombre AS subcategoria_nombre,
        v.version,
        p.nombre AS proveedor_nombre,
        (
            SELECT LISTAGG(a.nombre, ', ') WITHIN GROUP (ORDER BY a.nombre)
            FROM Libro_Autor@link_proyecto_bases la
            JOIN Autores@link_proyecto_bases a ON la.id_autor = a.id
            WHERE la.id_libro = l.id
        ) AS autores,
        e.codigo,
        e.estado,
        l.id_editorial
    FROM Libros@link_proyecto_bases l
    LEFT JOIN Categorias@link_proyecto_bases c ON l.id_categoria = c.id
    LEFT JOIN Subcategorias@link_proyecto_bases sc ON l.id_sub_categoria = sc.id
    LEFT JOIN Versiones@link_proyecto_bases v ON l.id_version = v.id
    LEFT JOIN Proveedores@link_proyecto_bases p ON l.id_proveedor = p.id
    LEFT JOIN Ejemplares@link_proyecto_bases e ON e.id_libro = l.id;

    COMMIT;

    INSERT INTO log_etl (
        id_log_etl,
        nombre_procedimiento,
        tipo_carga,
        estado,
        mensaje_error
    )
    VALUES (
        log_etl_seq.NEXTVAL,
        'etl_cargar_libros_detalle',
        'VOLATIL',
        'ÉXITO',
        ''
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        v_error_msg := SQLERRM;
        ROLLBACK;
        INSERT INTO log_etl (
            id_log_etl,
            nombre_procedimiento,
            tipo_carga,
            estado,
            mensaje_error
        )
        VALUES (
            log_etl_seq.NEXTVAL,
            'etl_cargar_libros_detalle',
            'VOLATIL',
            'ERROR',
            v_error_msg
        );
        COMMIT;
END;

----------------------------------------------------------
---------------------------------------------
----------------------------------------------------------
---------------------------------------------


███████████████████████████████████████████████████████████████
█████████░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░███░░░░░░░░░░░░░░█
█████████░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░███░░▄▀▄▀▄▀▄▀▄▀░░█
█████████░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░▄▀░░███░░▄▀░░░░░░░░░░█
█████████░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░███░░▄▀░░█████████
█████████░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░░░█░░▄▀░░░░░░░░░░█
█████████░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█
█░░░░░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░▄▀░░█░░░░░░░░░░▄▀░░█
█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░████░░▄▀░░█████████░░▄▀░░█
█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░░░░░░░▄▀░░█░░░░░░░░░░▄▀░░█
█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█
█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█
███████████████████████████████████████████████████████████████

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_autor_etl',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'autor_etl',
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_devoluciones_etl',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'devoluciones_etl', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_editorial_etl',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'editorial_etl',
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_facturas_etl',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'facturas_etl', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_dwh_historial_prestamos',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_dwh_historial_prestamos', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_dwh_historial_usuarios',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_dwh_historial_usuarios',
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_dwh_usuarios_detalle',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_dwh_usuarios_detalle', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_dwh_usuarios_sanciones',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_dwh_usuarios_sanciones', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_libros_detalle',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_libros_detalle', 
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'job_etl_cargar_libros_detalle',
      job_type        => 'STORED_PROCEDURE',
      job_action      => 'etl_cargar_libros_detalle', -- cambia esto si tu procedimiento se llama distinto
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE,
      comments        => 'Job diario que ejecuta el ETL a las 8:00 PM'
   );
END;
/




