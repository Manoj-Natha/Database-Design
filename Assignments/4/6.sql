set serveroutput on
DECLARE
thisEmployee Employee%ROWTYPE;
oldSalary Employee.salary%TYPE;
newSalary Employee.salary%TYPE;
CURSOR SalesEmployees IS
SELECT * FROM Employee WHERE DNO IN
(SELECT Department.DNO FROM Department WHERE Dname = 'Sales')
FOR UPDATE;
BEGIN
OPEN SalesEmployees;
LOOP
FETCH SalesEmployees INTO thisEmployee;
EXIT WHEN (SalesEmployees%NOTFOUND);
oldSalary:=thisEmployee.salary;
newSalary:=oldSalary*1.25;
UPDATE Employee SET salary = newSalary
WHERE CURRENT OF SalesEmployees;
END LOOP;
CLOSE SalesEmployees;
END;
.
RUN;