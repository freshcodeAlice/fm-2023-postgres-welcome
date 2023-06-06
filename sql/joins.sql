
/*

1. Отримати 1 юзера з найдовшим повним ім'ям (ім'я + прізвище)

2. Порахувати кількість юзерів з однаковою довжиною імені і відсіяти тих, в кого кількість символів < 5

*/

SELECT char_length(concat(first_name, last_name)) AS "name_length", *
FROM users
ORDER BY "name_length" DESC
LIMIT 1;


--2
SELECT char_length (first_name) AS "name_length"
, count(*)
FROM users
GROUP BY "name_length"
HAVING char_length (first_name) > 5
ORDER BY "name_length";


/* Поєднання запитів  */


CREATE TABLE A (
    v char(3),
    t int
);


CREATE TABLE B (
    v char(3)
);


INSERT INTO A VALUES
('XXX', 1),
('XXY', 1),
('XXZ', 1),
('XYX', 2),
('XYY', 2),
('XYZ', 2),
('YXX', 3),
('YXY', 3),
('ZYX', 3);

INSERT INTO B VALUES
('ZXX'),
('XXX'),
('ZXZ'),
('XYZ'),
('YXZ'),
('YXY');


-- Декартовий добуток (умножение)
SELECT * FROM A, B;



--- Об'єднання
-- UNION
-- Всі значення з А + всі значення з В, а те, що зустрічається в обох відношеннях - в єдиному екземплярі
-- Операція працює на однаковій кількості стовпців!

SELECT v FROM A
UNION
SELECT * FROM B;


-- Перехрещення (пересечение)
-- Всі значення з А та В, що є і там, і там, в єдиному екземплярі

SELECT v FROM a
INTERSECT
SELECT * FROM b;


--- Віднімання (вычитание)
-- Всі значення з А мінус ті, що зустрічаються в В

SELECT v FROM a
EXCEPT
SELECT * FROM b;


-- Всі значення з В мінус ті, які є в А

SELECT v FROM b
EXCEPT
SELECT v FROM a;



-----------------------


INSERT INTO users (
    first_name,
    last_name,
    email,
    birthday,
    is_subscribe,
    gender,
    height,
    weight
  )
VALUES (
    'Test1',
    'Testovich',
    'tester@1.com',
    '1990-01-01',
    true,
    'male',
    2.1,
    60
  ),
  (
    'Test2',
    'Testovich',
    'tester@2.com',
    '1990-01-01',
    true,
    'female',
    1.91,
    60
  ),
  (
    'Test3',
    'Testovich',
    'tester@3.com',
    '1990-01-01',
    true,
    'non-binary',
    1.90,
    70
  );




/* 
Задача: Отримати юзерів, які ніколи не робили замовлень
*/

SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders;



/*
Отримати тільки тих юзерів, які робили замовлення

*/

SELECT id FROM users
INTERSECT
SELECT customer_id FROM orders;



--------

/*
Задача: отримати пошту ююзерів, які нічого не купували

*/

-- bad version
SELECT email FROM users
WHERE id IN (SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders);


-------

--- Об'єднання таблиць за умовою
SELECT A.v AS id, A.t AS price, B.v AS phone_number FROM a, b
WHERE A.v = B.v;


-- Всі значення з А, яких нема в В

SELECT a.v AS id, a.t AS price 
FROM a
WHERE a.v NOT IN (SELECT * FROM b);




-----JOIN------


SELECT * 
FROM A JOIN B
ON A.v = B.v;


/*
Всю інформацію про юезра №4 і всі замовлення, які він робив

*/

SELECT * 
FROM orders AS o
JOIN users AS u
ON o.customer_id = u.id;




/*
Отримати всі повідомлення та інформацію про перший чат

*/

SELECT * 
FROM chats AS c
JOIN messages AS m 
ON c.id = m.chat_id
WHERE c.id = 1;


/*
Витягти всю інформацію про власників чатів та інформацію про чати

*/


SELECT * 
FROM chats AS c 
JOIN users AS u 
ON c.owner_id = u.id;


/*
Витягти всіх юзерів, які спілкуються у першому чаті разом з інформацією про цих юзерів та чат

*/


SELECT 
  u.id AS user_id,
  c.id AS chat_id,
  u.first_name AS name,
  u.last_name AS last_name,
  u.email AS email 
FROM messages AS m 
JOIN chats AS c 
ON m.chat_id = c.id
JOIN users AS u 
ON m.author_id = u.id
WHERE c.id = 1;



