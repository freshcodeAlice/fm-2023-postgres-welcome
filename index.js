const {getUsers} = require('./api/getUsers');
const { User, client } = require('./models');


async function start() {

    // робимо коннект (підключення до БД)
        await client.connect();
    
    // робимо роботу
    
    /// зробити запит на randomUser
    const users = await getUsers();

    //передати результати запиту функції mapUsers

    const res = await User.bulkCreate(users);

    console.log(res);
    
    // закриваємо за собою підключення
    await client.end();
}

start();
