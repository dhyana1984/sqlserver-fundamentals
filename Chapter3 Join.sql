---1---
select empid,firstname,lastname,n
from HR.Employees
cross join Nums
where Nums.n<=5


---1-2---
---从20090612到20090616，每天显示一条数据
---Nums表是一个整数递增数列,n是nums的字段
---n<=DATEDIFF(day,'20090612','20090616') +1 通过两个日期之间的天数差来控制n，从而控制结果范围
---DATEADD(DAY, n-1,'20090612') 是通过n来计算每一条数据对应的日期
select empid,DATEADD(DAY, n-1,'20090612') AS dt 
from HR.Employees
cross join Nums
where n<=DATEDIFF(day,'20090612','20090616') +1
order by dt


---2---
---注意去除重复的orderid
select C.custid, count(distinct o.orderid) AS numorders, sum(OD.qty) AS totalqty 
 from Sales.Orders O
 join Sales.Customers C on O.custid=C.custid
 join Sales.OrderDetails OD on OD.orderid = O.orderid
 where c.country= 'USA'
 group by c.custid
 order by custid


 ---3---
 select c.custid,c.companyname,o.orderid,o.orderdate
 from Sales.Orders O
 right join Sales.Customers C on O.custid = C.custid

 ---4---
 select c.custid,c.companyname
 from Sales.Orders O
 right join Sales.Customers C on O.custid = C.custid
 where o.orderid is null


 ---5---
 select c.custid, c.companyname, o.orderid, o.orderdate
 from Sales.Customers C
 join Sales.Orders O on c.custid=o.custid
 where orderdate='20160212' 


 ---6---
 select c.custid, c.companyname, o.orderid, o.orderdate
 from Sales.Customers C
 left join Sales.Orders O on c.custid=o.custid and orderdate='20160212'

 ---7---
 select c.custid, c.companyname,
 case
	when orderid is not null then 'Yes'
	else 'No'
	end AS HasOrderOn20070212
 from Sales.Customers C
 left join Sales.Orders O on c.custid=o.custid and orderdate='20160212'















