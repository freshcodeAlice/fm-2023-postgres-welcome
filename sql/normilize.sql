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



/*
Single source of truth (єдине джерело істини) 
Потрібно зберігати у таблицях первинні факти, які неможливо вивести з інших даних, які ми вже зберігаємо

*/



---4NF

/*
Ресторани (restaurants)
роблять піци
Піци розвозять різні служби доставки (delivery_services)

В мережі багато ресторанів в різних частинах міста,
ресторани збертаються до тих служб доставки, які працюють в тих самих районах, де сам ресторан
Служби доставки можуть працювати в декількох районах

*/

CREATE TABLE restaurants (
    id serial PRIMARY KEY
);

CREATE TABLE delivery_services (
    id serial PRIMARY KEY
);

CREATE TABLE restaurants_to_deliveries (
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
    pizza_type varchar(300) NOT NULL,
    PRIMARY KEY (restaurant_id, delivery_id)
);

INSERT INTO restaurants_to_deliveries VALUES
(1, 1, 'pepperoni'),
(1, 1, 'sea'),
(1, 1, '4chease'),
(1, 1, 'hawaii'),
(1, 2, 'pepperoni'),
(1, 2, 'sea'),
(1, 2, 'hawaii'),
(2, 1, 'pepperoni'),
(2, 1, 'sea'),
(2, 1, 'special'),
(2, 3, 'pepperoni'),
(2, 3, 'special');


/*
Вирішення:
створити таблицю піц, побудувати відповідність між ПІЦАМИ і РЕСТОРАНАМИ,а вже ресторани пов'язані з конкретними службами доставки

*/


CREATE TABLE pizzas (
    name varchar(300) PRIMARY KEY
);

CREATE TABLE restaurants_to_pizzas (
    restaurant_id int REFERENCES restaurants(id),
    pizza_type varchar(300) REFERENCES pizzas(name),
    PRIMARY KEY (restaurant_id, pizza_type)
);


CREATE TABLE restaurants_to_deliveries (
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
    PRIMARY KEY (restaurant_id, delivery_id)
);

---як виглядатиме інсерт

INSERT INTO restaurants_to_pizzas
(1, 'pepperoni'),
(1, 'hawaii'),
(1, 'sea'),
(1, '4chease'),
(2, 'sea'),
(2, 'special');

INSERT INTO restaurants_to_deliveries
(1, 1),
(1, 2),
(2, 1),
(2, 3);

---- 4NF!