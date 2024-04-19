import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class CommentBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Map<String, dynamic> snap;
  final User user;
  final ScrollController scrollController;

  const CommentBottomSheet(
      {super.key,
      required this.context,
      required this.snap,
      required this.user,
      required this.scrollController});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController textEditingController = TextEditingController();
  List<bool> isDelete = [false];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        for (int i = 0; i < (snapshot.data?.docs.length ?? 0); i++) {
          isDelete.add(false);
        }
        return snapshot.data == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListView(
                    shrinkWrap: true,
                    controller: widget.scrollController,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isDelete[selectedIndex]
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isDelete = [false];
                                      });
                                      await FireStoreMethods().deleteComment(
                                          postId: widget.snap['postId'],
                                          commentId:
                                              snapshot.data?.docs[selectedIndex]
                                                  ['commentId']);
                                    },
                                    child: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDelete = [false];
                                      });
                                    },
                                    child: const Icon(
                                      size: 30,
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            )
                          : const Column(
                              children: [
                                Text('Comments',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 20),
                              ],
                            ),
                    ],
                  ),
                  Expanded(
                    child: Scrollbar(thickness: 1.2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectedIndex = index;
                              setState(() {
                                isDelete[index] = true;
                              });
                            },
                            child: Container(
                              color:
                                  isDelete[index] == true ? Colors.black : null,
                              /*margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),*/
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          backgroundImage: NetworkImage(
                                              widget.snap['profImage']),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        snapshot.data?.docs[index]
                                                            ['username']),
                                                    const SizedBox(width: 2),
                                                    Text(DateFormat('dd/MM/yyyy')
                                                        .format(snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['datePublished']
                                                            .toDate()))
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(snapshot.data?.docs[index]
                                                    ['text']),
                                                const SizedBox(height: 5),
                                                GestureDetector(
                                                    onTap: () {},
                                                    child: const Text(
                                                      'Reply',
                                                      style: TextStyle(
                                                          color: secondaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        visualDensity: const VisualDensity(
                                            vertical: -4, horizontal: -4),
                                        padding: const EdgeInsets.only(top: 5),
                                        onPressed: () async {
                                          await FireStoreMethods().commentLikes(
                                              commentId: snapshot
                                                  .data?.docs[index]['commentId'],
                                              postId: widget.snap['postId'],
                                              uid: snapshot.data?.docs[index]
                                                  ['uid'],
                                              likes: snapshot.data?.docs[index]
                                                  ['likes']);
                                        },
                                        icon: snapshot.data?.docs[index]['likes']
                                                .contains(widget.snap['uid'])
                                            ? const Icon(
                                                Icons.favorite_outlined,
                                                size: 18,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.favorite_border_outlined,
                                                size: 18,
                                                color: secondaryColor,
                                              ),
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]['likes'].length
                                            .toString(),
                                        style: const TextStyle(
                                            color: secondaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                NetworkImage(widget.snap['profImage'])),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add a comment...',
                                hintStyle: TextStyle(fontSize: 14)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (textEditingController.text == '') {
                              showSnackBar(context, 'Please Enter Something');
                            } else {
                              await FireStoreMethods().sendComment(
                                  uid: widget.user.uid,
                                  username: widget.user.username,
                                  postId: widget.snap['postId'],
                                  userPhotoUrl: widget.user.photoUrl,
                                  text: textEditingController.text);
                              textEditingController.clear();
                              setState(() {});
                            }
                          },
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
      },
    );
  }
}
