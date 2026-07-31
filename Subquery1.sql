/*============================================================
  SQL JOINS PRACTICE DATABASE
  SQL Server DDL + DML Script
============================================================*/

--------------------------------------------------------------
-- 1. CREATE DATABASE
--------------------------------------------------------------




--------------------------------------------------------------
-- 2. DROP TABLES IF THEY ALREADY EXIST
--------------------------------------------------------------

DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Managers;
DROP TABLE IF EXISTS Departments;
GO


/*============================================================
  3. CREATE TABLES
============================================================*/

--------------------------------------------------------------
-- DEPARTMENTS TABLE
--------------------------------------------------------------

CREATE TABLE Departments
(
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);
GO


--------------------------------------------------------------
-- MANAGERS TABLE
--------------------------------------------------------------

CREATE TABLE Managers
(
    ManagerID INT PRIMARY KEY,
    ManagerName VARCHAR(100) NOT NULL
);
GO


--------------------------------------------------------------
-- EMPLOYEES TABLE
--------------------------------------------------------------

CREATE TABLE Employees
(
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    DeptID INT,
    ManagerID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50),
    JoinDate DATE
);
GO


--------------------------------------------------------------
-- PROJECTS TABLE
--------------------------------------------------------------

CREATE TABLE Projects
(
    ProjectID INT PRIMARY KEY,
    EmpID INT,
    ProjectName VARCHAR(100) NOT NULL,
    ProjectStatus VARCHAR(30)
);
GO


/*============================================================
  4. INSERT DATA
============================================================*/

--------------------------------------------------------------
-- INSERT DEPARTMENTS
--------------------------------------------------------------

INSERT INTO Departments
(
    DeptID,
    DeptName,
    Location
)
VALUES
(10, 'IT',        'Chennai'),
(20, 'HR',        'Mumbai'),
(30, 'Finance',   'Delhi'),
(40, 'Sales',     'Bengaluru'),
(50, 'Marketing', 'Hyderabad'),
(80, 'Legal',     'Pune');
GO


--------------------------------------------------------------
-- INSERT MANAGERS
--------------------------------------------------------------

INSERT INTO Managers
(
    ManagerID,
    ManagerName
)
VALUES
(201, 'Suresh'),
(202, 'Lakshmi'),
(203, 'David'),
(204, 'Farah'),
(206, 'Naveen');
GO


--------------------------------------------------------------
-- INSERT EMPLOYEES
--------------------------------------------------------------

INSERT INTO Employees
(
    EmpID,
    EmpName,
    DeptID,
    ManagerID,
    Salary,
    City,
    JoinDate
)
VALUES
(101, 'Rishi',   10, 201, 75000.00, 'Chennai',   '2022-01-10'),
(102, 'John',    20, 202, 68000.00, 'Mumbai',    '2021-05-15'),
(103, 'Priya',   30, 201, 82000.00, 'Delhi',     '2020-07-20'),
(104, 'Rahul',   40, 203, 55000.00, 'Bengaluru', '2023-03-12'),
(105, 'Sneha',   20, 202, 61000.00, 'Hyderabad', '2022-09-08'),
(106, 'Arun',    50, 204, 90000.00, 'Chennai',   '2019-11-11'),
(107, 'Meena',   60, 205, 70000.00, 'Pune',      '2021-02-17'),
(108, 'Vijay',   30, 201, 78000.00, 'Kolkata',   '2020-12-01'),
(109, 'Karthik', 70, 204, 65000.00, 'Chennai',   '2023-06-21'),
(110, 'Anita',   10, 201, 72000.00, 'Mumbai',    '2022-08-05');
GO


--------------------------------------------------------------
-- INSERT PROJECTS
--------------------------------------------------------------

INSERT INTO Projects
(
    ProjectID,
    EmpID,
    ProjectName,
    ProjectStatus
)
VALUES
(1, 101, 'ERP Implementation',   'Completed'),
(2, 101, 'AI Chatbot',           'In Progress'),
(3, 103, 'Finance Application',  'Completed'),
(4, 105, 'HR Portal',            'In Progress'),
(5, 106, 'Marketing Dashboard',  'Completed'),
(6, 111, 'Legacy Migration',     'Pending');
GO


/*============================================================
  5. VERIFY THE DATA
============================================================*/

SELECT * FROM Departments;
SELECT * FROM Employees;

GO

--alter table Employees Drop column City;
-- subquery

--Q1
select AVG(Salary) from Employees

select EmpName, Salary from Employees
where Salary > (select AVG(Salary) from Employees);

--Q2
select * from Departments where Location ='chennai'

select * from Employees
where DeptID in (select DeptID from Departments where Location ='chennai');

select * from Employees EE
join Departments DE
on EE.DeptID = DE.DeptID
where DE.Location ='chennai';

--Q5
select AVG(Salary) from Employees  where DeptID = DeptID

select EmpName, DeptID, Salary
from Employees E
where Salary > (select AVG(Salary) from Employees  where DeptID = E.DeptID);




select * from Employees;

--Q3

with HighSalaryEmployee as(
     select EmpID, EmpName, Salary
	 from Employees
	 where Salary > 60000

)

select * from HighSalaryEmployee
order by Salary desc;

--Q4
with DepartmentSalary as(
     select DeptID , COUNT(*) as No_Employee , SUM(Salary) as Total_Salary, AVG(Salary) as AvSalary
	 from Employees
	 group by DeptID
)  

select * from DepartmentSalary
where AvSalary > 55000

--Q6

--syntax
--dense_rank() over (partition by department order by Salary desc) meaning of Denserank highestsalary like salary 80,000 rank 1, 70,000 rank 2
-- we need rank 2 means we need to filter using where condition = 2

with Second_salary as(
     select E.EmpID,E.EmpName,E.DeptID, E.Salary, D.DeptName,
	 dense_rank() over (partition by E.DeptID order by E.Salary desc) as Rankno
	 from Employees E
	 join Departments D
	 on E.DeptID = D.DeptID
)

select EmpName, DeptName, Salary from Second_salary 
where Rankno = 2;

SELECT * FROM Departments;
SELECT * FROM Employees;

