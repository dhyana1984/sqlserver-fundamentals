---1---
---不适用循环结构生成一个1-10范围的10个数字辅助表

select 1 as n
union all select 2
union all select 3
union all select 4
union all select 5
union all select 6
union all select 7
union all select 8
union all select 9
union all select 10

---2---
---返回在2016年1月有订单而在2016年2月没有订单的客户和雇员

select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160229'
except
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'


---3---
---返回在2016年1月和2016年2月均有订单的客户和雇员


select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160131'
intersect
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'


---4---
---返回在2016年1月和2016年2月有订单，但是2015年没定但的客户和雇员

select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160131'
intersect
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'
except
select custid, empid
from Sales.Orders where orderdate>='20150101' and orderdate <= '20151231'


---5---
---补充已给逻辑，保证输出中employees返回的行在suppliers返回的行之前，并按照country,region和city排列

/*
SELECT country, region, city
FROM HR.Employees

UNION ALL

SELECT country, region, city
FROM Production.Suppliers;
*/

with A1 as
(
	SELECT country, region, city, 0 as r
	FROM HR.Employees

	UNION ALL

	SELECT country, region, city, 1 as r
	FROM Production.Suppliers
)
select country, region, city from A1
order by r, country, region, city





