-- Clientes y Segmentos

-- 17. ¿Qué segmento de clientes es más rentable?

select
segment,
sum(profit)/sum(sales) as margen
from samplesuperstore
group by segment
order by margen desc;



-- 18. ¿Cuáles son los clientes top 10 por ventas vs ganancias?
with clientes as (
	select
		customer_id,
		customer_name,
		sum(sales) as ventas,
		sum(profit) as ganancias
	from samplesuperstore
	group by customer_id, customer_name),
ranking as (
	select
		*,
        rank() over (order by ventas desc) as rank_ventas,
        rank() over (order by ganancias desc) as rank_ganancias
	from clientes)
select *
from ranking
where rank_ventas<=10 
or
rank_ganancias<=10
order by ganancias DESC, ventas;



-- 19. ¿Existen clientes con alto volumen de compra pero baja rentabilidad?

with base as(
	select
		customer_id,
		customer_name,
		sum(sales) as ventas,
		sum(profit) as beneficio,
		sum(profit)/sum(sales) as margen
	from samplesuperstore
	group by customer_id, customer_name),
promedio_ventas as (
select avg(ventas) as promedio_ventas from base
),
promedio_margen as (
select avg(margen) as promedio_margen from base
)
select
b.*
from base as b
cross join promedio_ventas as pv
cross join promedio_margen as pb
where 
b.ventas>pv.promedio_ventas 
and 
b.margen<pb.promedio_margen
order by b.margen asc;



-- 20.¿Cuál es el ticket promedio por cliente y segmento?

-- Por segmento

select
segment,
sum(sales) as ventas_totales,
count(distinct(Order_ID)) as numero_pedidos,
sum(sales)/count(distinct(Order_ID)) as ticket_promedio
from samplesuperstore
group by segment
order by ticket_promedio desc;

-- Por cliente

select
customer_name,
sum(sales) as ventas_totales,
count(distinct(Order_ID)) as numero_pedidos,
sum(sales)/count(distinct(Order_ID)) as ticket_promedio
from samplesuperstore
group by customer_name
order by ticket_promedio desc;