USE Company;

DECLARE @table_name VARCHAR(MAX);
DECLARE table_cursor CURSOR FOR
SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE';

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @constraint_name VARCHAR(MAX);
    DECLARE constraint_cursor CURSOR FOR
    SELECT constraint_name FROM information_schema.table_constraints 
    WHERE table_name = @table_name AND constraint_type = 'FOREIGN KEY';

    OPEN constraint_cursor;
    FETCH NEXT FROM constraint_cursor INTO @constraint_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT ' + @constraint_name;
        EXEC sp_executesql @sql;
        FETCH NEXT FROM constraint_cursor INTO @constraint_name;
    END

    CLOSE constraint_cursor;
    DEALLOCATE constraint_cursor;

    SET @sql = 'DROP TABLE ' + @table_name;
    EXEC sp_executesql @sql;

    FETCH NEXT FROM table_cursor INTO @table_name;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

---2) Create all required tables in SQL and then Insert at least 20 dummy data into each---

-- Table for storing airplane types
CREATE TABLE PLANE_TYPE (
  Model INT PRIMARY KEY,      -- Model number of the airplane type
  Capacity INT,               -- Passenger capacity of the airplane type
  Weight INT                  -- Weight of the airplane type
);

-- Table for tracking hangars
CREATE TABLE HANGAR (
  Number INT PRIMARY KEY,     -- Number of the hangar
  Capacity INT,               -- Capacity of the hangar
  Location VARCHAR(255)       -- Location of the hangar
);

-- Table for tracking airplanes
CREATE TABLE AIRPLANE (
  Reg# INT PRIMARY KEY,       -- Registration number of the airplane
  OF_TYPE INT,                -- Model number of the airplane type
  STORED_IN INT,              -- Number of the hangar where the airplane is stored
  FOREIGN KEY (OF_TYPE) REFERENCES PLANE_TYPE(Model),
  FOREIGN KEY (STORED_IN) REFERENCES HANGAR(Number)
);

-- Table for storing owners (can be a person or a corporation)
CREATE TABLE OWNER (
  ID INT PRIMARY KEY,         -- ID of the owner
  Type VARCHAR(20)CHECK (Type IN ('person', 'corporation')), -- Type of the owner (person or corporation)
  location varchar(35)
);

-- Table for storing personal information about individuals
CREATE TABLE PERSON (
  Ssn INT PRIMARY KEY,        -- Social Security number of the person
  Name VARCHAR(255),          -- Name of the person
  Address VARCHAR(255),       -- Address of the person
  Phone VARCHAR(20)           -- Phone number of the person
);

-- Table for storing information about corporations
CREATE TABLE CORPORATION (
  CO_ID INT PRIMARY KEY,      -- ID of the corporation
  Name VARCHAR(255),          -- Name of the corporation
  Address VARCHAR(255),       -- Address of the corporation
  Phone VARCHAR(20)           -- Phone number of the corporation
);

-- Table for storing information about employees
CREATE TABLE EMPLOYEE (
  Ssn INT PRIMARY KEY,        -- Social Security number of the employee
  Salary INT,                 -- Salary of the employee
  Shift VARCHAR(20),          -- Shift worked by the employee
  shift_timming VARCHAR(20),  -- Shift timing of the employee
  FOREIGN KEY (Ssn) REFERENCES PERSON(Ssn)
);

-- Table for storing information about pilots (subclass of PERSON)
CREATE TABLE PILOT (
  Ssn INT PRIMARY KEY,        -- Social Security number of the pilot
  Lic_num VARCHAR(20),        -- License number of the pilot
  Restr VARCHAR(255),		  -- Restrictions on the pilot's license
  FOREIGN KEY (Ssn) REFERENCES PERSON(Ssn)
);

