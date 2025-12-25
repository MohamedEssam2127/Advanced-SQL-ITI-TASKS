CREATE FUNCTION GetMonthName (@d DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN  format(@d,'MMMM')

END;

SELECT dbo.GetMonthName('2025-10-22');


--2
create function betweenTwoNums (@x int, @y int)
RETURNS @t table  (nums int)
AS
BEGIN
    WHILE @x < @y - 1
    BEGIN
        SET @x = @x + 1;
        INSERT INTO @t VALUES (@x);
    END
    RETURN;
end;

SELECT * FROM dbo.betweenTwoNums(1, 5);


--3 
create function getDepartName (@id int )
returns table
as 
   return 
   select dept_name  from Department d join Student s
   on d.dept_id = s.dept_id 
   where s.st_id = @id


   select * from dbo.getDepartName(3)

--4 
   CREATE FUNCTION checkNameNUlls (@id int)
RETURNS VARCHAR(60)
AS
BEGIN
     declare @fname varchar(20)
     declare @lname varchar(20)
     select @fname = st_fname ,@lname  = st_lname 
     from Student where  st_id = @id

     if @fname is null and @lname is null
        return 'First name & last name are null'
     else if @fname is null 
         return 'first name is null'
     else if  @lname is null
         return 'last name is null'
     
    return  'First name & last name are not null'
END;

SELECT dbo.checkNameNulls(1)

--6.5

create function managerDetails (@id int )
returns table
as 
   return 
   select dept_name  ,Manager_hiredate ,   Ins_Name  from Department d join Instructor i
   on d.Dept_Manager= i.Ins_Id 
   where i.Ins_Id = @id


  
  select * from  dbo.managerDetails(2)


  create function getstuds(@format varchar(20))
returns @t table
           (
			sname varchar(20)
		   )
as
	begin
		if @format='first name' 
			insert into @t
			select isnull(St_Fname,'') from Student
		else if @format='last name '
			insert into @t
			select isnull(st_lname,'') from Student
		else if @format='fullname'
			insert into @t
			select   concat(isnull(st_fname,''),'',isnull(st_lname,'')) from Student
		return 
	end
  
  select * from getstuds('first name')

  select st_id , substring(St_Fname , 1, len(st_fname)-1)  from Student

 update  g
 set g.Grade = NULL 
FROM Stud_Course g
JOIN Student s ON  s.St_Id = g.St_Id
JOIN Department d ON s.dept_id = d.dept_id
WHERE d.Dept_Name = 'SD';


