DROP DATABASE INSURANCE_CONTRACT_MANAGEMENT;
CREATE DATABASE INSURANCE_CONTRACT_MANAGEMENT;
USE INSURANCE_CONTRACT_MANAGEMENT;

CREATE TABLE Customers(	
	Customer_id VARCHAR(50) PRIMARY KEY,
    Full_name VARCHAR(100) NOT NULL,
    Phone_number VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Join_date DATE 
);

CREATE TABLE Insurance_Packages(
	Package_id VARCHAR(50) PRIMARY KEY ,
    Package_name VARCHAR(100) NOT NULL UNIQUE,
    Max_limit DECIMAL(12,2),
    Base_premium DECIMAL(12,2)
);

CREATE TABLE Policies(
	Policy_id VARCHAR(50) PRIMARY KEY,
    Customer_id VARCHAR(50),
    Package_id VARCHAR(50),
    Start_date DATE,
    End_date DATE,
    Status VARCHAR(10) NOT NULL,
    CONSTRAINT FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
	CONSTRAINT FOREIGN KEY (Package_id) REFERENCES Insurance_Packages(Package_id)
);

CREATE TABLE Claims(
	Claim_id VARCHAR(50) PRIMARY KEY,
    Policy_id VARCHAR(50),
    Claim_date DATE,
    Claim_amount DECIMAL(12,2) NOT NULL,
    Claim_status VARCHAR(10),
    CONSTRAINT FOREIGN KEY (Policy_id) REFERENCES Policies(Policy_id)
    
);

CREATE TABLE Claim_Processing_Log(
	Log_id VARCHAR(50) PRIMARY KEY,
    Claim_id VARCHAR(50),
    Action_detail VARCHAR(100) NOT NULL,
    Recorded_at DATETIME,
    Processing VARCHAR(50) NOT NULL,
    CONSTRAINT FOREIGN KEY (Claim_id) REFERENCES Claims(Claim_id)
);

INSERT INTO Customers
VALUES
('C001', 'Nguyen Hoang Long', '0901112223', 'long.nh@gmail.com', '2024-01-15'),
('C002', 'Tran Thi Kim Anh', '0988877766', 'anh.tk@gmail.com', '2024-03-10'),
('C003', 'Le Hoang Nam', '0903334445', 'nam.lh@gmail.com', '2024-05-20'),
('C004', 'Pham Minh Duc', '0355556667', 'duc.pm@gmail.com', '2024-08-12'),
('C005', 'Hoang Thu Thao', '0779998881', 'thao.ht@gmail.com', '2024-05-01');

INSERT INTO Insurance_Packages
VALUES
('PKG01', ' BAO HIEM SUC KHOE GOLD', 500000000, 5000000),
('PKG02', 'BAO HIEM OTO LIBERTY', 1000000000, 15000000),
('PKG03', 'BAO HIEM NHAN THO AN BINH', 2000000000, 25000000),
('PKG04', 'BAO HIEM DU LICH QUOC TE', 100000000, 1000000),
('PKG05', 'BAO HIEM TAI NAN 24/7',200000000 , 2500000);

INSERT INTO Policies
VALUES
('POL101', 'C001', 'PKG01', '2024-01-15', '2025-01-15','Expired'),
('POL102', 'C002', 'PKG02', '2024-03-10', '2026-03-10','Active'),
('POL103', 'C003', 'PKG03', '2025-05-20', '2035-05-20','Active'),
('POL104', 'C004', 'PKG04', '2025-08-12', '2025-09-12','Expired'),
('POL105', 'C005', 'PKG01', '2026-01-01', '2027-01-01','Active');

INSERT INTO Claims
VALUES
('CLM901', 'POL101', '2024-06-15', 12000000,'Approved'),
('CLM902', 'POL103', '2025-10-20', 50000000,'Pending'),
('CLM903', 'POL101', '2024-11-05', 5500000,'Approved'),
('CLM904', 'POL105', '2026-01-15', 2000000,'Rejected'),
('CLM905', 'POL102', '2025-02-10', 120000000,'Approved');

INSERT INTO Claim_Processing_Log
VALUES
('L001', 'CLM901', 'DA NHAN HO SO HIEN TRUONG', '2024-06-15 09:00','Admin_01'),
('L002', 'CLM901', 'CHAP NHAN BBOI THUONG XE TAI NAN', '2024-06-20 14:30','Admin_01'),
('L003', 'CLM902', 'DANG THAM DINH HO SO BENH AN', '2025-10-21 10:00','Admin_02'),
('L004', 'CLM904', 'TU CHOI DO LOI CO Y CUA KHACH HANG', '2026-01-16 16:00','Admin_03'),
('L005', 'CLM905', 'DA THANH TOAN QUA CHUYEN KHOANG', '2025-02-15 08:30','Accountant_01');

-- CAU 1
SET SQL_SAFE_UPDATES = 0;
UPDATE Insurance_Packages
SET Base_premium = Base_premium * 1.15
WHERE Max_limit > 500000000;

-- CAU 2
DELETE FROM Claim_Processing_Log
WHERE Recorded_at < '2025-06-17';

-- PHAN 2
-- CAU 1
SELECT *
FROM Policies
WHERE Status = 'Active';

-- CAU 2
SELECT Full_name, Email
FROM Customers
WHERE Full_name LIKE '%Hoang%' ;

-- CAU 3
SELECT *
FROM Claims
ORDER BY Claim_amount ASC
LIMIT 4 OFFSET 2;

-- PHAN 4 
-- CAU 1
SELECT 
	c.full_name,
    p.Package_name,
    po.Start_date,
    cl.Claim_amount
FROM Policies AS po
JOIN Customers AS c
    ON po.Customer_id = c.Customer_id
JOIN Insurance_Packages AS p
    ON po.Package_id= p.Package_id
JOIN Claims AS cl
	ON po.Policy_id = cl.Policy_id; 

-- CAU 2
SELECT c.full_name,
    SUM(cl.Claim_amount) AS total_claim_amount
FROM Customers AS c
JOIN Claims AS cl
    ON c.Customer_id = cl.Customer_id
WHERE cl.Claim_status = 'Approved'
GROUP BY c.Customer_id, c.full_name
HAVING SUM(cl.Claim_amount) > 50000000;



