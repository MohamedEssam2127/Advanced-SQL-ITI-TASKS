CREATE RULE loc_rule
AS
@loc IN ('NY','DS','KW');


CREATE DEFAULT loc_default
AS 'NY';

sp_addtype loc ,'nchar(2)' 

sp_bindrule  loc_rule , loc
sp_bindefault    loc_default ,loc

DROP TABLE Department
CREATE  TABLE Department (
    DeptNo CHAR(2) PRIMARY KEY,
    DeptName CHAR(20),
    Location loc
);
select * from Department

create rule salary_rule as @salary < 6000

CREATE TABLE Employee
(
    EmpNo     INT PRIMARY KEY,
    EmpFname  VARCHAR(20) NOT NULL,
    EmpLname  VARCHAR(20) NOT NULL,
    DeptNo    CHAR(2),
    Salary    INT,
    CONSTRAINT FK_Employee_Department
        FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
    CONSTRAINT UQ_Salary UNIQUE (Salary)
);

sp_bindrule salary_rule, 'Employee.Salary'


INSERT INTO Department VALUES
('d1','Research','NY'),
('d2','Accounting','DS'),
('d3','Markiting','KW');

iNSERT INTO Employee VALUES
(25348,'Mathew','Smith','d3',2500),
(10102,'Ann','Jones','d3',3000),
(28559,'Sybl','Moser','d1',2900)


INSERT INTO Works_on VALUES
(11111 ,'p3','Analyst','2007-10-15')
-- conflicted with the FOREIGN KEY
--  smae  conflicted with the FOREIGN KEY 

UPDATE Employee
SET EmpNo = 22222
WHERE EmpNo = 10102;
-- conflicted with the REFERENCE constraint 

ALTER TABLE Employee
ADD TelephoneNumber VARCHAR(15);


ALTER TABLE Employee

DROP COLUMN TelephoneNumber;

create  schema Company 


alter schema Company transfer Department 

create schema Human Resource  

alter schema HumanResource transfer Employee  


select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_SCHEMA, TABLE_NAME 
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where TABLE_NAME = 'Employee'

	CREATE SYNONYM Emp
FOR [HumanResource].Employee;

SELECT * FROM Employee
SELECT * FROM [HumanResource].Employee;
SELECT * FROM Emp;
SELECT * FROM [HumanResource].Emp;

UPDATE p
SET p.Budget = p.Budget * 1.10
FROM[Company].[PROJECT] p
JOIN Works_On w ON p.ProjectNo = w.ProjectNo
JOIN  [HumanResource].Employee e ON w.EmpNo = e.EmpNo
WHERE e.EmpNo = 10102;


UPDATE d
SET d.DeptName = 'Sales'
FROM [Company].Department d
JOIN [HumanResource].Employee e ON d.DeptNo = e.DeptNo
WHERE e.EmpFname = 'James';




UPDATE w
SET w.Enter_Date = '2007-12-12'
FROM Works_On w
join [HumanResource].Employee e ON w.EmpNo = e.EmpNo
JOIN [Company].Department d ON e.DeptNo = d.DeptNo
WHERE w.ProjectNo = 'p1'
  AND d.DeptName = 'Sales';

DELETE w
FROM Works_On w
JOIN [HumanResource].Employee e ON w.EmpNo = e.EmpNo
JOIN [Company].Department d ON e.DeptNo = d.DeptNo
WHERE d.Location = 'KW';






