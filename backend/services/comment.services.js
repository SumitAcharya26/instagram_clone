const CommentModel = require("../model/comment.model");
const db = require("../config/db");


class CommentService {
    static async createComment(postId, dataPublished, commentId, likes, text, userPhotoUrl, uid, username) {
        try {
            const createComment = new CommentModel({
                dataPublished, commentId, likes, text, userPhotoUrl, uid, username, postId
            });
            return await createComment.save();
        } catch (err) {
            throw err;
        }
    }

    static async getComment() {
        try {
           const getComments = db.collection("comments").find({}).toArray(function (err, result) {
                if (err) throw err;
                console.log(result);
            });
            /* const getComment = new CommentModel({
                dataPublished, commentId, likes, text, userPhotoUrl, uid, username, postId
            }); */
            return await getComments;
        } catch (err) {
            throw err;
        }
    }
}

module.exports = CommentService;