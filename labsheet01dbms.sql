CREATE DATABASE IF NOT EXISTS coer_university;
USE coer_university;
-- Q1: Create emplty table
CREATE TABLE departments(
   dept_id INT PRIMARY KEY,
   dept_name varchar(50)
   );
-- Q2: Create table employees
create table employees(
emp_id INT primary key,
first_name varchar(30),
salary decimal(10,2)
);
-- Q3: Create table projects with project_id (PK), project_name, and start_date
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE
);

-- Q4: Create table audit_logs with log_id (PK), action, and created_at
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY,
    action TEXT,
    created_at TIMESTAMP
);

-- Q5: Create table products with product_id (PK), product_name, and is_available
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    is_available BOOLEAN
);

-- Q6: Create table system_settings with setting_id (PK), setting_key, and setting_value
CREATE TABLE system_settings (
    setting_id SMALLINT PRIMARY KEY,
    setting_key VARCHAR(50),
    setting_value VARCHAR(100)
);

-- Q7: Add email column to employees table
ALTER TABLE employees 
ADD email VARCHAR(100);

-- Q8: Drop is_available column from products table
ALTER TABLE products 
DROP COLUMN is_available;

-- Q9: Rename table departments to dept_units
RENAME TABLE departments TO dept_units;

-- Q10: Empty all records from audit_logs using TRUNCATE
TRUNCATE TABLE audit_logs;

-- Q11: Create table user_profiles with user_id (PK), bio, and profile_pic
CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    bio TEXT,
    profile_pic BLOB
);

-- Q12: Create table ticket_orders with ticket_id (PK) and priority_level (ENUM)
CREATE TABLE ticket_orders (
    ticket_id INT PRIMARY KEY,
    priority_level ENUM('Low', 'Medium', 'High')
);

-- Q13: Drop products table permanently
DROP TABLE products;

-- Q14: Change email column data type to VARCHAR(150) in employees
ALTER TABLE employees 
MODIFY email VARCHAR(150);

-- Q15: Create table sensor_data with read_id (PK) and temperature
CREATE TABLE sensor_data (
    read_id BIGINT PRIMARY KEY,
    temperature FLOAT
);

create table student_courses(
    student_id int,
    course_id int);

-- Q16: Add composite primary key (student_id, course_id) to student_courses
ALTER TABLE student_courses 
ADD PRIMARY KEY (student_id, course_id);

-- Q17: Rename column first_name to given_name in employees table
ALTER TABLE employees 
RENAME COLUMN first_name TO given_name;

-- Q18: Drop primary key constraint from system_settings table
ALTER TABLE system_settings 
DROP PRIMARY KEY;

-- Q19: Create table clients with client_id (PK) and registration_time
CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    registration_time TIME
);

-- Q20: Re-add primary key on column client_id in clients table
alter table clients
drop primary key;
ALTER TABLE clients 
ADD PRIMARY KEY (client_id);

-- Q21: Create table order_items with composite PK (order_id, item_id), quantity, and unit_price
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(8,2),
    PRIMARY KEY (order_id, item_id)
);

-- Q22: Create table event_schedules with composite PK (event_id, venue_id), event_date, and duration_hours
CREATE TABLE event_schedules (
    event_id INT,
    venue_id INT,
    event_date DATE,
    duration_hours TINYINT,
    PRIMARY KEY (event_id, venue_id)
);

-- Q23: Add hire_date (DATE) and is_active (BOOLEAN) to employees in a single ALTER statement
ALTER TABLE employees 
ADD hire_date DATE,
ADD is_active BOOLEAN;

-- Q24: Drop email column and change salary data type to DECIMAL(12,2) in a single ALTER statement
ALTER TABLE employees 
DROP COLUMN email,
MODIFY salary DECIMAL(12,2);

-- Q25: Add a composite primary key (warehouse_id, sku) to existing inventory table
create table inventory (
   warehouse_id int,
   sku varchar (20)
   );

ALTER TABLE inventory 
ADD PRIMARY KEY (warehouse_id, sku);

-- Q26: Change bio column data type from TEXT to MEDIUMTEXT in user_profiles
ALTER TABLE user_profiles 
MODIFY bio MEDIUMTEXT;

-- Q27: Add middle_name (VARCHAR 30) to employees right after given_name
ALTER TABLE employees 
ADD middle_name VARCHAR(30) AFTER given_name;

