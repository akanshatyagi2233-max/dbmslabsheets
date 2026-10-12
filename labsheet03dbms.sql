-- 1. DATABASE & SCHEMA CREATION
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

CREATE TABLE IF NOT EXISTS departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    is_active BOOLEAN,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
) ENGINE=InnoDB;

-- 2. USER CREATION WITH VARYING PRIVILEGE LEVELS
-- Level 0: Unprivileged Accounts
CREATE USER IF NOT EXISTS 'john'@'localhost' IDENTIFIED BY 'JohnPass2026!';
CREATE USER IF NOT EXISTS 'alice'@'localhost' IDENTIFIED BY 'AlicePass2026!';
CREATE USER IF NOT EXISTS 'intern_user'@'localhost' IDENTIFIED BY 'InternPass2026!';
CREATE USER IF NOT EXISTS 'temp_user'@'localhost' IDENTIFIED BY 'TempPass2026!';
CREATE USER IF NOT EXISTS 'sec_user'@'localhost' IDENTIFIED BY 'SecPass2026!';
CREATE USER IF NOT EXISTS 'admin_user'@'%' IDENTIFIED BY 'AdminPass2026!';

-- Level 1: Read-Only User Accounts
CREATE USER IF NOT EXISTS 'auditor'@'localhost' IDENTIFIED BY 'AuditPass2026!';
GRANT SELECT ON company_db.* TO 'auditor'@'localhost';

CREATE USER IF NOT EXISTS 'analyst'@'localhost' IDENTIFIED BY 'AnalystPass2026!';
GRANT SELECT ON company_db.* TO 'analyst'@'localhost';

-- Level 2: Operational / Departmental Users
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'MgrPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.orders TO 'manager'@'localhost';

CREATE USER IF NOT EXISTS 'dev_user'@'localhost' IDENTIFIED BY 'DevPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.* TO 'dev_user'@'localhost';

CREATE USER IF NOT EXISTS 'hr_assistant'@'localhost' IDENTIFIED BY 'HrPass2026!';
GRANT SELECT, UPDATE ON company_db.employees TO 'hr_assistant'@'localhost';

CREATE USER IF NOT EXISTS 'finance_user'@'localhost' IDENTIFIED BY 'FinPass2026!';
GRANT SELECT, UPDATE ON company_db.departments TO 'finance_user'@'localhost';

-- Level 3: Lead & Administrative Users
CREATE USER IF NOT EXISTS 'team_lead'@'localhost' IDENTIFIED BY 'LeadPass2026!';
GRANT SELECT, INSERT ON company_db.* TO 'team_lead'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
SET SQL_SAFE_UPDATES = 0;

-- Q01: Grant SELECT permission on database company_db to pre-created user 'john'@'localhost'
GRANT SELECT ON company_db.* TO 'john'@'localhost';

-- Q02: Grant SELECT and INSERT permissions on company_db.employees to 'alice'@'localhost'
GRANT SELECT, INSERT ON company_db.employees TO 'alice'@'localhost';

-- Q03: Revoke INSERT privilege on company_db.employees from user 'alice'@'localhost'
REVOKE INSERT ON company_db.employees FROM 'alice'@'localhost';

-- Q04: Explicitly begin a new transaction block in MySQL
START TRANSACTION;

-- Q05: Permanently commit a pending insertion of Department 60 into departments table
START TRANSACTION;
INSERT IGNORE INTO departments (dept_id, dept_name, location, budget) 
VALUES (60, 'Quality Assurance', 'Building B', 250000.00);
COMMIT;

-- Q06: Undo an uncommitted DELETE statement executed against employees
START TRANSACTION;
DELETE FROM employees WHERE emp_id = 105;
ROLLBACK;

-- Q07: Establish a transaction savepoint named sp_before_update
START TRANSACTION;
INSERT IGNORE INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES (106, 'Fiona', 'Gallagher', 10, 65000.00, '2024-02-01', TRUE);
SAVEPOINT sp_before_update;

-- Q08: Grant ALL privileges on all databases to pre-created account 'admin_user'@'%'
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'%';

-- Q09: Refresh MySQL in-memory privilege tables after making grant modifications
FLUSH PRIVILEGES;

-- Q10: Revoke ALL privileges and grant options from pre-created user 'intern_user'@'localhost'
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'intern_user'@'localhost';

-- Q11: Audit 'dev_user'@'localhost' and grant additional DELETE permission on company_db.orders
GRANT DELETE ON company_db.orders TO 'dev_user'@'localhost';

-- Q12: Transaction block to update salary, set savepoint, update another salary, rollback to savepoint, and commit
START TRANSACTION;
UPDATE employees SET salary = 80000.00 WHERE emp_id = 101;
SAVEPOINT sp_first;
UPDATE employees SET salary = 95000.00 WHERE emp_id = 102;
ROLLBACK TO SAVEPOINT sp_first;
COMMIT;

-- Q13: Revoke UPDATE permission on company_db.employees from 'hr_assistant'@'localhost'
REVOKE UPDATE ON company_db.employees FROM 'hr_assistant'@'localhost';

-- Q14: Configure transaction mode to READ ONLY before running reporting SELECT queries
SET TRANSACTION READ ONLY;
START TRANSACTION;
SELECT * FROM employees;
COMMIT;

-- Q15: Demonstrate implicit commit via DDL (ALTER TABLE) inside an uncommitted transaction
START TRANSACTION;
UPDATE employees SET salary = 85000.00 WHERE emp_id = 101;
ALTER TABLE employees ADD COLUMN remarks VARCHAR(100); -- DDL causes implicit COMMIT
-- ROLLBACK here will have no effect on the previous UPDATE

