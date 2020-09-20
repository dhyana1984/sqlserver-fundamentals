--求@val 在 Sales.OrderValues表中按custid分组后的val字段的排名，注意，这里是Rank()
DECLARE @val AS NUMERIC(12,2) = 500.00

SELECT 
custid,
COUNT(CASE WHEN val < @val THEN 1 END) + 1 AS rnk
FROM Sales.OrderValues
GROUP BY custid
GO

--求@val 在 Sales.OrderValues表中按custid分组后的val字段的排名，注意，这里是DENSE_Rank()
DECLARE @val AS NUMERIC(12,2) = 500.00

SELECT 
custid,
COUNT(DISTINCT CASE WHEN val < @val THEN val END) + 1 AS rnk
FROM Sales.OrderValues
GROUP BY custid
GO

--返回每个客户的第一个订单金额和最后一个订单金额
WITH C AS
(
	SELECT custid,
	FIRST_VALUE(val) OVER(PARTITION BY custid
						  ORDER BY orderdate,orderid) AS val_firstorder,		--求每个客户的第一个订单，默认框架就是Range UNBOUNDED PRECEDING				
	LAST_VALUE(val) OVER(PARTITION BY custid
						  ORDER BY orderdate,orderid
						  ROWS BETWEEN CURRENT ROWS 
							   AND UNBOUNDED FOLLOWING) AS val_lastorder,		--求每个客户最后一个订单,在默认框架下最后一行就是当前行，所以框架上药指定边界为UNBOUNDED FOLLOWING
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY (SELECT NULL)) AS rownum	    --对结果加排序
	FROM Sales.OrderValues
)
SELECT custid, val_firstorder,val_lastorder
FROM C WHERE rownum =1															--选择排序第一的结果，即为每个客户第一个订单金额和最后一个订单金额
GO

select * from Sales.OrderValues where custid = 1