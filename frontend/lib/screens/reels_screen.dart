import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users.dart' as model;
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../widgets/video_player_widget.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  String videoUrl =
      "https://firebasestorage.googleapis.com/v0/b/instagram-clone-3dd05.appspot.com/o/reels%2FcxjIQjgUceYoZgktg3oqy3nNjcp1%2Fc0ca9d30-5e3e-1e43-9dec-af47d617b997?alt=media&token=65a95523-06e9-4e8e-a830-a2e6b3c03ea9";

/*
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((value) => _videoPlayerController.play());
    _videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }*/
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('reels').snapshots(),
            builder: (context, snapshot) {
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return snapshot.data == null
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(onTap: () {

                      },
                          onDoubleTap: () {
                            FireStoreMethods().likeReel(
                                reelId: snapshot.data?.docs[index]['reelId'],
                                uid: user.uid,
                                likes: snapshot.data?.docs[index]['likes']);
                            setState(() {
                              isAnimating = true;
                            });
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Center(
                                child: VideoPlayerWidget(
                                    videoUrl: snapshot.data?.docs[index]
                                        ['videoUrl']),
                              ),
                              Container(color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await FireStoreMethods().likeReel(
                                                reelId: snapshot.data?.docs[index]
                                                    ['reelId'],
                                                uid: user.uid,
                                                likes: snapshot.data?.docs[index]
                                                    ['likes']);
                                          },
                                          icon: snapshot
                                                  .data?.docs[index]['likes']
                                                  .contains(user.uid)
                                              ? const Icon(
                                                  Icons.favorite_outlined,
                                                  size: 35,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  size: 35,
                                                ),
                                        ),
                                        Text(
                                          snapshot
                                              .data!.docs[index]['likes'].length
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: isAnimating ? 1 : 0,
                                  child: LikeAnimation(
                                      isAnimating: isAnimating,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      onEnd: () {
                                        setState(() {
                                          isAnimating = false;
                                        });
                                      },
                                      child: snapshot.data?.docs[index]['likes']
                                              .contains(user.uid)
                                          ? const Icon(
                                              Icons.favorite_outlined,
                                              color: Colors.red,
                                              size: 200,
                                            )
                                          : const Icon(
                                              Icons.favorite_outlined,
                                              size: 200,
                                            )))
                            ],
                          ),
                        );
                },
              );
            }));
  }
}
