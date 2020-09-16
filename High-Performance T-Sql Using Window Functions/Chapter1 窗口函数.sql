/*
	���ô��ں��������ݵ�

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

--��ѯ���ݵ�
with diff as
(
	select 
	col1,
	--Ҫ��ѯ�Ĺ̶��е�ֵ��Row_Numberֵ֮��Ĳ�,ͨ���Բ�ֵ���飬Ȼ���ҳ����������Сֵ����Ϊ���ݵ�
	col1 - ROW_NUMBER() over(order by col1) as grp
	from dbo.T1
)
select min(col1) as start_range, max(col1) as end_range
from diff
group by grp

drop table dbo.t1

/*
	���ô��ں��������ݵ�

*/	 


/***
	ʹ��Window�Ӿ���дǰ�ò�ѯ 
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
