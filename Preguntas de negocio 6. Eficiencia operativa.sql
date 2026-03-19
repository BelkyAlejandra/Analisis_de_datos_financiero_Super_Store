-- 1. ¿El modo de envío afecta la rentabilidad?
-- 2. ¿Existen modos de envío asociados a mayores pérdidas?
select 
ship_mode,
round(sum(sales),2) as ventas_totales,
round(sum(profit),2) as ganancia_total,
round(sum(profit)/sum(sales), 2) as margen
from samplesuperstore
group by Ship_mode;


-- 3. ¿Cómo se relaciona el tiempo entre orden y envío con el margen?
with tiempos as (
select
order_id,
datediff(ship_date, order_date) as dias_envio,
sum(profit)/sum(sales) as beneficio
from samplesuperstore
group by Order_ID, dias_envio)
select
dias_envio,
SUM(beneficio) as `margen total segmento`
from tiempos
group by dias_envio
order by `margen total segmento` DESC;