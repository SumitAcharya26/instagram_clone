const dotenv = require('dotenv');
const connection = require('./config/db');
const app = require("./app");
dotenv.config({ path: './config.env' });
const port = 3000;


app.listen(port, () => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});