/* ¿Cuántos outliers existen en la variable monto de la venta (Cantidad * Precio) de la tabla venta? 
Utilizando el método Tres Sigmas aplicado por Producto.
columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad */
use henry_checkpoint_m3 ;

SELECT v.IdProducto, 
       COUNT(*) AS Outliers
FROM venta AS v
JOIN (
  SELECT IdProducto,
         AVG(Cantidad * Precio) AS Media,
         STDDEV(Cantidad * Precio) AS DesviacionEstandar
  FROM venta
  GROUP BY IdProducto
) AS subquery
ON v.IdProducto = subquery.IdProducto
WHERE (v.Cantidad * v.Precio) < (subquery.Media - 3 * subquery.DesviacionEstandar)
   OR (v.Cantidad * v.Precio) > (subquery.Media + 3 * subquery.DesviacionEstandar)
GROUP BY v.IdProducto;

SELECT SUM(Outliers) AS SumaOutliers
FROM (
  SELECT v.IdProducto, 
         COUNT(*) AS Outliers
  FROM venta AS v
  JOIN (
    SELECT IdProducto,
           AVG(Cantidad * Precio) AS Media,
           STDDEV(Cantidad * Precio) AS DesviacionEstandar
    FROM venta
    GROUP BY IdProducto
  ) AS subquery
  ON v.IdProducto = subquery.IdProducto
  WHERE (v.Cantidad * v.Precio) < (subquery.Media - 3 * subquery.DesviacionEstandar)
     OR (v.Cantidad * v.Precio) > (subquery.Media + 3 * subquery.DesviacionEstandar)
  GROUP BY v.IdProducto
) AS SubqueryOutliers;
 /* Del total de clientes que realizaron compras en 2019 ¿Qué porcentaje lo hizo sólo en una única sucursal? 
( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) 
columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad
columnas en la tabla clientes: IdCliente - Nombre_y_Apellido - Domicilio - Telefono - Edad - Rango_Etario - IdLocalidad - Latitud - Longitud
recuerda que estoy trabajando en MySQL Workbench */ 

SELECT 
    (COUNT(DISTINCT v.IdCliente) - COUNT(DISTINCT CASE WHEN s.NumSucursales = 1 THEN v.IdCliente END)) 
    / COUNT(DISTINCT v.IdCliente) AS PorcentajeClientes
FROM venta v
JOIN (
    SELECT IdCliente, COUNT(DISTINCT IdSucursal) AS NumSucursales
    FROM venta
    WHERE YEAR(Fecha) = 2019
    GROUP BY IdCliente
) AS s
ON v.IdCliente = s.IdCliente;

/* Del total de clientes que realizaron compras en 2020 ¿Qué porcentaje no había realizado compras en 2019? 
 ( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) 
 columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad
columnas en la tabla clientes: IdCliente - Nombre_y_Apellido - Domicilio - Telefono - Edad - Rango_Etario - IdLocalidad - Latitud - Longitud
recuerda que estoy trabajando en MySQL Workbench */ 

SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN compras_2019 = 0 THEN v.IdCliente END) 
        / COUNT(DISTINCT v.IdCliente), 2
    ) AS PorcentajeClientes
FROM venta v
LEFT JOIN (
    SELECT IdCliente, COUNT(*) AS compras_2019
    FROM venta
    WHERE YEAR(Fecha) = 2019
    GROUP BY IdCliente
) AS c2019
ON v.IdCliente = c2019.IdCliente
WHERE YEAR(v.Fecha) = 2020;
/* La ganancia neta por tipo de producto es las ventas menos las compras, 
se desea saber cuál tipo de producto tiene la mayor ganancia neta en el 2020 (Ganancia = Venta - Compra) 
 columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad
 columnas en la tabla producto : IdProducto - Producto - Precio - IdTipoProducto 
 columnas en la tabla tipo_producto : IdTipoProducto - TipoProducto 
 recuerda que estoy trabajando en MySQL Workbench
*/ 
SELECT tp.TipoProducto, 
       SUM(v.Precio * v.Cantidad - p.Precio * v.Cantidad) AS GananciaNeta
FROM venta v
JOIN producto p ON v.IdProducto = p.IdProducto
JOIN tipo_producto tp ON p.IdTipoProducto = tp.IdTipoProducto
WHERE YEAR(v.Fecha) = 2020
GROUP BY tp.TipoProducto
ORDER BY GananciaNeta DESC
LIMIT 1;
SELECT tp.TipoProducto, 
       SUM(v.Precio * v.Cantidad - p.Precio * v.Cantidad) AS GananciaNeta
FROM venta v
JOIN producto p ON v.IdProducto = p.IdProducto
JOIN tipo_producto tp ON p.IdTipoProducto = tp.IdTipoProducto
WHERE YEAR(v.Fecha) = 2020
GROUP BY tp.TipoProducto
ORDER BY GananciaNeta DESC;



/* muestrame de todos los clientes que realizaron compras en 2020 ¿cuantos lo hicieron en una unica sucursal? estos son los datos que te puedo proporcionar :
 columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad
columnas en la tabla clientes: IdCliente - Nombre_y_Apellido - Domicilio - Telefono - Edad - Rango_Etario - IdLocalidad - Latitud - Longitud
columnas en la tabla sucursal : IdSucursal - Sucursal - Domicilio - IdLocalidad - Latitud - Longitud 
recuerda que estoy trabajando en MySQL Workbench */

# rta 0.34
 
