const CommentService = require('../services/comment.services');


exports.comment = async (req, res, next) => {
    try {
        const { postId, dataPublished, commentId, likes, text, userPhotoUrl, uid, username } = req.body;
        const createComment = await CommentService.createComment(postId,
            dataPublished, commentId, likes, text, userPhotoUrl, uid, username
        );
        res.status(200).json({
            status: true,
            message: "Comment Created Successfully"
        });
    } catch (err) {
        throw err
    }
}

exports.getComment = async (req, res, next) => {
    try {
        // const { postId, dataPublished, commentId, likes, text, userPhotoUrl, uid, username } = req.body;
        const getComments = await CommentService.getComment();
        res.status(200).json({
            status: true,
            data:getComments
        });
    } catch (err) {
        throw err
    }
}
