Create Table Employee(
EmpID int,
EmpName varchar(50),
DeptID int,
Salary Decimal(10,2)
);

insert into Employee values (1,'siva',20,75000);
insert into Employee values (2,'Bala',21,15000);
insert into Employee values (3,'vimal',22,25000);
insert into Employee values (4,'Tricha',23,150000);
insert into Employee values (5,'Gayathri',24,85000);
insert into Employee values (6,'Divya',27,95000);

select * from Employee;

Create Table Department1(

DeptID int,
DepartmentName Varchar(50),
Location Varchar(50)
);

insert into Department1 values (20,'IT','Chennai');
insert into Department1 values (21,'HR','Benaluru');
insert into Department1 values (22,'Accounts','vellore');
insert into Department1 values (23,'Billing','avadi');
insert into Department1 values (24,'Developer','kolatur');
insert into Department1 values (28,'Developer','Egmore');
insert into Department1 values (30,'IT','Chennai');
select * from Department1;





select EmpName, DepartmentName
from Employee E
Join Department1 D
on E.DeptID = D.DeptID
order by EmpName;

select E1.EmpName, D1.DepartmentName, E1.Salary
from Employee E1
Join Department1 D1
on E1.DeptID = D1.DeptID
where Location = 'Chennai' and Salary > 60000
order by Salary Desc;

select EmpName, DepartmentName
from Employee E
Left Join Department1 D
on E.DeptID = D.DeptID
order by EmpName;

select E.EmpName, D.DepartmentName as Dft
from Employee E
Right Join Department1 D
on E.DeptID = D.DeptID
order by Dft ;

select DepartmentName, count(EmpID) as TotalEmployee, sum(Salary) as Total_salary, AVG(Salary) as avSalary
from Employee E
Join Department1 D
on E.DeptID = D.DeptID
where Salary > 50000
Group by DepartmentName
having count(EmpID) >= 2
order by Total_salary desc;

select * from Employee where Salary > 50000;


select E.EmpName,DepartmentName,Salary,count(EmpID) as TotalEmployee
from Employee E
Join Department1 D
on E.DeptID = D.DeptID
where Salary > 50000
Group by DepartmentName, E.EmpName,Salary

select E.EmpName,DepartmentName,sum(Salary) as TotalSalary,count(EmpID) as TotalEmployee
from Employee E
Join Department1 D
on E.DeptID = D.DeptID
Group by DepartmentName, E.EmpName


