
function mapUsers (userArray) {
    return userArray.map(u => `('${u.firstName}', '${u.lastName}', '${u.email}', '${u.birthday}', ${u.isSubscribe})`).join(',');
}


module.exports.mapUsers = mapUsers;