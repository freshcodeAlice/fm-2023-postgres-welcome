/*
SQL-програма - це послідовність SQL-команд

SQL-команда - це послідовність ключових слів та ідентифікаторів. Закінчується обов'язково ";"

Компонентами команди можуть бути:
- ключові слова 
- ідентифікатор

-- lowercase (маленькими літерами)
-- snake_case (_ замість пробілу)
-- без пробілів
-- не використовуємо в якості ідентифікаторів ключові слова

- ідентифікатор у лапках (кавычки)
- Для таблиць і атрибутів - ""
(для символьного типу даних будуть одинарні)


Спеціальні знаки
$ - або для ідентифікатора (хоча не бажано)
() - для групування виразів або визначення пріоритетності. Іноді є частиною синтаксису
[] - масиви
, - для розділювання елементів. Висяча кома не підтримується!!!
; - закінчує команду. Не може зустрічатись всередині виразу
* - залежно від контексту використання може означати "все" (для команди SELECT), м.б аргументом агрегатної функції та ін.
. - в числових константах, для визначення схеми (для доступу до таблиці всередині схеми)

*/



/* SQL-команди 

- DDL - Data Definition Language (визначення)
Create,
Drop,
Alter,
Truncate
Rename

- DML - Data Manipulation Language (управління)
Insert,
Update,
Delete,
Call,
Explain,
Lock

- DQL - Data Query Language - (запити)
SELECT

- TCL - Transaction Control Language
Commit
Rollback
Savepoint
(set transaction)
(set constraint)

- DCL - Data Control Language (управління доступом)
Grant
Revoke
*/
 


/* CREATE TABLE */

/*
CREATE TABLE ім'я_таблиці(
    ім'я_стовпця1 тип_даних .....,
    ім'я_стовпця2 тип_даних .....,
    ім'я_стовпця3 тип_даних .....,
    ім'я_стовпця4 тип_даних .....
) 
В одній таблиці не може бути двох одноіменних стопвців

*/


/*
Символьні типи даних
char()
varchar()
text - Рядок символів (великий). Максимальний розмір - 1GB

char(5) - Рядок фіксованої довжини
'12345' - ок
'123  ' - якщо коротший, то заб'є пробілами
'12345 67' - якщо значення більше, його вкоротять

varchar(5) - Рядок, що може зменшуватись, якщо дані менше заявленої довжини
'12345' - ok
'123' - ок, не буде доповнювати пробілами
'12345 67' - якщо значення більше, його вкоротять

*/


/* Числові типи даних 
decimal, numeric
numeric(точність, масштаб)

Точність - загальна кількість цифр в числі
Масштаб - кількість цифр після точки


Наприклад.
Число 234.09 
точність - 5
масштаб - 2

Число 0.123763
точність - 7
масштаб - 6

*/

DROP TABLE users;

CREATE TABLE users(
    first_name varchar(300) NOT NULL CHECK (first_name != ''),
    last_name varchar(300) NOT NULL CHECK (last_name != ''),
    email varchar(500) NOT NULL CHECK (email != ''),
    age date,
    is_subscribe boolean NOT NULL,
    height numeric(3, 2) CHECK (height > 0 AND height < 5.0),
    weight int CHECK (weight > 0)
);

/* 1.95 або 0.80 або 3.20 */


/* INSERT INTO ім'я_таблиці VALUES (перерахування всіх значень в тому порядку, в якому ідуть стовпці)*/

INSERT INTO users VALUES 
('Thor', 'Odinsson', 'super@avenger.com', '1990-09-02', true, 2.80, 90);


INSERT INTO users VALUES
('Tony', 'Stark', 'vip@ave.com', '2000-01-01', true, NULL, 70), 
('Bruce', 'Benner', NULL, '1980-01-23', false, 4.50, 200), 
('Peter', 'Parker', 'spider@man', '1995-01-02', false, NULL, NULL);


/* Помилка - неправильний тип даних! */
INSERT INTO users VALUES 
(true, 'Odinsson', 'super@avenger.com', '1990-09-02', 'not subscribe', 90);

INSERT INTO users VALUES 
(NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO users VALUES 
('вв', 'ввв', 'ddd', '1000-01-01', false, -2.03, 1);


/* CONSTRAINT  - обмеження
NOT NULL - в цьому стовпці NULL не дозволено
CHECK (умова істиності) - констрейнт-перевірка, яка буде перевіряти значення при кожному інсерті значень

Обмеження - це об'єкти таблиці

Констрейнт (обмеження) має ім'я
Автоматично складається з 
таблиця_стовбець_тип-перевірки

*/


/*

products(
    price numeric(10, 2)
    discounted_price numeric(10, 2),
    CONSTRAINT "discount" CHECK (price < discounted_price)
)

*/



----------------------

CREATE TABLE messages (
    body text NOT NULL CHECK (body != ''),
    author varchar(300) NOT NULL CHECK (author != ''),
    created_at timestamp DEFAULT current_timestamp,
    is_read boolean DEFAULT false 
);

INSERT INTO messages (body, author) VALUES 
('Test message', 'Me');

INSERT INTO messages (author, body) VALUES
('You', 'Go to coffes');


INSERT INTO messages (author, body) VALUES
('Me', 'Im on it'),
('You', 'Meet me on the corner'),
('Me', 'Ok');

/*
INSERT (з перерахуванням)

INSERT INTO ім'я_таблиці (імена стовпців в тому порядку, який нам потрібен) VALUES 
(перерахування значень в порядку стовпців який ми визначили)


*/