--answer 1 a) 

Select d.DNAME,count(*)
From EMPLOYEE e1, DEPARTMENT d
Where d.DNO=e1.dno AND e1.Dno IN( 
Select e2.Dno
From EMPLOYEE e2
Group by e2.Dno
Having avg(e2.Salary)>30000)
group by d.dname;


--answer 1 b)

Select d.DNAME,count(*)
From EMPLOYEE e1, DEPARTMENT d
Where d.DNO=e1.dno AND sex='M' AND e1.Dno IN( 
Select e2.Dno
From EMPLOYEE e2
Group by e2.Dno
Having avg(e2.Salary)>30000)
group by d.dname;


--answer 1 c)

Select e1.Fname
FROM EMPLOYEE e1
Where e1.dno IN(Select e2.dno 
                From employee e2
                Where e2.salary in ( select max(salary) 
                                      From EMPLOYEE e3)
);

--answer 1 d)

Select e1.Fname
FROM EMPLOYEE e1
Where e1.Salary-10000 >= (select min(Salary)
			      From employee);

				  
--answer 1 e)

select e1.Fname,e1.MINIT,e1.LNAME
from employee e1
where  e1.salary in (
select min(e2.salary)
from employee e2
where e2.dno=e1.DNO) 
and exists (select essn
            from DEPENDENT
            where e1.ssn=essn
            group by ESSN
            having count(*)>1); 
            

--answer 2 a)

create view managers as
select dname,Fname,salary
from department,EMPLOYEE
where ssn=mgrssn;

--answer 2 b)


create view depts as
select d.dname as Department_name, count(distinct e.SSN) as no_of_employee, count(distinct p.PNO) as no_of_projects
from department d, EMPLOYEE e, project p
where e.dno=d.dno and p.dno=d.DNO
group by d.dname;

create view department_info as
select Department_name, Fname,no_of_employee, no_of_projects
from depts,employee,department 
where Department_name=dname and SSN=mgrssn; 


--answer 2 c)

create view prjt as
select p.pname as project_name,p.pno as project_number,count(distinct w.ssn) as no_of_employee,sum(w.hours) as no_of_hours 
from project p, works_on w
where p.pno=w.pno group by p.pname,p.pno;


create view project_info as
select project_name, dname,no_of_employee, no_of_hours 
from prjt,department,PROJECT
where project_number=PROJECT.PNO and PROJECT.DNO =department.DNO; 

--answer 2 d)

create view prjts as
select p.pname as project_name,p.pno as project_number,count(distinct w.ssn) as no_of_employee,sum(w.hours) as no_of_hours 
from project p, works_on w
where p.pno=w.pno and p.pno in ( select p1.PNO
from project p1,works_on w1
where p1.pno=w1.pno
group by p1.PNO
having count(w1.ssn)>1 
)
group by p.pname,p.pno;


create view projects_info as
select project_name, dname,no_of_employee, no_of_hours 
from prjts,department,PROJECT
where project_number=PROJECT.PNO and PROJECT.DNO =department.DNO; 

--answer 2 e)

create view empls as
select ssn as employee_ssn,fname as employee_name,salary as employee_salary,employee.dno as employee_dept_no, mgrssn as manager_ssn
from employee,department
where department.DNO=employee.DNO;

create view mgrs as
select distinct(manager_ssn) as manager_ssn,fname as manager_name,salary as manager_salary
from EMPLOYEE,empls
where ssn=empls.manager_ssn;

create view avg_salary as
select dno as employee_dept_no, avg(salary) as department_avg_salary
from employee
group by dno;

create view employee_info as
select employee_name, employee_salary, empls.employee_dept_no, manager_name, manager_salary, department_avg_salary
from empls,mgrs,avg_salary
where empls.manager_ssn=mgrs.manager_ssn and avg_salary.EMPLOYEE_DEPT_NO=empls.EMPLOYEE_DEPT_NO;


