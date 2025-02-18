/*
Un banco necesita gestionar créditos para la construcción de viviendas para lo cual requiere la implementación de una base de datos relacional. 
El proceso a modelar es el siguiente:
1) Una persona solicita un crédito para la construcción de una vivienda. Para ello debe presentar un proyecto de obra y un presupuesto.
2) El banco evalúa el proyecto y el presupuesto y decide si aprueba o rechaza el crédito.
3) Si el crédito es aprobado, el banco lo otorga en tramos de acuerdo a certificaciones de avance de obra. Cada certificación aprueba o no el avance requerido. Si se aprueba, entonces se libera el nuevo tramo del crédito, sino no.
4) El banco le crea una cuenta bancaria al cliente donde se le acreditará cada tramo del crédito y donde el banco hará los débitos correspondientes a las cuotas del crédito.
5) Apenas el crédito se aprueba y la cuenta es creada, el banco acredita el primer tramo del crédito en la cuenta del cliente.

Teniendo en cuenta el proceso descripto, se pide:
a) Registrar los siguientes datos de personas (Clientes ó garantes): 
-Identificador interno numérico autogenerado
-apellido
-nombre
-tipo de documento de identidad
-número de documento de identidad
-domicilio
-teléfonos
-Email.

b) Registrar la solicitud del crédito solicitado: 
-identificador interno numérico del crédito
-cliente que solicita
-monto solicitado
-fecha de solicitud
-garantes propuestos 
-proyecto de obra
-Estado (A: Aprobado, B: Rechazado)
-Fecha de resolución (de aprobación o rechazo) . 

c) En el caso de aprobación registrar un Crédito con los siguientes datos:
-Monto aprobado
-Gastos y comisiones (se necesita un detalle de cada gasto y comisión con el concepto y el importe correspondiente)
-Monto neto del crédito (corresponde al monto aprobado menos el total de gastos y comisiones)
-Lista de cuotas con su fecha de vencimiento, importe neto, intereses e importe total 
-Tramos del crédito (en cuantos tramos se entregará la suma aprobada neta) 

d) Para las certificaciones de avance de obra se debe registrar:
- Fecha y el resultado (avance aprobado o rechazado) y una observación.  

e) En la misma cuenta donde se acreditan los tramos del crédito se debitarán las cuotas correspondientes. Este débito se hará por el monto completo de la cuota. Es decir, no hay pagos parciales de cuotas. Se debe informar el tipo de movimiento, la fecha y el importe. 

Se solicita implementar la base de datos con todas las reglas de integridad declarativas en SQL Server
*/


/*
    Programar los triggers necesarios para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
    ACLARACIÓN: Recordar que por cada acreditación de tramo se debe generar un movimiento en la cuenta del cliente con el tipo “Acreditación de tramo”.
*/


/*
    Programar un SELECT que muestre las cuotas impagas de cada crédito aprobado. 
*/



/*
    Programar un procedimiento almacenado que reciba el número de crédito como argumento y devuelva como resultado los siguientes datos del mismo: 
    a. Nro. de crédito 
    b. Fecha de solicitud 
    c. Estado (pendiente de aprobación, aprobado o rechazado) 
    d. Fecha de resolución (aprobación o rechazo) 
    e. Si el crédito está aprobado: 
        i. Monto aprobado 
        ii. Monto neto a acreditar 
        iii. Total acreditado hasta el momento 
        iv. Cantidad de tramos acreditados 
        v. Total de cuotas 
        vi. Total de cuotas pagadas 
        vii. Importe total de cuotas pagadas 
        viii. Total de cuotas pendientes 
        ix. Importe total de cuotas pendientes
*/