const {getUsers} = require('./api/getUsers');
const { User, client, Phone, Order } = require('./models');
const {generatePhones} = require('./utils/generateProducts');

/*
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

   
    // закриваємо за собою підключення
    await client.end();
}
*/

//start();



async function updateHeight() {
    await client.connect();

    const res = await User.updateHeight();
    console.log(res);
    await client.end();
}

updateHeight();