-- Q28: Create table geolocations with location_id (PK), latitude, and longitude
CREATE TABLE geolocations (
    location_id INT PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- Q29: Create table user_accounts with user_id (PK), account_type (ENUM), and created_timestamp
CREATE TABLE user_accounts (
    user_id BIGINT PRIMARY KEY,
    account_type ENUM('Standard', 'Premium', 'Admin'),
    created_timestamp TIMESTAMP
);

-- Q30: Create table device_logs with log_id (PK), ip_address, and payload (LONGBLOB)
CREATE TABLE device_logs (
    log_id BIGINT PRIMARY KEY,
    ip_address VARCHAR(45),
    payload LONGBLOB
);

-- Q31: Drop primary key from order_items, add order_item_id as first column & PK in single ALTER chain
ALTER TABLE order_items 
DROP PRIMARY KEY,
ADD order_item_id INT PRIMARY KEY FIRST;

-- Q32: Convert start_date column to project_year with data type YEAR in projects table
ALTER TABLE projects 
CHANGE start_date project_year YEAR;

-- Q33: Create table document_store with doc_id (PK), doc_title, and content (LONGTEXT)
CREATE TABLE document_store (
    doc_id INT PRIMARY KEY,
    doc_title VARCHAR(255),
    content LONGTEXT
);

-- Q34: Change column content to doc_body while maintaining LONGTEXT type in document_store
ALTER TABLE document_store 
CHANGE content doc_body LONGTEXT;

-- Q35: Create empty table employees_archive identical to employees table structure
CREATE TABLE employees_archive LIKE employees;

-- Q36: Drop table employees_archive safely only if it exists
DROP TABLE IF EXISTS employees_archive;

-- Q37: Create table financial_ledger with entry_id (PK), debit DECIMAL(15,4), and credit DECIMAL(15,4)
CREATE TABLE financial_ledger (
    entry_id BIGINT PRIMARY KEY,
    debit DECIMAL(15,4),
    credit DECIMAL(15,4)
);

-- Q38: Add transaction_date (DATETIME) as absolute first column in financial_ledger
ALTER TABLE financial_ledger 
ADD transaction_date DATETIME FIRST;

-- Q39: Create table measurements with sample_id (PK) and value (DOUBLE)
CREATE TABLE measurements (
    sample_id INT PRIMARY KEY,
    value DOUBLE
);

-- Q40: Create table app_users with user_id (PK) and status_code (TINYINT)
CREATE TABLE app_users (
    user_id INT PRIMARY KEY,
    status_code TINYINT
);

-- Q41: Design transactions table with xact_id (PK), user_id, amount, channel (ENUM), status, and xact_time
CREATE TABLE transactions (
    xact_id BIGINT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    channel ENUM('Web', 'Mobile', 'ATM'),
    status VARCHAR(20),
    xact_time TIMESTAMP
);

-- Q42: Create system_events with composite primary key (event_id, node_id)
CREATE TABLE system_events (
    event_id BIGINT,
    node_id SMALLINT,
    event_payload TEXT,
    logged_time TIMESTAMP,
    PRIMARY KEY (event_id, node_id)
);

-- Q43: Redesign clients table: drop PK, add region_code, and set new composite PK
ALTER TABLE clients 
DROP PRIMARY KEY,
ADD region_code CHAR(3),
ADD PRIMARY KEY (client_id, region_code);

-- Q44: Rename column temp_val to converted_val, change type to DECIMAL(6,3), add processed_at
create table raw_data(
   temp_val int);
   
ALTER TABLE raw_data 
CHANGE temp_val converted_val DECIMAL(6,3),
ADD processed_at TIMESTAMP AFTER converted_val;

-- Q45: Create student_enrollments with 3-column composite primary key
CREATE TABLE student_enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id, semester)
);

-- Q46: Refactor student_enrollments by dropping composite key and making enrollment_id new PK
ALTER TABLE student_enrollments 
DROP PRIMARY KEY,
ADD enrollment_id BIGINT PRIMARY KEY FIRST;

-- Q47: Create table file_metadata with file_id (PK), file_path, file_size_bytes, and checksum
CREATE TABLE file_metadata (
    file_id INT PRIMARY KEY,
    file_path VARCHAR(500),
    file_size_bytes BIGINT,
    checksum CHAR(64)
);

-- Q48: Modify file_metadata schema: change file_id to BIGINT, file_path to TEXT, drop checksum
ALTER TABLE file_metadata 
MODIFY file_id BIGINT,
MODIFY file_path TEXT,
DROP COLUMN checksum;

-- Q49: Create sensor_readings table with composite PK and rename to historical_sensor_readings
CREATE TABLE sensor_readings (
    sensor_id INT,
    recorded_at TIMESTAMP,
    reading FLOAT,
    PRIMARY KEY (sensor_id, recorded_at)
);

RENAME TABLE sensor_readings TO historical_sensor_readings;

-- Q50: Create application_logs table and modify level column to VARCHAR(10)
CREATE TABLE application_logs (
    log_id BIGINT PRIMARY KEY,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR'),
    message TEXT,
    execution_time DOUBLE,
    created_at DATETIME
);

ALTER TABLE application_logs 
MODIFY level VARCHAR(10);