-- Q16: Financial Budget Transfer ($10,000 from Dept 10 to Dept 20 atomically)
START TRANSACTION;
UPDATE departments SET budget = budget - 10000.00 WHERE dept_id = 10;
UPDATE departments SET budget = budget + 10000.00 WHERE dept_id = 20;
COMMIT;

-- Q17: Audit pre-created user 'team_lead'@'localhost' and verify delegation rights
SHOW GRANTS FOR 'team_lead'@'localhost';

-- Q18: Revoke GRANT OPTION from 'team_lead'@'localhost' without revoking base permissions
REVOKE GRANT OPTION ON company_db.* FROM 'team_lead'@'localhost';

-- Q19: Order Status Workflow Rollback if total_amount < 500
START TRANSACTION;
UPDATE orders SET status = 'Shipped' WHERE order_id = 5002;
-- Check condition: if total_amount < 500, rollback transaction
ROLLBACK; -- Order 5002 has total_amount = 450.00 (< 500), so we rollback

-- Q20: Create role 'reporter_role', grant SELECT on company_db.*, and assign to 'analyst'@'localhost'
CREATE ROLE IF NOT EXISTS 'reporter_role';
GRANT SELECT ON company_db.* TO 'reporter_role';
GRANT 'reporter_role' TO 'analyst'@'localhost';

-- Q21: Conditional Multi-Table Transaction with Savepoint Rollback
START TRANSACTION;
UPDATE employees SET salary = salary * 1.15 WHERE dept_id = 10;
SAVEPOINT sp_salary_done;
UPDATE departments SET budget = budget + 50000.00 WHERE dept_id = 10;
-- Budget exceeds 520,000 (500,000 + 50,000 = 550,000), rollback to savepoint
ROLLBACK TO SAVEPOINT sp_salary_done;
COMMIT;

-- Q22: Exclusive Pessimistic Locking (FOR UPDATE)
START TRANSACTION;
SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE;
UPDATE employees SET salary = 88000.00 WHERE emp_id = 101;
COMMIT;

-- Q23: Shared Read Locking (FOR SHARE / LOCK IN SHARE MODE)
START TRANSACTION;
SELECT * FROM departments WHERE dept_id = 10 FOR SHARE;
-- Generate analytical report queries here
COMMIT;

-- Q24: Account Resource Throttling for 'auditor'@'localhost'
ALTER USER 'auditor'@'localhost' WITH 
    MAX_QUERIES_PER_HOUR 100 
    MAX_USER_CONNECTIONS 2;

-- Q25: Order Cancellation Sync Workflow (Cancel order 5002 & refund $450.00 to dept 20)
START TRANSACTION;
UPDATE orders SET status = 'Cancelled' WHERE order_id = 5002;
UPDATE departments SET budget = budget + 450.00 WHERE dept_id = 20;
COMMIT;

-- Q26: Role Inheritance Hierarchy Setup
CREATE ROLE IF NOT EXISTS 'read_role', 'write_role', 'admin_role';
GRANT SELECT ON company_db.* TO 'read_role';
GRANT INSERT, UPDATE, DELETE ON company_db.* TO 'write_role';
GRANT 'read_role', 'write_role' TO 'admin_role';

CREATE USER IF NOT EXISTS 'super_dev'@'localhost' IDENTIFIED BY 'SuperPass2026!';
GRANT 'admin_role' TO 'super_dev'@'localhost';

-- Q27: Deadlock Handling Simulation Statements
-- Session 1 (`dev_user`):
-- START TRANSACTION; UPDATE employees SET salary = salary + 100 WHERE emp_id = 101;
-- Session 2 (`hr_assistant`):
-- START TRANSACTION; UPDATE employees SET salary = salary + 100 WHERE emp_id = 102;
-- Session 1: UPDATE employees SET salary = salary + 100 WHERE emp_id = 102; (Waits)
-- Session 2: UPDATE employees SET salary = salary + 100 WHERE emp_id = 101; (Deadlock detected, session 2 rolled back)

-- Q28: Encrypted Transport (TLS/SSL) Enforcement
CREATE USER IF NOT EXISTS 'cloud_user'@'%' IDENTIFIED BY 'CloudPass2026!' REQUIRE SSL;
GRANT SELECT, INSERT ON company_db.* TO 'cloud_user'@'%';

-- Q29: Granular Row-Level Batch Insert Recovery
START TRANSACTION;
INSERT INTO orders VALUES (5008, 'Enterprise Co', '2024-02-01', 1500.00, 'Pending');
SAVEPOINT sp_5008;
INSERT INTO orders VALUES (5009, 'Invalid Corp', '2024-02-02', -100.00, 'Pending');
-- Order 5009 fails business rules (negative amount), rollback to sp_5008
ROLLBACK TO SAVEPOINT sp_5008;
COMMIT;

-- Q30: Complete Administrative Maintenance Script
CREATE USER IF NOT EXISTS 'test_maint'@'localhost' IDENTIFIED BY 'MaintPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.* TO 'test_maint'@'localhost';

START TRANSACTION;
UPDATE employees SET is_active = FALSE WHERE emp_id = 104;
ROLLBACK;

SHOW GRANTS FOR 'test_maint'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'test_maint'@'localhost';
ALTER USER 'test_maint'@'localhost' ACCOUNT LOCK;