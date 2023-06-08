DROP TABLE test;

CREATE TABLE test (   
    v varchar(13),
    t int,
    UNIQUE (v,t)
);   --- 1NF!

INSERT INTO test VALUES ('test', 1),
('abracadabra', 2),
('test', 3);


--2NF---


CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(300),
    position varchar(300),
    car_aviability boolean
);

INSERT INTO employees (name, position, car_aviability) VALUES
('John', 'HR', false),
('Jane', 'Sales',  false),
('Jake', 'Developer', false),
('Andrew', 'driver', true); ---- not 2NF! need refactor!


----> 

CREATE TABLE positions (
    name varchar(300) PRIMARY KEY,
    car_aviability boolean
);

DROP TABLE employees;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(300),
    position varchar(300) REFERENCES positions(name)
);

INSERT INTO positions VALUES
('HR', false),
('Sales', false),
('Developer', false),
('Driver', true);

INSERT INTO employees (name, position) VALUES
('John', 'HR'),
('Jane', 'Sales'),
('Jake', 'Developer'),
('Andrew', 'Driver');


--- Як побачити інфу про співробітника + інфу про слуюбову машину

SELECT * FROM employees
JOIN positions
ON employees.position = positions.name;