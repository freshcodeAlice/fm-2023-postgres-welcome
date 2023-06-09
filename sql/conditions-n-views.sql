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