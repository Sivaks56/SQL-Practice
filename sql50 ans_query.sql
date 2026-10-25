---1. Find duplicate records in a table

 select employee_id, employee, count(*) as empcount from Employee
 group by  employee_id, employee
 having count(*) > 1


 ---2. Retrieve the second highest salary
 select * from Employee
  select * from Department
  select * from Products
  select * from Sales
 select max(Salary) from Employee
 where Salary < (select max(Salary) from Employee)

 
 ---3. Find employees without a department (LEFT JOIN) 
  select E.* from Employee E
  left join Department D on E.department_id = D.department_id 
  where D.department_id  is null

  ---4. Total revenue per product
   select S.product_id, sum(S.quantity * S.price) as Total_revenue from Sales S
   join Products P
   on S.product_id = P.product_id
   group by S.product_id

   --5. Top 3 highest-paid employees
     select Top 3 * from Employee order by Salary desc

   --6.Count of orders per customer
     select customer_id, count(*) as customer_count from Orders
	 group by customer_id
	--7.Employees who joined in 2023 (fixed – index friendly)
	select * from Employee
	where hire_date >= '2023-01-01' and hire_date < '2024-01-01';

	--8.Average order value per customer
	select * from Orders
	select customer_id, avg('total_amount') as Average_order from Orders
	group by  customer_id;

	---9.Latest order placed by each customer
	select customer_id, Max('order_date') as latest_order from Orders
	group by customer_id 

	---10.Products that were never sold

	select P.product_id from Products P
	left join Sales S
	on S.product_id = P.product_id
	where P.product_id is null

	select * from Products
  select * from Sales
   select * from Orders

  ---11.Most selling product
  select top 1 with ties product_id, sum(quantity) as total_qty
  from Sales
  group by product_id
  order by total_qty desc 

  ----12.Total revenue and number of orders per region
     select region, sum(total_amount) as Total_revenue, count(*) as orders_count from Orders
	 group by region 

-----13.Count customers who placed more than 5 orders
     select customer_id, count(*) as customer_count from Orders 
	 group by customer_id
	 having count(*) > 5

