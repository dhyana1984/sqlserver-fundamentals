---1--- 
---最后一天的所有订单
select orderid, orderdate, custid,empid 
from Sales.Orders O1
where orderdate=
(select max(O2.orderdate) from Sales.Orders O2 )

---2---
---订单数量最多的客户所有的订单, 最多订单量的客户不止一个，top 1要用TIES
select orderid, orderdate, custid,empid 
from Sales.Orders O1
where o1.custid in
(
	select top 1 with ties custid  --WITH TIES 可以查询所有订单量等于最大订单的客户，而不是仅仅TOP 1
	from sales.orders O2 
	group by O2.custid 
	order by count(O2.orderid)  desc
)

---3---
---2016年5月1日或者之后没有下订单的雇员
select EMP.empid, EMP.firstname, EMP.lastname
from hr.Employees EMP where EMP.empid not in
(
	select O.empid from Sales.Orders O 
	where O.orderdate>='20160501' 
)

---4---
---返回有客户但是没有雇员的国家
select distinct country from Sales.Customers C
where country not in 
(
	select E.country from HR.Employees E
	where E.country is not null
	
)
order by country


---5---
---返回每个客户活动最后一天下的所有订单
select custid,orderid,orderdate,empid 
from Sales.Orders O1
where O1.orderdate =
(
	select max(orderdate) from Sales.Orders O2
	where O1.custid = O2.custid
)
order by O1.custid, O1.orderid


---6---
--返回2016年下单，但是2017年没下单的客户

select custid, companyname
from Sales.Customers C
Where exists 
	(
		select O.custid from Sales.Orders O
		where o.custid= c.custid and orderdate>='20150101' and orderdate<='20151231'
	) and
	not exists
	(
		select O.custid from Sales.Orders O
		where o.custid= c.custid and orderdate>='20160101' and orderdate<='20161231'
	)


---7---
---返回订购了产品12的客户
Select distinct C.custid, companyname 
from Sales.Customers C
left join Sales.Orders O on c.custid = O.custid
left join Sales.OrderDetails OD on O.orderid = OD.orderid
where productid=12
order by C.custid


---8---
---计算每个客户及其月度的采购总量
select 
CO1.custid, 
CO1.ordermonth, 
CO1.qty,
(
	select sum(CO2.qty) 
	from Sales.CustOrders CO2
	where CO2.ordermonth<=CO1.ordermonth and CO2.custid= CO1.custid
	  ) AS runqty
from Sales.CustOrders CO1
order by custid,ordermonth
