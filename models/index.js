const {Client} = require('pg');
const {config} = require('../config');

const User = require('./User');

const client = new Client(config);



User._client = client;
User._tableName = 'users';


module.exports = {
    client,
    User
}