-- Table to store information about airplane owners
CREATE TABLE OWNS (
  Reg# INT,
  Owner_ID INT,
  Pdate DATE,
  FOREIGN KEY (Reg#) REFERENCES AIRPLANE(Reg#),    -- Foreign key referencing the Reg# column in the AIRPLANE table
  FOREIGN KEY (Owner_ID) REFERENCES OWNER(ID)      -- Foreign key referencing the ID column in the OWNER table
);

-- Table to store information about maintenance service records
CREATE TABLE SERVICE (
  Service_ID INT PRIMARY KEY,       -- Primary key identifying each service record
  Date DATE,                        -- Date of maintenance
  Hours INT,                        -- Number of hours spent on maintenance work
  Work_code VARCHAR(20)             -- Type of maintenance work done
);

-- Table to associate airplanes with maintenance service records
CREATE TABLE PLANE_SERVICE (
  Reg# INT,
  Service_ID INT,
  FOREIGN KEY (Reg#) REFERENCES AIRPLANE(Reg#),				 -- Foreign key referencing the Reg# column in the AIRPLANE table
  FOREIGN KEY (Service_ID) REFERENCES SERVICE(Service_ID)    -- Foreign key referencing the Service_ID column in the SERVICE table
);

-- Table to associate pilots with airplane models they are authorized to fly
CREATE TABLE FLIES (
  Pilot_Ssn INT,
  Model INT,
  FOREIGN KEY (Pilot_Ssn) REFERENCES PILOT(Ssn),    -- Foreign key referencing the Ssn column in the PILOT table
  FOREIGN KEY (Model) REFERENCES PLANE_TYPE(Model)  -- Foreign key referencing the Model column in the PLANE_TYPE table
);

-- Table to associate employees with airplane models they can work on
CREATE TABLE WORKS_ON (
  Ssn_emp INT,
  Model_emp INT,	
  FOREIGN KEY (Ssn_emp) REFERENCES EMPLOYEE(Ssn),			   -- Foreign key referencing the Ssn column in the EMPLOYEE table
  FOREIGN KEY (Model_emp) REFERENCES PLANE_TYPE(Model)         -- Foreign key referencing the Model column in the PLANE_TYPE table
);

CREATE TABLE MAINTAIN_BY (
	SERVICE_ID INT,
	EMP_ID INT
	FOREIGN KEY (SERVICE_ID) REFERENCES SERVICE(Service_ID),
	FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(SSN)
);

INSERT INTO PLANE_TYPE (Model, Capacity, Weight) VALUES
  (1001, 150, 50000),
  (1002, 250, 80000),
  (1003, 180, 60000),
  (1004, 120, 45000),
  (1005, 300, 100000),
  (1006, 200, 70000),
  (1007, 170, 55000),
  (1008, 160, 52000),
  (1009, 190, 62000),
  (1010, 220, 75000),
  (1011, 240, 78000),
  (1012, 130, 48000),
  (1013, 270, 90000),
  (1014, 230, 77000),
  (1015, 140, 52000),
  (1016, 210, 68000),
  (1017, 200, 71000),
  (1018, 250, 82000),
  (1019, 190, 62000),
  (1020, 150, 51000);

INSERT INTO HANGAR (Number, Capacity, Location) VALUES
  (1, 10, 'Building A'),
  (2, 8, 'Building B'),
  (3, 15, 'Building A'),
  (4, 12, 'Building C'),
  (5, 7, 'Building D'),
  (6, 20, 'Building C'),
  (7, 18, 'Building A'),
  (8, 9, 'Building D'),
  (9, 16, 'Building B'),
  (10, 11, 'Building A'),
  (11, 14, 'Building C'),
  (12, 13, 'Building B'),
  (13, 6, 'Building D'),
  (14, 19, 'Building A'),
  (15, 8, 'Building B'),
  (16, 12, 'Building G'),
  (17, 17, 'Building D'),
  (18, 10, 'Building A'),
  (19, 14, 'Building E'),
  (20, 15, 'Building F');

INSERT INTO AIRPLANE (Reg#, OF_TYPE, STORED_IN) VALUES
  (10001, 1001, 1),
  (10002, 1001, 1),
  (10003, 1001, 1),
  (10004, 1002, 1),
  (10005, 1002, 2),
  (10006, 1002, 2),
  (10007, 1003, 4),
  (10008, 1004, 4),
  (10009, 1005, 4),
  (10010, 1010, 8),
  (10011, 1011, 8),
  (10012, 1012, 8),
  (10013, 1013, 3),
  (10014, 1014, 10),
  (10015, 1015, 3),
  (10016, 1016, 6),
  (10017, 1017, 6),
  (10018, 1018, 6),
  (10019, 1019, 19),
  (10020, 1020, 20);

INSERT INTO OWNER (ID, Type, location) VALUES
  (1, 'person', 'Building A'),
  (2, 'corporation', 'Building B'),
  (3, 'corporation', 'Building C'),
  (4, 'corporation', 'Building D'),
  (5, 'person', 'Building E'),
  (6, 'corporation', 'Building F'),
  (7, 'person', 'Building G'),
  (8, 'corporation', 'Building H'),
  (9, 'person', 'Building I'),
  (10, 'corporation', 'Building J'),
  (11, 'person', 'Building K'),
  (12, 'corporation', 'Building L'),
  (13, 'corporation', 'Building M'),
  (14, 'corporation', 'Building N'),
  (15, 'person', 'Building O'),
  (16, 'corporation', 'Building P'),
  (17, 'person', 'Building Q'),
  (18, 'corporation', 'Building R'),
  (19, 'person', 'Building S'),
  (20, 'corporation', 'Building T');

INSERT INTO PERSON (Ssn, Name, Address, Phone)
VALUES 
  (123456789, 'John Doe', '123 Main St', '555-1234'),
  (234567890, 'Jane Doe', '456 Elm St', '555-5678'),
  (345678901, 'Bob Smith', '789 Oak St', '555-9012'),
  (456789012, 'Alice Johnson', '321 Pine St', '555-3456'),
  (567890123, 'Charlie Brown', '654 Cedar St', '555-7890'),
  (678901234, 'Emily Davis', '987 Maple St', '555-1234'),
  (789012345, 'George Lee', '246 Walnut St', '555-5678'),
  (890123456, 'Karen Martin', '369 Birch St', '555-9012'),
  (901234567, 'Mike Adams', '582 Spruce St', '555-3456'),
  (112233445, 'Nicole Anderson', '735 Fir St', '555-7890'),
  (223344556, 'Oliver Baker', '864 Oak St', '555-1234'),
  (334455667, 'Patricia Brown', '927 Elm St', '555-5678'),
  (445566778, 'Quinn Carter', '150 Maple St', '555-9012'),
  (556677889, 'Ryan Davis', '381 Pine St', '555-3456'),
  (667788990, 'Samantha Evans', '294 Cedar St', '555-7890'),
  (778899001, 'Thomas Ford', '603 Maple St', '555-1234'),
  (889900112, 'Ursula Green', '816 Walnut St', '555-5678'),
  (990011223, 'Victoria Hernandez', '429 Birch St', '555-9012'),
  (101112233, 'William Ito', '758 Spruce St', '555-3456'),
  (121212121, 'Xavier Johnson', '387 Fir St', '555-7890');

INSERT INTO CORPORATION (CO_ID, Name, Address, Phone)
VALUES
	(1, 'Acme Corporation', '123 Main St, Anytown, USA', '555-1234'),
	(2, 'Globex Corporation', '456 Elm St, Anytown, USA', '555-5678'),
	(3, 'Wayne Enterprises', '1007 Mountain Dr, Gotham City', '555-1212'),
	(4, 'Stark Industries', '10880 Malibu Point, Malibu, CA', '555-2468'),
	(5, 'Umbrella Corporation', '13 Spencer Mansion, Raccoon City', '555-9876'),
	(6, 'Tyrell Corporation', '10988 Wilshire Blvd, Los Angeles, CA', '555-4321'),
	(7, 'Weyland-Yutani Corporation', '35 Corporate Sector, Thedus', '555-9999'),
	(8, 'Oscorp Industries', '22 Riverside Dr, New York, NY', '555-5555'),
	(9, 'Spacely Sprockets', '123 Orbit Way, Spacely Space Sprockets, Inc.', '555-0000'),
	(10, 'Cogswell Cogs', '456 Galaxy Blvd, Cogswell Cogs, Inc.', '555-1111'),
	(11, 'Wonka Industries', '123 Candy Lane, Chocolate River, USA', '555-2468'),
	(12, 'Initech', '1234 Main St, Suite 200, Austin, TX', '555-7777'),
	(13, 'Gekko & Co', '123 Wall St, New York, NY', '555-4444'),
	(14, 'Bluth Company', '1234 Sycamore St, Newport Beach, CA', '555-8888'),
	(15, 'Dunder Mifflin', '1725 Slough Ave, Scranton, PA', '555-3333'),
	(16, 'Waystar Royco', '1 Waystar Way, New York, NY', '555-2222'),
	(17, 'Ewing Oil', '100 Southfork Ranch, Braddock County, TX', '555-1212'),
	(18, 'Dynasty Corp', '555 Carrington Way, Denver, CO', '555-4567'),
	(19, 'Krusty Krab', '123 Conch St, Bikini Bottom', '555-7890'),
	(20, 'Monsters, Inc.', '123 Scarers Way, Monstropolis', '555-2468');

INSERT INTO EMPLOYEE (Ssn, Salary, Shift, shift_timming) VALUES
  (123456789, 50000, 'Day', '08AM-05PM'),
  (234567890, 60000, 'Night', '12PM-02AM'),
  (345678901, 55000, 'Day', '08AM-05PM'),
  (456789012, 65000, 'Night', '11PM-07AM'),
  (567890123, 45000, 'Day', '08AM-05PM'),
  (678901234, 55000, 'Night', '11PM-07AM'),
  (789012345, 50000, 'Day', '08AM-05PM'),
  (890123456, 60000, 'Night', '11PM-07AM'),
  (901234567, 55000, 'Day', '08AM-05PM'),
  (112233445, 65000, 'Night', '11PM-07AM'),
  (223344556, 45000, 'Day', '08AM-05PM'),
  (334455667, 55000, 'Night', '11PM-07AM'),
  (445566778, 50000, 'Day', '08AM-05PM'),
  (556677889, 60000, 'Night', '11PM-07AM'),
  (667788990, 55000, 'Day', '08AM-05PM'),
  (778899001, 65000, 'Night', '01AM-04AM'),
  (889900112, 45000, 'Day', '08AM-05PM'),
  (990011223, 55000, 'Night', '10PM-05AM'),
  (101112233, 50000, 'Day', '08AM-05PM'),
  (121212121, 60000, 'Night','11PM-01AM');

INSERT INTO PILOT (Ssn,Lic_num,Restr)
VALUES 
  (123456789, 'P12345', 'None'),
  (234567890, 'P23456', 'Glasses'),
  (345678901, 'P34567', 'None'),
  (456789012, 'P45678', 'Contacts'),
  (567890123, 'P56789', 'None'),
  (678901234, 'P67890', 'Glasses'),
  (789012345, 'P78901', 'None'),
  (890123456, 'P89012', 'Contacts'),
  (901234567, 'P90123', 'None'),
  (112233445, 'P11223', 'Glasses'),
  (223344556, 'P22334', 'None'),
  (334455667, 'P33445', 'Contacts'),
  (445566778, 'P44556', 'None'),
  (556677889, 'P55667', 'Glasses'),
  (667788990, 'P66778', 'None'),
  (778899001, 'P77889', 'Contacts'),
  (889900112, 'P88990', 'None'),
  (990011223, 'P99001', 'Glasses'),
  (101112233, 'P10111', 'None'),
  (121212121, 'P12121', 'Contacts');

INSERT INTO OWNS (Reg#, Owner_ID, Pdate)
VALUES 
  (10001, 1, '2022-01-01'),
  (10002, 2, '2022-01-02'),
  (10003, 1, '2022-01-03'),
  (10004, 3, '2022-01-04'),
  (10005, 4, '2022-01-05'),
  (10006, 16, '2022-01-06'),
  (10007, 14, '2022-01-07'),
  (10008, 13, '2022-01-08'),
  (10009, 12, '2022-01-09'),
  (10010, 11, '2022-01-10'),
  (10011, 12, '2022-01-11'),
  (10012, 3, '2022-01-12'),
  (10013, 3, '2022-01-13'),
  (10014, 3, '2022-01-14'),
  (10015, 8, '2022-01-15'),
  (10016, 9, '2022-01-16'),
  (10017, 1, '2022-01-17'),
  (10018, 6, '2022-01-18'),
  (10019, 6, '2022-01-19'),
  (10020, 6, '2023-03-01');

INSERT INTO SERVICE (Service_ID, Date, Hours, Work_code)
VALUES 
  (1, '2005-01-01', 5, 'ACFT01'),
  (2, '2022-01-02', 7, 'ACFT02'),
  (3, '2022-01-03', 4, 'ACFT03'),
  (4, '2022-01-04', 3, 'ACFT04'),
  (5, '2022-01-05', 9, 'ACFT05'),
  (6, '2022-01-06', 8, 'ACFT06'),
  (7, '2022-01-07', 6, 'ACFT07'),
  (8, '2022-01-08', 2, 'ACFT08'),
  (9, '2022-01-09', 10, 'ACFT09'),
  (10,'2022-01-10', 3, 'ACFT10'),
  (11,'2022-01-11', 6, 'ACFT11'),
  (12,'2022-01-12', 7, 'ACFT12'),
  (13,'2022-01-13', 4, 'ACFT13'),
  (14,'2022-01-14', 8, 'ACFT14'),
  (15,'2022-01-15', 5, 'ACFT15'),
  (16,'2022-01-16', 2, 'ACFT16'),
  (17,'2022-01-17', 7, 'ACFT17'),
  (18,'2020-01-18', 9, 'ACFT18'),
  (19,'2023-03-22', 3, 'ACFT19'),
  (20,'2015-03-20', 6, 'ACFT20');

INSERT INTO PLANE_SERVICE (Reg#, Service_ID)
VALUES
	(10001, 1),
	(10001, 2),
	(10002, 3),
	(10002, 4),
	(10002, 5),
	(10006, 6),
	(10004, 7),
	(10004, 8),
	(10004, 9),
	(10010, 10),
	(10011, 11),
	(10012, 12),
	(10013, 13),
	(10014, 14),
	(10015, 15),
	(10016, 16),
	(10017, 17),
	(10018, 18),
	(10019, 19),
	(NULL, 20);

INSERT INTO FLIES (Pilot_Ssn, Model)
VALUES 
	(123456789, 1001),
	(123456789, 1001),
	(345678901, 1001),
	(778899001, 1001),
	(567890123, 1001),
	(678901234, 1002),
	(778899001, 1002),
	(890123456, 1002),
	(901234567, 1002),
	(678901234, 1002),
	(223344556, 1003),
	(334455667, 1003),
	(778899001, 1003),
	(556677889, 1003),
	(678901234, 1004),
	(778899001, 1004),
	(778899001, 1004),
	(678901234, 1004),
	(101112233, 1004),
	(778899001, 1005);

INSERT INTO WORKS_ON (Ssn_emp, Model_emp)
VALUES
	(123456789, 1001),
	(NULL, 1002),
	(345678901, 1003),
	(456789012, 1004),
	(567890123, 1005),
	(678901234, 1006),
	(789012345, 1007),
	(890123456, 1008),
	(901234567, 1009),
	(112233445, 1010),
	(223344556, 1011),
	(334455667, 1012),
	(445566778, 1013),
	(556677889, 1014),
	(667788990, 1015),
	(778899001, 1016),
	(889900112, 1017),
	(990011223, 1018),
	(NULL, 1019),
	(121212121, 1020);

INSERT INTO MAINTAIN_BY (SERVICE_ID, EMP_ID) VALUES
  (1,  123456789),
  (2,  234567890),
  (3,  345678901),
  (4,  456789012),
  (5,  567890123),
  (6,  678901234),
  (7,  789012345),
  (8,  890123456),
  (9,  901234567),
  (10, 112233445),
  (11, 223344556),
  (12, 334455667),
  (13, 445566778),
  (14, 556677889),
  (15, 667788990),
  (16, 778899001),
  (17, 889900112),
  (18, 990011223),
  (19, 101112233),
  (20, 121212121);

-----------------------------------------------------------QUERIES----------------------------------------------------------------------------------
 
-----VIEW ALL THE INSERTED DATA-----
SELECT *FROM AIRPLANE
SELECT *FROM PLANE_TYPE
SELECT *FROM HANGAR
SELECT *FROM OWNER
SELECT *FROM PERSON
SELECT *FROM CORPORATION
SELECT *FROM EMPLOYEE
SELECT *FROM PILOT
SELECT *FROM OWNS
SELECT *FROM SERVICE
SELECT *FROM PLANE_SERVICE
SELECT *FROM FLIES
SELECT *FROM WORKS_ON

---3)	Write a SQL query to find the registration numbers of airplanes that have never undergone maintenance ---

SELECT Reg#
FROM AIRPLANE
WHERE Reg# NOT IN (
  SELECT Reg#
  FROM PLANE_SERVICE
);

---4)	Write a SQL query to find the names and addresses of corporations that own airplanes with a capacity greater than 200.---

SELECT CORPORATION.CO_ID,CORPORATION.Name,CORPORATION.Address FROM CORPORATION 
INNER JOIN OWNER ON CORPORATION.CO_ID = OWNER.ID
INNER JOIN OWNS ON OWNER.ID = OWNS.Owner_ID
INNER JOIN AIRPLANE ON AIRPLANE.Reg# = OWNS.Reg#
INNER JOIN PLANE_TYPE ON AIRPLANE.OF_TYPE = PLANE_TYPE.Model
WHERE PLANE_TYPE.Capacity > 200

---5)	Write a SQL query to find the average salary of employees who work the night shift (between 10 PM and 6 AM).---

SELECT ssn, AVG(Salary) AS avg_salary
FROM EMPLOYEE
WHERE Shift = 'Night' AND (
  (shift_timming LIKE '__PM-__AM' AND 
   (CAST(SUBSTRING(shift_timming, 1, 2) AS INT) >= 10 OR CAST(SUBSTRING(shift_timming, 1, 2) AS INT) = 12) AND 
   (CAST(SUBSTRING(shift_timming, 6, 2) AS INT) < 6 OR (CAST(SUBSTRING(shift_timming, 6, 2) AS INT) = 12 AND CAST(SUBSTRING(shift_timming, 4, 2) AS INT) = 0))
  )
  OR
  (shift_timming LIKE '__AM-__AM' AND  (CAST(SUBSTRING(shift_timming, 1, 2) AS INT) < 6 ) AND  (CAST(SUBSTRING(shift_timming, 6, 2) AS INT) < 6 ))
)
group by ssn;

---6) Write a SQL query to find the top 5 employees with the highest total number of maintenance hours worked.---

