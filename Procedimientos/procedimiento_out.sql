CREATE OR REPLACE PROCEDURE mostrar_balance_diario
IS
BEGIN
    dbms_output.put_line ('id_cooperativa | fecha | saldo_cdp | saldo_prestamo | saldo_cuenta');
    FOR balance_rec
        IN (SELECT * FROM cooperativa_balance)
    LOOP
        dbms_output.put_line (
            balance_rec.id_cooperativa || ' | ' ||
            balance_rec.fecha || ' | ' ||
            balance_rec.saldo_cdp || ' | ' ||
            balance_rec.saldo_prestamo || ' | ' ||
            balance_rec.saldo_cuenta || ' | ');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
END;

CREATE OR REPLACE PROCEDURE mostrar_cdp 
IS
BEGIN
    dbms_output.put_line ('id_cliente | fecha_creada | plazo | interes | monto | fecha_terminacion| interes_total| saldo_total | tipo_moneda');
    FOR rec
        IN (SELECT * FROM cdp)
    LOOP
        dbms_output.put_line (
            rec.id_cliente || ' | ' ||
            rec.fecha_creada || ' | ' ||
            rec.plazo || ' | ' ||
            rec.interes || ' | ' ||
            rec.monto || ' | ' ||
            rec.fecha_terminacion || ' | ' ||
            rec.interes_total || ' | ' ||
            rec.saldo_total || ' | ' ||
            rec.tipo_moneda || ' | ' );
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
END;


CREATE OR REPLACE PROCEDURE mostrar_cuenta
IS
BEGIN
    dbms_output.put_line ('id_cliente | fecha_creada | saldo_disponible |tipo_moneda');

    FOR rec
        IN (SELECT * FROM cuenta)
    LOOP
        dbms_output.put_line (
            rec.id_cliente || ' | ' ||
            rec.fecha_creada || ' | ' ||
            rec.saldo_disponible || ' | ' ||
            rec.tipo_moneda  || ' | ' );

    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
END;


CREATE OR REPLACE PROCEDURE mostrar_prestamos
IS
BEGIN
    dbms_output.put_line ('id_cliente | fecha_creada | plazo | fecha_terminacion | monto | interes| pago_interes| pago_total| tipo_moneda|saldo');
    FOR rec
        IN (SELECT * FROM prestamo)
    LOOP
        dbms_output.put_line (
            rec.id_cliente || ' | ' ||
            rec.fecha_creada || ' | ' ||
            rec.plazo || ' | ' ||
            rec.fecha_terminacion  || ' | ' ||
            rec.monto || ' | ' ||
            rec.interes || ' | ' ||
            rec.pago_interes || ' | ' ||
            rec.pago_total || ' | ' ||
            rec.tipo_moneda || ' | ' ||
            rec.saldo || ' | ' );
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
END;


CREATE OR REPLACE PROCEDURE mostrar_operaciones
IS
BEGIN
    dbms_output.put_line ('id_prestamo_detalle | id_cdp_detalle | id_cuenta |id_destino|trans_tipo|detalle|monto');

    FOR rec
        IN (SELECT * FROM operaciones)
    LOOP
        dbms_output.put_line (
            rec.id_prestamo_detalle || ' | ' ||
            rec.id_cdp_detalle || ' | ' ||
            rec.id_cuenta || ' | ' ||
            rec.id_destino  || ' | ' ||
            rec.trans_tipo || ' | ' ||
            rec.detalle || ' | ' ||
            rec.monto || ' | ');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( SQLERRM );
END;
























