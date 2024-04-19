const PostService = require('../services/post.services');

exports.post = async (req, res, next) => {
    try {
        const { dataPublished, description, likes, postId, postUrl, profImage, uid, username } = req.body;
        const createPost = await PostService.createPost(
            dataPublished, description, likes, postId, postUrl, profImage, uid, username
        );
        res.status(200).json({
            status: true,
            message: "Post Created Successfully"
        });
    } catch (err) {
        throw err
    }
}


exports.getPosts = async (req, res, next) => {
    try {
        const getPosts = await PostService.getPostData(        );
        res.status(200).json({
            status: true,
            data: getPosts
        });
    } catch (err) {
        throw err
    }
}