SELECT TOP 5 e.Ssn, SUM(s.Hours) AS total_hours
FROM EMPLOYEE e
JOIN MAINTAIN_BY m ON e.Ssn = m.EMP_ID
JOIN SERVICE s ON m.SERVICE_ID = s.Service_ID
GROUP BY e.Ssn
ORDER BY total_hours DESC;

---7) Write a SQL query to find the names and registration numbers of airplanes that have undergone maintenance in the past week.---

---7(a)) past week

SELECT DISTINCT p.Reg#
FROM AIRPLANE p
JOIN PLANE_SERVICE ps ON p.Reg# = ps.Reg#
JOIN SERVICE s ON ps.Service_ID = s.Service_ID
WHERE s.Date BETWEEN DATEADD(day, -7, GETDATE()) AND GETDATE();

---7(b)) find the names and registration numbers of airplanes that have undergone maintenance in the last 15 years.---

SELECT DISTINCT p.Reg#
FROM AIRPLANE p
JOIN PLANE_SERVICE ps ON p.Reg# = ps.Reg#
JOIN SERVICE s ON ps.Service_ID = s.Service_ID
WHERE s.Date BETWEEN DATEADD(year, -15, GETDATE()) AND GETDATE();


---8) Write a SQL query to find the names and phone numbers of all owners who have purchased a plane in the past month.---

