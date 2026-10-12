-- SETUP: Tables creation and sample data insertion
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    is_active BOOLEAN
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50),
    budget DECIMAL(12,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

INSERT INTO employees VALUES
(101, 'Alice', 'Smith', 10, 75000.00, '2021-03-15', TRUE),
(102, 'Bob', 'Johnson', 20, 52000.00, '2022-06-01', TRUE),
(103, 'Charlie', 'Brown', 10, 82000.00, '2019-11-20', TRUE),
(104, 'Diana', 'Prince', 30, 48000.00, '2023-01-10', FALSE),
(105, 'Evan', 'Wright', 20, 61000.00, '2020-08-05', TRUE);

INSERT INTO departments VALUES
(10, 'Engineering', 'Building A', 500000.00),
(20, 'Marketing', 'Building B', 200000.00),
(30, 'Human Resources', 'Building A', 150000.00),
(40, 'Finance', 'Building C', 350000.00),
(50, 'Research', 'Building D', 600000.00);

INSERT INTO orders VALUES
(5001, 'TechCorp LLC', '2024-01-15', 1250.50, 'Completed'),
(5002, 'Global Media', '2024-01-18', 450.00, 'Pending'),
(5003, 'Alpha Retail', '2024-01-20', 3100.00, 'Completed'),
(5004, 'Beta Systems', '2024-01-22', 150.25, 'Cancelled'),
(5005, 'Gamma Inc', '2024-01-25', 890.00, 'Shipped');

-- Q01: Insert new employee Fiona Gallagher into employees table
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES (106, 'Fiona', 'Gallagher', 10, 65000.00, '2024-02-01', TRUE);

-- Q02: Insert new department Quality Assurance into departments table
INSERT INTO departments (dept_id, dept_name, location, budget)
VALUES (60, 'Quality Assurance', 'Building B', 250000.00);

-- Q03: Insert new order for customer Delta Retail into orders table
INSERT INTO orders (order_id, customer_name, order_date, total_amount, status)
VALUES (5006, 'Delta Retail', '2024-01-28', 2100.00, 'Pending');

-- Q04: Retrieve all columns from the employees table
SELECT * FROM employees;

-- Q05: Retrieve only first_name, last_name, and salary of all employees
SELECT first_name, last_name, salary FROM employees;

-- Q06: Find all employees who belong to department 10
SELECT * FROM employees WHERE dept_id = 10;

-- Q07: Display all orders where the status is Completed
SELECT * FROM orders WHERE status = 'Completed';

-- Q08: Update salary of employee with emp_id 102 to 55000.00
UPDATE employees SET salary = 55000.00 WHERE emp_id = 102;

-- Q09: Change status of order 5002 from Pending to Shipped
UPDATE orders SET status = 'Shipped' WHERE order_id = 5002;

-- Q10: Increase the budget of department 20 by 20000.00
UPDATE departments SET budget = budget + 20000.00 WHERE dept_id = 20;

-- Q11: Delete the order record with order_id 5004 from orders table
DELETE FROM orders WHERE order_id = 5004;

-- Q12: Remove employee Diana Prince (emp_id 104) from employees table
DELETE FROM employees WHERE emp_id = 104;

-- Q13: Find all employees with a salary greater than 60000.00
SELECT * FROM employees WHERE salary > 60000.00;

-- Q14: Retrieve all orders placed between 2024-01-15 and 2024-01-20
SELECT * FROM orders WHERE order_date BETWEEN '2024-01-15' AND '2024-01-20';

-- Q15: Display all departments located in either Building A or Building B
SELECT * FROM departments WHERE location IN ('Building A', 'Building B');

-- Q16: Find all employees whose last_name starts with the letter 'S'
SELECT * FROM employees 
WHERE last_name LIKE 'S%';

-- Q17: List all employees sorted by salary in descending order
SELECT * FROM employees 
ORDER BY salary DESC;

-- Q18: Retrieve all departments sorted alphabetically by department name
SELECT * FROM departments 
ORDER BY dept_name ASC;

-- Q19: Count the total number of records in the employees table
SELECT COUNT(*) AS total_employees 
FROM employees;

-- Q20: Calculate the average total_amount of all orders
SELECT AVG(total_amount) AS avg_order_amount 
FROM orders;

-- Q21: Insert two new employees in a single query
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active) 
VALUES 
(107, 'George', 'Clark', 30, 50000.00, '2024-02-05', TRUE),
(108, 'Hannah', 'Abbott', 10, 71000.00, '2024-02-10', TRUE);

-- Q22: Give a 10% salary raise to all employees working in department 10
set sql_safe_updates=0;

UPDATE employees 
SET salary = salary * 1.10 
WHERE dept_id = 10;

-- Q23: Deactivate (set is_active = FALSE) all employees hired before 2021-01-01
UPDATE employees 
SET is_active = FALSE 
WHERE hire_date < '2021-01-01';

