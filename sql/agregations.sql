SELECT * FROM users;

/*
1. Що зробити? Отримати дані
2. З якої таблиці? users
3. Які стовпці потрібні? Всі
*/

SELECT * FROM users
WHERE id % 2 = 0;

SELECT email
FROM users;


/* Агрегатні функції */

--- Задача - визначити суму ваги всіх користувачів

SELECT sum(weight) 
FROM users;


--- Задача - визначити найменший зріст серед всіх користувачів

SELECT min(height)
FROM users;


/*
max - максимальне
min - мінімальне
sum - сума
count - кількість значень
avg - среднє арифметичне

*/

SELECT avg(weight)
FROM users;


--- Кількість користувачів

SELECT count(*)
FROM users;


--- Середня вага чоловіків та середня вага жінок

SELECT avg(weight), gender
FROM users
GROUP BY gender;


--- Порахувати середню вагу всіх користувачів, які народились після 2000 року

SELECT avg(weight)
FROM users
WHERE extract(years from birthday) > 2000; 


--- Середній зріст всіх чоловіків, яким понад 25 років

SELECT avg(height), gender
FROM users
WHERE extract(years from age(birthday)) > 25
GROUP BY gender;

/*
Практика:

1. Визначити середній зріст всіх чоловіків та жінок
2. Мінімальний та максимальний зріст чоловіків та жінок
3. Кількість юзерів, які народилися після 1998
4. Кількість людей з певним ім'ям. 
5. Кількість юзерів віком від 20 до 30 років.


*/
--1
SELECT avg(height), gender
FROM users
GROUP BY gender;

--2
SELECT min(height), max(height), gender
FROM users
GROUP BY gender;


--3
SELECT count(*)
FROM users
WHERE extract(years from birthday) > 1998;

--4
SELECT count(*)
FROM users
WHERE first_name LIKE 'Kate';


SELECT count(*)
FROM users
WHERE first_name LIKE 'K%';


--5
SELECT count(*)
FROM users
WHERE extract(years from age(birthday)) BETWEEN 20 AND 30;
