--1.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 
--and increases it by 20% if Salary >=3000. Use company DB

declare c1 cursor
for select salary from Employee
declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS=0
	begin
		if @sal>=3000
			update Employee
				set Salary=@sal*1.20
			where current of c1
		else if @sal<3000
			update Employee
				set Salary=@sal*1.10
			where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1


--2.	Display Department name with its manager name using cursor. Use


--ITI DB

declare  c1 cursor  
for select d.Dept_Name ,i.Ins_Name from Department d join Instructor  i on d.Dept_Manager = i.Ins_Id 
declare @deptname varchar(30) ,@mangName varchar(30) 
open c1
  fetch c1 into @deptname , @mangName  
  while @@FETCH_STATUS =0
      begin
	      select CONCAT('department ',@deptname ,'  manager: ', @mangName)
	      fetch c1 into @deptname , @mangName 
      end 
close c1
deallocate c1

--3.	Try to display all students first name in one cell separated by comma. Using Cursor 
declare c1 cursor 
for select St_Fname from Student 
for read only
declare @name varchar(20) , @res varchar(400)=''
open c1
   fetch c1 into @name 
   while @@FETCH_STATUS =0 
       begin
	        set @res = concat( @res ,' , ', @name )
		   fetch c1 into @name 
	   end
   select @res 
close c1
deallocate c1

--4.	Create a sequence object that allow values from 1 to 10 without cycling in a 
--specific column and test it.
  Create SEQUENCE MySequence
START WITH 1
INCREMENT BY 1
MinValue 1
MaxValue 10
no CYCLE;

drop 
CREATE TABLE TestTable (
    ID INT,
    Note VARCHAR(50)
);
GO 
insert into TestTable (ID, Note) values (next value for MySequence, ' 1');
INSERT INTO TestTable (ID, Note) values (next value for MySequence, ' 2');
 insert into TestTable (ID, Note) VALUES (next value for MySequence, ' 3');
 INSERT INTO TestTable (ID, Note) VALUES (NEXT value for MySequence, ' 4');
 insert into TestTable (ID, Note) values (next value for MySequence, ' 5');
 insert INTO TestTable (ID, Note) values (next value for MySequence, ' 6');
  insert into TestTable (ID, Note) values (next value for MySequence, ' 7');
 insert INTO TestTable (ID, Note) values (next value for MySequence, ' 8');
 insert into TestTable (ID, Note) values (next value for MySequence, ' 9');
insert INTO TestTable (ID, Note) values (next value for MySequence, ' 10');

INSERT INTO TestTable (ID, Note) values (NEXT VALUE FOR MySequence, ' 11');

SELECT * FROM TestTable;
drop  table TestTable

--5.	Create snapshot of adventureworks_db and test it\

create database snapITI
on
(
 name='AdventureWorks2012_Data',  
 filename='D:\ITI\Db\AdvSQL\snap1.ss'
)
as snapshot of AdventureWorks2012

select * from HumanResources.Employee

--6.	Transform all functions in day2 to Stored Procedures

--6.1
create  proc GetMonthName (@d DATE)
as
BEGIN
    select FORMAT(@d, 'MMMM') AS [Month Name];
end;

exec GetMonthName '2025-10-22';

--6.2
alter proc betweenTwoNums (@x int, @y int)
AS
BEGIN
  declare @t table (num int)
    WHILE @x < @y 
    BEGIN
	    INSERT INTO @t (num) VALUES (@x);
        SET @x = @x + 1;
    END
	select * from @t
end;
betweenTwoNums 2,8

-- 6.3
   alter proc getDepartName_proc (@id int )
  as 
   select dept_name  from Department d join Student s
   on d.dept_id = s.dept_id 
   where s.st_id = @id

   getDepartName_proc 6
  
  -- 6.4

  -- CREATE FUNCTION checkNameNUlls (@id int)
---RETURNS VARCHAR(60)
--AS
--BEGIN
    -- declare @fname varchar(20)
   --  declare @lname varchar(20)
    -- select @fname = st_fname ,@lname  = st_lname 
    -- from Student where  st_id = @id

    -- if @fname is null and @lname is null
    --    return 'First name & last name are null'
    -- else if @fname is null 
      --   return 'first name is null'
    -- else if  @lname is null
    --     return 'last name is null'
     
   -- return  'First name & last name are not null'
---END;

create proc  checkNameNUlls_proc  (@id int )
 as 
      declare @fname varchar(20)
     declare @lname varchar(20)
     select @fname = st_fname ,@lname  = st_lname 
     from Student where  st_id = @id
     if @fname is null and @lname is null
        select 'First name & last name are null'
     else if @fname is null 
         select 'first name is null'
     else if  @lname is null
         select 'last name is null'
      else 
        select  'First name & last name are not null'

       checkNameNUlls_proc 4
   
  --6.5

  create function managerDetails (@id int )
returns table
as 
   return 
   select dept_name  ,Manager_hiredate ,   Ins_Name  from Department d join Instructor i
   on d.Dept_Manager= i.Ins_Id 
   where i.Ins_Id = @id
   
   create proc  managerDetails_proc @id int 
     as  
   select dept_name  ,Manager_hiredate ,   Ins_Name  from Department d join Instructor i
   on d.Dept_Manager= i.Ins_Id 
   where i.Ins_Id = @id

   managerDetails_proc 3
  --6.6

   create proc  getstuds_proc(@format varchar(20))
as
	begin
       declare @t table  (sname varchar(20))
		if @format='first name' 
			insert into @t
			select isnull(St_Fname,'') from Student
		else if @format='last name '
			insert into @t
			select isnull(st_lname,'') from Student
		else if @format='fullname'
			insert into @t
			select   concat(isnull(st_fname,''),'',isnull(st_lname,'')) from Student
		
        select * from @t
	end

      exec getstuds_proc @format = 'first name';


--7.	Create full, differential Backup for SD DB.

-- full backup
backup database AdventureWorks2012
to disk = 'D:\ITI\Db\AdvSQL\AdventureWorks2012.bak'


-- differential 
backup database AdventureWorks2012
to disk = 'D:\ITI\Db\AdvSQL\AdventureWorks2012.bak'
with differential


--8.	Use display student’s data (ITI DB) in excel sheet

select * from Student