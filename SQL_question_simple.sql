--1.Write a query to display EmployeeName, Salary and City for all employees.


select EmpName,Salary,City from Employees 




--2.Write a query to display employees whose Salary is greater than 50,000 and City is 'Chennai'.

select * from employees
where Salary = 50000 and 'Chennai';


--3.Write a query to display all employees sorted by Salary from highest to lowest.

select * from employees
order by Salary desc;



--4.Write a query to find the total number of employees in each DepartmentID.

select DT.DepartmentName, count(*) as no_of_employee from  Employees ED
join Department1 DT
on ED.DeptID = DT.DeptID
group by DT.DepartmentName


--5.Write a query using INNER JOIN to display EmployeeName and DepartmentName.

select E.EmpName, D.DepartmentName from Employees E
join Department1 D
on E.DeptID = D.DeptID

select * from Employees;
select * from Department1;

--6. Write a query using GROUP BY and HAVING to display departments having more than 3 employees.

select DT.DepartmentName, count(*) as no_of_employee from  Employees ED
join Department1 DT
on ED.DeptID = DT.DeptID
group by DT.DepartmentName
having count(*) > 3


--7.Write a query to find employees whose Salary is greater than the average Salary of all employees. Use a subquery.

select * from employees
where Salary > (select avg(Salary) from employees)

--8.Write a query using ROW_NUMBER() to assign a salary rank within each department, with the highest salary getting
--number 1.
with CTD as (
select EF.Salary,DB.DepartmentName, ROW_NUMBER() over(partition by DB.DepartmentName order by EF.Salary desc) as rn from Employees EF
join Department1 DB)

select * from CTD where rn = 1

--9.Write a query using a CTE to calculate total sales for each employee and then display only employees whose total sales
--are greater than 100,000.

with cb as ( select S.customerID, sum(SD.Linetotal) as TotalSales
   from  [SalesLT].[SalesOrderHeader] as S
   join [SalesLT].[SalesOrderDetail] as SD
   on S.SalesOrderID = SD.SalesOrderID
   Group by S.customerID
)

select * from cb where TotalSales > 50000;



--10.For each employee, display EmployeeName, SaleDate, Amount and the previous Sale Amount using LAG(). Also calculate
--the running total of Amount for each employee using a window function.

with ctf as (select SF.CustomerID, SN.LineTotal, SF.OrderDate, 
             LAG(SN.LineTotal) over(partition by CustomerID order by OrderDate) as previous_Sale_Amount,
             sum(SN.LineTotal) over(partition by CustomerID order by OrderDate) as Runing_Total from [SalesLT].[SalesOrderHeader] SF
			 join [SalesLT].[SalesOrderDetail] SN
			 on SF.SalesOrderID = SN.SalesOrderID
)


select * from ctf;