SELECT DISTINCT
    CASE
        WHEN Owner.Type = 'person' THEN Person.Name
        WHEN Owner.Type = 'corporation' THEN Corporation.Name
    END AS Name,
    CASE
        WHEN Owner.Type = 'person' THEN Person.Phone
        WHEN Owner.Type = 'corporation' THEN Corporation.Phone
    END AS Phone
FROM
    OWNS
    JOIN AIRPLANE ON OWNS.Reg# = AIRPLANE.Reg#
    JOIN OWNER ON OWNS.Owner_ID = OWNER.ID
    LEFT JOIN PERSON ON Owner.Type = 'person' AND OWNER.ID = PERSON.Ssn
    LEFT JOIN CORPORATION ON Owner.Type = 'corporation' AND OWNER.ID = CORPORATION.CO_ID
WHERE
    OWNS.Pdate >= DATEADD(month, -1, GETDATE())

---9) Write a SQL query to find the number of airplanes each pilot is authorized to fly.---

SELECT 
    Pilot.Ssn,
    COUNT(FLIES.Model) AS aut_airplane
FROM 
    PILOT 
    JOIN FLIES ON PILOT.Ssn = FLIES.Pilot_Ssn 
GROUP BY 
    Pilot.Ssn
ORDER BY 
    aut_airplane DESC;

