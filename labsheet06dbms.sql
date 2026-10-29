
use sql_lab;
CREATE TABLE department(
DeptID INT PRIMARY KEY,
DeptName VARCHAR(50) NOT NULL
);
INSERT INTO Department VALUES
(10,'Computer science'),(20,'Information Technology'),
(30,'Pharmacy'),(40,'Managment');
DESC department;
SELECT*FROM department;

CREATE TABLE student(
StudentID INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
Email VARCHAR(100),
Age INT,
DeptID INT,
JoiningDate DATE
);

INSERT INTO student VALUES
(101,'Akansha Tyagi','akansha@email.com',20,10,'2026-07-12'),
(102,'Aman Tyagi','aman@email.com',21,10,'2026-08-11'),
(103,'Ayushi Tyagi','ayushi@email.com',22,20,'2026-07-13'),
(104,'Akshit Tyagi','akshit@email.com',25,20,'2026-09-10');
SELECT*FROM Student;

CREATE TABLE Enrollment(
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseName VARCHAR(100)
);
INSERT INTO Enrollment VALUES 
(1,101,'DBMS'),(2,102,'OPERATING SYSTEM'),
(3,103,'PYTHON'),(4,104,'C++');


INSERT INTO Enrollment VALUES (1,105,'data python');

ALTER TABLE Enrollment
ADD CONSTRAINT fk_Enrollment_student
FOREIGN KEY(studentID)
REFERENCES student(studentID);
INSERT INTO student VALUES (106,'riya','riya@email.com',21,99,'2026-08-01');

SELECT student.studentID, student.Name,
Department.DeptName
FROM student
INNER JOIN Department
ON student.DeptID = Department.DeptID;

CREATE TABLE IF NOT EXISTS Department2;
select*from department2;

INSERT INTO Department2 VALUES (50,NULL);

INSERT INTO Student (StudentID, Email, Age, DeptID) VALUES (106,'riya@example.com',21,20);
ALTER TABLE Student ADD CONSTRAINT uq_student_email UNIQUE (Email);
INSERT INTO Student VALUES (106,'Riya Das','amit@example.com',21,20,'2026-08-01');

CREATE TABLE Library ( 
 BookID INT UNIQUE,  
 Title VARCHAR(150) NOT NULL
 );
 INSERT INTO Library VALUES (1,'Database Systems'), 
 (2,'Operating Systems'), 
 (3,'Computer Networks'), 
 (4,'Python Programming'), 
 (5,'Data Mining');
 
 ALTER TABLE Student ADD CONSTRAINT chk_student_age CHECK (Age > 18);
 INSERT INTO Student VALUES (106,'Riya Das','riya@example.com',17,20,'2026-08-01');
 
 CREATE TABLE Course ( 
 CourseID INT PRIMARY KEY, 
 CourseName VARCHAR(100), 
 Credits INT CHECK (Credits BETWEEN 1 AND 6) );
INSERT INTO Course VALUES (1,'DBMS',8);

ALTER TABLE Student ADD COLUMN JoiningDate2 DATE DEFAULT (CURRENT_DATE);
INSERT INTO Student (StudentID,Name,Email,Age,DeptID) VALUES (106,'Riya Das','riya@example.com',21,20);
SELECT * FROM Student;

CREATE TABLE Faculty ( 
 FacultyID INT PRIMARY KEY,  
 FacultyName VARCHAR(100) NOT NULL,  
 Designation VARCHAR(50) DEFAULT 'Lecturer'
 );
INSERT INTO Faculty (FacultyID, FacultyName) VALUES (1,'Dr. Meera Sharma');
SELECT * FROM Faculty;

CREATE TABLE employees ( 
emp_id INT PRIMARY KEY,
 name VARCHAR(80), 
 department VARCHAR(50),
 salary DECIMAL(10,2),
 hire_date DATE
 );
 INSERT INTO employees VALUES (101,'John Smith','IT',55000,'2024-01-15'); 
INSERT INTO employees VALUES
 (102,'Sarah Johnson','HR',48000,'2024-02-10'),
 (103,'Mike Davis','Finance',52000,'2024-01-20'),
 (104,'Lisa Wilson','Marketing',45000,'2024-03-01'); 
 
 INSERT INTO employees (emp_id,name,department) VALUES (107,'David Clark','Sales');
 SELECT * FROM employees; 
 
 SELECT * FROM employees;
SELECT name, salary FROM employees; 
 SELECT * FROM employees WHERE department = 'IT';
 SELECT * FROM employees WHERE salary > 50000;
 SELECT * FROM employees WHERE hire_date BETWEEN '2024-01-01' AND '2024-01-31';
 SELECT DISTINCT department FROM employees;
 
 SELECT COUNT(*) AS total_employees FROM employees;
  SELECT MAX(salary) AS maximum_salary, MIN(salary) AS minimum_salary, AVG(salary) AS average_salary FROM employees; 
  
  UPDATE employees SET salary = 58000 WHERE name = 'John Smith'; 
   UPDATE employees SET salary = salary * 1.05 WHERE department = 'HR';
  UPDATE employees SET salary = 47000, hire_date = '2024-03-05' WHERE name = 'Lisa Wilson'; 
  UPDATE employees SET department = 'Operations' WHERE salary < 50000; 
UPDATE employees SET salary = salary + 2000 WHERE department = 'Finance'; 
UPDATE employees SET department = 'Senior Staff' WHERE hire_date < '2024-02-01';

use product;
DELETE FROM products WHERE stock_quantity = 0; 
DELETE FROM products WHERE category = 'Electronics' AND price > 1000;
 DELETE FROM products WHERE product_name = 'Desk Chair'; 
 
use student;
SELECT * FROM students ORDER BY marks DESC; 
 SELECT * FROM students ORDER BY marks DESC LIMIT 5; 
  SELECT * FROM students WHERE course = 'Computer Science' ORDER BY student_name ASC; 
   SELECT * FROM students ORDER BY marks ASC LIMIT 3; 
   SELECT * FROM students WHERE marks BETWEEN 80 AND 90;
    SELECT * FROM students WHERE student_name LIKE 'A%'; 
    SELECT * FROM students WHERE city IN ('Mumbai','Delhi');
    
    CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL, 
    author VARCHAR(255), 
    isbn VARCHAR(13) UNIQUE,
    genre VARCHAR(50) ); 
    CREATE TABLE Members ( 
    member_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20) 
    );
    
    CREATE TABLE Loans ( 
    loan_id INT PRIMARY KEY,
    book_id INT, member_id INT,
    loan_date DATE, return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id), 
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
    ); 
    INSERT INTO Books VALUES
    (1,'Database System Concepts','Korth','9780073523323','Database'),
    (2,'Operating System Concepts','Silberschatz','9781119456339','OS'),
    (3,'Python Crash Course','Eric Matthes','9781718502703','Programming');
    INSERT INTO Members VALUES 
    (101,'Amit Sharma','amit.lib@example.com','9876500001'),
    (102,'Priya Singh','priya.lib@example.com','9876500002'), 
    (103,'Rahul Verma','rahul.lib@example.com','9876500003'); 
    
    INSERT INTO Loans VALUES
    (1,1,101,'2026-09-01',NULL),
    (2,2,102,'2026-09-02','2026-09-06'),
    (3,3,103,'2026-09-04',NULL); 
     SELECT l.loan_id, b.title,
     m.name, l.loan_date, l.return_date
     FROM Loans l 
     INNER JOIN Books b ON l.book_id = b.book_id 
     INNER JOIN Members m ON l.member_id = m.member_id; 
   
