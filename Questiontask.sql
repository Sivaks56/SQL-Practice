select * from Employee_Details;

select Department, COUNT(EmpID)as Totalemployee, AVG(Salary) as avsalary, SUM(bonus) as Totalbonus
from Employee_Details
where (City = 'Chennai' or city = 'Bengaluru') and Bonus is not null
group by Department
having COUNT(EmpID) >= 3
and AVG(Salary) > 65000
order by Totalbonus desc