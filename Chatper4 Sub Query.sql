---1--- 
---���һ������ж���
select orderid, orderdate, custid,empid 
from Sales.Orders O1
where orderdate=
(select max(O2.orderdate) from Sales.Orders O2 )

---2---
---�����������Ŀͻ����еĶ���, ��ඩ�����Ŀͻ���ֹһ����top 1Ҫ��TIES
select orderid, orderdate, custid,empid 
from Sales.Orders O1
where o1.custid in
(
	select top 1 with ties custid  --WITH TIES ���Բ�ѯ���ж�����������󶩵��Ŀͻ��������ǽ���TOP 1
	from sales.orders O2 
	group by O2.custid 
	order by count(O2.orderid)  desc
)

---3---
---2016��5��1�ջ���֮��û���¶����Ĺ�Ա
select EMP.empid, EMP.firstname, EMP.lastname
from hr.Employees EMP where EMP.empid not in
(
	select O.empid from Sales.Orders O 
	where O.orderdate>='20160501' 
)

---4---
---�����пͻ�����û�й�Ա�Ĺ���
select distinct country from Sales.Customers C
where country not in 
(
	select E.country from HR.Employees E
	where E.country is not null
	
)
order by country


---5---
---����ÿ���ͻ�����һ���µ����ж���
select custid,orderid,orderdate,empid 
from Sales.Orders O1
where O1.orderdate =
(
	select max(orderdate) from Sales.Orders O2
	where O1.custid = O2.custid
)
order by O1.custid, O1.orderid


---6---
--����2016���µ�������2017��û�µ��Ŀͻ�

select distinct custid, companyname
from Sales.Customers C


