const postRouter = require('express').Router();

const PostController = require('../controllers/post.controller');

postRouter.post("/post", PostController.post);

module.exports = postRouter;