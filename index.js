const {Client} = require('pg');
const {mapUsers} = require('./utils/mapUsers');
const {getUsers} = require('./api/getUsers');
const {config} = require('./config');

const client = new Client(config);


async function start() {
    // робимо коннект (підключення до БД)
    await client.connect();
    // робимо роботу
    
    /// зробити запит на randomUser
    const users = await getUsers();

    //передати результати запиту функції mapUsers

    const res = await client.query(`INSERT INTO users (first_name, last_name, email, birthday, is_subscribe, gender) VALUES ${mapUsers(users)};`);

    console.log(res);
    
    // закриваємо за собою підключення
    await client.end();
}

start();
