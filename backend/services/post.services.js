const PostModel = require("../model/post.model");

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
}

module.exports = PostService;