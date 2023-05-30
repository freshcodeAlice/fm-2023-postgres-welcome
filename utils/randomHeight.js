const _ = require('lodash');

function getRandomHeight () {
    return _.random(1, 3, true).toFixed(2);
}

module.exports.getRandomHeight = getRandomHeight;