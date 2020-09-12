---1---
if OBJECT_ID('dbo.customers','u') is not null
drop table dbo.customers

create table dbo.customers
(
	custid int not null primary key,
	companyname nvarchar(40) not null,
	country nvarchar(15) not null,
	region nvarchar(15) null,
	city nvarchar(15) not null
)

---1-1---
insert dbo.customers (custid, companyname, country, region, city)
values(100, 'Coho Winery', 'USA','WA', 'Redmond');

---1-2---
insert dbo.customers
select custid, companyname, country, region, city from sales.Customers


---1-3---
select * into dbo.Orders 
from Sales.Orders 
where orderdate>='20150101' and orderdate <='20171231' 

select * from dbo.Orders

---2---
---删除2015年8月以前的订单，使用output子句返回被删除订单的orderid和orderdate
delete from dbo.Orders
output deleted.orderid, deleted.orderdate
where orderdate <'20150801'

---3---
---删除dbo.Orders表中巴西客户的订单
delete from O ---注意这里是From table的alia
from dbo.Orders O
 join Sales.Customers C on c.custid = o.custid
 where c.country = 'Brazil'


 ---4---
update dbo.customers
	set region = '<None>'
output 
	inserted.custid, 
	deleted.region oldregion, 
	inserted.region newregion
where region is null;

---5---
update O
	set 
		shipcountry = c.country,
		shipregion = c.region,
		shipcity = c.city
from dbo.Orders O
join Sales.Customers c on c.custid = o.custid
where c.country = 'uk'


---使用merge
merge  dbo.Orders  as TGT
using Sales.Customers AS SRC
on TGT.custid = SRC.custid and SRC.country = 'UK'
WHEN MATCHED THEN
	update set
		shipcountry = SRC.country,
		shipregion = SRC.region,
		shipcity = SRC.city;















