SELECT * FROM users;

/* Умовні конструкції */


ALTER TABLE orders
ADD COLUMN is_done boolean;


---- Як вивести вагу юзерів так, щоб не змінюючи фізично дані, отримати 0 замість NULL

/*
CASE

--Syntax 1

CASE
    WHEN condition1 = true
        THEN result1
    WHEN condition2 = true
        THEN result2
    ....
    ELSE
        result3
END

*/

SELECT id, email, (CASE
                        WHEN weight IS NULL
                        THEN 0
                        ELSE
                            weight
                        END) AS user_weight
FROM
users;


/*
Вивести замовлення так, щоб в стовпці is_done замість NULL виводилось false

*/

SELECT id, created_at, customer_id, (
    CASE 
    WHEN is_done IS NULL
        THEN FALSE
        ELSE
            TRUE
    END
) AS is_done
FROM orders;



/*
Оновити дані замовлень, щоб половина була виконана (true), половина - невиконана (false)
*/

UPDATE orders
SET is_done = FALSE
WHERE id % 2 = 1;


/*
--Syntax 2

(CASE вираз
    WHEN значення1 THEN результат1
    WHEN значення2 THEN результат2    
    ....
END
)

*/


--- Вивести сезон, в якому народився користувач

SELECT *, (
    CASE extract(month from birthday)
        WHEN 1 THEN 'winter'
        WHEN 2 THEN 'winter'
        WHEN 3 THEN 'spring'
        WHEN 4 THEN 'spring'
        WHEN 5 THEN 'spring'
        WHEN 6 THEN 'summer'
        WHEN 7 THEN 'summer'
        WHEN 8 THEN 'summer'
        WHEN 9 THEN 'autumn'
        WHEN 10 THEN 'autumn'
        WHEN 11 THEN 'autumn'
        WHEN 12 THEN 'winter'
    END
) as season
FROM users;


/*
Вивести інформацію про юзера, додати новий стовбець "adult"
Всі користувачі, молодші за 21, отримують значення false
Всі, хто старше - значення TRUE

*/


SELECT *, (
    CASE 
        WHEN extract(year from age(birthday)) < 21
        THEN false
        ELSE
            TRUE
    END 
) AS adult 
FROM users;


/*
Вивести телефони, у графі "manufacturer" для телефонів бренду iPhone вивести Apple, для всіх інших - вивести "other"

*/


SELECT *, (
    CASE 
        WHEN brand LIKE'iPhone'
        THEN 'Apple'
        ELSE
            'other'
    END
) as manufacturer
FROM products;


/*
Якщо ціна телефону < 10000 - в графі "Класс" вивести "бюджетний"
Якщо > 20 000 - вивести "Флагман"
між 10 та 20 - вивести "середній клас"

Задачка з *:
Для всіх телефонів, що коштують дорожче за середню ціну всіх телефонів, вивести "дорогий", 
для дешевших - "дешевий"

*/

---1
SELECT *, (
    CASE
        WHEN price < 4000
        THEN 'budget'
        WHEN price > 9000
        THEN 'flagman'
        ELSE 
            'middle'
    END
) AS product_class
FROM products;


--- *

SELECT *, (
    CASE
        WHEN price > (SELECT avg(price) FROM products)
        THEN 'high'
        ELSE 
            'low'
    END
) AS product_class
FROM products;


/*
Вивести дані користувача + колонку "клієнт"
Якщо у користувача > 3 замовлення в магазині - вивести "постійний клієнт",
якщо > 1 - вивести "клієнт",
якщо 0 - вивести "новий клієнт"


*/

SELECT u.id, u.email, (
    CASE 
        WHEN count(o.id) > 3
        THEN 'active'
        WHEN count(o.id) >= 1
        THEN 'client'
        ELSE 'new client'
    END
) as client_status
FROM users AS u
LEFT JOIN orders AS o 
ON u.id = o.customer_id
GROUP BY u.id
ORDER BY u.id DESC;


