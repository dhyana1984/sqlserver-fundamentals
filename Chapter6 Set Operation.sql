---1---
---������ѭ���ṹ����һ��1-10��Χ��10�����ָ�����

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
---������2016��1���ж�������2016��2��û�ж����Ŀͻ��͹�Ա

select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160229'
except
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'


---3---
---������2016��1�º�2016��2�¾��ж����Ŀͻ��͹�Ա


select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160131'
intersect
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'


---4---
---������2016��1�º�2016��2���ж���������2015��û�����Ŀͻ��͹�Ա

select custid, empid
from Sales.Orders where  orderdate>='20160101' and orderdate <= '20160131'
intersect
select custid, empid
from Sales.Orders where  orderdate >='20160201' and orderdate < '20160301'
except
select custid, empid
from Sales.Orders where orderdate>='20150101' and orderdate <= '20151231'


---5---
---�����Ѹ��߼�����֤�����employees���ص�����suppliers���ص���֮ǰ��������country,region��city����

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





