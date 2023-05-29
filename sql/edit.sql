ALTER TABLE users
ADD COLUMN gender varchar(100);

UPDATE users
SET gender = 'male' 
WHERE first_name IN ('Mikki', 'Harry', 'Ron', 'Draco');



UPDATE users
SET gender = 'female' 
WHERE first_name IN ('Bell', 'Hermany', 'Rapuntzel', 'Cinderella');

