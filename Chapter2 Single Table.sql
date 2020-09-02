select orderid,sum(unitprice * qty) as totalvalue  from Sales.OrderDetails
group by orderid
having sum(unitprice * qty) > 10000
order by totalvalue desc

select * from Sales.Orders

select top 3 shipcountry , avg(freight) avgfreight from Sales.Orders
where orderdate>'20141231' and orderdate <'20160101'
group by shipcountry
order by avgfreight desc


select custid, orderdate, orderid,
ROW_NUMBER() Over ( partition by custid order by orderdate,orderid) rownum
from Sales.Orders 
order by custid, rownum


select
empid,
firstname,
lastname,
titleofcourtesy,
case
when titleofcourtesy='Ms.' or titleofcourtesy='Mrs.' then 'Femail'
when titleofcourtesy='Mr.' then 'Male'
else 'Unknow'
end AS gender
from HR.Employees


---region是null的排在后面，region不是null的排在前面，并且按照region字母排序
select custid,region from Sales.Customers
order by
case when region is null then 1
else 0
end, region








