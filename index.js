const {Client} = require('pg');

const config = {
    host: 'localhost',
    database: 'fm_2023_test',
    user: 'postgres',
    password: '718',
    port: 5432
}

const client = new Client(config);


async function start() {
    // робимо коннект (підключення до БД)
    await client.connect();
    // робимо роботу
    
    const user = {
        firstName: 'Harry',
        lastName: 'Potter',
        email: 'potter@hogwarts.com',
        birthday: '1990-01-02',
        isSubscribe: false
    }

    const res = await client.query(`INSERT INTO users (first_name, last_name, email, birthday, is_subscribe) VALUES ('${user.firstName}', '${user.lastName}', '${user.email}', '${user.birthday}', ${user.isSubscribe});`);

    console.log(res);
    
    // закриваємо за собою підключення
    await client.end();
}

start();
