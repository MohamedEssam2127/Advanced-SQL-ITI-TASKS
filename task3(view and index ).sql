--1
create view  stdAndcourse
as 
select s.st_id , crs_name from  Student  s join stud_course x
on s.st_id = x.st_id  join Course  c on  c.Crs_Id = x.crs_id 
where  x.Grade >50 
---------------------------------------
--2
alter  view  v_Manager_Topics
WITH ENCRYPTION 
as 
select i.ins_name  AS [Manager Name] ,t.Top_Name from Instructor  i join Department d 
on Dept_Manager = Ins_Id  join Ins_Course ic
on ic.ins_id  = i.Ins_Id  join Course c 
on ic.Crs_Id = c.Crs_Id join Topic t
on t.Top_Id = c.Top_Id

select * from v_Manager_Topics

sp_helptext 'v_Manager_Topics'   

------------------------
--3
CREATE VIEW v_java_SD_Instructor 
as
select ins_name ,dept_name from Instructor i join Department d
on d.Dept_Id = i.Dept_Id
where Dept_Name in ('SD','JAVA')

---------------------------------------------------------------
--4
create view V1 
as
select * from Student 
where st_address in ('Alex' , 'Cairo')
with check option 

-----------------------------------------------
-- 5
create view  V_projectName_numofEmp
as
select projectname  , count(e.empNo) as [ num of employees ]  from company.PROJECT  p join  works_on w
on w.ProjectNo = p.ProjectNo join [HumanResource].employee e
on w.EmpNo = e.empNo 
group by projectname

--==========================================
-- 6
create  clustered  index i3  on  Department (manager_hiredate)

--  error can not create anthor  clustered   there is one already (primary key )

--========================================================================================
-- 7

create unique index i_age   on student (st_age)
--   error  ( because the unique constraint applies to existing and new data. ) 

--============================================================================
--8.	Using Merge statement between the following two tables [User ID, Transaction Amount]

CREATE TABLE Daily_Transactions (
    ID INT,
    Amount INT
);
INSERT INTO Daily_Transactions (ID, Amount) VALUES (1, 1000);
INSERT INTO Daily_Transactions (ID, Amount) VALUES (2, 2000);
INSERT INTO Daily_Transactions (ID, Amount) VALUES (3, 1000);



CREATE TABLE Last_Transactions (
    ID INT,
    Amount INT
);

INSERT INTO Last_Transactions (ID, Amount) VALUES (1, 4000);
INSERT INTO Last_Transactions (ID, Amount) VALUES (4, 2000);
INSERT INTO Last_Transactions (ID, Amount) VALUES (2, 10000);

merge   into Last_Transactions as T
using Daily_Transactions as S 
on S.id = T.id
when matched  then
   update 
       set T.amount = s.Amount 
 when not matched  then
    insert 
        values ( s.id ,s.Amount )   ;
        select * from Last_Transactions



--1)	Create view named   “v_clerk” that will display employee#,project#, 
--the date of hiring of all the jobs of the type 'Clerk'.
create view   v_clerk as 
select e.empNo  , w.ProjectNo ,Enter_Date  from HumanResource.Employee  e join works_on w
on w.EmpNo = e.EmpNo 
where w.Job = 'Clerk'

--2)	 Create view named  “v_without_budget” that will display all the projects data 
--without budget
create view  v_without_budget
as 
select * from Company.PROJECT 
where Budget is null 
--3)	Create view named  “v_count “ that will display the project name and the # of jobs in it
create view  v_count as
select projectName  ,count (job)  as [num of jobs ]from Company.PROJECT  p LEFT join works_on  w
on p.ProjectNo = w.ProjectNo 
  group by  projectName 



--4)	 Create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’
--use the previously created view  “v_clerk”

create view  v_project_p2 as 
 select empNo from  v_clerk 
 where ProjectNo ='p2'

--5)	modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 
alter  view v_without_budget as
select * from Company.PROJECT 
where ProjectNo in ('p1','p2')
 
--6)	Delete the views  “v_ clerk” and “v_count”

drop   view v_clerk
drop   view v_count

--7)	Create view that will display the emp# and emp lastname who works on dept# is ‘d2’
create view v_emp_d2 
as
  select   e.EmpNo  , e.EmpLname from HumanResource.Employee e 
  where  e.DeptNo ='d2'

--8)	Display the employee  lastname that contains letter “J”
--Use the previous view created in Q#7

select EmpLname from v_emp_d2
 where EmpLname LIKE '%J%'; 

--9)	Create view named “v_dept” that will display the department# and department name.
create view  v_dept  as
select    DeptNo ,DeptName  from Company.Department

--10)	using the previous view try enter new department data where dept# is
---’d4’ and dept name is ‘Development’

insert into v_dept 
values ('d4' ,'Development' )

--11)	Create view name “v_2006_check” that will display employee#, the project #where he works
--and the date of joining the project which must be from the first of January 
--and the last of December 2006.

CREATE VIEW v_2006_check AS
SELECT e.EmpNo, w.ProjectNo, w.Enter_Date
FROM HumanResource.Employee e
JOIN works_on w ON w.EmpNo = e.EmpNo
JOIN Company.PROJECT p ON p.ProjectNo = w.ProjectNo
WHERE w.Enter_Date BETWEEN '2006-01-01' AND '2006-12-31';
