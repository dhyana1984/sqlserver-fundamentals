--��@val �� Sales.OrderValues���а�custid������val�ֶε�������ע�⣬������Rank()
DECLARE @val AS NUMERIC(12,2) = 500.00

SELECT 
custid,
COUNT(CASE WHEN val < @val THEN 1 END) + 1 AS rnk
FROM Sales.OrderValues
GROUP BY custid
GO

--��@val �� Sales.OrderValues���а�custid������val�ֶε�������ע�⣬������DENSE_Rank()
DECLARE @val AS NUMERIC(12,2) = 500.00

SELECT 
custid,
COUNT(DISTINCT CASE WHEN val < @val THEN val END) + 1 AS rnk
FROM Sales.OrderValues
GROUP BY custid
GO

--����ÿ���ͻ��ĵ�һ�������������һ���������
WITH C AS
(
	SELECT custid,
	FIRST_VALUE(val) OVER(PARTITION BY custid
						  ORDER BY orderdate,orderid) AS val_firstorder,		--��ÿ���ͻ��ĵ�һ��������Ĭ�Ͽ�ܾ���Range UNBOUNDED PRECEDING				
	LAST_VALUE(val) OVER(PARTITION BY custid
						  ORDER BY orderdate,orderid
						  ROWS BETWEEN CURRENT ROWS 
							   AND UNBOUNDED FOLLOWING) AS val_lastorder,		--��ÿ���ͻ����һ������,��Ĭ�Ͽ�������һ�о��ǵ�ǰ�У����Կ����ҩָ���߽�ΪUNBOUNDED FOLLOWING
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY (SELECT NULL)) AS rownum	    --�Խ��������
	FROM Sales.OrderValues
)
SELECT custid, val_firstorder,val_lastorder
FROM C WHERE rownum =1															--ѡ�������һ�Ľ������Ϊÿ���ͻ���һ�������������һ���������
GO

select * from Sales.OrderValues where custid = 1