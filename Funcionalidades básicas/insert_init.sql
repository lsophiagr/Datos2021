
INSERT INTO cooperativa (nombre, dirreccion) VALUES ('Cooperativa Sophia', 'Guatemala');

INSERT INTO cliente (id_cooperativa, primer_nombre, segundo_nombrre, primer_apellido, segundo_apellido, correo, direccion, numero_telofonico, nacionalidad, fecha) VALUES (1, 'Sophia', 'Leslie', 'Gamarro', 'Rod', 'sof@ufm.edu', 'Guatemala', '+50289651648', 'Guatemalteca', sysdate);

INSERT INTO cuenta (id_cliente, fecha_creada, saldo_disponible, tipo_moneda) VALUES (1, sysdate, 1000, 'GTQ');

INSERT INTO prestamo (id_cliente, fecha_creada, plazo, monto, interes, tipo_moneda, saldo) VALUES (1, sysdate, 3, 0, 0, 'GTQ', 0);

INSERT INTO cdp (id_cliente, fecha_creada, plazo, interes, monto, tipo_moneda) VALUES (1, sysdate, 6, 5, 0, 'GTQ');



-- Inserts
INSERT INTO cooperativa (nombre, dirreccion) VALUES ('Cooperativa Sophia', 'Guatemala');

INSERT INTO cooperativa_balance (id_cooperativa, fecha, saldo_cdp, saldo_prestamo, saldo_cuenta) VALUES (, , , , );

INSERT INTO cliente (id_cooperativa, primer_nombre, segundo_nombrre, primer_apellido, segundo_apellido, correo, direccion, numero_telofonico, nacionalidad, fecha) VALUES (1, , , , , , , ,);

INSERT INTO cuenta (id_cliente, fecha_creada, saldo_disponible, tipo_moneda) VALUES (, , , );

INSERT INTO cdp (id_cliente, fecha_creada, plazo, interes, monto, fecha_terminacion, interes_total, saldo_total, tipo_moneda) VALUES (, , , , , , , , );

INSERT INTO prestamo (id_cliente, fecha_creada, plazo, fecha_terminacion, monto, interes, pago_interes, pago_total, tipo_moneda, saldo) VALUES (, , , , , , , , , );


