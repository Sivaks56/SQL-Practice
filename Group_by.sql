
select * from Employee_Details;

select Department , COUNT(*) as Total_Employee , AVG(Salary) as avsalary
from Employee_Details
where Salary > 10000
Group by Department
having COUNT(*) > 2
order by avsalary;


select COUNT(*) as Total_Employee from Employee_Details;

---where operator 
-- % modulus
select * from Employee_Details
where Name Like 'A%'; -- It will select only starting letter A

select * from Employee_Details
where Bonus is Not null; -- it will only show amount without Null value

select * from Employee_Details
where Bonus is null; -- it will show only null value

select * from Employee_Details
where City in('Mumbai','Delhi','Pune'); -- it will filter multiple Location

select * from Employee_Details
where Salary Between 30000 and 60000;

select * from Employee_Details
where Not Department = 'Sales'; -- it will filter except Sales

select * from Employee_Details
where Department = 'HR' and Salary < 30000;

select * from Employee_Details
where Department = 'HR'or Department = 'IT'; -- shows rows if any one condition is true

select * from Employee_Details
where  Department Not in ('IT', 'HR'); ---it will all values except  IT and hR

select * from Employee_Details
where  Department <> 'HR'; --it will all values except hR

select * from Employee_Details
where  Salary > 30000;

select * from Employee_Details
where  Salary >= 30000;

select Department, MAX(Salary) as Highestsalary
from Employee_Details
where Salary > 25000
Group by Department
Having MAX(Salary) > 50000
order by Highestsalary Desc;

select Department, Min(Salary) as Lowestsalary
from Employee_Details
where BONUS IS NOT NULL
Group by Department
Having Min(Salary) > 15000
order by Lowestsalary Desc;

select City, count(EmpID) as Total_Employee -- how many employees there in hr department city wise
from Employee_Details
where Department = 'HR'
Group by City
Having count(EmpID) >= 1
order by City Desc;
