select prod_name, max(stocksum)
from
(
	select
		prod_name,
		sum(prod_instock) over
		(
    		partition by prod_name
			order by prod_id
    		rows between unbounded preceding
    		and 1 preceding
		) as stocksum
	from products
) as cte
group by prod_name ;
