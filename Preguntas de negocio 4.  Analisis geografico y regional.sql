-- ANÁLISIS GEOGRÁFICO Y REGIONAL

-- 13. ¿Qué regiones son más rentables?

with regiones as (
select 
region,
sum(sales) as ventas, 
sum(profit) as profit,
sum(profit)/sum(sales) as margen
from samplesuperstore
group by region),
promedio as (
select AVG(margen) as margen_promedio
from regiones
)
select 
e.region,
e.profit,
e.margen,
p.margen_promedio
from regiones as e
cross join promedio as p;
-- where e.margen>=p.margen_promedio
-- order by e.margen DESC;



-- 14. ¿Hay estados o ciudades con ventas altas pero pérdidas sistemáticas?

with base as (
select 
city,
state,
sum(sales) as ventas,
sum(profit) as beneficio,
sum(profit)/sum(sales) as margen
from samplesuperstore
group by city, state),
ventasavg as (
select avg(ventas) as ventaspromedio from base
),
realtable as (
select 
b.*,
v.* 
from base as b
cross join ventasavg as v),
finally as (
select * from realtable
where ventas>ventaspromedio and margen<0)
select
state,
city,
sum(margen)
from finally
group by state,city
order by sum(margen);



-- 15. ¿Cómo varía el margen por región?

WITH margen_region AS (
    SELECT
        Region,
        SUM(Profit) / SUM(Sales) AS margen
    FROM samplesuperstore
    GROUP BY Region
)
SELECT
    Region,
    round(margen,3),
    round(margen - (SELECT AVG(margen) FROM margen_region),3) AS diferencia_vs_promedio
FROM margen_region
ORDER BY diferencia_vs_promedio DESC;



-- 16. ¿Existen regiones donde los descuentos promedio son más altos?

WITH region_descuento AS (
    SELECT
        Region,
        AVG(Discount) AS descuento
    FROM samplesuperstore
    GROUP BY Region
)
SELECT
    Region,
    descuento,
    descuento - (SELECT AVG(descuento) FROM region_descuento) AS diferencia_vs_promedio
FROM region_descuento
ORDER BY diferencia_vs_promedio DESC;

