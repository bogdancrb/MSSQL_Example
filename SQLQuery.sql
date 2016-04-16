/* 
	EN: Created by Bogdan Corbeanu - ACE UCV RO 
	RO: Creat de Bogdan Corbeanu - ACE UCV RO 
*/

CREATE DATABASE Examen;

USE Examen;

CREATE TABLE Employee
(
	FName varchar(20) not null,
	MInit varchar(2) not null,
	LName varchar(20) not null,
	SSN varchar(15) not null,
	BDate date,
	Address varchar(50) not null,
	Sex varchar(2) not null,
	Salary float not null,
	SUPERSSN varchar(15) null,
	DNO int not null
	primary key (SSN),
);

CREATE TABLE Department 
(
	DName varchar(20) not null,
	DNumber int not null,
	MGRSSN varchar(15) not null,
	MGRSTARTDATE date not null,
	primary key (DNumber),
	foreign key (MGRSSN) references Employee(SSN) on delete cascade on update cascade
);

CREATE TABLE Dept_Location
(
	DNumber int not null,
	DLocation varchar(20) not null,
	foreign key (DNumber) references Department(DNumber) on delete cascade on update cascade
);

CREATE TABLE Project
(
	PName varchar(20) not null,
	PNumber int not null,
	PLocation varchar(20) not null,
	DNUM int not null,
	primary key (PNumber)
);

CREATE TABLE Works_On
(
	ESSN varchar(15) not null,
	PNO int not null,
	Hours float null,
	foreign key (ESSN) references Employee(SSN) on delete cascade on update cascade,
	foreign key (PNO) references Project(PNumber) on delete cascade on update cascade
);

CREATE TABLE Dependent
(
	ESSN varchar(15) not null,
	DependentName varchar(20) not null,
	Sex varchar(2) not null,
	BDate date,
	Relationship varchar(10) not null,
	foreign key (ESSN) references Employee(SSN) on delete cascade on update cascade
);

INSERT INTO Employee VALUES ('John','B','Smith','123456789','1965-01-09','731 Fondren, Houston, TX','M',30000,'333445555',5),
							('Franklin','T','Wong','333445555','1955-12-08','638 Voss, Houston, TX','M',40000,'888665555',5),
							('Alicia','J','Zelaya','999887777','1968-01-19','3321 Castle, Spring, TX','F',25000,'987654321',4),
							('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire, TX','F',43000,'888665555',4),
							('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble, TX','M',38000,'333445555',5),
							('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston, TX','F',25000,'333445555',5),
							('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston, TX','M',25000,'987654321',4),
							('James','E','Borg','888665555','1937-11-10','450 Stone, Houston, TX','M',55000,null,1);

UPDATE Employee SET DNO = 5 WHERE FName = 'Joyce';

INSERT INTO Department VALUES ('Research',5,'333445555','1988-05-22'),
							  ('Administration',4,'987654321','1995-01-01'),
							  ('Headquarters',1,'888665555','1981-06-19');

INSERT INTO Dept_Location VALUES (1,'Houston'),
								 (4,'Stafford'),
								 (5,'Bellaire'),
								 (5,'Sugarland'),
								 (5,'Houston');

INSERT INTO Project VALUES ('Product',5,'Bellaire',5),
						   ('ProductY',2,'Sugarland',5),
						   ('ProductZ',3,'Houston',5),
						   ('Computerization',10,'Stafford',4),
						   ('Reorganization',20,'Houston',1),
						   ('Newbenefits',30,'Stafford',4);

UPDATE Project SET PName = 'ProductX' WHERE PName = 'Product';
UPDATE Project SET PNumber = 1 WHERE PName = 'ProductX';

INSERT INTO Works_On VALUES ('123456789',1,32.5),
							('123456789',2,7.5),
							('666884444',3,40.0),
							('453453453',1,20.0),
							('453453453',2,20.0),
							('333445555',2,10.0),
							('333445555',3,10.0),
							('333445555',10,10.0),
							('333445555',20,10.0),
							('999887777',30,30.0),
							('999887777',10,10.0),
							('987987987',10,35.0),
							('987987987',30,5.0),
							('987654321',30,20.0),
							('987654321',20,15.0),
							('888665555',20,null);

