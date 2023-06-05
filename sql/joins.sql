
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