--1.	Create a stored procedure without parameters to show the
--number of students per department name.[use ITI DB] 
create proc  GetStudentCountPerDept
 as 
    select d.Dept_Name ,count(st_id) as [num of student]  from Department d join Student s
    on d.Dept_Id  = s.Dept_Id
    group by Dept_Name

    GetStudentCountPerDept
    
    
    --2.	Create a stored procedure that will check for the # of employees 
--in the project p1 if they are more than 3 print message to the user 
--“'The number of employees in the project p1 is 3 or more'” if they are less 
--display a message to the user “'The following employees work for the project p1'”
--in addition to the first name and last name of each one. [Company DB] 

 create proc numOFemployeeInP1
 as 
    if (select count(essn) from Works_for  where pno = 100 ) >3
        select 'The number of employees in the project p1 is 3 or more'
     else 
        begin 
             select 'The following employees work for the project p1'
             select fname ,lname from employee join works_for on ssn = essn
             where pno = 100 
        end 

        numOFemployeeInP1

--3.	Create a stored procedure that will be used in case 
--there is an old employee has left the project and a new one become 
--instead of him. The procedure should take 3 parameters
--(old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_on table. [Company DB]

alter  proc replaceEmployee  @oldId  int , @newId int  , @pid int 
as 
  if     (  EXISTS (select * from Employee where ssn = @newId) 
            and EXISTS( select * from Works_for   where   essn =  @oldId and Pno = @pid ) )
        begin
             delete  Works_for where essn= @oldId and Pno = @pid 
             insert into  Works_for 
             values ( @newId , @pid ,0 ) 
        end
    else 
      select ' error '
  
   replaceEmployee 112233,968574,100   


   -- 4 
  -- This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--Note: This process will take place only if the 
  --User updated the budget column

  alter TRIGGER tr_1
ON project
AFTER UPDATE
AS
    IF UPDATE(budget)
    BEGIN
        INSERT INTO audit (ProjectNo , username, ModifiedDate , Budget_old, Budget_New )
        SELECT
            i.pnumber,
            SUSER_NAME(),
            GETDATE(),
            d.budget,
            i.budget
        FROM inserted i
        JOIN deleted d
            ON i.pnumber = d.pnumber;
    END


    -- try 
       update  Project
        set budget = 888888
        where pnumber=100 
  
  -- 5.	Create a trigger to prevent anyone from inserting a 
  ---new record in the Department table [ITI DB]
   ---“Print a message for user to tell him that he can’t insert a new record in that table”
   create trigger tr_2
   on department
     instead of insert 
     as
        select 'can’t insert a new record in that table' 
       
 -- 6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
 CREATE TRIGGER TR_3
ON Employee
instead  of  INSERT
As
    IF FORMAT(GETDATE(), 'MMMM') = 'March'
        SELECT 'NOT ALLOWED TO INSERT THIS MONTH'
    ELSE
    BEGIN
        INSERT into Employee (fname, lname , ssn, Bdate , Address , sex , salary , Superssn , Dno )
        select fname, lname , ssn, Bdate , Address , sex , salary , Superssn , Dno
        from inserted;
    end

--7.	Create a trigger on student table after insert to add Row in Student Audit table 
--(Server User Name , Date, Note) 
--where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”

CREATE TRIGGER tr_99
ON Student
after INSERT
as
    insert into  Student_Audit ([Server User Name], Date, Note)
    SELECT 
        SUSER_NAME(), GETDATE(), 
        CONCAT(SUSER_NAME(), ' Insert New Row with Key=', i.St_Id, ' in table Student')
    from inserted i;

-- 8 
  create trigger tr_444
on Student
instead of Delete
as
    insert into Student_Audit
    select 
        SUSER_NAME(),GETDATE(), concat('try to delete Row with Key=', d.St_Id) as Note
    from deleted d;

    delete Student   where st_id = 10 


   