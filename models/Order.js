const _ = require('lodash');

class Order {
    static _client;

    static async bulkCreate(users, phones) {
        const orderValueString = users.map(u => 
            new Array(_.random(1, 4, false))
            .fill(null)
            .map(() => `(${u.id})`)
            .join(',')
            ).join(',');

        const {rows: orders} = await this._client.query(`INSERT INTO orders (customer_id) VALUES ${orderValueString} RETURNING id;`)    
        
        const phonesToOrdersValueString = orders.map(
            o => {
                const arr = new Array(_.random(1, 4, false))
                            .fill(null)
                            .map(() => phones[_.random(0, phones.length - 1, false)]);
                return [...new Set(arr)]
                .map(p => `(${o.id}, ${p.id}, ${_.random(1, 4, false)})`)
                .join(',')
            }
        ).join(',');    

        return this._client.query(`INSERT INTO orders_to_products (order_id, product_id, quantity) VALUES ${phonesToOrdersValueString};`)

    }
}

module.exports = Order;