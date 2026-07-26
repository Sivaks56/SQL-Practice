create table employee1(
empid int ,
empname varchar(30),
salary decimal(10,2) check(salary > 0)

);

insert into employee1 values (1, 'fathima', 35000);
insert into employee1 values (2, 'geetha', 16000);
insert into employee1 values (3, 'pakavathi', 35000);
insert into employee1 values (4, 'parvathi', 16000);
insert into employee1 values (5, 'Gomathi', 35000);
insert into employee1 values (6, 'manju', 16000);

Begin Transaction

alter table employee1 add Phone varchar(10)not null constraint df_phone default '999999999' ;

select * from employee1
order by empname desc;
select * from employee1 where empid = 5;

select COUNT(empid) As Total_employee
from employee1;

select * from employee1 where salary > 25000;

select * from employee1
order by salary desc;

select MAX(salary) from employee1;

alter table employee1 drop constraint df_employee1_phone;
alter table employee1 drop column Phone1;

commit;

rollback;


