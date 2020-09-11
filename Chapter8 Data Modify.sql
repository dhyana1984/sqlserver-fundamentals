---1---
---����ÿ���ͻ��������������ܼ���������custid�������Ұ�qty����
select 
custid,
orderid,
qty,
Rank() over (partition by custid order by qty) as rnk,
DENSE_RANK() over (partition by custid order by qty) as drnk
from dbo.Orders


---2---
---����ÿ���ͻ������ĵ�ǰ����������ÿͻ�֮ǰ��������֮��Ĳ���
select 
custid,
orderid,
qty,
qty - lag(qty) over (partition by custid order by orderdate, orderid)  as diffprev ,
qty - lead(qty) over (partition by custid order by orderdate,orderid) as diffnext,
orderdate
from dbo.Orders


---3---
---ÿ����Ա����һ�У�ÿ���������һ�У�ÿ����Աÿ��Ķ�������

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
---ÿ����Ա����ȶ���һ�У������ж�����������������Ϊ0����
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
---Ϊÿ�����鼯(��Ա���ͻ��Ͷ������)������Ա�Ͷ�����ȣ������ͻ��Ͷ�����ȣ������ܼƶ�������

select 
GROUPING_ID(empid, custid,year(orderdate)) as groupingset, --�������ֲ�ͬ�ķ��鼯
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
