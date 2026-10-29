-- Step 1: Create and select database
CREATE DATABASE IF NOT EXISTS Hospital_Cursor_Trigger_Lab;
USE Hospital_Cursor_Trigger_Lab;

-- Step 2: Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    Department VARCHAR(50),
    ConsultationFee DECIMAL(10,2),
    Status VARCHAR(20)
);

-- Step 3: Insert initial dataset
INSERT INTO Doctors VALUES
(201, 'Dr. Anil', 'Cardiology', 1200.00, 'Active'),
(202, 'Dr. Beena', 'Pediatrics', 900.00, 'Active'),
(203, 'Dr. Chirag', 'Neurology', 1500.00, 'Active'),
(204, 'Dr. Divya', 'Dermatology', 1000.00, 'Active'),
(205, 'Dr. Eshan', 'Cardiology', 1300.00, 'Active'),
(206, 'Dr. Farah', 'Pediatrics', 850.00, 'Active');

-- Step 4: Create Doctor_Audit table
CREATE TABLE Doctor_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    ActionType VARCHAR(30),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create Fee_Log table
CREATE TABLE Fee_Log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,-- Question 1
DELIMITER //
CREATE PROCEDURE DisplayAllDoctors()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    
    DECLARE cur_doc CURSOR FOR 
        SELECT DoctorID, DoctorName FROM Doctors;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_doc;
    
    read_loop: LOOP
        FETCH cur_doc INTO v_id, v_name;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_id AS DoctorID, v_name AS DoctorName;
    END LOOP;
    
    CLOSE cur_doc;
END //
DELIMITER ;


-- Question 2
DELIMITER //
CREATE PROCEDURE DisplayHighFeeDoctors()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_fee DECIMAL(10,2);
    
    DECLARE cur_high_fee CURSOR FOR 
        SELECT DoctorID, DoctorName, ConsultationFee 
        FROM Doctors 
        WHERE ConsultationFee > 1000;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_high_fee;
    
    read_loop: LOOP
        FETCH cur_high_fee INTO v_id, v_name, v_fee;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_id AS DoctorID, v_name AS DoctorName, v_fee AS ConsultationFee;
    END LOOP;
    
    CLOSE cur_high_fee;
END //
DELIMITER ;


-- Question 3
DELIMITER //
CREATE PROCEDURE CalculateTotalFee(OUT total_fee DECIMAL(10,2))
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    
    DECLARE cur_fee CURSOR FOR SELECT ConsultationFee FROM Doctors;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    SET total_fee = 0.00;
    OPEN cur_fee;
    
    read_loop: LOOP
        FETCH cur_fee INTO v_fee;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SET total_fee = total_fee + v_fee;
    END LOOP;
    
    CLOSE cur_fee;
END //
DELIMITER ;


-- Question 4
DELIMITER //
CREATE PROCEDURE CountCardiologyDoctors(OUT doc_count INT)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    DECLARE cur_cardio CURSOR FOR 
        SELECT DoctorID FROM Doctors WHERE Department = 'Cardiology';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    SET doc_count = 0;
    OPEN cur_cardio;
    
    read_loop: LOOP
        FETCH cur_cardio INTO v_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SET doc_count = doc_count + 1;
    END LOOP;
    
    CLOSE cur_cardio;
END //
DELIMITER ;


-- Question 5
DELIMITER //
CREATE PROCEDURE CalculateAverageFee(OUT avg_fee DECIMAL(10,2))
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_count INT DEFAULT 0;
    
    DECLARE cur_avg CURSOR FOR SELECT ConsultationFee FROM Doctors;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_avg;
    
    read_loop: LOOP
        FETCH cur_avg INTO v_fee;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SET v_total = v_total + v_fee;
        SET v_count = v_count + 1;
    END LOOP;
    
    CLOSE cur_avg;
    
    IF v_count > 0 THEN
        SET avg_fee = v_total / v_count;
    ELSE
        SET avg_fee = 0.00;
    END IF;
END //
DELIMITER ;


-- Question 6
DELIMITER //
CREATE PROCEDURE UpdatePediatricsFee()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    DECLARE cur_pedia CURSOR FOR 
        SELECT DoctorID FROM Doctors WHERE Department = 'Pediatrics';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_pedia;
    
    read_loop: LOOP
        FETCH cur_pedia INTO v_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        UPDATE Doctors 
        SET ConsultationFee = ConsultationFee * 1.10 
        WHERE DoctorID = v_id;
    END LOOP;
    
    CLOSE cur_pedia;
END //
DELIMITER ;


