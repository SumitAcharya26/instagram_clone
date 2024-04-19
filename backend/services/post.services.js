const PostModel = require("../model/post.model");
const db = require("../config/db");

class PostService {
    static async createPost(dataPublished, description, likes, postId, postUrl, profImage, uid, username) {
        try {
            const createPost = new PostModel({
                dataPublished, description, likes, postId, postUrl, profImage, uid, username
            });
            return await createPost.save();
        } catch (err) {
            throw err;
        }
    }
    static async getPostData(dataPublished, description, likes, postId, postUrl, profImage, uid, username) {
        try {
            const getPosts = db.collection("posts").find({}).toArray(function (err, result) {
                if (err) throw err;
                console.log(result);
            });;
            return await getPosts;
        } catch (err) {
            throw err;
        }
    }
}

module.exports = PostService;