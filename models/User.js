const { mapUsers } = require("../utils/mapUsers");
const {getRandomHeight} = require("../utils/randomHeight");

class User {
    static _client;
    static _tableName;

    static async findAll() {
        return this._client.query(`SELECT * FROM ${this._tableName}`);
    }

    static async bulkCreate (users) {
        return this._client.query(`INSERT INTO ${this._tableName} (first_name, last_name, email, birthday, is_subscribe, gender) VALUES ${mapUsers(users)};`)
    }


    static async updateHeight() {
        return this._client.query(`UPDATE ${this._tableName} SET height = ${getRandomHeight()} WHERE gender = 'male';`)
    }
}


module.exports = User;