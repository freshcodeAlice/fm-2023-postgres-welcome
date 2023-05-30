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