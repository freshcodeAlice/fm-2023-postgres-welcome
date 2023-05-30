/*
DQL - data query (SELECT)
DDL - data definition
DML - data manipulation
DCL - data control
TCL - transaction conrol

*/


/*
SELECT - дай мені
*/

/*
CRUD над даними

Create - INSERT --- DML
Read - SELECT - DQL
Update - UPDATE ---  DML
Delete - DELETE --- DML

CRUD над таблицями
Create - CREATE TABLE --- DDL
Read - SELECT
Update - ALTER  --- DDL
Delete - DROP  --- DDL

*/

/* SELECT */
/*
Data Query Language (запити даних)
Процес або команда для отримання даних з БД наз. запитом
*/

/*
SELECT список вибірки FROM назва_таблиці


список вибірки - атрибути відношення (колонки таблиці), які мають увійти в результуючу таблицю
* - це всі атрибути таблиці


*/

SELECT * FROM users; --- всі колонки таблиці users

SELECT email FROM users;

/*
Табличний вираз

Табличний вираз обчислює таблицю.

*/

SELECT first_name, last_name, email FROM users;

-----WHERE-------

SELECT * FROM users
WHERE id = 5;


SELECT email FROM users
WHERE gender = 'male';



/*
Практика

1. Отримати всіх користувачів, в яких id - парний (четный )
2. Отримати всіх користувачів, які підписані на новини
3. Отримати мейли всіх користувачів-жінок


*/

---1
SELECT * FROM users
WHERE id % 2 = 0;

--2
SELECT * FROM users
WHERE is_subscribe = true;

--3
SELECT email FROM users
WHERE gender = 'female';


----------------------


SELECT * FROM users
WHERE first_name = 'John';

SELECT * FROM users
WHERE first_name IN ('John', 'Kate', 'William');

--v1
SELECT * FROM users
WHERE id IN (3, 4, 5);

--v2
SELECT * FROM users
WHERE id = 3 OR id = 4 OR id = 5;



--Всі користувачі, id яких між 100 і 200

--v1
SELECT * FROM users
WHERE id BETWEEN 100 AND 200;


--v2
SELECT * FROM users
WHERE id >= 100 AND id <=200;

-- Задача: вибрати всіх користувачів, в яких id в проміжку від 200 до 250 і при цьому вони чоловічого роду

SELECT * FROM users
WHERE (id BETWEEN 200 AND 250) AND (gender = 'male');


--------------------


--- Отримати всіх користувачів, в яких ім'я починається на літеру "К"

SELECT * FROM users
WHERE first_name LIKE 'K%';

/*

% - будь-яка кількість будь-яких символів
_ - 1 будь-який символ

*/

SELECT * FROM users
WHERE first_name LIKE '_____';


-----------------


ALTER TABLE users
ADD COLUMN height numeric(3, 2);

ALTER TABLE users
ADD COLUMN weight int;

------


UPDATE users
SET weight = 60
WHERE gender = 'female';



------


UPDATE users
SET height = 1.90
WHERE gender = 'female';

UPDATE users
SET height = 1.85
WHERE id % 2 = 0;


/*
Оновити висоту всіх підписаних жінок
встановити 1.75

*/


UPDATE users
SET height = 1.75
WHERE gender = 'female' AND is_subscribe;


/*

employees - робітники, співробітники
- ім'я (name)
- зарплата (salary)
- кількість відпрацьованих годин (work_hours)

Задача: всім робітникам, які відпрацювали більше ніж 150 годин
збільшити зп на 20%

UPDATE employees
SET salary = salary * 1.2
WHERE work_hours > 150;

*/


---- DELETE ---

INSERT INTO users (first_name, last_name, email, is_subscribe) VALUES
('Test', 'Testovich', 'tester', true) RETURNING *;

SELECT * FROM users
WHERE id = 1010;

DELETE 
FROM users
WHERE id = 1010
RETURNING *;



----------

--- Ім'я довше за 5 літер

SELECT * FROM users
WHERE char_length(first_name) > 5; 

UPDATE users
SET first_name = upper(first_name)
WHERE id = 1;


--- Вивести юзерів зі всією їхньою інформацією + стовбцем з повного імені користувача

SELECT *, concat(first_name, ' ', last_name) FROM users;


-- Всі дані + стовбець з кількістю літер імені
SELECT *, char_length(first_name) FROM users;


--------- Псевдоніми (аліас) ---------


---Вивести мейли користувачів під грифом "пошта", ім'я називалося "ім'я", height називався зріст

SELECT email AS "Пошта", first_name AS "Ім'я", height AS "Зріст"
FROM users;


/*
Вивести користувачів, id назвати як "Порядковий номер", first_name + last_name вивести як "Повне ім'я" 
і is_subsdcribe вивести як "Підписка"
*/


SELECT id AS "Порядковий номер", concat(first_name, ' ', last_name) AS "Повне ім'я", is_subscribe AS "Підписка"
FROM users;


SELECT * 
FROM users AS u
WHERE u.id = 1;


--------------

SELECT *, extract(years from age(birthday)) 
FROM users;


/*
1. Отримати всіх жінок, ім'я яких починається на "А"

2. Отримати всіх повнолітніх чоловіків

3. Отримати всіх користувачів, які народились у вересні

*/

--1
SELECT * 
FROM users
WHERE (first_name LIKE 'A%') AND gender = 'female';


--2
SELECT * 
FROM users
WHERE (extract(years from age(birthday)) >= 18) AND (gender = 'male');


--3
SELECT * 
FROM users
WHERE extract(month from birthday) = 9;


/*
4. Всіх користувачів віком від 20 до 40 років

5. Всім користувачам, які народились у січні, оновити підписку  на TRUE

6. Оновити зріст всім користувачам, старшим за 60 років.
Встановити 1.78

7. Всім користувачам, зріст яких більше 2 метрів, встановити вагу 90кг.



*/

---4

SELECT * 
FROM users
WHERE extract(years from age(birthday)) BETWEEN 20 AND 40;


--5
UPDATE users
SET is_subscribe = TRUE
WHERE extract(month from birthday) = 1;


--6
UPDATE users
SET height = 1.78
WHERE extract(years from age(birthday)) > 60;


--7
UPDATE users
SET weight = 90
WHERE height > 2.0;



------Pagination--------

SELECT * 
FROM users
LIMIT 10; --- обмежує кількість результатів (рядків)

 SELECT * 
 FROM users
 OFFSET 20
 LIMIT 10;


 /*
Пагінація = відступ + обмеження кількості

page 1, по 50 товарів на сторінці
OFFSET 0, LIMIT 50

page2
OFFSET 50, LIMIT 50

OFFSET = LIMIT * (page - 1)
 */