create table orders(
cusid int ,
cusname varchar(30),
amount int 

);

insert into orders values (1, 'fadith', 25000);
insert into orders values (2, 'delli', 25000);
insert into orders values (3, 'sathish', 35000);

update orders set amount = 3000 where cusid = 1

select * from orders;

create table employee1(
empid int ,
empname varchar(30),
salary decimal(10,2) check(salary > 0)

);

insert into employee1 values (1, 'vinoth', 25000);
insert into employee1 values (2, 'vinothini', 26000);

update employee1  set salary  = 3000 where empid = 2

select * from employee1;