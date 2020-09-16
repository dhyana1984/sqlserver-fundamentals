/*
	利用窗口函数求数据岛

*/

create table dbo.T1
(
	col1 int not null
	constraint pk_t1 primary key
)

insert into dbo.T1 (col1)
values(2),(3),(11),(12),(13),(27),(33),(34),(35),(42)
GO


select * from T1 
go

--查询数据岛
with diff as
(
	select 
	col1,
	--要查询的固定列的值和Row_Number值之间的差,通过对差值分组，然后找出组中最大最小值，即为数据岛
	col1 - ROW_NUMBER() over(order by col1) as grp
	from dbo.T1
)
select min(col1) as start_range, max(col1) as end_range
from diff
group by grp

drop table dbo.t1

/*
	利用窗口函数求数据岛

*/	 


/***
	使用Window子句缩写前置查询 
***/

select empid, ordermonth,qty, 
	sum(qty) over w1 as run_sum_qty, 
	avg(qty) over w1 as run_avg_qty, 
	min(qty) over w1 as run_min_qty, 
	max(qty) over w1 as run_max_qty 
from Sales.EmpOrders 
window w1 as 
( 
	partition by empid 
	order by ordermonth 
	rows between unbounded preceding and current row 
) 
