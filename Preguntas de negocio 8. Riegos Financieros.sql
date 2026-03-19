-- RIESGOS FINANCIEROS



-- 20. ¿Qué proporción de las órdenes tienen profit negativo?

with ordenes as (
select
order_id as orden,
sum(profit) as beneficio
from samplesuperstore
group by order_id)
select
count(*) as total_ordenes,
sum(
case
	when beneficio<0 then 1 else 0
end
) as ordenes_perdidas,
sum(
case
	when beneficio<0 then 1 else 0
end
)*100/count(*) as porcentaje_con_perdida

from ordenes;


-- 29. ¿Qué categorías concentran más órdenes no rentables?

with table_base as (
select 
category as categoria, 
order_id as orden , 
sum(profit)/sum(sales) as margen
from
samplesuperstore
group by categoria, orden
having margen<0
)
select 
count(orden),
sum(margen),
categoria
from table_base
group by categoria;


-- 30. ¿Qué regiones combinan alto descuento + bajo margen?
select
region,
AVG(discount),
sum(profit)/sum(sales) as margen
from samplesuperstore
group by region
order by margen desc;