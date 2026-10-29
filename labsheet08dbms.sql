-- Database create aur select karna
CREATE DATABASE IF NOT EXISTS Hospital_Functions_Lab;
USE Hospital_Functions_Lab;

-- Patients Table Create karna
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    WeightKg DECIMAL(5,2),
    ConsultationFee DECIMAL(10,2)
);

-- Medicines Table Create karna
CREATE TABLE IF NOT EXISTS Medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Stock INT
);

-- Sample Data Insert karna
INSERT INTO Patients VALUES
(201, 'Asha', 24, 'F', 55.5, 600),
(202, 'Rohan', 35, 'M', 72.0, 800),
(203, 'Meera', 29, 'F', 61.5, 700),
(204, 'Vivek', 46, 'M', 85.0, 1000),
(205, 'Nitin', 17, 'M', 58.0, 500),
(206, 'Kavya', 52, 'F', 68.0, 900);

INSERT INTO Medicines VALUES
(301, 'Paracetamol', 25, 100),
(302, 'Amoxicillin', 80, 50),
(303, 'Cetirizine', 35, 75),
(304, 'Omeprazole', 60, 40),
(305, 'Azithromycin', 120, 25);

DELIMITER //
CREATE FUNCTION calculate_bmi(weight_kg DECIMAL(5,2), height_m DECIMAL(4,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN weight_kg / (height_m * height_m);
END //
DELIMITER ;

-- Test Query:
SELECT calculate_bmi(70, 1.75) AS Calculated_BMI;

DELIMITER //
CREATE FUNCTION age_category(age INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE cat VARCHAR(20);
    IF age < 18 THEN
        SET cat = 'Child';
    ELSEIF age <= 50 THEN
        SET cat = 'Adult';
    ELSE
        SET cat = 'Senior';
    END IF;
    RETURN cat;
END //
DELIMITER ;

-- Test Query: Apply to all patients
SELECT PatientID, PatientName, Age, age_category(Age) AS Category 
FROM Patients;

DELIMITER //
CREATE FUNCTION medicine_stock_value(unit_price DECIMAL(10,2), stock INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN unit_price * stock;
END //
DELIMITER ;

-- Test Query:
SELECT MedicineName, UnitPrice, Stock, 
       medicine_stock_value(UnitPrice, Stock) AS Total_Stock_Value 
FROM Medicines;

DELIMITER //
CREATE PROCEDURE patient_by_gender(IN p_gender VARCHAR(10))
BEGIN
    SELECT * FROM Patients WHERE Gender = p_gender;
END //
DELIMITER ;

-- Execute for Female ('F'):
CALL patient_by_gender('F');

-- Execute for Male ('M'):
CALL patient_by_gender('M');

DELIMITER //
CREATE PROCEDURE patients_above_age(IN p_age INT)
BEGIN
    SELECT * FROM Patients WHERE Age > p_age;
END //
DELIMITER ;

-- Test Case 1 (Age > 30):
CALL patients_above_age(30);

-- Test Case 2 (Age > 45):
CALL patients_above_age(45);

DELIMITER //
CREATE PROCEDURE update_medicine_stock(IN p_id INT, IN p_quantity INT)
BEGIN
    UPDATE Medicines 
    SET Stock = Stock + p_quantity 
    WHERE MedicineID = p_id;
END //
DELIMITER ;

-- Execution: Medicine 301 (Paracetamol) me +20 quantity add karein
CALL update_medicine_stock(301, 20);

-- Verify updated row:
SELECT * FROM Medicines WHERE MedicineID = 301;

DELIMITER //
CREATE PROCEDURE medicine_count(OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count FROM Medicines;
END //
DELIMITER ;

-- Call using session variable @total_meds:
CALL medicine_count(@total_meds);

-- Display result:
SELECT @total_meds AS Total_Medicines_Count;

DELIMITER //
CREATE PROCEDURE patient_report()
BEGIN
    SELECT 
        PatientID, 
        PatientName, 
        Age, 
        calculate_bmi(WeightKg, 1.65) AS Calculated_BMI,
        age_category(Age) AS Category
    FROM Patients;
END //
DELIMITER ;

-- Execution:
CALL patient_report();

DELIMITER //
CREATE PROCEDURE medicine_report()
BEGIN
    SELECT 
        MedicineID,
        MedicineName,
        UnitPrice,
        Stock,
        medicine_stock_value(UnitPrice, Stock) AS Total_Stock_Value,
        CASE 
            WHEN Stock >= 100 THEN 'Sufficient'
            WHEN Stock BETWEEN 40 AND 99 THEN 'Moderate'
            ELSE 'Low Stock'
        END AS Stock_Status
    FROM Medicines;
END //
DELIMITER ;

-- Execution:
CALL medicine_report();