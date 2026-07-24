create table Employee(
   EMPID bigint,
   name varchar(50),
   Salary int

);

  insert into Employee values (1011, 'Hari', 35000);

  begin transaction;

  UPDATE Employee set Salary = 25000 where EMPID = 1011;

  commit;

 Rollback;

  select * from Employee;