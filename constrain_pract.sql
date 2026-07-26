create table Department(
 DeptID int primary key,
 deptname varchar(30) unique
 );

 create table Employee(
 empID int primary key,
 empname varchar(30) unique,
 City varchar(30) default 'chennai'
 );

 create table shop1(
 shopID int primary key,
 shopname varchar(30) Not Null
 );

 create table customer(
 cusID int primary key,
 cusname varchar(30) unique
 );

 create table Amazon(
 orID int primary key,
 productname varchar(30) unique,
 amount decimal(10,2) check(amount > 0)
 );


 -- All constrains
 --Primary key = it will get Unique value only not null
 --Foreign key = it will connect two table
 --unique = No duplicate value
 --Not null = value is compulsary
 --check = we will give condition like age int check (age >= 20)
 --- default = it will take default value automatically


 create table school(
 
 studName varchar(30),
 departmentid int primary key

);

insert into school values ('key',1);
insert into school values ('key1',2);

select * from school;

create table FD(
cusid int primary key ,
cusname varchar(30),
departmentid int
Foreign key (departmentid)
        references school(departmentid)
);

insert into FD values (1, 'df', 1);
insert into FD values (2, 'df1', 2);

select * from FD;