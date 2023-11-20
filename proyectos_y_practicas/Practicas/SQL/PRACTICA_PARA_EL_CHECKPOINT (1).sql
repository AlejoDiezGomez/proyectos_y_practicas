/* 9) La ganancia neta por producto es las ventas menos las compras (Ganancia = Venta - Compra) ¿Cuál es el tipo de producto con mayor ganancia
neta en 2020?
Opciones:

1- Informática (X)

2- Impresión

3- Grabacion */

SELECT tp.tipoproducto, sum(v.venta - c.compra) as Ganancia
FROM (SELECT idproducto, (sum(precio) *sum(cantidad)) as venta FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY idproducto) v
JOIN (SELECT idproducto, (sum(precio) *sum(cantidad)) as compra FROM compra
WHERE YEAR(Fecha) = 2020
GROUP BY IdProducto) c
ON (v.idproducto = c.idproducto)
JOIN producto p ON (p.idproducto = v.idproducto)
JOIN tipo_producto tp ON (tp.idtipoproducto = p.idtipoproducto)
GROUP BY tp.TipoProducto
ORDER BY 2 DESC;

/* 10) A partir de los datos de las Ventas, Compras y Gastos de los años 2020 y 2019, 
si comparamos mes a mes (ejemplo: junio 2020-junio 2019),
¿Cuál fue el mes cuya diferencia entre ingresos y egresos es mayor? [Ventas (Precio * Cantidad) - Compras (Precio * Cantidad) – Gastos].
Respuesta_Ejemplo: 2 (Refiriendose al segundo mes del año, Febrero. OJO, sólo coloca el número de mes, no el nombre del mes)
*/

SELECT v.Fecha, COALESCE(sum(v.venta), 0) - COALESCE(sum(c.compra), 0) - COALESCE(sum(g.gastos), 0) as Ganancia
FROM (SELECT fecha, sum(precio * cantidad) as venta FROM venta
      WHERE YEAR(fecha) IN (2020, 2019)
      GROUP BY fecha) v
LEFT JOIN (SELECT fecha, sum(precio * cantidad) as compra FROM compra
           WHERE YEAR(fecha) IN (2020, 2019)
           GROUP BY fecha) c 
    ON (v.fecha = c.fecha)
LEFT JOIN (SELECT fecha, sum(monto) as gastos FROM gasto
           WHERE YEAR(fecha) IN (2020, 2019)
           GROUP BY fecha) g
    ON (v.fecha = g.fecha)
GROUP BY v.fecha
ORDER BY ganancia
LIMIT 1;

-- rta: 4

/* 11) Del total de clientes que realizaron compras en 2020, ¿Qué porcentaje no había realizado compras en 2019?
Opciones:

1-0.45

2-0.38

3-0.41 (X)

4-0.51
*/

SELECT COUNT(DISTINCT IdCliente) AS TotalClientes
FROM venta
WHERE YEAR(Fecha) IN (2019);
-- TOTAL EN 2019: 1674

SELECT COUNT(DISTINCT IdCliente) AS TotalClientes
FROM venta
WHERE YEAR(Fecha) IN (2020);
-- TOTAL EN 2020: 2415

SELECT COUNT(DISTINCT IdCliente) AS TotalClientes
FROM venta
WHERE YEAR(Fecha) IN (2019, 2020);
-- EN AMBOS AÑOS: 2659

SELECT COUNT(DISTINCT IdCliente)
FROM venta
WHERE YEAR(Fecha) = 2020
AND IdCliente NOT IN (
    SELECT DISTINCT IdCliente
    FROM venta
    WHERE YEAR(Fecha) = 2019
);
-- en 2020 si pero en 2019 no: 985

-- 985 / 2415 = 0,4078 = 0,41

/*n 12) Del total de clientes que realizaron compras en 2019, ¿Qué porcentaje lo hizo también en 2020?
1-0.88

2-0.90

3-0.82

4-0.85 (X)
*/

SELECT COUNT(DISTINCT IdCliente)
FROM venta
WHERE YEAR(Fecha) = 2019
AND IdCliente IN (
    SELECT DISTINCT IdCliente
    FROM venta
    WHERE YEAR(Fecha) = 2020
);
-- 1430
--  1430 / 1674 = 0.85

/* 13) ¿Qué cantidad de clientes realizó compras sólo por el canal presencial entre 2019 y 2020?
Opciones:

1-0.23 (X)

2-0.15

3-0.47

4-0.33
*/
-- 1351
SELECT v.cantidad_clientes , cv.nombre_canal
FROM (
    SELECT COUNT(DISTINCT idcliente) AS cantidad_clientes, idcanal
    FROM venta
    WHERE idcanal = 3 AND YEAR(fecha) BETWEEN 2019 AND 2020
    GROUP BY idcanal
) v
JOIN (
    SELECT canal AS nombre_canal, idcanal
    FROM canal_venta
    WHERE idcanal = 3
) cv ON cv.idcanal = v.idcanal;


SELECT SUM(cantidad_clientes) AS total_clientes
FROM (
    SELECT COUNT(DISTINCT idcliente) AS cantidad_clientes
    FROM venta
    WHERE YEAR(fecha) BETWEEN 2019 AND 2020
    GROUP BY idcanal
) AS s;
/* 14) El sector de Marketing desea saber cuál sucursal tiene la mayor ganancia neta en el 2020,(Ganancia = suma_total(Venta - Gasto) ¿Cuál es la sucursal con mayor ganancia neta en 2020?
Opciones:

1- Alberdi

2- Flores

3- Corrientes*/

SELECT v.IdSucursal,
       s.Sucursal,
       (v.venta - g.gasto) ganancia_neta
  FROM (SELECT IdSucursal, 
               SUM(Precio) venta 
          FROM venta 
         WHERE year(fecha) = 2020
        GROUP BY IdSucursal) v
JOIN (SELECT IdSucursal, SUM(Monto) gasto
        FROM gasto
       WHERE year(Fecha) = 2020
      GROUP BY IdSucursal) g
  ON (v.IdSucursal = g.IdSucursal)
JOIN sucursal s
  ON (v.IdSucursal = s.IdSucursal)
  ORDER BY ganancia_neta DESC;
/* 15) Del total de clientes que realizaron compras en 2019, ¿Qué porcentaje lo hizo sólo en una única sucursal?
Opciones:

1-0.45

2-0.64

3-0.41

4-0.51*/
SELECT 
    (COUNT(DISTINCT CASE WHEN total_sucursales = 1 THEN idcliente END) / COUNT(DISTINCT idcliente)) * 100 AS porcentaje
FROM (
    SELECT idcliente, COUNT(DISTINCT idsucursal) AS total_sucursales
    FROM venta
    WHERE YEAR(fecha) = 2019
    GROUP BY idcliente
) AS subquery;

SELECT COUNT(idcliente) * 100.0 / (SELECT COUNT(DISTINCT idcliente) FROM venta WHERE YEAR(fecha) = 2019) AS porcentaje
FROM (
  SELECT idcliente, COUNT(DISTINCT idsucursal) AS sucursales
  FROM venta
  WHERE YEAR(fecha) = 2019
  GROUP BY idcliente
  HAVING sucursales = 1
) AS clientes_unicos;