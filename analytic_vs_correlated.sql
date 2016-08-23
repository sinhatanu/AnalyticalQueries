--EXEC DBMS_STATS.GATHER_TABLE_STATS(USER,'emp_test',CASCADE=>true); -- gathering table statistics to generate most optimal plan
--Finding Running Total by Correlated Query and checking the plan
EXPLAIN PLAN FOR
SELECT e1.employee_id,e1.salary,(select sum(salary)from emp_test e2 where e2.employee_id <= e1.employee_id)cum_sal
FROM emp_test e1 ORDER BY employee_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--Finding Running Total by Analytic Query and checking the plan
EXPLAIN PLAN FOR
SELECT employee_id,salary,sum(salary) OVER (ORDER BY employee_id)cum_sal FROM EMPLOYEES ORDER BY employee_id; 

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--PLAN TABLE O/P FOR BOTH QUERIES.THE ANALYTIC QUERY HAS MUCH LESS COST, READ VERY LESS ROWS AND RUNS FASTER THAN THE
--CORRELATED QUERY

/*plan FOR succeeded.
PLAN_TABLE_OUTPUT                                                                                                                                                                                                                                                                                          
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 4191633369                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                             
---------------------------------------------------------------------------------------                                                                                                                                                                                                                      
| Id  | Operation          | Name     | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |                                                                                                                                                                                                                      
---------------------------------------------------------------------------------------                                                                                                                                                                                                                      
|   0 | SELECT STATEMENT   |          | 20000 |   156K|       |    88   (3)| 00:00:02 |                                                                                                                                                                                                                      
|   1 |  SORT AGGREGATE    |          |     1 |     8 |       |            |          |                                                                                                                                                                                                                      
|*  2 |   TABLE ACCESS FULL| EMP_TEST |  1000 |  8000 |       |    13   (0)| 00:00:01 |                                                                                                                                                                                                                      
|   3 |  SORT ORDER BY     |          | 20000 |   156K|   328K|    88   (3)| 00:00:02 |                                                                                                                                                                                                                      
|   4 |   TABLE ACCESS FULL| EMP_TEST | 20000 |   156K|       |    13   (0)| 00:00:01 |                                                                                                                                                                                                                      
---------------------------------------------------------------------------------------                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                             
Predicate Information (identified by operation id):                                                                                                                                                                                                                                                          
---------------------------------------------------                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                             
   2 - filter("E2"."EMPLOYEE_ID"<=:B1)                                                                                                                                                                                                                                                                       

 16 rows selected 

plan FOR succeeded.
PLAN_TABLE_OUTPUT                                                                                                                                                                                                                                                                                          
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1919783947                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                             
--------------------------------------------------------------------------------                                                                                                                                                                                                                             
| Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |                                                                                                                                                                                                                             
--------------------------------------------------------------------------------                                                                                                                                                                                                                             
|   0 | SELECT STATEMENT   |           |   108 |   864 |     3   (0)| 00:00:01 |                                                                                                                                                                                                                             
|   1 |  WINDOW SORT       |           |   108 |   864 |     3   (0)| 00:00:01 |                                                                                                                                                                                                                             
|   2 |   TABLE ACCESS FULL| EMPLOYEES |   108 |   864 |     3   (0)| 00:00:01 |                                                                                                                                                                                                                             
--------------------------------------------------------------------------------                                                                                                                                                                                                                             

 9 rows selected 
*/

