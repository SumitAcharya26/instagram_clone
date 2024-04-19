const mongoose = require("mongoose");
const db = require("../config/db");

const fileSchema = new mongoose.Schema({
    filename: String,
    contentType: String,
    data: Buffer
});

const postSchema = mongoose.Schema({
    dataPublished: {
        type: String
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
        type: fileSchema
    },
    profImage: {
        type: String
    },
    uid: { type: String },
    username: { type: String }
});

const PostModel = db.model('posts', postSchema);

module.exports = PostModel;