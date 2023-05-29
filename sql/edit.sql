ALTER TABLE users
ADD COLUMN gender varchar(100);

UPDATE users
SET gender = 'male' 
WHERE first_name IN ('Mikki', 'Harry', 'Ron', 'Draco');

UPDATE users
SET is_subscribe = true
WHERE id = 1
RETURNING *;

UPDATE users
SET gender = 'female' 
WHERE first_name IN ('Bell', 'Hermany', 'Rapuntzel', 'Cinderella');

-----


ALTER TABLE products
DROP COLUMN name;

DELETE FROM products;

ALTER TABLE products
ADD COLUMN model varchar(300) NOT NULL CHECK (brand != '');