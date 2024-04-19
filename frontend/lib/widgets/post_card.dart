import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_bottom_sheet.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/users.dart' as model;

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});

  final Map<String, dynamic> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool animating = false;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              shrinkWrap: true,
                              children: ['Delete']
                                  .map((e) => InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                postId: widget.snap['postId'],
                likes: widget.snap['likes'],
                uid: user.uid,
              );
              setState(() {
                animating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child:
                        Image.network(widget.snap['postUrl'], fit: BoxFit.cover)
                    // Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
                    ),
                AnimatedOpacity(
                  opacity: animating ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: LikeAnimation(
                    isAnimating: animating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        animating = false;
                      });
                    },
                    child: widget.snap['likes'].contains(user.uid)
                        ? const Icon(Icons.favorite_outlined,
                            color: Colors.red, size: 120)
                        : const Icon(Icons.favorite_outlined,
                            color: Colors.white, size: 120),
                  ),
                )
              ],
            ),
          ),
          // Like and Comment
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    FireStoreMethods().likePost(
                      postId: widget.snap['postId'],
                      uid: user.uid,
                      likes: widget.snap['likes'],
                    );
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: widget.snap['likes'].contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                  )),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_sharp,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_outline_outlined,
                  ),
                ),
              ))
            ],
          ),

          // Description and Comment Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' ${widget.snap['description']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // commentsBottomSheet(context, widget.snap, user);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      context: context,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.4,
                          maxChildSize: 0.9,
                          initialChildSize: 0.6,
                          builder: (context, scrollController) {
                            return CommentBottomSheet(
                              context: context,
                              scrollController: scrollController,
                              snap: widget.snap,
                              user: user,
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text('View all 200 comments',
                        style: TextStyle(fontSize: 16, color: secondaryColor)),
                  ),
                ),
                Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 14, color: secondaryColor))
              ],
            ),
          )
        ],
      ),
    );
  }
}
