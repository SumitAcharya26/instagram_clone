const mongoose = require("mongoose");
const db = require("../config/db");

const postSchema = mongoose.Schema({
    dataPublished: {
        type:String
    },
    description: {
        type: String
    },
    likes: {
        type: Array
    }, postId: {
        type: String
    },
    postUrl: {
        type: String
    },
    profImage: {
        type: String
    },
    uid: { type: String },
    username: { type: String }
});

const PostModel = db.model('posts', postSchema);

module.exports = PostModel;