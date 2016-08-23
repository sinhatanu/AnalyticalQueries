-- Below are the scripts to create a test table and populate it with 20000 records using 'FORALL'
-- This table will be queried using analytical query and a workaround(correlated query)
-- and the performance will be compared


DROP TABLE emp_test;

CREATE TABLE emp_test (
employee_id NUMBER(6,0),
salary NUMBER(8,2) 
);

DECLARE
TYPE IdTab IS TABLE OF emp_test.employee_id%TYPE INDEX BY PLS_INTEGER;
TYPE SalTab IS TABLE OF emp_test.salary%TYPE INDEX BY PLS_INTEGER;
ids IdTab;
sals SalTab;
iterations CONSTANT PLS_INTEGER := 20000;
BEGIN
FOR i IN 1..iterations LOOP -- populate collections
ids(i) := i;
sals(i) := i+100;
END LOOP;
FORALL j IN 1..iterations
INSERT INTO emp_test (employee_id, salary)
VALUES (ids(j), sals(j));
COMMIT;
END;