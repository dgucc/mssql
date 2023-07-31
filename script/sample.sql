-- Datediff example  

```sql
DECLARE @months INT
SET @months = DATEDIFF(MONTH, CAST('1973-09-23' AS DATETIME), GETDATE())
SELECT 
	CAST('1973-09-23' AS DATETIME) AS birthday
	,GETDATE() AS today
	,CONCAT(
		@months/12
		,' years '
		,@months%12
		,' months'
		) AS age

```
