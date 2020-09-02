---1---
select empid,firstname,lastname,n
from HR.Employees
cross join Nums
where Nums.n<=5


---1-2---
---��20090612��20090616��ÿ����ʾһ������
---Nums����һ��������������,n��nums���ֶ�
---n<=DATEDIFF(day,'20090612','20090616') +1 ͨ����������֮���������������n���Ӷ����ƽ����Χ
---DATEADD(DAY, n-1,'20090612') ��ͨ��n������ÿһ�����ݶ�Ӧ������
select empid,DATEADD(DAY, n-1,'20090612') AS dt 
from HR.Employees
cross join Nums
where n<=DATEDIFF(day,'20090612','20090616') +1
order by dt


---2---
---ע��ȥ���ظ���orderid
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















