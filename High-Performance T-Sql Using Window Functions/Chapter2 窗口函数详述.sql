select orderid, custid, val,
	sum(val) over() as sumall,
	sum(val) over(partition by custid) as sumcust
from sales.OrderValues as o1



select empid,ordermonth, qty,
sum(qty) over 
			(
				partition by empid
				order by ordermonth
				rows unbounded preceding
				--rows between unbounded preceding and current row --可以简写为rows unbounded preceding
			) as runqty


from sales.EmpOrders




select orderid, orderdate,val,
ROW_NUMBER() over(order by (select null)) as rownum --只是想在分区中生成唯一行号，没有特别排序要求，用over(order by (select null))
from Sales.OrderValues











