-- Analisis por categoría y subcategoría

-- 1. ¿Qué categorías generan más ventas y cuáles más ganancias?

select 
Category as categoria,
sum(sales) as ventas,
sum(profit) as ganancias
from samplesuperstore
group by categoria
order by  ganancias DESC;



-- 2. ¿Hay subcategorías con ventas altas pero ganancias negativas?

with ventas_ganancias_subcategoria as (
select 
`Sub-Category` as subcategoria,
sum(sales) as ventas,
sum(Profit) as ganancias
from samplesuperstore
group by `Sub-Category`),
promedio as (
select AVG(ventas) as promedio_ventas
from ventas_ganancias_subcategoria)
select 
v.subcategoria,
v.ventas,
v.ganancias
from ventas_ganancias_subcategoria as v
cross join promedio as p
where v.ventas>p.promedio_ventas and ganancias<0;



-- 3. ¿Cuál es el margen promedio por categoría y subcategoría?

-- Categoría
select 
Category,
sum(Profit)/sum(Sales) as margen_promedio_categoria
from
samplesuperstore
group by Category
order by Category DESC;

-- Subcategoría
select 
Category,
`Sub-Category`,
sum(Profit)/sum(sales) as margen_promedio_subcategoria
from
samplesuperstore
group by category, `Sub-Category`
order by margen_promedio_subcategoria DESC;



-- 4. ¿Qué subcategorías explican la mayor pérdida financiera del negocio?

select
`Sub-Category` as subcategoria,
sum(profit) as beneficio
from
samplesuperstore
group by subcategoria
having beneficio <0
order by beneficio ASC;
