const {getUsers} = require('./api/getUsers');
const { User, client, Phone, Order } = require('./models');
const {generatePhones} = require('./utils/generateProducts');


async function start() {

    // робимо коннект (підключення до БД)
        await client.connect();
    
    // робимо роботу
    
    /// зробити запит на randomUser
    const userArray = await getUsers();

    //передати результати запиту функції mapUsers

    const {rows: users} = await User.findAll();
    const {rows: phones} = await Phone.bulkCreate(generatePhones());
    const {rows: orders} = await Order.bulkCreate(users, phones);

    console.log(res);
    
    // закриваємо за собою підключення
    await client.end();
}

start();
