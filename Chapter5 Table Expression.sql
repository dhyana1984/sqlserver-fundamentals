

---1---
---����ÿ����Ա��orderdate���е����ֵ
select 
empid,
max(orderdate) AS maxorderdate
from Sales.Orders
group by empid


---1-2---
---����ÿ����Ա��󶩵����ڵĶ���
select O1.empid, orderdate, orderid,custid
from Sales.Orders O1
join 
(
	select 
	empid,
	max(orderdate) AS maxorderdate
	from Sales.Orders
	group by empid

)O2 on O1.empid = O2.empid where  O1.orderdate = O2.maxorderdate


---2-1---
---���㰴orderdate,orderid�����ÿ���������к�

select 
orderid,
orderdate,
custid,
empid,
ROW_NUMBER() over (order by orderid) as rownum
from Sales.Orders


---2-2
---����2-1�к�11-20����
with c1 As
(
	select 
	orderid,
	orderdate,
	custid,
	empid,
	ROW_NUMBER() over (order by orderid) as rownum
	from Sales.Orders
)
select orderid,
	orderdate,
	custid,
	empid,
	rownum
from c1
where rownum between 11 and 20


---3---
---���ع�Ա9�Ĺ�������
with A1 AS
(
	select empid, mgrid, firstname, lastname
	from HR.Employees
	where empid=9

	union all

	select hr.empid,  hr.mgrid,hr.firstname,hr.lastname
	from A1 as P
	join HR.Employees as hr on P.mgrid = hr.empid
)
select empid, mgrid,firstname,lastname from A1


---4-1---
---����ÿλ��Աÿ�������������ͼ

if OBJECT_ID('Sales.VEmpOrders') is not null
	drop view Sales.VEmpOrders
go
create view Sales.VEmpOrders as
with A1 as
(
	select empid,year(orderdate) as orderyear,sum(qty) as qty from Sales.Orders O
	join Sales.OrderDetails OD on O.orderid = OD.orderid
	group by empid,year(orderdate)
)
select empid, orderyear,qty from A1
go
select  empid, orderyear,qty from Sales.VEmpOrders order by empid,orderyear


---4-2---
---����ÿ����Աÿ�������������

select  
empid, 
orderyear,
qty,
(
	select sum(qty) 
	from  Sales.VEmpOrders O2 
	where O2.orderyear <= O1.orderyear and O1.empid=O2.empid
	group by empid
)  as runqty
from Sales.VEmpOrders O1
order by empid,orderyear


---5-1---
---����������������Ϊ����Ĺ�Ӧ��id�Ͳ�Ʒ����n��������ָ����Ӧ�̹�Ӧ��n����ߵ��۲�Ʒ
if OBJECT_ID('Production.TopProducts') is not null
	drop function Production.TopProducts
go
create function Production.TopProducts(@supid as int, @n as int)  
returns table
as
return
	select top (@n) productid, productname, unitprice from Production.Products
	where supplierid=@supid
	order by unitprice desc
go

select * from Production.TopProducts(5,2)


---5-2---
---ʹ��cross appplyΪÿ����Ӧ�̷����������Ĳ�Ʒ
select supplierid, companyname, p.productid,p.productname,p.unitprice 
from Production.Suppliers s
cross apply Production.TopProducts(s.supplierid,2) p










