# PROYECTO 2 / DAT0S 2021
## Objetivo 🤖🤖
Implementar estructuras de almacenamiento para aplicación de Cooperativa, para gestión de productos financieros.
Implementar lógica de procesamiento de los datos de lado de la base de datos.

## Aplicación 👩‍💻
Se le asigna elaborar las estructuras de datos de una aplicación para control de productos financieros de una Cooperativa. Los servicios que presta la aplicación son:
• Cuentas de ahorro (control de depósitos y retiros)
• Certificados de deposito a plazos (3, 6, 12, 24 meses)
• Prestamos (control de desembolso, y pagos)

## Modelo Entidad relación 🧠
Tomar este modelo de referencia, y agregar los nombres de campos que considere necesarios. Si considera agregar alguna entidad adicional, favor hacerlo y anotarlo en la documentación.

## Reglas del negocio: 👾👾
 El cliente, para obtener un préstamo, o crear un certificado de depósito, debe tener una cuenta de ahorros con la cooperativa.
• El monto máximo permitido para otorgar un préstamo es: 5 veces su saldo promedio de los últimos 6 meses.
• El total de los prestamos del banco se desembolsan de los CDP de sus clientes. El total de préstamos no debe superar el 50% de los CDP.
• El plazo mínimo para un préstamo es 3 meses
• El plazo máximo para un préstamo es de 36 meses
• Los certificados de depósito tienen plazo de 6,12,24 meses con tasas de 5%, 6% y
7% anual.
• Se debe llevar registro del balance diario de la cooperativa diariamente.

