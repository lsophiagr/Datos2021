CREATE OR REPLACE PROCEDURE crear_cliente(
    id_cooperativa NUMBER,
    primer_nombre VARCHAR2,
    segundo_nombrre VARCHAR2,
    primer_apellido VARCHAR2,
    segundo_apellido VARCHAR2,
    correo VARCHAR2,
    direccion VARCHAR2,
    numero_telofonico  VARCHAR2,
    nacionalidad  VARCHAR2,
    fecha DATE
)
IS
BEGIN
    INSERT INTO cliente (id_cooperativa, primer_nombre, segundo_nombrre, primer_apellido, segundo_apellido, correo, direccion, numero_telofonico, nacionalidad, fecha) VALUES (id_cooperativa, primer_nombre, segundo_nombrre, primer_apellido, segundo_apellido, correo, direccion, numero_telofonico, nacionalidad, fecha);
    commit;
    dbms_output.put_line('Cliente ' || primer_nombre || ' insertado correctamente');
end crear_cliente;

CREATE OR REPLACE PROCEDURE crear_balance_diario
IS
cuenta_total FLOAT;
prestamo_total FLOAT;
cdp_total FLOAT;
BEGIN
    SELECT sum(saldo_disponible) INTO cuenta_total from cuenta;
    SELECT sum(monto) INTO prestamo_total from prestamo;
    SELECT sum(monto) INTO cdp_total from cdp;
    INSERT INTO cooperativa_balance (id_cooperativa, fecha, saldo_cdp, saldo_prestamo, saldo_cuenta) VALUES (1, sysdate, cdp_total, prestamo_total, cuenta_total);
    commit;
end crear_balance_diario;

CREATE OR REPLACE PROCEDURE crear_historial(
    id_cooperativa NUMBER,
    fecha DATE,
    saldo_cdp FLOAT,
    saldo_prestamo FLOAT,
    saldo_cuenta FLOAT
)
IS
BEGIN
    INSERT INTO cooperativa_historial (id_cooperativa, fecha, saldo_cdp, saldo_prestamo, saldo_cuenta) VALUES (id_cooperativa, fecha, saldo_cdp, saldo_prestamo, saldo_cuenta);
    commit;
end crear_historial;

