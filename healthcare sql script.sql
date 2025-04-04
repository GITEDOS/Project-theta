create database healthcare_db;

alter table dirty_healthcare_data rename to healthcare;

SELECT 
    *
FROM
    healthcare;

-- Create a duplicate table

CREATE TABLE healthcare_copy LIKE healthcare;

insert into healthcare_copy
select * from healthcare;

SELECT 
    *
FROM
    healthcare_copy;

-- Checking for duplicates
select * ,row_number() over (partition by Patient_ID, `Name`, 
Gender, Age, Admission_Date,
 Discharge_Date, Diagnosis,
 Department,
 Doctor_Name,
 Bill_Amount ) from healthcare_copy;/*** no duplicates ****/
 
UPDATE healthcare_copy 
SET 
    `Name` = TRIM(`name`);

UPDATE healthcare_copy 
SET 
    diagnosis = TRIM(diagnosis);
 
UPDATE healthcare_copy 
SET 
    department = TRIM(department);

UPDATE healthcare_copy 
SET 
    Doctor_name = TRIM(Doctor_name);
 
 -- Ensuring Consistency
 
 with copy_cte as 
 (
 select Patient_ID, `Name`,
	 upper(substring(`Name`,1,1) )as first_letter,
	 lower(substring(`Name`,2) ) as rem_letters,
	 Gender,
	 Age,
	 Admission_Date,
	 Discharge_Date,
	 Diagnosis,
	 Department,
	 Doctor_Name,
	 Bill_Amount
 from healthcare_copy
 )
 select * from copy_cte;
 
 
CREATE TABLE `healthcare_copy1` (
    `Patient_ID` TEXT,
    `Name` TEXT,
    `first_letter` VARCHAR(100),
    `rem_letters` VARCHAR(100),
    `Gender` TEXT,
    `Age` DOUBLE DEFAULT NULL,
    `Admission_Date` TEXT,
    `Discharge_Date` TEXT,
    `Diagnosis` TEXT,
    `Department` TEXT,
    `Doctor_Name` TEXT,
    `Bill_Amount` TEXT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;


insert into healthcare_copy1
select Patient_ID, `Name`,
	 upper(substring(`Name`,1,1) )as first_letter,
	 lower(substring(`Name`,2) ) as rem_letters,
	 Gender,
	 Age,
	 Admission_Date,
	 Discharge_Date,
	 Diagnosis,
	 Department,
	 Doctor_Name,
	 Bill_Amount
 from healthcare_copy;
 
SELECT 
    *
FROM
    healthcare_copy1;
 
 -- to begin comsistency on the name,diagnosis,department column
UPDATE healthcare_copy1 
SET 
    `name` = CONCAT(first_letter, rem_letters);
 
 alter table healthcare_copy1 add column first_letter varchar(100)AFTER Diagnosis;
alter table healthcare_copy1  add column rem_letters varchar(100) AFTER first_letter ;
 
UPDATE healthcare_copy1 
SET 
    first_letter = UPPER(SUBSTRING(Doctor_Name, 1, 1));
 
UPDATE healthcare_copy1 
SET 
    rem_letters = LOWER(SUBSTRING(Doctor_Name, 2));
 
UPDATE healthcare_copy1 
SET 
    Doctor_Name = CONCAT(first_letter, rem_letters);
 
SELECT 
    *
FROM
    healthcare_copy1
;
 
  alter table healthcare_copy1 drop column rem_letters;
 
 
 -- STANDARDIZING THE DATE COLUMNS
 
 select	 admission_date,coalesce(admission_date,str_to_date(admission_date,'%m-%d-%Y')) from healthcare_copy1;
SELECT 
    admission_date, DATE_FORMAT(admission_date, '%m-%d-%Y')
FROM
    healthcare_copy1;
 
alter table healthcare_copy1 modify column admission_date text;
 
UPDATE healthcare_copy1 
SET 
    admission_date = DATE_FORMAT(admission_date, '%Y-%m-%d');
    
 -- filling blank space with null
 
UPDATE healthcare_copy1 
SET 
    admission_date = NULL
WHERE
    admission_date = '';
 
UPDATE healthcare_copy1 
SET 
    Discharge_Date = NULL
WHERE
    Discharge_Date = '';
 
UPDATE healthcare_copy1 
SET 
    `NAME` = NULL
WHERE
    `NAME` = '';
 
UPDATE healthcare_copy1 
SET 
    Bill_Amount = NULL
WHERE
    Bill_Amount = '';
 
UPDATE healthcare_copy1 
SET 
    Gender = NULL
WHERE
    Gender = '';
 
SELECT 
    *
FROM
    healthcare_copy1
;
 
 -- using coalesce
 
UPDATE healthcare_copy1 
SET 
    gender = COALESCE(gender, 'unknown');
 
UPDATE healthcare_copy1 
SET 
    admission_date = COALESCE(admission_date, 'unknown');
 
UPDATE healthcare_copy1 
SET 
    Bill_Amount = COALESCE(Bill_Amount, '$ 0.00');
    

 select bill_amount, cast(bill_amount as decimal(10,0)) from healthcare_copy1;
 
 update healthcare_copy1
 set bill_amount = concat('$',' ',coalesce(cast(nullif(bill_amount,'') as decimal(10,0)),0.0))
 ;
 
 -- use self join to update some data
SELECT 
    t1.Patient_ID,
    t1.`Name`,
    t1.Gender,
    t1.Age,
    t1.Admission_Date,
    t1.Discharge_Date,
    t1.Diagnosis,
    t1.Department,
    t1.Doctor_Name,
    t1.Bill_Amount,
    t1.Patient_ID,
    t2.`Name`,
    t2.Gender,
    t2.Age,
    t2.Admission_Date,
    t2.Discharge_Date,
    t2.Diagnosis,
    t2.Department,
    t2.Doctor_Name,
    t2.Bill_Amount
FROM
    healthcare_copy t1
    join healthcare_copy1 t2
    on t1.patient_id = t2.patient_id
    where t2.bill_amount = '' and t1.bill_amount <>'';

;


 alter table healthcare_copy1 add column Bill_Amount text AFTER Doctor_Name;
 
 insert into healthcare_copy1 (Bill_Amount)
 select Bill_Amount from healthcare;
 
 update healthcare_copy1 t2
 join healthcare_copy t1
    on t1.patient_id = t2.patient_id
    set t2.bill_amount = t1.bill_amount
    where t2.bill_amount = '' and t1.bill_amount <>'';
    
select *  from healthcare_copy1
;
 
 