CREATE DATABASE IF NOT EXISTS labsheet4_db;
USE labsheet4_db;

-- ============================================================
-- PART A & B: Table Creation & Foreign Keys
-- ============================================================

-- Q1: DeptID unique hai aur NULL nahi ho sakta, isliye Primary Key hai.

-- Q2: Department Table
CREATE TABLE IF NOT EXISTS Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

INSERT IGNORE INTO Department VALUES
(10, 'Computer Science'),
(20, 'Information Technology'),
(30, 'Pharmacy'),
(40, 'Management');

-- Q3: Student Table
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Age INT,
    DeptID INT,
    JoiningDate DATE
);

INSERT IGNORE INTO Student VALUES
(101, 'Amit Sharma', 'amit@example.com', 20, 10, '2026-07-01'),
(102, 'Priya Singh', 'priya@example.com', 21, 20, '2026-07-03'),
(103, 'Rahul Verma', 'rahul@example.com', 22, 30, '2026-07-05'),
(104, 'Neha Gupta', 'neha@example.com', 20, 10, '2026-07-08'),
(105, 'Arjun Mehta', 'arjun@example.com', 23, 40, '2026-07-10');

-- Q4: Testing duplicate student ID
-- INSERT INTO Student VALUES (101, 'Karan Shah', 'karan@example.com', 21, 20, '2026-07-11');
-- Error: Duplicate entry '101' for primary key

-- Q5: Enrollment Table
CREATE TABLE IF NOT EXISTS Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseName VARCHAR(100)
);

INSERT IGNORE INTO Enrollment VALUES
(1, 101, 'DBMS'),
(2, 102, 'Operating Systems'),
(3, 103, 'Pharmacology'),
(4, 104, 'Python');

-- Q6: Testing duplicate enrollment ID
-- INSERT INTO Enrollment VALUES (1, 105, 'Data Mining');
-- Error: Duplicate entry '1' for primary key

-- Q7 & Q8: Foreign Keys
ALTER TABLE Student ADD CONSTRAINT fk_student_dept FOREIGN KEY (DeptID) REFERENCES Department(DeptID);
ALTER TABLE Enrollment ADD CONSTRAINT fk_enroll_student FOREIGN KEY (StudentID) REFERENCES Student(StudentID);

-- Q9 & Q10: FK Testing
-- INSERT INTO Student VALUES (106, 'Riya Das', 'riya@example.com', 21, 99, '2026-08-01'); -- Dept 99 doesn't exist
-- INSERT INTO Enrollment VALUES (5, 999, 'DBMS'); -- Student 999 doesn't exist

-- Q11: Inner join students and dept
SELECT s.StudentID, s.Name, d.DeptName 
FROM Student s 
JOIN Department d ON s.DeptID = d.DeptID;

-- Q12: Inner join enrollment and student
SELECT e.EnrollmentID, s.Name, e.CourseName 
FROM Enrollment e 
JOIN Student s ON e.StudentID = s.StudentID;


-- ============================================================
-- PART C: Constraints
-- ============================================================

-- Q13: Not null test
CREATE TABLE IF NOT EXISTS Department2 (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);
-- INSERT INTO Department2 VALUES (50, NULL); -- Fails due to NOT NULL

-- Q14
-- INSERT INTO Student (StudentID, Email, Age, DeptID) VALUES (106, 'riya@example.com', 21, 20); -- Name missing

-- Q15: Unique email constraint
ALTER TABLE Student ADD CONSTRAINT uq_email UNIQUE (Email);
-- INSERT INTO Student VALUES (106, 'Riya Das', 'amit@example.com', 21, 20, '2026-08-01'); -- Duplicate email

-- Q16: Library Table
CREATE TABLE IF NOT EXISTS Library (
    BookID INT UNIQUE,
    Title VARCHAR(150) NOT NULL
);

INSERT IGNORE INTO Library VALUES
(1, 'Database Systems'),
(2, 'Operating Systems'),
(3, 'Computer Networks'),
(4, 'Python Programming'),
(5, 'Data Mining');

-- Q17: Check constraint age > 18
ALTER TABLE Student ADD CONSTRAINT chk_age CHECK (Age > 18);
-- INSERT INTO Student VALUES (106, 'Riya Das', 'riya@example.com', 17, 20, '2026-08-01'); -- Age < 18 fails

-- Q18: Course table with credits check
CREATE TABLE IF NOT EXISTS Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT CHECK (Credits BETWEEN 1 AND 6)
);

-- Q19: Default joining date
ALTER TABLE Student ADD COLUMN JoiningDate2 DATE DEFAULT (CURRENT_DATE);
INSERT IGNORE INTO Student (StudentID, Name, Email, Age, DeptID) VALUES (106, 'Riya Das', 'riya@example.com', 21, 20);

-- Q20: Faculty table
CREATE TABLE IF NOT EXISTS Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL,
    Designation VARCHAR(50) DEFAULT 'Lecturer'
);

INSERT IGNORE INTO Faculty (FacultyID, FacultyName) VALUES (1, 'Dr. Meera Sharma');


-- ============================================================
-- PART D: DML Exercises
-- ============================================================

-- Ex 1: Basic Inserts
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(80),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Q22
INSERT IGNORE INTO employees VALUES (101, 'John Smith', 'IT', 55000.00, '2024-01-15');