-- Cuando se crea una cuenta nueva o se deposita en efectivo a una cuenta el valor de id_cuenta es nulo lo que implica que se metio dinero en efectivo y no es una transaccion entre cuentas pero el id_destino es el id de la cuenta a la que se esta depositando o creando la cuenta. Esto implica que la unica manera de crear una cuenta es por medio de una transferencia en efectivo.
-- el campo id_cuenta es el atributo donde sale el dinero y el campo id_destino es a donde cae el dinero.
CREATE OR REPLACE PROCEDURE crear_operacion(
    id_prestamo_detalle NUMBER,
    id_cdp_detalle NUMBER,
    id_cuenta NUMBER,
    id_destino NUMBER,
    trans_tipo VARCHAR2,
    detalle VARCHAR2,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO operaciones (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto) VALUES (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto);
    commit;
    dbms_output.put_line('Operacion (transaccion) creada correctamente');
end crear_operacion;

CREATE OR REPLACE PROCEDURE crear_cuenta_detalle(
    id_cuenta NUMBER,
    trans_tipo VARCHAR2,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO cuenta_detalle (id_cuenta, trans_tipo, monto) VALUES (id_cuenta, trans_tipo, monto);
    commit;
    dbms_output.put_line('Detalle de cuenta agregado correctamente ' || id_cuenta);
end crear_cuenta_detalle;

-- Cuando creas una cuenta se tiene que generar un registro tambien en operacion (transacciones) porque esta metiendo dinero a la cuenta de igual manera se crea un registro en la tabla cuenta_detalle.
CREATE OR REPLACE PROCEDURE crear_cuenta(
    id_cliente NUMBER,
    fecha_creada DATE,
    saldo_disponible_p FLOAT,
    tipo_moneda VARCHAR2
)
IS
    id_cuenta_nuevo NUMBER;
    saldo_cdp_total NUMBER;
    saldo_prestamo_total NUMBER;
    saldo_cuenta_total NUMBER;
BEGIN
    SELECT (MAX(id_cuenta) + 1) INTO id_cuenta_nuevo FROM cuenta;
    
    SELECT SUM(monto) INTO saldo_cdp_total from cdp;
    SELECT SUM(monto) INTO saldo_prestamo_total from prestamo;
    SELECT (SUM(saldo_disponible) + saldo_disponible_p) INTO saldo_cuenta_total from cuenta;

    INSERT INTO cuenta (id_cliente, fecha_creada, saldo_disponible, tipo_moneda) VALUES (id_cliente, fecha_creada, saldo_disponible_p, tipo_moneda);
    commit;
    crear_cuenta_detalle(id_cuenta_nuevo, 'Deposito', saldo_disponible_p);
    crear_operacion('','','',id_cuenta_nuevo, 'Deposito', 'Efectivo', saldo_disponible_p);
    crear_historial(1, fecha_creada, saldo_cdp_total, saldo_prestamo_total, saldo_cuenta_total);
    dbms_output.put_line('Cuenta de ahorro creada correctamente para cliente ' || id_cliente);
end crear_cuenta;

CREATE OR REPLACE PROCEDURE crear_cdp_detalle(
    id_cdp NUMBER,
    fecha_pago DATE,
    interes FLOAT,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO cdp_detalle (id_cdp, fecha_pago, interes, monto, estado) VALUES (id_cdp, fecha_pago, interes, monto, 'False');
    commit;
end crear_cdp_detalle;

-- Preguntar porque esta redondeando los numeros cuando se hacen los calculos de operaciones.
CREATE OR REPLACE PROCEDURE crear_cdp(
    id_cliente NUMBER,
    fecha_creada DATE,
    plazo INTEGER,
    monto_p FLOAT,
    tipo_moneda VARCHAR2
)
IS
    n_cuenta NUMBER;
    interes_cdp INTEGER;
    id_cdp_nuevo NUMBER;
    interes_mensual NUMBER;
    monto_interes_mensual NUMBER;
    saldo_cdp_total NUMBER;
    saldo_prestamo_total NUMBER;
    saldo_cuenta_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO n_cuenta from cuenta WHERE id_cliente = id_cliente;
    SELECT (MAX(id_cdp) + 1) INTO id_cdp_nuevo FROM cdp;
    SELECT (SUM(monto) + monto_p) INTO saldo_cdp_total from cdp;
    SELECT SUM(monto) INTO saldo_prestamo_total from prestamo;
    SELECT SUM(saldo_disponible) INTO saldo_cuenta_total from cuenta;
    IF n_cuenta >= 1 THEN
        IF plazo = 6 THEN
            interes_cdp := 5;
        ELSIF plazo = 12 THEN
            interes_cdp := 6;
        ELSE
            interes_cdp := 7;
        END IF;
        INSERT INTO cdp (id_cliente, fecha_creada, plazo, interes, monto, tipo_moneda) VALUES (id_cliente, fecha_creada, plazo, interes_cdp, monto_p, tipo_moneda);
        commit;
        dbms_output.put_line('CDP creado correctamente para cliente ' || id_cliente);
        crear_historial(1, fecha_creada, saldo_cdp_total, saldo_prestamo_total, saldo_cuenta_total);

        -- calcular valores para nuevo registro de la tabla detalle
        interes_mensual := (interes_cdp/1200) * monto_p;
        monto_interes_mensual := ((monto_p/plazo) + interes_mensual);

        FOR l_counter IN 1..plazo
        LOOP
            crear_cdp_detalle(id_cdp_nuevo, ADD_MONTHS(fecha_creada, l_counter), interes_mensual, monto_interes_mensual);
        END LOOP;

    ELSE
        dbms_output.put_line('Error al crear CDP, no tiene una cuenta asociada el cliente' || id_cliente);
    END IF;
end crear_cdp;

CREATE OR REPLACE PROCEDURE crear_prestamo_detalle(
    id_prestamo NUMBER,
    fecha_pago DATE,
    interes_mensual FLOAT,
    saldo_pagar FLOAT
)
IS
BEGIN
    INSERT INTO prestamo_detalle (id_prestamo, fecha_pago, interes_mensual, saldo_pagar, estado) VALUES (id_prestamo, fecha_pago, interes_mensual, saldo_pagar, 'False');
    commit;
end crear_prestamo_detalle;

CREATE OR REPLACE PROCEDURE crear_prestamo(
    id_cliente NUMBER,
    fecha_creada DATE,
    plazo INTEGER,
    monto_p FLOAT,
    interes FLOAT,
    tipo_moneda VARCHAR2,
    saldo FLOAT
)
IS
    n_cuenta NUMBER;
    saldo_cdp_total_if NUMBER;
    saldo_prestamo_total_if NUMBER;
    saldo_cdp_total NUMBER;
    saldo_prestamo_total NUMBER;
    saldo_cuenta_total NUMBER;
    monto_maximo NUMBER;
    id_prestamo_nuevo NUMBER;
    interes_mensual NUMBER;
    monto_interes_mensual NUMBER;
BEGIN
    SELECT COUNT(*) INTO n_cuenta from cuenta WHERE id_cuenta = id_cliente;
    SELECT (SUM(saldo_disponible)/n_cuenta) INTO monto_maximo from cuenta WHERE id_cuenta = id_cliente;
    SELECT (saldo_cdp * 0.5) INTO saldo_cdp_total_if from cooperativa_historial;
    SELECT saldo_prestamo INTO saldo_prestamo_total_if from cooperativa_historial;
    SELECT SUM(monto) INTO saldo_cdp_total from cdp;
    SELECT (SUM(monto) + monto_p) INTO saldo_prestamo_total from prestamo;
    SELECT SUM(saldo_disponible) INTO saldo_cuenta_total from cuenta;
    SELECT (MAX(id_prestamo) + 1) INTO id_prestamo_nuevo FROM prestamo;
    IF n_cuenta >= 1 THEN
        IF ((saldo_prestamo_total_if + monto_p) <= saldo_cdp_total_if) THEN
            IF (monto_p <= monto_maximo) THEN
                INSERT INTO prestamo (id_cliente, fecha_creada, plazo, monto, interes, tipo_moneda, saldo) VALUES (id_cliente, fecha_creada, plazo, monto_p, interes, tipo_moneda, saldo);
                commit;
                crear_historial(1, fecha_creada, saldo_cdp_total, saldo_prestamo_total, saldo_cuenta_total);
                -- calcular valores para nuevo registro de la tabla detalle
                interes_mensual := (interes/1200) * monto_p;
                monto_interes_mensual := ((monto_p/plazo) + interes_mensual);

                FOR l_counter IN 1..plazo
                LOOP
                    crear_prestamo_detalle(id_prestamo_nuevo, ADD_MONTHS(fecha_creada, l_counter), interes_mensual, monto_interes_mensual);
                END LOOP;
            END IF;
        ELSE
            dbms_output.put_line('No se creo Prestamo creo para cliente ' || id_cliente);
        END IF;
    ELSE
            dbms_output.put_line('No se creo Prestamo creo para cliente ' || id_cliente);
    END IF;     
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
end crear_prestamo;

CREATE OR REPLACE PROCEDURE hacer_deposito_cuenta(
    id_destino NUMBER,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO operaciones (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto) VALUES ('', '', '', id_destino, 'Deposito', 'Efectivo', monto);
    commit;
    dbms_output.put_line('Operacion (transaccion) creada correctamente');
end hacer_deposito_cuenta;

CREATE OR REPLACE PROCEDURE hacer_retiro_cuenta(
    id_cuenta NUMBER,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO operaciones (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto) VALUES ('', '', id_cuenta, '', 'Retiro', 'Efectivo', monto);
    commit;
    dbms_output.put_line('Operacion (transaccion) creada correctamente');
end hacer_retiro_cuenta;

CREATE OR REPLACE PROCEDURE hacer_pago_prestamos(
    id_prestamo_detalle_p NUMBER
)
IS
BEGIN
    UPDATE prestamo_detalle SET estado = 'True' WHERE id_prestamo_detalle = id_prestamo_detalle_p;
    commit;
end hacer_pago_prestamos;

CREATE OR REPLACE PROCEDURE hacer_pago_cdp(
    id_cdp_detalle_p NUMBER
)
IS
BEGIN
    UPDATE cdp_detalle SET estado = 'True' WHERE id_cdp_detalle = id_cdp_detalle_p;
    commit;
end hacer_pago_cdp;


CREATE OR REPLACE PROCEDURE hacer_transferencia_entre_cuentas(
    id_cuenta NUMBER,
    id_destino NUMBER,
    monto FLOAT
)
IS
BEGIN
    INSERT INTO operaciones (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto) VALUES (id_prestamo_detalle, id_cdp_detalle, id_cuenta, id_destino, trans_tipo,detalle, monto);
    commit;
    dbms_output.put_line('Operacion (transaccion) creada correctamente');
end crear_operacion;
