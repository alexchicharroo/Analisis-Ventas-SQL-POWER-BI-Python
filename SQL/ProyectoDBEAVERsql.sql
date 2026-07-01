------------------------------------------------------
--PROYECTO ANALISIS DE VENTAS
------------------------------------------------------


-------------------------------------------------------
--PARTE 1. PRACTICAS Y EJERCICIOS BASE (DIAS INICIALES)
------------------------------------------------------
--EJERCICIOS SELECT FROM WHERE
SELECT* FROM ventas WHERE ciudad="Madrid" LIMIT 10; --busca las 10 primeras ventas de madrid
select * from ventas limit 10; --muestra datos de la tabla de las 10 primeras ventas
select producto, ciudad, fecha FROM ventas limit 10; -- de esas 10 primeras ventas, nos muestra solo los datos que hemos pedido
select* FROM ventas WHERE ciudad="Madrid" limit 20; -- muestra las primeras 20 ventas de madrid
select*from ventas where unidades >3 limit 10; --muestra las ventas donde se venden mas de 3 uds
select*from ventas where categoria = "Comida" limit 10; --muestra las 10 primeras ventas de comida
select producto from ventas where categoria="Comida" and ciudad= "Madrid" and unidades > 5 limit 10;

--EJERCICIOS AND, OR, NOT
select* from ventas where ciudad= "Madrid" and categoria= "Bebida" limit 10;
select*from ventas where ciudad= "Madrid" or ciudad= "Sevilla" limit 20;
select*from ventas where not ciudad= "Bilbao" limit 15;
select*from ventas where categoria = "Comida" and precio_unitario > 5 LIMIT 15;
select*from ventas where (ciudad= "Madrid" or ciudad="Sevilla") and unidades >= 3 limit 20;

--EJERCICIOS CON DISTINCT QUE ELIMINA DUPLICADOS, ORDER BY QUE ORDENA Y LIMIT QUE EVITA TABLA GRANDE
SELECT DISTINCT CIUDAD FROM VENTAS; --mostrar distintas ciudades de la tabla ventas
select distinct producto from ventas;
select*, unidades*precio_unitario as importe from ventas order by importe DESC limit 10; --SELECCIONA LA TABLA INICIAL
--Y AÑADE LA COLUMNA IMPORTE QUE ES UD*PRECIO. Y LO ORDENA DE MAYOR A MENOR, DANDO 10 VALORES
select*from ventas order by fecha asc limit 30;
select*from  ventas where ciudad="Madrid" order by fecha desc limit 20; --ventas de madrid por fecha descendente



-------------------------------------------------------
--PARTE 2. AGREGACIONES Y AGRUPACIONES (PROYECTO)
------------------------------------------------------
--En el primer día usamos funciones básicas com count, sum..
--1.1 Calculamos el numero de ventas
select count(*) from ventas; --cuenta filas de la tabla
--1.2 Calculamos unidades totales
select sum(unidades) from ventas; --suma los valores de la columna unidades
--1.3 Queremos calcular la facturacion total
select round(sum(unidades*precio_unitario),2) facturacion from ventas; --aproximamos a dos decimales
--1.4 ¿Cual seria el ticket medio?
select round(avg(unidades*precio_unitario),2) ticket_medio from ventas; --avg hace el promedio
--1.5 ¿cual es el precio máximo?
select max(precio_unitario) from ventas;
--1.6 ¿cual seria la venta maxima?
select max(unidades*precio_unitario) from ventas;

--- En el segundo dia hay que centrarse en group by sobre todo
--2.1 Facturacion por ciudad
select ciudad, round(sum(unidades*precio_unitario),2) facturacion from ventas group by ciudad order by facturacion;
--2.2 Queremos saber ahora las unidades por categoria
select categoria, sum(unidades) from ventas group by categoria;
--2.3 Tras esto, la facturacion agrupada por producto
select producto, round(sum(unidades*precio_unitario),2) facturacion from ventas group by producto order by facturacion;
--2.4 Vemos las ventas por fecha
select fecha, count(*) ventas from ventas group by fecha order by fecha;
--2.5 ticket medio por categoria
select categoria, avg(precio_unitario) ticket_medio from ventas group by categoria order by ticket_medio

-- En el tercer día, usaremos el having (where filtra antes de agrupar y having después)
--3.1 Productos con facturacion mayor a 5000
select producto, round(sum(unidades*precio_unitario),2) facturacion from ventas group by producto having sum(unidades*precio_unitario)>5000;
--3.2 Ciudades con mas de 1000 ventas
select ciudad, count(*) ventas from ventas group by  ciudad having count(*)>1000;
--3.3 Categorias con ticket medio mayor que 20
select categoria, round(avg(unidades*precio_unitario),2) ticket_medio from ventas group by categoria having avg(unidades*precio_unitario) > 20;

