const mongoose = require("mongoose");
const db = require("../config/db");

const commentSchema = new mongoose.Schema({
    commentId: { type: String },
    datePublished: { type: String },
    likes: {
        type: Array
    },
    text: { type: String },
    uid: { type: String },
    userPhotoUrl: { type: String },
    username: { type: String },
    postId: { type: String }
});
const CommentModel = db.model('comments', commentSchema);

module.exports = CommentModel;