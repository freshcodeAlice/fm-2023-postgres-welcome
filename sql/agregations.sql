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


/*------- */

UPDATE workers
SET birthday = birthday + MAKE_INTERVAL(
    years => 1999 - EXTRACT(
      year
      from birthday
    )::INTEGER
  )
WHERE id BETWEEN 2 AND 5;


-------

UPDATE workers
SET birthday = '1999-01-02'
WHERE id BETWEEN 2 AND 5;