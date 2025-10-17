create database hospital;

USE HOSPITAL;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dateofbirth DATE,
    gender VARCHAR(100)
    );
    
    CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100)
    );

CREATE TABLE nurses (
    nurse_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100)
    );
    
    CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_time time,
    status VARCHAR(20) 
);

CREATE TABLE billing (
    bill_id INT PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    amount decimal(10,2),
    billing_date date,
    paid boolean default true
);


CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    admission_date TIMESTAMP DEFAULT current_timestamp,
    room_number int,
    discharge_date timestamp
    );
    
   

INSERT INTO patients (patient_id,first_name,last_name,dateofbirth ,gender ) VALUES
(1,'John', 'Doe', '1990-01-15', 'Male'),
(2,'Jane', 'Smith', '1985-06-30', 'Female'),
(3,'Robert', 'Brown', '1975-04-20', 'Male');



INSERT INTO nurses (nurse_id,first_name, last_name, department) VALUES
(1,'Emma', 'Clark', 'ICU'),
(2,'Olivia', 'Davis', 'Emergency');


INSERT INTO doctors (doctor_id,first_name, last_name, specialization) VALUES
(1,'Alice', 'Williams', 'Cardiology'),
(2,'David', 'Johnson', 'Neurology');



INSERT INTO appointments (appointment_id,patient_id, doctor_id, appointment_time, status) VALUES
(1,1, 1, '10:30:00', 'Scheduled'),
(2,2, 2, '14:00:00', 'Completed');


INSERT INTO billing (bill_id,patient_id, amount, paid) VALUES
(1,1, 200.00, FALSE),
(2,2, 450.50, TRUE);


INSERT INTO admissions (patient_id, doctor_id, room_number)
VALUES (1, 1, 101);





---- TRIGGER 
CREATE TABLE visit_log (
    log_id INT PRIMARY KEY,
    visit_id INT references admission_id,      
    action VARCHAR(100),
    action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER log_billing_payment
AFTER UPDATE ON billing
FOR EACH ROW
BEGIN
   
        INSERT INTO visit_log (visit_id, action, action_time)
        VALUES (NEW.bill_id, 'BILL PAID', NOW());
  
END$$
DELIMITER 

INSERT INTO visit_log (log_id, visit_id, action, action_time)
VALUES
(104, 2, 'Follow-up Scheduled', '2025-08-12 10:15:00');

UPDATE visit_log
SET visit_id = 2
WHERE log_id = 104;

INSERT INTO visit_log (log_id, visit_id, action, action_time)
VALUES
(105, 3, 'Scheduled', '2025-08-12 10:15:00');

UPDATE visit_log
SET visit_id = 3
WHERE log_id = 105;

select * from visit_log;

-- 2. JOIN 

select a.admission_id, p.first_name, p.last_name , a.room_number, a.admission_date
FROM admissions a
inner join patients p ON a.patient_id = p.patient_id;




-- 2. Total Billed Amount by Patient

SELECT p.first_name ,p.last_name ,
SUM(b.amount) AS  billing_calculation
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
GROUP BY p.patient_id;
 
-- 3. admission and discharge date
select admission_id, patient_id,discharge_date from admissions where discharge_date;
select admission_id, patient_id,admission_date from admissions where admission_date;

-- 4.find real time data
SELECT 
    a.appointment_id,
    p.first_name ,p.last_name ,
    d.first_name ,d.last_name ,   
    a.appointment_time,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;






