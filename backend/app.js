const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('./routes/user.route');
const postRouter = require('./routes/post.route');
const commentRouter = require('./routes/comment.route');
const app = express();

app.use(body_parser.json());

app.use('/', userRouter);

app.use('/', postRouter);

app.use('/', commentRouter);

module.exports = app;