--En el cuarto día se usará join, donde se empiezan a cruzar tablas
--4.1 Piden facturacion por cliente, es decir se junta cliente y ventas
select c.nombre, round(sum(v.unidades*v.precio_unitario),2) facturacion from clientes c inner join ventas v on c.id_cliente = v.id_cliente group by c.nombre order by facturacion desc;
--4.2 Facturacion por segmento, sigue siendo la tabla cliente
select c.segmento, round(sum(v.unidades*v.precio_unitario),2) facturacion from clientes c inner join ventas v on c.id_cliente = v.id_cliente group by c.segmento order by facturacion desc;
--4.3 Top 10 clientes 
select  c.nombre, round(sum(v.unidades*v.precio_unitario),2) total_gastado from clientes c inner join ventas v on c.id_cliente = v.id_cliente group by c.nombre order by total_gastado DESC LIMIT 10;
--4.4 Nos piden tambien las ventas y lo generado por ciudad del cliente
select c.ciudad_cliente, count(*) total_ventas, round(sum(v.unidades*v.precio_unitario),2) facturacion from clientes c inner join ventas v on c.id_cliente = v.id_cliente group by c.ciudad_cliente order by total_ventas desc;

--En el quinto dia se usa left join, que mantiene todos los registros de la primera tabla y asi vemos clientes que no tienen ventas por ejemplo
--5.1 Clientes sin ventas
select c.id_cliente, c.nombre from clientes c left join ventas v on c.id_cliente = v.id_cliente where v.id_venta IS NULL;
--5.2 Conteo de ventas por cliente incluyendo 0
select c.nombre, count(v.id_venta) ventas from clientes c left join ventas v on c.id_cliente=v.id_cliente group by c.nombre order by ventas desc;
--5.3 Facturacion por cliente con coalesce (da valor a los nulos)
select c.nombre, coalesce(round(sum(v.unidades * v.precio_unitario),2),0) facturacion from clientes c left join ventas v on c.id_cliente=v.id_cliente group by c.nombre order by facturacion desc;


--En el sexto dia usamos el case when, que es como una condicion
--6.1 Crea tipos de ticket y cantidad
select case when unidades*precio_unitario>=25 then "ticket alto" else "ticket bajo" end tipo_ticket, count(*) as ventas from ventas group by tipo_ticket;
--6.2 Facturacion por tipo ticket
select case when unidades*precio_unitario>=25 then "ticket alto" else "ticket bajo" end tipo_ticket, round(sum(unidades*precio_unitario),2) facturacion from ventas group by tipo_ticket;
--6.3 segmentacion por precio unitario
select case when precio_unitario<5 then "economico" when precio_unitario >=5 and precio_unitario <=10 then "estandar" else "premium" end as SEGMENTO_PRECIO, count(*) as cantidad_productos from ventas group by SEGMENTO_PRECIO ;
--6.4 Categoria de unidades
select case when unidades<=1 then "baja cantidad" when unidades>1 and unidades <=4 then "entre 2 y 4" else "mas de 4 ud" end as cantidad_comprada, count(*) as veces from ventas group by cantidad_comprada; 

--En el septimo día vamos a estudiar subconsultas
--7.1 Ventas por encima del ticket medio
select * from ventas where unidades*precio_unitario > (select avg(unidades*precio_unitario) from ventas) limit 10; --calcula la media, y va fila por fila calculando si es mayor o no.
--7.2 Productos con facturacion superior a la media por producto
select producto, sum(unidades*precio_unitario) facturacion from ventas group by producto having  facturacion > (select avg(total_producto) from(select sum(unidades*precio_unitario) total_producto from ventas group by producto));
--7.3 Clientes top sobre media
select v.id_cliente, c.nombre, sum(v.unidades*v.precio_unitario) total_gastado from ventas v inner join clientes c on v.id_cliente=c.id_cliente group by c.nombre, v.id_cliente having total_gastado > (select(avg(total_cliente)) from (select(sum(unidades*precio_unitario)) total_cliente from ventas group by id_cliente)) limit 20;
--en la ultima consulta lo que se hace explicado es. En la subconsulta se agrupa por cliente y se calcula  el total por cliente de lo que ha gastado, tras ello, se hace la media del total de todos los clientes
-- esto se compara con la suma de cada cliente y sila suma es mayor se anota en el resultado, el cual nos va a dar el nombre de la tabla cliente
-- el id del cliente y el total gastado. Para que se pueda poner el id y el nombre se usa el inner join y te une las tablas cliente y venta