-- Question 7
DELIMITER //
CREATE PROCEDURE UpdateLowFeeStatus()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    DECLARE cur_low CURSOR FOR 
        SELECT DoctorID FROM Doctors WHERE ConsultationFee < 1000;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_low;
    
    read_loop: LOOP
        FETCH cur_low INTO v_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        UPDATE Doctors SET Status = 'Review' WHERE DoctorID = v_id;
    END LOOP;
    
    CLOSE cur_low;
END //
DELIMITER ;


-- Question 8
DELIMITER //
CREATE PROCEDURE GenerateDoctorReport()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(50);
    DECLARE v_dept VARCHAR(50);
    DECLARE v_fee DECIMAL(10,2);
    
    DECLARE cur_report CURSOR FOR 
        SELECT DoctorName, Department, ConsultationFee 
        FROM Doctors 
        ORDER BY Department, DoctorName;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_report;
    
    read_loop: LOOP
        FETCH cur_report INTO v_name, v_dept, v_fee;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_dept AS Department, v_name AS DoctorName, v_fee AS ConsultationFee;
    END LOOP;
    
    CLOSE cur_report;
END //
DELIMITER ;


-- Question 9
DELIMITER //
CREATE PROCEDURE CountActiveDoctors(OUT active_count INT)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    DECLARE cur_active CURSOR FOR 
        SELECT DoctorID FROM Doctors WHERE Status = 'Active';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    SET active_count = 0;
    OPEN cur_active;
    
    read_loop: LOOP
        FETCH cur_active INTO v_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SET active_count = active_count + 1;
    END LOOP;
    
    CLOSE cur_active;
END //
DELIMITER ;


-- Question 10
DELIMITER //
CREATE PROCEDURE IncreamentHighFeeDoctors()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    DECLARE cur_inc CURSOR FOR 
        SELECT DoctorID FROM Doctors WHERE ConsultationFee >= 1200;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_inc;
    
    read_loop: LOOP
        FETCH cur_inc INTO v_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        UPDATE Doctors 
        SET ConsultationFee = ConsultationFee * 1.05 
        WHERE DoctorID = v_id;
    END LOOP;
    
    CLOSE cur_inc;
END //
DELIMITER ;

-- Question 1
DELIMITER //
CREATE TRIGGER trg_after_insert_doctor
AFTER INSERT ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit(DoctorID, ActionType, OldFee, NewFee)
    VALUES (NEW.DoctorID, 'INSERT', NULL, NEW.ConsultationFee);
END //
DELIMITER ;


-- Question 2
DELIMITER //
CREATE TRIGGER trg_after_update_fee_audit
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Doctor_Audit(DoctorID, ActionType, OldFee, NewFee)
        VALUES (OLD.DoctorID, 'FEE_UPDATE', OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //
DELIMITER ;


-- Question 3
DELIMITER //
CREATE TRIGGER trg_before_insert_uppercase_name
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    SET NEW.DoctorName = UPPER(NEW.DoctorName);
END //
DELIMITER ;


-- Question 4
DELIMITER //
CREATE TRIGGER trg_before_insert_check_fee
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: ConsultationFee cannot be negative.';
    END IF;
END //
DELIMITER ;


-- Question 5
DELIMITER //
CREATE TRIGGER trg_after_delete_doctor
AFTER DELETE ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit(DoctorID, ActionType, OldFee, NewFee)
    VALUES (OLD.DoctorID, 'DELETE', OLD.ConsultationFee, NULL);
END //
DELIMITER ;


-- Question 6
DELIMITER //
CREATE TRIGGER trg_after_update_fee_log
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Fee_Log(DoctorID, DoctorName, OldFee, NewFee)
        VALUES (OLD.DoctorID, OLD.DoctorName, OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //
DELIMITER ;


-- Question 7
DELIMITER //
CREATE TRIGGER trg_before_update_check_fee
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Updated ConsultationFee cannot be negative.';
    END IF;
END //
DELIMITER ;


-- Question 8
DELIMITER //
CREATE TRIGGER trg_before_update_normalize_status
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF LOWER(NEW.Status) = 'active' THEN
        SET NEW.Status = 'Active';
    END IF;
END //
DELIMITER ;


-- Question 9
DELIMITER //
CREATE TRIGGER trg_after_update_dept_change
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.Department <> NEW.Department THEN
        INSERT INTO Doctor_Audit(DoctorID, ActionType, OldFee, NewFee)
        VALUES (OLD.DoctorID, CONCAT('DEPT_CHANGE: ', OLD.Department, ' -> ', NEW.Department), OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //
DELIMITER ;


-- Question 10
DELIMITER //
CREATE TRIGGER trg_before_update_prevent_id_change
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.DoctorID <> NEW.DoctorID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: DoctorID modification is strictly prohibited.';
    END IF;
END //
DELIMITER ;
    DoctorName VARCHAR(50),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