-- Q23
INSERT IGNORE INTO employees VALUES
(102, 'Sarah Johnson', 'HR', 48000.00, '2024-02-10'),
(103, 'Mike Davis', 'Finance', 52000.00, '2024-01-20'),
(104, 'Lisa Wilson', 'Marketing', 45000.00, '2024-03-01');

-- Q24
INSERT IGNORE INTO employees (emp_id, name, department) VALUES (107, 'David Clark', 'Sales');

-- Q25
SELECT * FROM employees;

-- Ex 2: Select Queries
SELECT * FROM employees; -- Q26
SELECT name, salary FROM employees; -- Q27
SELECT * FROM employees WHERE department = 'IT'; -- Q28
SELECT * FROM employees WHERE salary > 50000; -- Q29
SELECT * FROM employees WHERE hire_date BETWEEN '2024-01-01' AND '2024-01-31'; -- Q30
SELECT DISTINCT department FROM employees; -- Q31
SELECT COUNT(*) FROM employees; -- Q32
SELECT MAX(salary), MIN(salary), AVG(salary) FROM employees; -- Q33

-- Ex 3: Updates
SET SQL_SAFE_UPDATES = 0;

UPDATE employees SET salary = 58000 WHERE name = 'John Smith'; -- Q34
UPDATE employees SET salary = salary * 1.05 WHERE department = 'HR'; -- Q35
UPDATE employees SET salary = 47000, hire_date = '2024-03-05' WHERE name = 'Lisa Wilson'; -- Q36
UPDATE employees SET department = 'Operations' WHERE salary < 50000; -- Q37
UPDATE employees SET salary = salary + 2000 WHERE department = 'Finance'; -- Q38
UPDATE employees SET department = 'Senior Staff' WHERE hire_date < '2024-02-01'; -- Q39

-- Ex 4: Deletes
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

INSERT IGNORE INTO products VALUES
(1, 'Laptop', 'Electronics', 999.99, 5),
(2, 'Mouse', 'Electronics', 25.50, 0),
(3, 'Desk Chair', 'Furniture', 150.00, 3),
(4, 'Monitor', 'Electronics', 1200.00, 2),
(5, 'Keyboard', 'Electronics', 75.00, 0),
(6, 'Coffee Mug', 'Office', 12.99, 10),
(7, 'Notebook', 'Office', 5.99, 8),
(8, 'Smartphone', 'Electronics', 1500.00, 1);

DELETE FROM products WHERE stock_quantity = 0; -- Q40
DELETE FROM products WHERE category = 'Electronics' AND price > 1000; -- Q41
DELETE FROM products WHERE product_name = 'Desk Chair'; -- Q42
DELETE FROM products WHERE price < 100; -- Q43

-- Ex 5: Sorting, Like, Limit
CREATE TABLE IF NOT EXISTS students_grade (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course VARCHAR(50),
    marks INT,
    city VARCHAR(50)
);

INSERT IGNORE INTO students_grade VALUES
(1, 'Alice Brown', 'Computer Science', 85, 'Mumbai'),
(2, 'Bob Wilson', 'Mathematics', 92, 'Delhi'),
(3, 'Carol Davis', 'Computer Science', 78, 'Mumbai'),
(4, 'David Miller', 'Physics', 88, 'Chennai'),
(5, 'Eva Garcia', 'Mathematics', 95, 'Delhi'),
(6, 'Frank Johnson', 'Computer Science', 82, 'Bangalore'),
(7, 'Grace Lee', 'Physics', 90, 'Mumbai'),
(8, 'Henry Smith', 'Mathematics', 76, 'Chennai'),
(9, 'Ivy Chen', 'Computer Science', 89, 'Delhi'),
(10, 'Jack Taylor', 'Physics', 84, 'Bangalore');

SELECT * FROM students_grade ORDER BY marks DESC; -- Q44
SELECT * FROM students_grade ORDER BY marks DESC LIMIT 5; -- Q45
SELECT * FROM students_grade WHERE course = 'Computer Science' ORDER BY student_name ASC; -- Q46
SELECT * FROM students_grade ORDER BY marks ASC LIMIT 3; -- Q47
SELECT * FROM students_grade WHERE marks BETWEEN 80 AND 90; -- Q48
SELECT * FROM students_grade WHERE student_name LIKE 'A%'; -- Q49
SELECT * FROM students_grade WHERE city IN ('Mumbai', 'Delhi'); -- Q50


-- ============================================================
-- PART E: Library DB
-- ============================================================

CREATE TABLE IF NOT EXISTS Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    isbn VARCHAR(13) UNIQUE,
    genre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

INSERT IGNORE INTO Books VALUES
(1, 'Database System Concepts', 'Korth', '9780073523323', 'Database'),
(2, 'Operating System Concepts', 'Silberschatz', '9781119456339', 'OS'),
(3, 'Python Crash Course', 'Eric Matthes', '9781718502703', 'Programming');

INSERT IGNORE INTO Members VALUES
(101, 'Amit Sharma', 'amit.lib@example.com', '9876500001'),
(102, 'Priya Singh', 'priya.lib@example.com', '9876500002'),
(103, 'Rahul Verma', 'rahul.lib@example.com', '9876500003');

INSERT IGNORE INTO Loans VALUES
(1, 1, 101, '2026-09-01', NULL),
(2, 2, 102, '2026-09-02', '2026-09-06'),
(3, 3, 103, '2026-09-04', NULL);

-- Q55: Loan details join query
SELECT l.loan_id, b.title, m.name, l.loan_date, l.return_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id;