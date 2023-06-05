
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