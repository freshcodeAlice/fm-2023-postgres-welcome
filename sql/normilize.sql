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




---3NF------

CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(300),
    department varchar(300),
    department_phone int
);


INSERT INTO employees (name, department, department_phone) VALUES
('John Dow', 'HR', 44455),
('Jane Smith', 'sales', 33322),
('Andrew', 'HR', 44455);


/* departmant -> id, department_phone -> department,
транзитивна залежність: department_phone -> id */

CREATE TABLE departments (
    name varchar(300) PRIMARY KEY,
    phone_number int
);



/* NFBC (Нормальна форма Бойса-Кодда) */

/* 
Приклад:
Викладачі, студенти, предмети
(teachers, students, subjects)

Студенти ходять на предмети (різні)
1 викладач може вести 1 предмет,
у студента може бути багато предметів
1 предмет слухає багато студентів

teachers  n:1  subjects
students  m:n  subjects
students  m:n  teachers
*/

CREATE TABLE students(
    id serial PRIMARY KEY,
    name varchar(300)
    );

CREATE TABLE teachers (
    id serial PRIMARY KEY,
    name varchar(300)
);


CREATE TABLE students_to_teachers_to_subjects
(
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    subject varchar(300) 
    PRIMARY KEY (teacher_id, student_id)
);

INSERT INTO students_to_teachers_to_subjects VALUES
(1, 1, 'biology'),
(1, 2, 'biology'),
(2, 1, 'math'),
(2, 2, 'phisics');   ------ <-- this is a problem!

----- Solution: ---


CREATE TABLE subjects(
    name varchar(300) PRIMARY KEY,
);

CREATE TABLE teachers (
    id serial PRIMARY KEY,
    name varchar(300),
    subject varchar(300 REFERENCES subjects(name))
);

CREATE TABLE students_to_teachers
(
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    PRIMARY KEY (teacher_id, student_id)
);   --- NFBC