----COALESCE, NULLIF, GRETEST/LEAST ---

-- Аналог конструкції || 

SELECT users.*, COALESCE(weight, 0) AS user_weight
FROM users;


---- NULLIF

-- Якщо два аргумента однакові, результат - NULL
-- якщо різні - результатом буде перше значення
SELECT NULLIF(NULL, NULL);


---- GREATEST, LEAST

SELECT LEAST (23, 12, 4, 1, 45);


--- Вивести ціни телефонів, якщо ціна менше 2 000, вивести рівно 2 000

SELECT id, brand, model, GREATEST(price, 2000) AS price
FROM products;




/* ENUM (власний тип даних) */

--- Змінити таблицю orders
-- Стовбець is_done переробити на стовбець "status"
-- Мати такі статуси:
-- new
-- processing
-- delivery
-- done


/* Створюємо тип даних  */

CREATE TYPE order_status AS ENUM ('new', 'processing', 'delivery', 'done');


ALTER TABLE orders
RENAME COLUMN is_done TO status;  -- перейменовуємо стовбець

ALTER TABLE orders
ALTER COLUMN status TYPE order_status;
---- якщо б в колонці status не було даних, то ця команда успішно змінила би наш тип даних 


ALTER TABLE orders
ALTER COLUMN status TYPE order_status
USING (
    CASE status
        WHEN false THEN 'new'
        WHEN true THEN 'done'
        ELSE 'processing'
    END
)::order_status;


---- Якщо б у стовпця status було DEFAULT-значення, то воно автоматично не кастується!
-- В такому випадку слід знести DEFAULT, кастанути (привести) тип даних і вже після цього додавати новий DEFAULT

ALTER TABLE orders
ALTER COLUMN status SET DEFAULT 'new';


UPDATE orders
SET status = 'processing'
WHERE id BETWEEN 100 AND 1000;

INSERT INTO orders (customer_id, status)
VALUES (
   1,
   'new'
  );


/* VIEWS - Представлення (подання - представление) */


--- Вивести всіх юзерів з кількістю їхніх замовлень

 SELECT u.*, count(o.id) 
 FROM users AS u 
 JOIN orders AS o
 ON u.id = o.customer_id
 GROUP BY u.id, u.email;

 /*
CREATE VIEW назва_представлення AS (підзапит, який повертає табличний вираз)

 */


 CREATE VIEW users_with_order_amounts AS (
     SELECT u.*, count(o.id) 
 FROM users AS u 
 JOIN orders AS o
 ON u.id = o.customer_id
 GROUP BY u.id, u.email
 );


 SELECT * 
 FROM users_with_order_amounts AS uwoa
 JOIN orders AS o
ON uwoa.id = o.customer_id
WHERE o.id = 15;


/*
Створити представлення всіх замовлень з їхньою повною вартістю (ціна моделі*кількість куплених екземплярів)

*/

SELECT o.id, o.customer_id, o.created_at, o.status, sum(otp.quantity * p.price) AS sum
FROM orders AS o
JOIN orders_to_products AS otp 
ON o.id = otp.order_id
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY o.id;

CREATE VIEW orders_with_sum AS (
    SELECT o.id, o.customer_id, o.created_at, o.status, sum(otp.quantity * p.price) AS sum
FROM orders AS o
JOIN orders_to_products AS otp 
ON o.id = otp.order_id
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY o.id
);


/*
Вивести всі замовлення вартістю більше середнього чеку магазину

*/

SELECT * 
FROM orders_with_sum
WHERE sum > (
    SELECT avg(sum)
    FROM orders_with_sum
); 


/*
Максимальна вкладеність view на основі іншої view - 32
Максимум 1024 стовпці

*/


/*
ДЗ:

Створити вью для отримання:

1. Топ-10 найпродаваніших телефонів
2. Топ-10 найдорожчіх телефонів
3. Топ-5 користувачів, які залишили найбільше грошей в нашому магазині

*/