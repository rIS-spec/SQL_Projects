DROP TABLE IF EXISTS employee2;

CREATE TABLE employee2(
	employee_id	INT	PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	email VARCHAR(50),	
	department VARCHAR(20),	
	salary NUMERIC(10,2),	
	joining_date DATE,	
	age INT	
);

SELECT * FROM employee2;


select first_name, salary, (salary*0.10) AS Bonus
from employee2;


-- Calculate New Salary--
Select first_name, last_name, salary,
		(salary*12) AS Annua_salary,
		(salary*0.05) AS Increment_salary,
		(salary + (salary*0.05)) AS New_salary,
		(salary * 1.05) AS New_salary2
From employee2;




-- matches age 30
SELECT * FROM employee2
WHERE age=30;


--matches all except 30
SELECT first_name, age FROM employee2
WHERE age!=30;


-- salary greather than 50000
SELECT first_name, salary FROM employee2
WHERE salary<50000;





--USING AND OPERATORS
SELECT * FROM employee2
WHERE age>=60 AND salary >=90000;


--USING OR OPERTORS
SELECT * FROM employee2
WHERE age>=60 OR salary >=100000;

--USING NOT
SELECT * FROM employee2
WHERE NOT (department='IT');
 



-- 1) Retrieve employees whose salary is between 40,000 and 60,000. - Use BETWEEN Operators

SELECT first_name, last_name, salary 
FROM employee2
WHERE salary BETWEEN 40000 AND 60000;


-- 2) Find employees whose email addresses end with gmail.com - Use LIKE Operators

SELECT first_name, last_name, email 
FROM employee2
WHERE email LIKE '%@gmail.com';


SELECT first_name FROM employee2
WHERE first_name LIKE '%j%';


-- 3) Retrieve employees who belong to either the 'Finance' or 'Marketing' departments-- Use IN Operator

SELECT first_name, last_name, department
FROM employee2
WHERE department IN ('Finance','Marketing', 'IT');






-- Find employees where the email column is NULL ( if applicable).

SELECT first_name, last_name, email
FROM employee2
WHERE email IS NULL;


-- List employees sorted by salary in DESCENDING order.

SELECT first_name, last_name, salary
FROM employee2
ORDER BY salary ASC;

-- Retrieve the top 5 highest-paid employees.

SELECT first_name, last_name, salary
FROM employee2
ORDER BY salary DESC
LIMIT 5; 

select first_name, las

-- Retrieve a list of unique departments

SELECT COUNT (DISTINCT department) AS DEP_UNIQUE_COUNT
FROM employee2;

