-- RENTABILIDAD GENERAL DEL NEGOCIO

-- 1. ¿Cuál es el total de ventas, ganancia y margen del negocio por año?

select 
sum(ventas), 
sum(ganancias), 
sum(ganancias)/sum(ventas) as margen from 
(
select
	year(order_date) as anio,
	month(order_date) as mes,
	sum(Sales) as 'Ventas',
	sum(Profit) as 'Ganancias' 
from samplesuperstore
group by anio, mes 
order by anio, mes
) as sub;



-- 2. ¿Cómo evolucionan las ventas y la ganancia a lo largo del tiempo (por año y meses)?

-- Evolución por mes

WITH base AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS periodo,
        SUM(Sales) AS ventas,
        SUM(Profit) AS ganancias
    FROM samplesuperstore
    GROUP BY periodo
),
temporal as (
SELECT
    periodo,
    ventas,
    ganancias,
    ventas - LAG(ventas) OVER (ORDER BY periodo) AS cambio_ventas,
    ganancias - LAG(ganancias) OVER (ORDER BY periodo) AS cambio_ganancias
FROM base),
intermedia as (
select * from temporal 
where cambio_ganancias<0)
-- select * from intermedia where periodo like '%-12';
select  AVG(cambio_ganancias) from intermedia where periodo like '%-12';

-- Evolución anual
with anio_meses as (
select
	year(order_date) as anio,
	month(order_date) as mes,
	sum(Sales) as 'Ventas',
	sum(Profit) as 'Ganancias' 
from samplesuperstore
group by anio, mes 
)
select 
	sum(ventas), 
	sum(ganancias), 
	anio
from anio_meses
group by anio
order by sum(ganancias);



-- 3. ¿Existen periodos donde las ventas crecen pero las ganancias caen?

with 
mensualmente as (
	select
	year(order_date) as anio,
	month(order_date) as mes,
	sum(Sales) as 'Ventas',
	sum(Profit) as 'Ganancias' 
from samplesuperstore
group by anio, mes 
),
crecimiento as (
select
	anio,
    mes,
    ventas,
    ganancias,
	ventas-lag(ventas) over(order by anio, mes) as delta_ventas,
    ganancias-lag(ganancias) over(order by anio, mes) as delta_ganancias
from mensualmente
)
Select *
from crecimiento
where delta_ventas>0 AND delta_ganancias <0
Order by anio, mes;



-- 4. ¿Cuál es la variabilidad del profit a lo largo del tiempo?

select anio, 
stddev_samp(Ganancias) as variabilidad_profit,
AVG(Ganancias) as promedio_profit
 from 
(
select
	year(order_date) as anio,
	month(order_date) as mes,
	sum(Sales) as 'Ventas',
	sum(Profit) as 'Ganancias' 
from samplesuperstore
group by anio, mes 
order by anio, mes) sub 
group by anio;