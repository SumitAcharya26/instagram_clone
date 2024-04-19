const mongoose = require("mongoose");
const db = require("../config/db");

const bcrypt = require("bcrypt");

const userSchema = mongoose.Schema({
    email: {
        type: String,
        lowercase: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    }/* ,
    role: {
        type: Number,
        default: 0 //0 -> Normal User, 1 -> Admin, 2 -> Sub-Admin, 3 -> Editor
    } */
});

userSchema.pre('save', async function () {
    try {
        var user = this;
        const salt = await (bcrypt.genSalt(10));
        const hashPass = await bcrypt.hash(user.password, salt);

        user.password = hashPass;
    } catch (err) {
        throw err;
    }

});

userSchema.methods.comparePassword = async function (userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return isMatch;
    } catch (err) {
        throw err;
    }
}

const UserModel = db.model('users', userSchema);

module.exports = UserModel;