-- ANÁLISIS DE PRODUCTOS



-- 24.¿Cuáles son los productos más rentables?

with productos as (
select
product_id,
product_name,
sum(sales) as ventas_totales,
sum(profit) as profit_total,
sum(profit)/sum(sales) as margen
from
samplesuperstore
group by Product_ID, Product_Name),
cuartiles as (
select *,
-- ntile(4) parte los registros en 4 grupos, ¿cómo lo hace? por concepto de margen descendente
	ntile(4) over (order by margen desc) as cuartil_margen
from productos
)
select * 
from cuartiles
-- Aquí se toma el primer cuartil
where cuartil_margen=1;


-- 25.¿Cuáles son los productos que generan pérdidas recurrentes?
-- Recurrentes: vamos a definir que recurrentes sea por año

with productos as (
    select
        year(order_date) as anio,
        product_id,
        product_name,
        sum(profit) as beneficio
    from samplesuperstore
    group by product_id, product_name, anio
),
perdidas as (
    select *
    from productos
    where beneficio < 0
)
select
    product_id,
    product_name,
    count(distinct anio) as años_con_perdida,
    round(sum(beneficio),2) as perdida_total,
    round(avg(beneficio),2) as perdida_promedio_anual
from perdidas
group by product_id, product_name
having count(distinct anio) > 1
order by años_con_perdida desc, perdida_total asc;


-- 26.¿Qué porcentaje del catálogo genera el 80% de la ganancia? (Pareto)

with productos as (
    select 
        product_name,
        sum(profit) as profit_total
    from samplesuperstore
    group by product_name
),
ordenados as (
    select
        product_name,
        profit_total,
        sum(profit_total) over () as profit_global,
        sum(profit_total) over (order by profit_total desc) as profit_acumulado
    from productos
)

select
    count(*) as productos_que_generan_80_por_ciento,
    (select count(*) from productos) as total_productos,
    round(
        count(*) * 100.0 / (select count(*) from productos),
        2
    ) as porcentaje_del_catalogo
from ordenados
where profit_acumulado <= profit_global * 0.8;


-- 27. ¿Hay productos con baja rotación pero alto margen?

with base_table as (
    select
        product_name,
        count(distinct order_id) as rotacion,
        sum(profit)/sum(sales) as margen
    from samplesuperstore
    group by product_name
),
clasificados as (
select *,
ntile(4) over (order by margen desc) as cuartil_margen,
ntile(4) over (order by rotacion asc) as cuartil_rotacion
from base_table
)
select
product_name,
margen, 
rotacion
from clasificados
where cuartil_margen=1
and cuartil_rotacion=1;