----14.Orders above the average order value (fixed wording)
----The PDF's query returns the orders above average; to get the customers, select the distinct customer IDs.
   select * from Orders where total_amount > (select avg(total_amount) from Orders)

   select distinct customer_id from Orders 
   where total_amount > (select avg(total_amount) from Orders)

   ----15.Employees hired on weekends
   select * from Employee where Datepart(weekday hire_date) in (1, 7)
   ----16.Employees with salary between 50,000 and 100,000 (fixed title)
   select * from Employee
   where Salary between 50000 and 100000
   ---16.Monthly sales revenue and order count (fixed column names)
   select format(order_date,'yyyy-mm') month, sum(total_amount) as sales revenue, count(order_id) as order_count
   from Orders 
   group by format(order_date,'yyyy-mm')
   order by month desc

   ----17.Rank employees by salary within each department
   select employee_id, department_id, Salary, rank() over(partition by department_id order by Salary desc) as sl_r
   from Employee
   ---18.First and last order date for each customer
   select customer_id, min(order_date)as first_order_date, max(order_date) as last_order_date
   from Orders
   group by customer_id

   ---19.Top-performing departments by average salary
   select department_id, avg(Salary) as av_salary
   from Employee
   group by department_id
   order by av_salary desc

   --20.Maximum salary difference within each department
   select department_id, max(Salary) - min(Salary) as salary_diff from Employee
   group by department_id

   ---21.Last purchase for each customer with order amount
   with last_pur as (select customer_id, order_id, total_amount, 
   ROW_NUMBER() over(partition by customer_id order by order_date desc) as rn from Orders)

   select customer_id, order_id, total_amount from last_pur
   where rn = 1

   --22.Employees who earn more than their manager (self join)
   select * from Employee

   select e.employee_id, e.salary, m.employee_id as manager_id, m.salary as manager_salary
   from Employee E
   join Employee M
   on e.employee_id = m.employee_id
   where e.salary > m.salary




   --23. Delete duplicate rows but keep one

   with remove_dup as (select *, ROW_NUMBER() over(partition by employee_name order by employee_id desc) as rn from Employee)

   delete from remove_dup where rn > 1

 
   --24.Top 3 salaries in each department
   with df as ( select employee_id,department_id, Salary, DENSE_RANK() over(partition by department_id order by Salary desc) as rj
   from Employee)

   select employee_id,department_id, Salary from df
   where rj <= 3

   --25.Employees earning more than their department's average salary
   select * from Employee e1
   where Salary > (select avg(e2.Salary) from Employee e2 where e1.department_id = e2.department_id)
   

   --26.Nth highest salary (example: 3rd)

   with df as ( select Salary, DENSE_RANK() over(order by Salary desc) as rn
   from employee
   select Salary from df where Salary = 3


   ---27.Departments with more than 5 employees
   select department_id, count(*) as emp_count from employee
   group by department_id
   having count(*)  > 5;


   --28.Running total of order amount per customer
   select customer_id, order_date, total_amount, sum(total_amount) over(partition by customer_id order by total_amount desc) as runing_total
   from Orders 
   

   --29.find the percentage of employee in each department # oru department la ethana employee irukankanu count pannum 2*100/total_employee
   --secound select all department total employee count
     select department_id, count(*) as emp_count, count(*) * 100.0/
	 (select count(*) from employee) as pct from employee
	 group by department_id

	--30.calculate avrage time between two puchuse for each customer
	select * from Orders
	with ete as (select customer_id, order_date,lag(order_date) as pres_date from Orders
	select customer_id, order_date, avg(datediff(day,pres_date,order_date) as avg_gap_days from ete
	where pres_date is not null
	group by customer_id;

	----31.calculate revenue generated fro new customer
	with vf as(select customer_id, min(order_date) as first_order_date
	from Orders

	select sum(o.total_amount) as new_revenue from Orders o	
	join first_order_date as f
	on o.customer_id = f.customer_id
	where o.order_date = f.first_order_date;

	---32.find customer who orders more than the average number of orders per customer
	with customer_ordrs as(select customer_id, count(*) as order_count from orders

	select * from customers
	where order_count > (select avg(order_count) from customers_orders);

	---33.find churned customer(no orders in the last 6 months
	   select customer_id from Orders 
	   group by customer_id
	   having max(order_date) < dateadd(month, -6,getdate())

	---34.calculative cumulative revenue by day
	   select order_date, sum(total_amount) over(order by order_date) as cumulative_revenue 
	   from Orders;	

	 ---35.Retrieve customer who made consecutive purchase (2days)
	    with fg as (order_id, order_date,lag(order_date) over(partition by order_id order by order_date) as pres_order_day
		from orders)

		select order_id, order_date from fg where DATEDIFF(day,pres_order_day,order_Date) = 1

	---36.show product sales distribution(percent of total revenue)
	   with total_revenue as
	   (select sum(quentity * price) as total from sales)
	   select product_id, sum(quentity * price) as revenue,
	   sum(quentity * price) * 100/ total as revenue_pct
	   from sales
	   cross join total_revenue
	   group by product_id, total

	---37.find moving average of sales over the last 3 days
	   select order_date, avg(total_amount) over(order by order_date rows between 2 preceding and current row) as moving_average
	   from Orders

	   select order_date, avg(total_amount) over(order by order_date rows between 2 preceding and current row) as moving_av
	   from orders


	 ---38.find customer who placed orders everymonth in 2023
	     select customer_id from orders
		 where YEAR(order_date) = 2023
		 group by customer_id
		 having count(distinct FORMAT(order_date,'yyyy-mm')) = 12

	----39.detect customer whose purchase amount is highest than their historical 90th percentile
	     with rl as (customer_id,order_id,total_amount, ntile(10) over(partition by customer_id order by total_amount)
		 as decile from Orders)

		 select customer_id,order_id,total_amount from rl
		 where decile = 10

		 
----40.Find employees whose salary is greater than the average salary.
       with AG as (select avg(salary) as avg_salary from employee)

	   select emp_name,salary,avg_salary from emoployee e
	   cross join AG a
	   where e.salary > a.avg_sal

	   ---normal method

	   select emp_name, salary from employee
	   where Salary > (select avg(salary) from employee)

	  

	
	----morequestion
	---find the secound highest salary in employee table
select max(salary) as highest_sal from employee where salary < (select max(salary) from employee )

----find employee who earn more than Gokul
select employee_name, salary from employee  where salary > (select salary from employee where employee_name = 'Gokul')
-----find employee earning more than their department average salary
   select * from employee e1 where salary > (select avg(salary) from employee e2 where e1.department_id = e2.department_id)
   --secound method
   with cte as (select department_id, avg(salary) as av_sl from employee
               group by department_id) --this is department av_salary

	select employee_name,department,salary,av_sl from employee e1
	join cte e2
	on e1.department_id = e2.department_id
	where salary > av_sl


   select * from employee e1
   join cte e2
   on e1.department_id = e2.department_id

----find employee earning more than IT department average salary
    select * from employee where salary > (select avg(salary) from employee where Department = 'IT')
	

---find the secound highest salary in employee table using windows function
   with cte as (select emp_name,salary, DENSE_RANK() over(order by salary desc) as rn from employee
  
   select emp_name,salary from cte
   where rn = 2

---find the rolling sum of the current day and previous 2 days
  select date, amount,sum(amount)over(order by date rows between 2 preciding and current row) as rolling_sum
  from employeesales  --oovuru row kum previous amount oda amount ta add panni total culculate panrathu

  ---find the cumulative sales total --total ketta sum use pannanum average sale ketta avg(amont)
  select date, amount,sum(amount)over(order by date rows between unbounded preciding and current row) as rolling_sum
  from employee_sales -- rows means take all row between renduthukum idayil unbounded preciding first row la irunthu and current row varaikum
  --- date     amount  rolling_sum
  ---jan 1      100    100
  ----jan 2     200    300
  ---jan 3      300    600

----find the 3 row rolling average of sales
select date ,amount, avg(amount)over(order by date rows between 2 preceding and current row) as roll_av
from employee_sales

---display the previous days' sales amount
    select date, amount, lag(amount,1) over(order by date) as previous_amount
    from employee_sales

--- find the difference between current sales and previous sales
    select date, amount,lag(amount,1) over(order by date) as previous_amount,
	amount - lag(amount,1) over(order by date) as salesdiffrence
	from employeesales

---- display the next days sales amount
     select date, amount, lead(amount 1) over(order by date) as nextamount from employesales
   

   ----self join
    select E.emp_name as emp_name, M.emp_name as emp_name from employee E
	join employee M
	on M.emp_id = E.emp_id
















