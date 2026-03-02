-- IMPACTO DE DESCUENTOS

-- 9. ¿cómo se relaciona el nivel de descuento con la ganancia?

with clasificacion_descuentos as (
	select
		case
			when Discount<0.1 then '0-10%'
			when Discount<0.2 then '10-20%'
			when Discount<0.3 then '20-30%'
			when Discount<0.4 then '30-40%'
			when Discount<0.5 then '40-50%'
			when Discount<0.6 then '50-60%'
			when Discount<0.7 then '60-70%'
			when Discount<0.8 then '70-80%'
			when Discount<0.9 then '80-90%'
		end as rango_descuento,
		Profit,
		sales
	from samplesuperstore) 
select 
count(*) as numero_registros,
sum(profit) as beneficio_total,
sum(sales) as ventas_totales,
avg(profit) as beneficio_promedio,
sum(profit)/sum(sales) as margen,
rango_descuento
from 
clasificacion_descuentos
group by rango_descuento
order by rango_descuento ASC;



-- 10. ¿A partir de qué descuento el profit se vuelve negativo?


with descuentos as (
	select
		case 
			when discount <0.3 then 'Menos de 30%'
            when discount <0.31 then '- 31%'
			when discount <0.32 then '- 32%'
            when discount <0.33 then '- 33%'
			when discount <0.34 then '- 34%'
            when discount <0.35 then '- 35%'
			when discount <0.36 then '- 36%'
            when discount <0.37 then '- 37%'
			when discount <0.38 then '- 38%'
            when discount <0.39 then '- 39%'
			when discount >=0.4 then 'Mayor al 40%'
		end as `rango descuento preciso`,
	profit,
    sales,
    discount
    from samplesuperstore)
    select 
    sum(profit)/sum(sales) as margen, 
    `rango descuento preciso`
    from descuentos
    group by `rango descuento preciso`;
    
    
    
    -- 11. ¿Qué categorías se vuelven más sensibles al descuento?
    
	select
		case
			when Discount<0.1 then '0-10%'
			when Discount<0.2 then '10-20%'
			when Discount<0.3 then '20-30%'
			when Discount<0.4 then '30-40%'
			when Discount<0.5 then '40-50%'
			when Discount<0.6 then '50-60%'
			when Discount<0.7 then '60-70%'
			when Discount<0.8 then '70-80%'
			when Discount<0.9 then '80-90%'
        end as descuento,
	category as categoria,
	sum(profit) as beneficio,
    sum(sales) as ventas,
    sum(profit)/sum(sales)*100 as margen
    from samplesuperstore
    group by descuento, categoria
    order by descuento;
    

-- 12. ¿Existen productos que siempre pierden dinero, incluso con bajo descuento?
    
with productos as (
select
		case
			when Discount<0.1 then '0-10%'
			when Discount<0.2 then '10-20%'
			when Discount<0.3 then '20-30%'
			when Discount<0.4 then '30-40%'
			when Discount<0.5 then '40-50%'
			when Discount<0.6 then '50-60%'
			when Discount<0.7 then '60-70%'
			when Discount<0.8 then '70-80%'
			when Discount<0.9 then '80-90%'
        end as descuento,
Product_Name,
category,
`Sub-Category`,
sum(sales) as ventas,
sum(Profit) as beneficio,
sum(Profit)/sum(sales) as margen
from samplesuperstore
group by Product_Name, category,`Sub-Category`,descuento
order by margen desc),
final as (
select * from productos where margen<0)
select * from final where descuento='0-10%' or descuento='10-20%' 
order by margen ASC;
    
    