---10) Write a SQL query to find the location and capacity of the hangar with the most available space.

SELECT TOP 1 LOCATION, Capacity  FROM HANGAR
ORDER BY 
	Capacity DESC

--11) Write a SQL query to find the number of planes owned by each corporation, sorted in descending order by number of planes.---

SELECT C.CO_ID,c.Name AS Corporation, COUNT(DISTINCT ow.Reg#) AS Num_Planes_Owned
FROM CORPORATION c
JOIN OWNER o ON o.ID = c.CO_ID AND o.Type = 'corporation'
JOIN OWNS ow ON ow.Owner_ID = o.ID
GROUP BY c.Name,c.CO_ID
ORDER BY Num_Planes_Owned DESC;

--12) Write a SQL query to find the average number of maintenance hours per plane, broken down by plane type.

SELECT pt.Model, AVG(s.Hours) AS Avg_Maintenance_Hours
FROM AIRPLANE a
JOIN PLANE_TYPE pt ON a.OF_TYPE = pt.Model
JOIN PLANE_SERVICE ps ON ps.Reg# = a.Reg#
JOIN SERVICE s ON s.Service_ID = ps.Service_ID
GROUP BY pt.Model


--13) Write a SQL query to find the names of owners who have purchased a plane that requires maintenance work from an employee who is not qualified to
---Work on that type of plane.---