-- Q24: Retrieve all active employees who earn more than 60000.00
SELECT * FROM employees 
WHERE is_active = TRUE AND salary > 60000.00;

-- Q25: Find orders that are either 'Cancelled' OR have total_amount greater than 2000.00
SELECT * FROM orders 
WHERE status = 'Cancelled' OR total_amount > 2000.00;

-- Q26: List all employees who do NOT belong to departments 10 or 30
SELECT * FROM employees 
WHERE dept_id NOT IN (10, 30);

-- Q27: Find all employees whose first_name contains the letter 'a' (case-insensitive)
SELECT * FROM employees 
WHERE LOWER(first_name) LIKE '%a%';

-- Q28: Calculate total salary expenditure for each department
SELECT dept_id, SUM(salary) AS total_salary 
FROM employees 
GROUP BY dept_id;

-- Q29: Find the total number of employees in each department
SELECT dept_id, COUNT(*) AS total_employees 
FROM employees 
GROUP BY dept_id;

-- Q30: Display departments that have a total salary expenditure exceeding 100000.00
SELECT dept_id, SUM(salary) AS total_salary 
FROM employees 
GROUP BY dept_id 
HAVING SUM(salary) > 100000.00;

-- Q31: Find maximum and minimum order amounts per order status
SELECT status, MAX(total_amount) AS max_amount, MIN(total_amount) AS min_amount 
FROM orders 
GROUP BY status;

-- Q32: Retrieve all employees who earn more than the average employee salary
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q33: Find all employees who work in departments located in 'Building A'
SELECT * FROM employees 
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Building A');

-- Q34: Delete all orders placed by customers who have an order with 'Cancelled' status
DELETE FROM orders 
WHERE customer_name IN (SELECT customer_name FROM (SELECT customer_name FROM orders WHERE status = 'Cancelled') AS temp);

-- Q35: Find all employees whose last_name is NULL (if any exists)
SELECT * FROM employees 
WHERE last_name IS NULL;

-- Q36: Display full names of employees by concatenating first_name and last_name with a space
SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees;

-- Q37: Retrieve the top 3 highest-paid employees
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- Q38: List employees sorted by department ID ascending, then by salary descending
SELECT * FROM employees 
ORDER BY dept_id ASC, salary DESC;

-- Q39: Delete all departments that have a budget less than 200000.00
DELETE FROM departments 
WHERE budget < 200000.00;

-- Q40: Count the number of completed orders
SELECT COUNT(*) AS completed_orders_count 
FROM orders 
WHERE status = 'Completed';

-- Q41: Increase salary by 15% for employees working in the department with the highest budget
UPDATE employees 
SET salary = salary * 1.15 
WHERE dept_id = (SELECT dept_id FROM departments ORDER BY budget DESC LIMIT 1);

-- Q42: Find departments where average employee salary is greater than global average employee salary
SELECT dept_id, AVG(salary) AS avg_dept_salary 
FROM employees 
GROUP BY dept_id 
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- Q43: Display employee details for employees who belong to departments with a budget > 300000.00
SELECT * FROM employees 
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 300000.00);

-- Q44: Find the third highest salary in the employees table using OFFSET
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 1 OFFSET 2;

-- Q45: Update employees: Increase salary by 10% if salary < 60000, else increase by 5% using CASE
UPDATE employees 
SET salary = CASE 
    WHEN salary < 60000 THEN salary * 1.10 
    ELSE salary * 1.05 
END;

-- Q46: Delete employees who are inactive (is_active = FALSE) AND earn less than their department's average salary
DELETE e FROM employees e 
JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary 
    FROM employees 
    GROUP BY dept_id
) d ON e.dept_id = d.dept_id 
WHERE e.is_active = FALSE AND e.salary < d.avg_salary;

-- Q47: Find department name and total employee count using a scalar subquery in SELECT projection list
SELECT dept_name, 
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS total_employees 
FROM departments d;

-- Q48: List customer names who have placed more than 1 order OR have a total spending sum > 1000.00
SELECT customer_name 
FROM orders 
GROUP BY customer_name 
HAVING COUNT(order_id) > 1 OR SUM(total_amount) > 1000.00;

-- Q49: Insert into employees a copy of all employees from dept 10 into dept 50 with modified IDs (+500)
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
SELECT emp_id + 500, first_name, last_name, 50, salary, hire_date, is_active 
FROM employees 
WHERE dept_id = 10;

-- Q50: Bulk update order statuses: 'Completed' if total_amount > 1000, 'Shipped' if between 500 & 1000, else 'Pending'
UPDATE orders 
SET status = CASE 
    WHEN total_amount > 1000 THEN 'Completed' 
    WHEN total_amount BETWEEN 500 AND 1000 THEN 'Shipped' 
    ELSE 'Pending' 
END;