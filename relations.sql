CREATE TABLE products(
    id serial PRIMARY KEY,
    name varchar(300),
    category varchar(300), 
    price decimal(16, 2) CHECK (price > 0),
    quantity int CHECK (quantity >= 0),
    UNIQUE (name, category)
);


CREATE TABLE users(
    first_name varchar(300) NOT NULL CHECK (first_name != ''),
    last_name varchar(300) NOT NULL CHECK (last_name != ''),
    email varchar(500) CHECK (email != ''),
    birthday date CHECK (birthday > '1900-01-01'),
    is_subscribe boolean NOT NULL
);

ALTER TABLE users
ADD COLUMN id serial PRIMARY KEY;

INSERT INTO users (first_name, last_name, email, birthday, is_subscribe)
VALUES 
('Mikki', 'Mouse', 'mikki@mouse.com', '1980-02-01', true),
('Rapuntzel', 'Longhair', 'hair@cut.com', '1990-02-03', false),
('Cinderella', 'Gold', 'shoe@cn.com', '1940-02-01', true),
('Bell', 'Beasted', 'rose@flow.com', '1994-02-01', false);



INSERT INTO products
(name, category, price, quantity)
VALUES
('Samsung', 'phones', 100, 20),
('Sony', 'TV', 250, 10),
('Nokia', 'phones', 5500, 1),
('Alcatel', 'phones', 80, 10),
('Motorolla', 'phones', 19, 5),
('iPhone', 'phones', 5, 20);

CREATE TABLE orders (
    id serial PRIMARY KEY,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    customer_id int REFERENCES users(id)
);



/*
Зв'язки

За кількістю учасників
бінарні, тернарні, n-арні зв'язки


За обов'язковістю
(обов'язкові, не обов'язкові)
Тренер - команда
0..1 
Юзери - чати
0..m
Покупець - замовлення
0..1


За типом зв'язку

1:1 (один-до-одного)
тренер - команда,
капітан - корабель


1:m (один-до-багатьох)
тренер - игроки (члени команди)
teamLead - проекти
покупці - замовлення


m:n (багато-до-багатьох)
гравці - команди
предмети (дисципліни) - студенти
чати - учасники
замовлення - товари


*/


/*
Реалізація зв'язку

1:1 - реалізується через парне посилання

1:m - реалізується через посилання


m:n - реалізується через зв'язуючу таблицю, що має складовий первинний ключ, що є відповідністю (відношенням) між однією сутністю та іншою. Ця таблиця може містити додаткові атрибути відношення (додаткові стовпці), що передають необхідну інформацію.
Ім'я зв'язуючої таблиці традиційно виглядає так:
ім'яТаблиці1_to_ім'яТаблиці2

products_to_orders
students_to_subjects
users_to_chats

*/

DROP TABLE orders_to_products;

CREATE TABLE orders_to_products(
    order_id int REFERENCES orders(id),
    product_id int REFERENCES products(id),
    quantity int,
    PRIMARY KEY(product_id, order_id)
);



-------------


INSERT INTO orders (customer_id)
VALUES
(1),
(1),
(2),
(4),
(4),
(4);

INSERT INTO orders (customer_id)
VALUES
(6); /*  Не спрацює, такого юзера нема! */


INSERT INTO orders_to_products (order_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 2, 3),
(2, 1, 5),
(3, 3, 1),
(4, 1, 1),
(4, 2, 1),
(5, 2, 1);


INSERT INTO orders_to_products
VALUES 
(1, 1, 1);


----- 1:1 ----

CREATE TABLE coaches (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL

);
-----    team_id int REFERENCES teams(id)

CREATE TABLE teams (
    id serial PRIMARY KEY,
    name varchar(300),
    coach_id int REFERENCES coaches(id)
);


ALTER TABLE coaches
ADD COLUMN team_id int REFERENCES teams(id);

----

DROP TABLE coaches;  --- не вийде! на коача посилаються команди

ALTER TABLE coaches
DROP COLUMN team_id; ---- видаляємо стовбець, який посилається на команди

---тепер можемо видалити таблицю команд

DROP TABLE teams;

DROP TABLE coaches;

----------


SELECT * FROM users;



---------Practice-----------

/* Задача: реалізувати чат між юзерами */

CREATE TABLE chats (
    id serial PRIMARY KEY,
    name varchar(250) CHECK (name != ''),
    owner_id int REFERENCES users(id),
    created_at timestamp NOT NULL DEFAULT current_timestamp
);


CREATE TABLE users_to_chats (
    user_id int REFERENCES users(id),
    chat_id int REFERENCES chats(id),
    join_at timestamp DEFAULT current_timestamp,
    PRIMARY KEY (user_id, chat_id)
);



CREATE TABLE messages (
    id serial PRIMARY KEY,
    body text NOT NULL CHECK (body != ''),
    created_at timestamp DEFAULT current_timestamp,
    author_id int,
    chat_id int,
    FOREIGN KEY (author_id, chat_id) REFERENCES users_to_chats (user_id, chat_id)
);


----


INSERT INTO chats (name, owner_id) VALUES
('First chat', 1),
('Second chat', 2),
('Superchat', 2);


INSERT INTO users_to_chats (user_id, chat_id) VALUES
(2, 1),
(3, 1),
(2, 2), 
(4, 2);

INSERT INTO messages (
    body, author_id, chat_id
) VALUES
('Hi!', 2, 1),
('Hello', 3, 1),
('Go to coffe', 2, 2),
('How are you?', 4, 2);



/*

Контент
- ім'я (назва),
- опис
- дата створення

Реакції
- is_liked:
    true - лайкнуте
    false - дизлайкнуте
    null - конкретний користувач прибрав оцінку або її немає

Реакції - це зв'язок між контентом і користувачем


*/

DROP TABLE contents;

CREATE TABLE contents (
    id serial PRIMARY KEY,
    name varchar(250) NOT NULL CHECK (name != ''), 
    description text,
    author_id int REFERENCES users(id),
    created_at timestamp DEFAULT current_timestamp
);

DROP TABLE reactions;

CREATE TABLE reactions (
    user_id int REFERENCES users(id),
    content_id int REFERENCES contents(id),
    is_liked boolean,
    PRIMARY KEY (user_id, content_id)
);