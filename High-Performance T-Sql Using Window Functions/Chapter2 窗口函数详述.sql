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
				--rows between unbounded preceding and current row --���Լ�дΪrows unbounded preceding
			) as runqty


from sales.EmpOrders




select orderid, orderdate,val,
ROW_NUMBER() over(order by (select null)) as rownum --ֻ�����ڷ���������Ψһ�кţ�û���ر�����Ҫ����over(order by (select null))
from Sales.OrderValues