SELECT DISTINCT o.ID
FROM OWNER o
JOIN OWNS os ON o.ID = os.Owner_ID
JOIN AIRPLANE a ON os.Reg# = a.Reg#
JOIN PLANE_TYPE pt ON a.OF_TYPE = pt.Model
JOIN WORKS_ON wo ON pt.Model = wo.Model_emp
LEFT JOIN EMPLOYEE e ON wo.Ssn_emp = e.Ssn
LEFT JOIN WORKS_ON wo2 ON e.Ssn = wo2.Ssn_emp AND wo2.Model_emp = pt.Model
WHERE wo2.Ssn_emp IS NULL;

---14) Write a SQL query to find the names and phone numbers of owners who have purchased a plane from a corporation that has a hangar in the same location as the owner.---

SELECT DISTINCT o.ID, o.location,o.Type
FROM OWNER o
JOIN OWNS ows ON ows.Owner_ID = o.ID
JOIN AIRPLANE a ON a.Reg# = ows.Reg#
JOIN HANGAR h ON h.Location = o.location
WHERE O.Type = 'corporation'

---15) Write a SQL query to find the names of pilots who are qualified to fly a plane that goes currently in maintenance---

--15 A)

SELECT DISTINCT p.Lic_num, p.Restr
FROM PILOT p
JOIN FLIES f ON p.Ssn = f.Pilot_Ssn
JOIN PLANE_TYPE pt ON f.Model = pt.Model
JOIN AIRPLANE a ON pt.Model = a.OF_TYPE
JOIN PLANE_SERVICE ps ON a.Reg# = ps.Reg#
JOIN SERVICE s ON ps.Service_ID = s.Service_ID
WHERE s.Date BETWEEN DATEADD(day, -1000, GETDATE()) AND GETDATE()

--15 B) 

