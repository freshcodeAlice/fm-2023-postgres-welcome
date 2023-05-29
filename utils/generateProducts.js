const _ = require('lodash');

const PHONES_BRANDS = [
    'Samsung',
    'iPhone',
    'Siemens',
    'Nokia',
    'Sony',
    'Alcatel',
    'Xiaomi',
    'Realme'
];


const generateOnePhone = key => ({
    brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length, false)],
    model: `model ${key}`,
    quantity: _.random(10, 1500, false),
    price: _.random(200, 10000, false),
    category: 'phones'
});

module.exports.generatePhones = (length = 50) => new Array(length).fill(null).map((el, i) => generateOnePhone(i));