SELECT COUNT(DISTINCT v.IdCliente) AS ClientesUnicaSucursal
FROM venta v
WHERE YEAR(v.Fecha) = 2020
GROUP BY v.IdCliente
HAVING COUNT(DISTINCT v.IdSucursal) = 1;
SELECT COUNT(*) AS ClientesUnicaSucursal
FROM (
    SELECT v.IdCliente, COUNT(DISTINCT v.IdSucursal) AS CantSucursales
    FROM venta v
    WHERE YEAR(v.Fecha) = 2020
    GROUP BY v.IdCliente
    HAVING CantSucursales = 1
) AS ClientesUnicaSucursal2020;
SELECT COUNT(DISTINCT IdCliente) AS Clientes2020
FROM venta
WHERE YEAR(Fecha) = 2020;

/* Del total de clientes ¿Qué porcentaje realizó compras sólo por el canal online entre 2019 y 2020?  
( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) */ 

/* Del total de clientes que realizaron compras en 2019 
¿Qué porcentaje lo hizo sólo en una única sucursal? ( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) */ 

#rt: 0.64
SELECT COUNT(DISTINCT IdCliente) AS Clientes2019
FROM venta
WHERE YEAR(Fecha) = 2019;
SELECT COUNT(*) AS ClientesUnicaSucursal
FROM (
    SELECT v.IdCliente, COUNT(DISTINCT v.IdSucursal) AS CantSucursales
    FROM venta v
    WHERE YEAR(v.Fecha) = 2019
    GROUP BY v.IdCliente
    HAVING CantSucursales = 1
) AS ClientesUnicaSucursal2019;

 /* Del total de clientes que realizaron compras en 2020 ¿Qué porcentaje no había realizado compras en 2019?  
( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) 
 columnas en la tabla venta : IdVebta - Fecha - Fecha_Entrega - IdCanal - IdCliente - IdSucursal - IdEmpleado - IdProducto - Precio - Cantidad
columnas en la tabla clientes: IdCliente - Nombre_y_Apellido - Domicilio - Telefono - Edad - Rango_Etario - IdLocalidad - Latitud - Longitud
recuerda que estoy trabajando en MySQL Workbench
*/ 
# rta: 41
#cantidad de clientes que compraron 2020 y no en 2019 

SELECT COUNT(DISTINCT v2020.IdCliente) AS ClientesEn2020SinComprasEn2019
FROM venta v2020
LEFT JOIN (
    SELECT DISTINCT IdCliente
    FROM venta
    WHERE YEAR(Fecha) = 2019
) v2019
ON v2020.IdCliente = v2019.IdCliente
WHERE YEAR(v2020.Fecha) = 2020 AND v2019.IdCliente IS NULL;
#cantidad de ventas en 2020
SELECT COUNT(DISTINCT IdCliente) AS Clientes2020
FROM venta
WHERE YEAR(Fecha) = 2020;
/* Del total de clientes que realizaron compras en 2019 ¿Qué porcentaje lo hizo también en 2020? 
 ( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) */
 
 SELECT COUNT(DISTINCT v2020.IdCliente) AS ClientesEnAmbosAños
FROM (
    SELECT DISTINCT IdCliente
    FROM venta
    WHERE YEAR(Fecha) = 2019
) v2019
JOIN (
    SELECT DISTINCT IdCliente
    FROM venta
    WHERE YEAR(Fecha) = 2020
) v2020
ON v2019.IdCliente = v2020.IdCliente;
SELECT COUNT(DISTINCT IdCliente) AS Clientes2020
FROM venta
WHERE YEAR(Fecha) = 2019;


/* Del total de clientes ¿Qué porcentaje realizó compras sólo por el canal online entre 2019 y 2020?  
( Responder con valores entre 0 y 1, redondeado a 2 decimales, siendo 1 = 100%. Ej: 0.398 ->  0.4  ->  40% ) */
#cantidad de clientes

# rta  0.17


SELECT COUNT(DISTINCT IdCliente) AS Clientes
 FROM cliente;
#cantidad de compras por id canal = 2 
SELECT SUM(ClientesSoloCanal2) AS SumaClientesSoloCanal2
FROM (
    SELECT COUNT(DISTINCT IdCliente) AS ClientesSoloCanal2
    FROM venta
    WHERE YEAR(Fecha) BETWEEN 2019 AND 2020
    GROUP BY IdCliente
    HAVING COUNT(DISTINCT IdCanal) = 1 AND MAX(IdCanal) = 2
) AS ClientesSoloCanal2Result;

/* Cada una de las sucursales de la provincia de Córdoba, disponibilizaron un excel donde registraron el porcentaje de comisión que se 
le otorgó a cada uno de los empleados sobre la venta que realizaron. Es necesario incluir esas tablas (Comisiones Córdoba Centro.xlsx,
 Comisiones Córdoba Quiróz.xlsx y Comisiones Córdoba Cerro de las Rosas.xlsx) en el modelo y contestar las siguientes preguntas: */
CREATE TABLE comisiones (
    CodigoEmpleado int,
    IdSucursal int , 
    Apellido_y_Nombre VARCHAR (80),
    Sucursal VARCHAR (80) , 
    Anio INT ,
    Mes INT ,
    Porcentaje DECIMAL (12 , 4)
    
);
LOAD DATA LOCAL INFILE 'C:\Users\vikto\Desktop\alejo\HC 2\tablas cvs' 
INTO TABLE comisiones
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';
SET GLOBAL local_infile = 1;
GRANT FILE ON *.* TO 'root1234'@'localhost';
select Nombre_y_Apellido from cliente