SELECT DISTINCT p.Lic_num, p.Restr
FROM PILOT p
JOIN FLIES f ON p.Ssn = f.Pilot_Ssn
JOIN PLANE_TYPE pt ON f.Model = pt.Model
JOIN AIRPLANE a ON pt.Model = a.OF_TYPE
JOIN PLANE_SERVICE ps ON a.Reg# = ps.Reg#
JOIN SERVICE s ON ps.Service_ID = s.Service_ID
WHERE s.Date >= GETDATE()

---16) Write a SQL query to find the names of employees who have worked on planes owned by a particular corporation, sorted by the total number of maintenance hours worked.---

SELECT e.Ssn, SUM(s.Hours) AS Total_Maintenance_Hours
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Ssn_emp
JOIN PLANE_TYPE p ON w.Model_emp = p.Model
LEFT JOIN AIRPLANE a ON p.Model = a.OF_TYPE
LEFT JOIN PLANE_SERVICE ps ON a.Reg# = ps.Reg#
LEFT JOIN SERVICE s ON ps.Service_ID = s.Service_ID
JOIN OWNS o ON a.Reg# = o.Reg#
JOIN OWNER ow ON o.Owner_ID = ow.ID
WHERE ow.Type = 'corporation'
GROUP BY e.Ssn
ORDER BY Total_Maintenance_Hours DESC;

---17) Write a SQL query to find the names and registration numbers of airplanes that have been owned by a PERSON  or undergone
---maintenance work from an employee who works the day shift.---

SELECT a.Reg#, a.OF_TYPE
FROM AIRPLANE a
LEFT JOIN OWNS o ON a.Reg# = o.reg#
LEFT JOIN OWNER ow ON o.Owner_ID = ow.ID AND ow.Type = 'person'
LEFT JOIN WORKS_ON w ON a.OF_TYPE = w.Model_emp
LEFT JOIN EMPLOYEE e ON w.Ssn_emp = e.Ssn AND e.Shift = 'day'
WHERE ow.ID IS NOT NULL OR e.Ssn IS NOT NULL;

---18) Write a SQL query to find the names and addresses of owners who have purchased a plane from a corporation that has also 
---purchased a plane of the same type in the past 20 month.(i edit the query because my data is not in this range :))( for past just we have to do -1) ---

SELECT o.ID, o.Type,o.location
FROM OWNER o
JOIN OWNS o1 ON o.ID = o1.Owner_ID
JOIN AIRPLANE a1 ON o1.Reg# = a1.Reg#
WHERE o.Type = 'corporation'
AND o1.Pdate >= DATEADD(month, -20, GETDATE())

---19)  Write a Query to find the total number of planes stored in each hangar.---

SELECT HANGAR.Number, COUNT(AIRPLANE.Reg#) AS TOTAL_PLANES
FROM HANGAR
LEFT JOIN AIRPLANE ON AIRPLANE.STORED_IN = HANGAR.Number
GROUP BY HANGAR.Number
ORDER BY TOTAL_PLANES DESC

---20)	Write a Query to find the total number of planes of each plane type.---

SELECT PLANE_TYPE.Model, COUNT(AIRPLANE.Reg#) AS TOTAL_PLANES
FROM PLANE_TYPE
LEFT JOIN AIRPLANE ON AIRPLANE.OF_TYPE = PLANE_TYPE.Model
GROUP BY PLANE_TYPE.Model
ORDER BY TOTAL_PLANES DESC

---21) Write a Query to find the total number of services performed on each plane.---

SELECT AIRPLANE.Reg#, COUNT(PLANE_SERVICE.Reg#) AS Total_Services
FROM AIRPLANE
LEFT JOIN PLANE_SERVICE
ON AIRPLANE.Reg# = PLANE_SERVICE.Reg#
GROUP BY AIRPLANE.Reg#
ORDER BY Total_Services DESC

--22) Write a Query to find the average salary of employees in each shift.----------

--22(A) AVERAGE SALARY OF EACH EMPLOYEE

SELECT E.Ssn, E.Shift, AVG(E.Salary) AS AVG_SAL_OF_EMP
FROM EMPLOYEE E
group by E.Ssn, E.Shift

--22(B) AVG SALARY OF EMPLOYEE IN EACH SHIFT 

SELECT Shift, AVG(Salary) AS AvgSalary
FROM EMPLOYEE
GROUP BY Shift;

--23) Write a Query to find the total number of planes each owner owns.

SELECT  O.ID, COUNT(OW.Reg# ) AS TOTAL_PLANES
FROM OWNER O
LEFT JOIN OWNS OW ON OW.Owner_ID = O.ID
GROUP BY O.ID
ORDER BY TOTAL_PLANES DESC

--24) Write a Query to find the number of planes each pilot is authorized to fly.

SELECT PILOT.Ssn, COUNT(FLIES.Model) AS AUTH_PLANES
FROM PILOT
LEFT JOIN FLIES ON PILOT.Ssn = FLIES.Pilot_Ssn
GROUP BY PILOT.SSN
ORDER BY AUTH_PLANES DESC