INSERT INTO Dependent VALUES ('333445555','Alice','F','1986-04-05','DAUGHTER'),
							 ('333445555','Theodore','M','1963-10-25','SON'),
							 ('333445555','Joy','F','1958-05-03','SPOUSE'),
							 ('987654321','Abner','M','1942-02-28','SPOUSE'),
							 ('123456789','Michael','M','1988-01-04','SON'),
							 ('123456789','Alice','F','1988-12-30','DAUGHTER'),
							 ('123456789','Elizabeth','F','1967-05-05','SPOUSE');

------------------------------------------------------------------------------------------------------------------

/* 1.	RO: Sa se afiseze angajatii care fie sunt in departamentul 4, fie au salariul mai mare de $30,000 pe an. 
		EN: Display all the empolyees that belong to department 4 or that have salary greater than $30.000/year. */

SELECT FName, LName, DNO, Salary
FROM Employee
WHERE DNO = 4 OR Salary > 30000;

---

/* 2.	RO: Sa se afiseze angajatii care fie sunt in departamentul 4 si au salariul peste  $25,000 pe an, fie lucreaza 
	in departamentul 5 si care au salariul peste  $25,000.
		EN: Display all the employees that belong to department 4 and have the salary over $25.000/year, or belong to
	department 5 and have the salary over $25.000/year. */

SELECT FName, LName, DNO, Salary
FROM Employee
WHERE (DNO = 4 OR DNO = 5) AND SALARY > 25000;

SELECT FName, LName, DNO, Salary
FROM Employee
WHERE DNO IN (4,5) AND SALARY > 25000;

---

/* 3.	RO: Sa se afiseze numele si adresele tuturor angajatilor care lucreaza la departamentul "Research".
		EN: DIsplay the name and address of the employees who work in the "Research" department. */

SELECT FName, MInit, LName, Address, DName
FROM Employee, Department
WHERE DNO = DNumber AND DNumber = 5;

SELECT FName, MInit, LName, Address, DNO
FROM (Employee INNER JOIN Department ON DNO = DNumber AND DNumber = 5);

SELECT FName, MInit, LName, Address, DNO
FROM (Employee INNER JOIN Department ON DNO = DNumber) 
WHERE DNumber = 5;

---

/* 4.	RO: Pentru proiectele cu locatia in 'Stafford', sa se afiseze numarului proiectului, numarul de department 
	care controloleaza proiectul, numele si adresa managerului de department.
		EN: For the projects that are located in 'Stafford', display the project number, the department number who manages
	the project, the name and address of the department manager. */

SELECT PNumber, DNUM, FName, LName, Address
FROM Project, Employee, Department
WHERE PLocation = 'Stafford' AND DNUM = DNumber AND MGRSSN = SSN;

SELECT PNumber, DNum, FName, LName, Address
FROM Project, Employee
WHERE PLocation = 'Stafford' AND DNUM IN (SELECT DNumber
										  FROM Department
										  WHERE MGRSSN = SSN);

--- 

/* 5.	RO: Sa se afiseze lista proiectelor (numerele proiectelor) unui angajat cu numele “Smith” care lucreaza ca 
	angajat in proiect sau este manager la departamentul care controleaza proiectul.
		EN: Display the project list (project number) of an employee whos name is "Smith" who works at a project or
	is a manager of the department that controls the project. */

SELECT DISTINCT PNumber
FROM Project, Employee, Department
WHERE LName = 'Smith' AND (DNO = DNUM OR (MGRSSN = SSN AND DNumber = DNUM));

---

/* 6.	RO: Sa se afiseze numele angajatilor care nu au persoane in intretinere.
		EN: Display the name of the employees who do not have dependents. */

SELECT FName, LName
FROM Employee
WHERE NOT EXISTS (SELECT *
				  FROM Dependent
				  WHERE SSN = ESSN);

---

/* 7.	RO: Sa se afiseze numele managerilor care au cel putin o singura persoana in intretinere.
		EN: Display the name of the managers who have at least one dependent. */

SELECT FName, LName
FROM Employee, Department
WHERE SSN = MGRSSN AND EXISTS (SELECT *
							   FROM Dependent
							   WHERE SSN = ESSN);

---

