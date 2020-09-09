---1---
---计算每个客户订单的排名和密集排名，按custid分区并且按qty排序
select 
custid,
orderid,
qty,
Rank() over (partition by custid order by qty) as rnk,
DENSE_RANK() over (partition by custid order by qty) as drnk
from dbo.Orders


---2---
---计算每个客户订单的当前订单数量与该客户之前订单数量之间的差异
select 
custid,
orderid,
qty,
qty - lag(qty) over (partition by custid order by orderdate, orderid)  as diffprev ,
qty - lead(qty) over (partition by custid order by orderdate,orderid) as diffnext,
orderdate
from dbo.Orders


---3---
---每个雇员返回一行，每个订单年度一列，每个雇员每年的订单数量

select 
empid, 
[2014] as cnt2014,
[2015] as cnt2015,
[2016] as cnt2016 
from
(
	select empid, year(orderdate) as orderyear
	from dbo.Orders 
)t
pivot(count(orderyear) for  orderyear in ([2014],[2015],[2016]) ) as p


select * from dbo.Orders 
where empid =3

---4---
---每个雇员和年度订单一行，并带有订单数量，消除订单为0的行
/*
empid       cnt2014     cnt2015     cnt2016
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2
*/

select 
empid,
cast(right(orderyear,4) as int) as orderyear,
numorders
from dbo.EmpYearOrders
unpivot( numorders for orderyear in (cnt2014,cnt2015,cnt2016)) u
where numorders <> 0


---5
---为每个分组集(雇员，客户和订单年度)、（雇员和订单年度）、（客户和订单年度）返回总计订购数量

select 
GROUPING_ID(empid, custid,year(orderdate)) as groupingset, --用于区分不同的分组集
empid,
custid,
year(orderdate) orderyear,
sum(qty) as summary
from 
dbo.orders
group by
	GROUPING sets
	(
		(empid,custid,year(orderdate)),
		(empid,year(orderdate)),
		(custid,year(orderdate))
	)