/*

Задача: знайти номери замовлень, в яких були замовлені телефони Samsung


Декомпозуємо задачу:
1. Бренд в таблиці products
  Номери замовлень в orders, orders_to_products

2. Робимо вибірку по бренду
*/

SELECT * 
FROM products AS p 
JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE p.brand = 'Samsung';


---- Скільки моделей самсунга було в одному замовленні

SELECT count(*), p.model 
FROM products AS p 
JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE p.brand = 'Samsung'
GROUP BY p.model;



/*
Дізнатися кількість замовлень на кожен бренд

*/


 SELECT count(*), p.brand 
 FROM products AS p 
 JOIN orders_to_products AS otp
 ON p.id = otp.product_id
 GROUP BY p.brand;

 --- Топ-3 найпродаваніших брендів

  SELECT count(*) AS sales, p.brand 
 FROM products AS p 
 JOIN orders_to_products AS otp
 ON p.id = otp.product_id
 GROUP BY p.brand
 ORDER BY sales DESC
 LIMIT 3;


 -- Топ-5 моделей

   SELECT count(*) AS sales, p.model, p.brand 
 FROM products AS p 
 JOIN orders_to_products AS otp
 ON p.id = otp.product_id
 GROUP BY p.model, p.brand
 ORDER BY sales DESC
 LIMIT 3;




 /*

Задача: знайти телефони які ніхто не купував

 */

 INSERT INTO products (category, price, quantity, brand, model)
 VALUES (
     'phones',
     2000,
     1,
     'iPad',
     'model 5'
   ),
   (
     'phones',
     1000,
     1,
     'superTel',
     'model 10'
   );


-- Всі телефони, які купувались
SELECT product_id, p.model
FROM orders_to_products AS otp
JOIN products AS p 
ON p.id = otp.product_id
GROUP BY product_id, p.model;


--- Всі попередні випадки використання JOIN === INNER JOIN


SELECT product_id, p.model
FROM orders_to_products AS otp
INNER JOIN products AS p 
ON p.id = otp.product_id
GROUP BY product_id, p.model;


/*

A JOIN B

INNER JOIN - тільки те, що є і в А, і в В

LEFT JOIN - те, що є в обох + унікальні з А
RIGHT JOIN - те, що є в обох + унікальні з В



*/

SELECT count(*), p.id 
FROM orders_to_products AS otp
INNER JOIN products AS p 
ON p.id = otp.product_id
GROUP BY p.id;


SELECT count(otp.order_id), p.id 
FROM orders_to_products AS otp
RIGHT JOIN products AS p 
ON p.id = otp.product_id
GROUP BY p.id
ORDER BY p.id DESC;


-- продукти, які ніхто ніколи не купував

SELECT p.id, p.model, p.brand, otp.order_id
FROM products AS p
LEFT JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE otp.product_id IS NULL;


/*
Знайти всіх користувачів, які коли-небудь робити замовлення в нашому магазині


*/

--v1
SELECT u.*
FROM users AS u 
JOIN orders AS o 
ON u.id = o.customer_id
GROUP BY u.id;

--v2
SELECT DISTINCT u.id, u.first_name, u.last_name
FROM users AS u 
JOIN orders AS o 
ON u.id = o.customer_id;

--- Юзери, які не робили замовлень


SELECT u.*
FROM users AS u 
LEFT JOIN orders AS o 
ON u.id = o.customer_id
WHERE o.customer_id IS NULL
GROUP BY u.id;


/*
1. Знайти email всіх користувачів, які купували product #5

Задачка з *:
2. знайти мейли всіх користувачів, які купували телефони Samsung

*/


--1
SELECT u.email
FROM users AS u 
JOIN orders AS o 
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
WHERE otp.product_id = 10;


-- Перевіряємо

SELECT * FROM users
WHERE email = 'israel.robledo@example.com'; -- id - 29

SELECT * FROM orders
WHERE customer_id = 29; --76


SELECT * FROM orders_to_products
WHERE order_id = 76; -- Підтверджуємо, що в цьому замовленні є товар №10



-----------

--2

SELECT u.email
FROM users AS u 
JOIN orders AS o 
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p 
ON p.id = otp.product_id
WHERE p.brand = 'Samsung'
GROUP BY u.email;


/*
Вивести всіх користувачів та кількість їхніх замовлень

*/


SELECT u.*, count(o.id) AS order_amount
FROM users AS u 
LEFT JOIN orders AS o 
ON u.id = o.customer_id
GROUP BY u.id;

-- Перевіряємо
SELECT * FROM orders
WHERE customer_id = 652;


