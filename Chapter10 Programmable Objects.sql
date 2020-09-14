--GO支持一个指示要执行批多少次的参数
INSERT INTO dbo,T1 DEFAULT VALUES
GO 100 --执行100次

--临时表
CREATE TABLE #MyOrderTotalsByYear ---一个#号打头
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO #MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM dbo.#MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN dbo.#MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
GO


--全局临时表
CREATE TABLE ##Globals --两个星号打头
(
  id  sysname     NOT NULL PRIMARY KEY,
  val SQL_VARIANT NOT NULL
);

-- Run from any session
INSERT INTO ##Globals(id, val) VALUES(N'i', CAST(10 AS INT));

-- Run from any session
SELECT val FROM ##Globals WHERE id = N'i';

-- Run from any session
DROP TABLE IF EXISTS ##Globals;
GO


--表变量
DECLARE @MyOrderTotalsByYear TABLE ---和定义其他变量类似
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);
  
  SELECT
  YEAR(O.orderdate) AS orderyear,
  SUM(OD.qty) AS curyearqty,
  LAG(SUM(OD.qty)) OVER(ORDER BY YEAR(orderdate)) AS prvyearqty
FROM Sales.Orders AS O
  INNER JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY YEAR(orderdate);
GO



---表类型
CREATE TYPE dbo.OrderTotalsByYear AS TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);
GO

-- Use table type
DECLARE @MyOrderTotalsByYear AS dbo.OrderTotalsByYear;

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT orderyear, qty FROM @MyOrderTotalsByYear;
GO




---根据生日日期和事件日期返回年龄
DROP FUNCTION IF EXISTS dbo.GetAge;
GO

CREATE FUNCTION dbo.GetAge
(
  @birthdate AS DATE,
  @eventdate AS DATE
)
RETURNS INT
AS
BEGIN
  RETURN
    DATEDIFF(year, @birthdate, @eventdate)
    - CASE WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
              < 100 * MONTH(@birthdate) + DAY(@birthdate)
           THEN 1 ELSE 0
      END;
END;
GO


---调用存储过程输出多个结果
DROP PROC IF EXISTS Sales.GetCustomerOrders;
GO

CREATE PROC Sales.GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT   ---输出参数
AS
SET NOCOUNT ON; --禁止“xxx行受影响”的提示消息

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;

SET @numrows = @@rowcount; --给输出参数获赋值
GO

--调用存储过程
DECLARE @rc AS INT;

EXEC Sales.GetCustomerOrders
  @custid   = 1, -- Also try with 100
  @fromdate = '20150101',
  @todate   = '20160101',
  @numrows  = @rc OUTPUT;   --给输出参数赋值，@rc是定义的新变量，等待output

SELECT @rc AS numrows;  --获取输出值
GO