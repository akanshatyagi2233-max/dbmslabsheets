CREATE DATABASE CollegeJoinDB;
USE CollegeJoinDB;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50)
);

CREATE TABLE SalaryGrades (
    Grade CHAR(2) PRIMARY KEY,
    MinSalary DECIMAL(10,2),
    MaxSalary DECIMAL(10,2)
);

INSERT INTO Departments VALUES
(10, 'Computer Science', 'Block A'),
(20, 'Pharmacy', 'Block B'),
(30, 'Management', 'Block C'),
(40, 'Civil Engineering', 'Block D');

INSERT INTO Employees VALUES
(101, 'Aarav', 10, 65000, 'Delhi'),
(102, 'Priya', 20, 72000, 'Mumbai'),
(103, 'Rahul', 10, 48000, 'Delhi'),
(104, 'Sneha', 30, 91000, 'Pune'),
(105, 'Vikram', 20, 55000, 'Jaipur'),
(106, 'Neha', 50, 80000, 'Bengaluru'),
(107, 'Kabir', 30, 43000, 'Pune');

INSERT INTO SalaryGrades VALUES
('G1', 0, 49999),
('G2', 50000, 69999),
('G3', 70000, 89999),
('G4', 90000, 120000);

-- Q1. Basic Inner Join Display employee names, department names, and department loca ons for employees with matching departments. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Departments.DeptName, Departments.Location 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID;

-- Q2. Employee and Department IDs Use INNER JOIN to display EmpID, EmpName, DeptID, and DeptName.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpID, Employees.EmpName, Employees.DeptID, Departments.DeptName 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID;

-- Q3. Pharmacy Employees Use INNER JOIN and WHERE to display employees belonging to the Pharmacy department.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.* 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
WHERE Departments.DeptName = 'Pharmacy';

-- Q4. Salary Filter Display matched employees whose salary is greater than 60000.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.* 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
WHERE Employees.Salary > 60000;

-- Q5. Equi Join Perform an Equi Join between Employees and Departments using DeptID = DeptID. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT * FROM Employees, Departments 
WHERE Employees.DeptID = Departments.DeptID;

-- Q6. Equi Join with Mul ple Columns Display employee name, employee city, department name, and department loca on using an equalitybased join. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Employees.City, Departments.DeptName, Departments.Location 
FROM Employees, Departments 
WHERE Employees.DeptID = Departments.DeptID;

-- Q7. Computer Science Find all employees belonging to Computer Science using an equality-based INNER JOIN.
--  SQL Command: ______________________________________________ 
--  Output / Observation: _______________________________________ 

SELECT Employees.* 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
WHERE Departments.DeptName = 'Computer Science';

-- Q8. Theta Join – Greater Than Use a Theta Join to display employees whose salary is greater than a salary grade's minimum salary. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Employees.Salary, SalaryGrades.Grade, SalaryGrades.MinSalary 
FROM Employees 
JOIN SalaryGrades ON Employees.Salary > SalaryGrades.MinSalary;

-- Q9. Theta Join – Salary Range Assign each employee to the correct salary grade using >= and <= in the join condi on.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Employees.Salary, SalaryGrades.Grade 
FROM Employees 
JOIN SalaryGrades ON Employees.Salary >= SalaryGrades.MinSalary AND Employees.Salary <= SalaryGrades.MaxSalary;

-- Q10. Theta Join – Less Than Display employee names and salary grades where employee salary is less than the grade maximum salary. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT Employees.EmpName, SalaryGrades.Grade 
FROM Employees 
JOIN SalaryGrades ON Employees.Salary < SalaryGrades.MaxSalary;

-- Q11. Theta Join – Greater Than or Equal Display employee name, salary, and grade where employee salary is >= the grade minimum.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Employees.Salary, SalaryGrades.Grade 
FROM Employees 
JOIN SalaryGrades ON Employees.Salary >= SalaryGrades.MinSalary;

-- Q12. Natural Join Use NATURAL JOIN to display employee names, DeptID, and department names. Do not write an ON condi on. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT EmpName, DeptID, DeptName 
FROM Employees 
NATURAL JOIN Departments;

-- Q13. Natural Join with Filter Using NATURAL JOIN, display employees belonging to the department located in Block B.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT * 
FROM Employees 
NATURAL JOIN Departments 
WHERE Location = 'Block B';

-- Q14. Natural Join with Salary Using NATURAL JOIN, display employee name, department name, and salary for salaries >= 70000. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 


SELECT EmpName, DeptName, Salary 
FROM Employees 
NATURAL JOIN Departments 
WHERE Salary >= 70000;

-- Q15. Inner Join + ORDER BY Display matched employee name, department, and salary sorted from highest salary to lowest. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Departments.DeptName, Employees.Salary 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
ORDER BY Employees.Salary DESC;

-- Q16. DISTINCT Departments Display dis nct department names that have at least one matching employee. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT DISTINCT Departments.DeptName 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID;

-- Q17. Employee Count Use INNER JOIN, GROUP BY, and COUNT to show the number of employees in each matched department.
--  SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT Departments.DeptName, COUNT(Employees.EmpID) AS Employee_Count 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
GROUP BY Departments.DeptName;

-- Q18. Average Salary Use INNER JOIN and GROUP BY to calculate average salary for each matched department. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________  

SELECT Departments.DeptName, AVG(Employees.Salary) AS Average_Salary 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
GROUP BY Departments.DeptName;

-- Q19. HAVING Show departments whose average employee salary is greater than 60000. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 



SELECT Departments.DeptName, AVG(Employees.Salary) AS Avg_Salary 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
GROUP BY Departments.DeptName 
HAVING AVG(Employees.Salary) > 60000;

-- Q20. Highest Paid Employee Find the highest-paid employee among matched employees and display name, department, and salary. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT Employees.EmpName, Departments.DeptName, Employees.Salary 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
ORDER BY Employees.Salary DESC 
LIMIT 1;

-- Q21. IN Condi on Display employees working in either Computer Science or Pharmacy.
--  SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.* 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
WHERE Departments.DeptName IN ('Computer Science', 'Pharmacy');

-- Q22. Mul ple WHERE Condi ons Display employees from Delhi or Pune whose salary is at least 50000, with department names. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT Employees.*, Departments.DeptName 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
WHERE Employees.City IN ('Delhi', 'Pune') AND Employees.Salary >= 50000;

-- Q23. Matched Rows Observa on Use INNER JOIN to display all matched employees. Observe which employee is excluded because no department has DeptID 50.
--  SQL Command: ______________________________________________ 
--  Output / Observation: _______________________________________ 


SELECT *
FROM Employees
INNER JOIN Departments
ON Employees.DeptID = Departments.DeptID;




-- Q24. Natural Join + GROUP BY Using NATURAL JOIN, count employees in each department. 
-- SQL Command: ______________________________________________
--  Output / Observation: _______________________________________ 

SELECT DeptName, COUNT(EmpID) AS Employee_Count 
FROM Employees 
NATURAL JOIN Departments 
GROUP BY DeptName;

-- Q25. Final Challenge Use an equality-based INNER JOIN to find departments whose total employee salary is greater than 100000. Display department name and total salary. 
-- SQL Command: ______________________________________________ 
-- Output / Observation: _______________________________________ 

SELECT Departments.DeptName, SUM(Employees.Salary) AS Total_Salary 
FROM Employees 
INNER JOIN Departments ON Employees.DeptID = Departments.DeptID 
GROUP BY Departments.DeptName 
HAVING SUM(Employees.Salary) > 100000;