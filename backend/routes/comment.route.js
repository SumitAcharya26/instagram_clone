const commentRouter = require('express').Router();

const CommentController = require('../controllers/comment.controller');

commentRouter.post("/comment", CommentController.comment);

commentRouter.get("/comment", CommentController.getComment)

module.exports = commentRouter;