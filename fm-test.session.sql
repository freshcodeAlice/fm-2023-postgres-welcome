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



---- ідентифікація даних -----

/*
- за природніми ознаками - певні дані, які ВЖЕ Є в тих даних, які прийшли
(унікальні дані, на які ми можемо спиратися для ідентифікації рядка в таблиці)

- за штучними ознаками
(певні дані, які ми ДОМІШУЄМО до існуючих, для забезпечення ідентифікації)

- за зв'язком об'єктів
(коли ідентифікація сутності відбувається за зв'язком з іншою сутністю)

Умова для ідентифікатора:
- унікальне (не повторюється)
- існує (не null)

*/

DROP TABLE messages;

CREATE TABLE messages (
    id serial NOT NULL UNIQUE,
    body text NOT NULL CHECK (body != ''),
    author varchar(300) NOT NULL CHECK (author != ''),
    created_at timestamp DEFAULT current_timestamp,
    is_read boolean DEFAULT false 
);

INSERT INTO messages (id, body, author) VALUES
(5, 'Hi', 'Y');


/* Key 

Первинний ключ (primary key)
Ключ - унікальні дані (ідентифікатор), який однозначно ідентифікує рядки в таблиці

*/


DROP TABLE messages;

CREATE TABLE messages (
    id serial PRIMARY KEY,
    body text NOT NULL CHECK (body != ''),
    author varchar(300) NOT NULL CHECK (author != ''),
    created_at timestamp DEFAULT current_timestamp,
    is_read boolean DEFAULT false 
);


/*
PRIMARY KEY по двом стовпцям

*/

--- Задача: в таблиці юзерів не може бути людей з однаковим іменем+прізвищем

CREATE TABLE unique_users(
    first_name varchar(300),
    last_name varchar(300),
    PRIMARY KEY (first_name, last_name)
);

INSERT INTO unique_users VALUES
('Vasya', 'Petrov'),
('Vasya', 'Vasechkin'),
('Petya', 'Petrov');

INSERT INTO unique_users VALUES
('Vasya', 'Petrov');



/*
Зробити таблицю юзерів, в якій мейл буде первинним ключем

*/


DROP TABLE users;

CREATE TABLE users(
    first_name varchar(300) NOT NULL CHECK (first_name != ''),
    last_name varchar(300) NOT NULL CHECK (last_name != ''),
    email varchar(500) CHECK (email != ''),
    age date,
    is_subscribe boolean NOT NULL,
    height numeric(3, 2) CHECK (height > 0 AND height < 5.0),
    weight int CHECK (weight > 0),
    CONSTRAINT "unique_email" PRIMARY KEY (email)
);


INSERT INTO users (first_name, last_name, email, age, is_subscribe) VALUES
('test1', 'test2','mail', '1990-09-09', false);


INSERT INTO users (first_name, last_name, email, age, is_subscribe) VALUES
('test1', 'test2','mail1', '1990-09-09', false),
('test1', 'test2','mail3', '1990-09-09', false);

INSERT INTO users (first_name, last_name, email, age, is_subscribe) VALUES
('test2', 'test3','mail', '1990-09-09', false);



-----Редагування існуючої таблиці----

/*
ALTER - команда для зміни

ALTER TABLE -  зміна опису таблиці
*/

ALTER TABLE users
ADD COLUMN order_quantity int NOT NULL;


ALTER TABLE users
DROP COLUMN order_quantity;


/* 
Додавання нового стовпця в існуючу таблицю, якщо дані протирічать обмеженням нового стовпця

Варіант 1:
- Додати дефолтне значення, і дані переконвертуються автоматично

Варіант 2:
- Спочатку створюємо стовбець (без обмеження)
- Вручну оновлюємо дані в таблиці
- Додати обмеження у існуючу таблицю (до існуючого стовпця)
*/

ALTER TABLE users
ADD COLUMN order_quantity int;

UPDATE users
SET order_quantity = 5;

ALTER TABLE users
ALTER COLUMN order_quantity SET NOT NULL;



---------


INSERT INTO users (first_name, last_name, email, age, is_subscribe, height, order_quantity) VALUES
('test2', 'test3','3422323334', '1990-09-09', false, 5.4, 7);


--v1
ALTER TABLE users
DROP CONSTRAINT "users_height_check";


UPDATE users
SET height = 3.0
WHERE height > 3.0;

ALTER TABLE users
ADD CONSTRAINT "too_high" CHECK (height > 0 AND height < 4.0);


/*
Створити таблицю юзерів
1. Пара ім'я + прізвище має бути унікальним
2. Повне ім'я - не пустий рядок
3. Додати юзерам id

----
Після створення таблиці внести такі зміни:
- Додати користувачу стовбець "розмір ноги", тип данних - int
Розмір ноги не може бути більше 50

- Додати обмеження - користувач не може народитися раніше 1900


Задачка з *:
Відредагувати обмеження дати народження
- користувач народився не раніше 1900 і не пізніше сьогоднішнього дня

*/

DROP TABLE unique_users;


CREATE TABLE users (
    first_name varchar(300),
    last_name varchar(300),
    CONSTRAINT "unique_pair_name" UNIQUE(first_name, last_name)
    CONSTRAINT "not_empty_name" CHECK (first_name != '' AND last_name != '')
);


ALTER TABLE users
ADD COLUMN foot_size int CHECK (foot_size < 50);

ALTER TABLE users
ADD COLUMN birthday date;


ALTER TABLE users
ADD CONSTRAINT "birthday_check" CHECK (birthday > '1900-01-01' AND birthday < current_date);

-------------