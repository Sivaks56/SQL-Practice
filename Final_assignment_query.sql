select * from Employee_Details
select * from Departments
--alter table Employee_Details Drop column city, age

alter table Employee_Details Drop column Department;
alter table Employee_Details add DeptID int;

update Employee_Details 
set DeptID = Case(EmpID % 6)
    When 1 Then 10
	When 2 Then 20
	When 3 Then 30
	When 4 Then 40
	When 5 Then 50
	When 0 Then 80
 End;

 --1. Display all employees with their department names. Include employees without a department.

select E.Name, D.DeptName from Employee_Details E
left join Departments D
on E.DeptID = D.DeptID

.--2 Find the top 3 highest-paid employees in each department using a window function.
select * from Employee_Details
select * from Departments

with fv as(
 select ER.Name, DR.DeptName,ER.Salary, Row_number() over(partition by ER.DeptID order by ER.Salary desc) as r_u
 from Employee_Details ER join Departments DR
 on ER.DeptID = DR.DeptID
 )

 select * from fv
 where r_u <= 3;

 with fv1 as(
 select ER.Name, DR.DeptName,ER.Salary, Row_number() over(partition by ER.DeptID order by ER.Salary desc) as r_i,
 Dense_rank() over(partition by ER.DeptID order by ER.Salary desc) as rnk
 from Employee_Details ER join Departments DR
 on ER.DeptID = DR.DeptID
 )

 select * from fv1
 where rnk <= 3;



. --3 Display departments whose average salary is greater than 60,000.

--joins
select vb.Name, vn.DeptName, avg(vb.Salary) as av_salary from Employee_Details vb
join Departments vn
on vb.DeptID = vn.DeptID
group by vb.Name, vn.DeptName
Having avg(vb.Salary) > 60000
order by av_salary;

--subquery
select deptID, avg(Salary) from Employee_Details
group  by DeptID
Having avg(Salary) > 60000

select DF.DeptName, EF.av_salry from Departments DF
join (select deptID,avg(Salary) as av_salry from Employee_Details 
group  by DeptID
Having avg(Salary) > 60000) EF
on EF.deptID = DF.deptID


--4 Find employees whose salary is greater than the average salary of their own department.
--own department means department = department

select * from Employee_Details
select * from Departments

select EmpID,Name,Salary,DeptID from Employee_Details Ec
where Salary > (select AVG(Salary) from Employee_Details
where DeptID = Ec.DeptID
)


--5  Display the second highest salary in the Employee table without using TOP 2.
 
 with dc as (select Salary , DENSE_RANK() over(order by Salary desc) as rn2
 from Employee_Details) 
 select Salary from dc
 where rn2 = 2


--6 Write a query to remove duplicate employee records using ROW_NUMBER() (assume
--duplicates exist).

with cvb as (
select EmpID,Name,ROW_NUMBER() over (partition by Name order by EmpID) as rown from Employee_Details
)

Delete from cvb where rown > 1

select * from cvb
order by EmpID


--7 Create a CTE that calculates total salary for each department and display only departments with
--total salary greater than 300,000.
select * from Employee_Details
select * from Departments


with cx as (
select FM.DeptID,XF.DeptName, sum(Salary) as totalsalary from Employee_Details FM
join Departments XF
on FM.DeptID = XF.DeptID
group by FM.DeptID,XF.DeptName
)

select DeptID, DeptName,totalsalary from cx where totalsalary > 300000

--8 Display customers who have placed more than three orders and show their total order value.
  select * from [SalesLT].[Customer]
  select * from [SalesLT].[SalesOrderHeader]

  select C.CustomerID,C.FirstName,C.LastName, count(OD.SalesOrderID) as Totalorders, sum(OD.TotalDue) as Totalorder_value
  from [SalesLT].[Customer] C
  join [SalesLT].[SalesOrderHeader] OD
  on C.CustomerID = OD.CustomerID
  Group by C.CustomerID,C.FirstName,C.LastName
  Having count(OD.SalesOrderID) > 3





--9 . Create a stored procedure that accepts a DepartmentID and returns all employees in that
--department ordered by salary descending.

select * from Employee_Details
select * from Departments

create procedure DBI1 @DeptID int
as begin
   select EmpID,Name,Salary
   from Employee_Details
   where DeptID = @DeptID
   order by Salary desc;

end;

exec DBI1 @DeptID = 10;


--10 Create an AFTER INSERT trigger that stores the inserted EmployeeID, action ('Employee
--Inserted'), and current date into an EmployeeAudit table.


create table EmployeeAudit(   -- This table for see triggers
  EmpID int,
  auditaction varchar(30),
  actiondate Date

);

create Trigger cbn on Employee_Details
after insert
-- or  after delete
--or  after update
as 
begin
     insert into EmployeeAudit( EmpID,auditaction, actiondate)
	 select EmpID,'Employeeinserted', GETDATE() from inserted;
end;


  insert into Employee_Details values (203,'baanu',30000,32,'chennai',2,2000,'2018-03-23',30);


  select * from EmployeeAudit; -- see Trigger after insert