/* 8.	RO: Sa se afiseze numele angajatilor din departamentul 5 care lucreaza minim 10 ore pe saptamana la 
	proiectul 'ProductX'.
		EN: soon */

SELECT FName, LName
FROM Employee, Project, Works_On
WHERE PName = 'ProductX' AND DNO = DNUM AND PNumber = PNO AND SSN = ESSN AND Hours >= 10;

---

/* 9.	RO: Sa se afiseze numele angajatilor care au o persoana in intretinere cu acelasi prenume. 
		EN: soon*/

SELECT FName, LName
FROM Employee
WHERE (SELECT COUNT(DependentName) 
	   FROM Dependent
	   WHERE ESSN = SSN) >= 2;

---

/* 10.	RO: Sa se afiseze angajatii care sunt direct supervizati de 'Franklin Wong'.
		EN: soon */

SELECT *
FROM Employee
WHERE SUPERSSN IN (SELECT SSN
				   FROM Employee
				   WHERE FName = 'Franklin' AND LName = 'Wong');

---

/* 11.	RO: Pentru fiecare proiect, sa se afiseze denumirea si numarul de ore pe saptamana (ale tuturor angajatilor) 
	lucrate pentru proiect. 
		EN: soon*/

SELECT PName, SUM(Hours)
FROM Project, Works_On
WHERE PNumber = PNO
GROUP BY PName;

---

/* 12.	RO: Sa se afiseze numele tuturor angajatilor care lucreaza la proiecte.
		EN: soon */

SELECT FName, LName
FROM Employee
WHERE SSN IN (SELECT ESSN
			  FROM Works_On
			  WHERE Hours > 0);

---

/* 13.	RO: Sa se afiseze numele tuturor angajatilor care nu lucreaza la nici un proiect.
		EN: soon */

SELECT FName, LName
FROM Employee
WHERE SSN NOT IN (SELECT ESSN
			      FROM Works_On
			      WHERE Hours > 0);

---

/* 14.	RO: Pentru fiecare departament sa se afiseze numele departmanetului si salariul mediu al angajatilor 
	care lucreaza in acel departament.
		EN: soon */

SELECT DName, AVG(Salary)
FROM Department, Employee
WHERE DNumber = DNO
GROUP BY DName;

---

/* 15.	RO: Sa se afiseze salariul mediu al tuturor angajatilor femei.
		EN: soon */

SELECT AVG(Salary)
FROM Employee
WHERE SEX = 'F';

---

/* 16.	RO: Sa se afiseze numele si adresele tuturor angajatilor care lucreaza la cel putin un proiect cu 
	locatia in Houston, dar care lucreaza la un departament care nu are locatia in Houston.
		EN: soon */

SELECT FName, LName, Address
FROM Employee
WHERE EXISTS (SELECT *
			  FROM Project, Dept_Location
			  WHERE DNO = DNUM AND PLocation = 'Houston' AND DNumber = DNO AND DLocation != 'Houston');

---

/* 17.	RO: Sa se afiseze numele si adresa angajatilor care au mai mult de 2 persoane in intretinere.
		EN: soon */

SELECT FName, LName, Address
FROM Employee
WHERE SSN IN (SELECT ESSN
			  FROM Dependent
			  GROUP BY ESSN
			  HAVING COUNT(ESSN) >= 2);

---

/* 18.	RO: Sa se afiseze numele si adresa managerilor care au mai mult de 2 persoane in intretinere.
		EN: soon */

SELECT FName, LName, Address
FROM Employee, Department
WHERE SSN = MGRSSN AND EXISTS (SELECT *
							   FROM Dependent
							   WHERE SSN = ESSN
							   GROUP BY ESSN
							   HAVING COUNT(ESSN) >=2);

---

/* 19.	RO: Sa se afiseze numele departamentelor si numarul de locatii ale acestora.
		EN: soon */

SELECT DName, COUNT(Dept_Location.DNumber)
FROM Department, Dept_Location
WHERE Department.DNumber = Dept_Location.DNumber
GROUP BY DName;

---

/* 20.	RO: Sa se afiseze numele departamentelor si numarul de angajati ale acestora.
		EN: soon */

SELECT DName, COUNT(DNO)
FROM Department, Employee
WHERE DNumber = DNO
GROUP BY DName;