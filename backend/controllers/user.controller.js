const UserService = require('../services/user.services');

exports.register = async (req, res, next) => {
    try {
        const { email, password, username } = req.body;

        const user = await UserService.checkUser(email);

        if (user) {

            res.json({
                status: false, success: "Email Already in Use"
            });
        }
        else if (!email.includes('@gmail')) {

            res.json({
                status: false, success: "Please Enter Valid Email"
            });
        } else if (password.length < 6) {
            res.json({
                status: false, success: "Password length must be 6 or more than 6 characters"
            });
        } else {
            const successRes = await UserService.registerUser(email, password, username);

            res.json({
                status: true, success: "User Registered Successfully"
            });
        }
    }
    catch (error) {
        throw error
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserService.checkUser(email);

        if (!user) {
            res.status(200).json({
                status: false, success: 'User does not Exist'
            })
        } else {

            const isMatch = await user.comparePassword(password);

            if (isMatch == false) {
                res.status(200).json({
                    status: false, success: 'Password InValid'
                })
            } else {
                let tokenData = { _id: user.id, email: user.email };

                const token = await UserService.generateToken(tokenData, "secretKey", "1h");

                res.status(200).json({
                    status: true, token: token
                })
            }
        }

    }
    catch (error) {
        throw error
    }
}