--25) Write 4 Queries Other than this and write their Importance in the Comments why do you think they are important and where can they be used. ---

--QUERY: NO: 01 : Retrieve a list of pilots and their authorized airplane models ---

SELECT p.Ssn, pt.Model
FROM PILOT p
INNER JOIN FLIES f ON p.Ssn = f.Pilot_Ssn
INNER JOIN PLANE_TYPE pt ON f.Model = pt.Model;

/* ***IMPORTANCE***
	This query is important as it provides information about which pilots are authorized to fly which airplane models. 
	This information can be used for scheduling flights and assigning pilots to specific planes based on their authorization.
	It can also help in managing the training and certification of pilots for different airplane models.
	Additionally, this information can be used for analyzing the distribution of pilot authorizations across different airplane types
	and identifying areas for improvement in pilot training and certification programs.
*/
--QUERY: NO: 02 : Retrieve a list of maintenance service records for a specific airplane---

SELECT s.Date, s.Hours, s.Work_code
FROM SERVICE s
INNER JOIN PLANE_SERVICE ps ON s.Service_ID = ps.Service_ID
INNER JOIN AIRPLANE ON AIRPLANE.Reg# = ps.Reg#

/* ***IMPORTANCE***
	This query is important for maintaining the maintenance history of a specific airplane. By using this query, you can retrieve the list 
	of maintenance service records for a specific airplane. This information is very useful in case of any issues with the airplane in the future,
	as it will help in identifying the maintenance history of the airplane, and any recurring issues that may have occurred in the past. 
	This query can be used by maintenance engineers, mechanics, and airline companies to keep track of the maintenance history of their airplanes.
*/
--QUERY: NO: 03 : Retrieve a list of employees who can work on a specific airplane model and additional print in sequence of shifts and salaray in descending order---

SELECT *
FROM employee
ORDER BY 
    CASE 
        WHEN shift = 'night' THEN 1
        ELSE 2
    END, shift, salary DESC;

/* ***IMPORTANCE***
	This query is useful in situations where you want to find employees who are qualified to work on a specific airplane model,
	and then sort them by their shift and salary. It can be used by airline companies to efficiently manage their workforce and 
	assign employees to specific tasks based on their skills and availability.
	The query uses the ORDER BY clause to sort the results in a specific order. The CASE statement is used to sort employees based on
	their shift, with those working the night shift appearing first. The salary is sorted in descending order, so that employees with 
	higher salaries appear first. This allows companies to quickly identify the most qualified and available employees for a particular job,
	while also ensuring that employees are paid fairly for their work.
*/

--QUERY: NO: 04 : Retrieve the data from every hangar on the basis of its capacity in descending order 

SELECT *
FROM HANGAR
ORDER BY HANGAR.Capacity DESC

/* *** IMPORTANCE ***
	This query is useful for retrieving the data of all the hangars based on their capacity in descending order. This information can be helpful in
	managing the parking and storage of airplanes. For example, if the capacity of a hangar is nearing its limit, it may be necessary to either move 
	some planes to another hangar or build a new one with a higher capacity.
	By having this information easily accessible, airport or airline administrators can make informed decisions about hangar management.
*/
--QUERY: NO: 05 : Retrieve the names and addresses of all corporations that own more than 2 airplanes:

SELECT c.Name, c.Address
FROM OWNER o
JOIN CORPORATION c ON o.ID = c.CO_ID
JOIN OWNS ow ON o.ID = ow.Owner_ID
JOIN AIRPLANE a ON ow.Reg# = a.Reg#
GROUP BY c.Name, c.Address
HAVING COUNT(*) >= 3;

/* *** IMPORTANCE ***
This query is important because it helps identify corporations that have a large fleet of airplanes, which could be useful in various scenarios such as 
market analysis, customer segmentation, or business strategy planning. For example, an airline company could use this query to identify potential competitors
or partners in the industry, or a manufacturer could use it to identify potential customers for their aircraft. This query can be used in various industries
such as aviation, transportation, and business analysis.
*/
--QUERY: NO: 06 : Retrieve the total number of hours spent on maintenance for each airplane:

SELECT a.Reg#, SUM(s.Hours) AS total_maintenance_hours
FROM AIRPLANE a
LEFT JOIN PLANE_SERVICE ps ON a.Reg# = ps.Reg#
LEFT JOIN SERVICE s ON ps.Service_ID = s.Service_ID
GROUP BY a.Reg#
ORDER BY total_maintenance_hours desc

/* *** IMPORTANCE ***
	This query is important for analyzing the maintenance history of each airplane in the database. By retrieving the total number of hours spent on maintenance
	for each airplane, we can identify which airplanes require more maintenance and which ones require less. This information can be used to optimize maintenance
	schedules and ensure that all airplanes are properly maintained to ensure safe and efficient operations. The query can be used by airlines, aircraft maintenance
	organizations, and other aviation-related businesses.
*/