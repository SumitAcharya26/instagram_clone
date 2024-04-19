const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb+srv://sumitacharya825:KZxzKSzJ8bFXoxW4@cluster0.6q8taa2.mongodb.net/instagram_clone?retryWrites=true',
)
    .on('open', () => {
        console.log('Mongodb atlas Connected');
    }).on('error', (err) => {
        console.log(err);
        console.log('MongoDb Connection Error');
    });

module.exports = connection;