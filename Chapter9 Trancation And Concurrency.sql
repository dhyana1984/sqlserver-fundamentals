--查询锁相关的session情况，根据wait status来判断是否有session被锁死
SELECT -- use * to explore
  request_session_id            AS sid,
  resource_type                 AS restype,
  resource_database_id          AS dbid,
  DB_NAME(resource_database_id) AS dbname,
  resource_description          AS res,
  resource_associated_entity_id AS resid,
  request_mode                  AS mode,
  request_status                AS status
FROM sys.dm_tran_locks;

--查相关的表
SELECT  *
FROM sys.objects  
WHERE name = OBJECT_NAME(709577566) --709577566是涉及wait状态的resourceid

--根据session id 查询connection情况
SELECT -- use * to explore
  session_id AS sid,
  connect_time,
  last_read,
  last_write,
  most_recent_sql_handle
FROM sys.dm_exec_connections
WHERE session_id IN(52, 55);

--使用  CROSS APPLY sys.dm_exec_sql_text 函数来处理sys.dm_exec_connections表查询到每一行的most_recent_sql_handle，得到阻塞链中涉及的每个连接调用的最后一个批代码
--因为阻塞者可能继续工作，此时看到的最后的事情不一定是导致问题的语句
SELECT session_id, text 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST 
WHERE session_id IN(52, 55);

---获取event info，阻塞连接发生阻塞时详细sql语句
SELECT session_id, event_info 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_input_buffer(session_id, NULL) AS IB 
WHERE session_id IN(52, 55);



---查询阻塞情况中涉及会话的更多有用信息，包括主机名，登录名，winNT用户名等等
SELECT -- use * to explore
  session_id AS sid,
  login_time,
  host_name,
  program_name,
  login_name,
  nt_user_name,
  last_request_start_time,
  last_request_end_time
FROM sys.dm_exec_sessions
WHERE session_id IN(52, 55);


-- 查询block请求
--可以清晰得到block session id和被block session id
SELECT -- use * to explore
  session_id AS sid,
  blocking_session_id,
  command,
  text,
  event_info,
  sql_handle,
  database_id,
  wait_type,
  wait_time,
  wait_resource
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS ST 
CROSS APPLY sys.dm_exec_input_buffer(session_id, NULL) AS IB 
WHERE blocking_session_id > 0;
```

* 设置会话等待锁时间

```sql
--SET LOCK_TIMEOUT 5000 --设置等待超时时间为5秒
SET LOCK_TIMEOUT -1 --设置等待超时时间为无期限 

SELECT *
FROM Production.Products
WHERE productid = 2