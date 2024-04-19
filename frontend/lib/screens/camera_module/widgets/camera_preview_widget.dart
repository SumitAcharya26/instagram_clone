import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/screens/reels_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../models/users.dart' as model;
import '../../../providers/user_provider.dart';

class CameraPreviewWidget extends StatefulWidget {
  final File file;

  const CameraPreviewWidget({super.key, required this.file});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late VideoPlayerController _controller;
  double progressValue = 0.0; // Initial progress value
  int currentDurationInSeconds = 0;
  late Timer timer;
  bool isEnd = false;
  bool initialize = true;
  bool loading = false;

  void startProgress() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (currentDurationInSeconds <
          ((double.parse(_controller.value.duration.toString().split(':')[2]) *
                  10) +
              1.0)) {
        setState(() {
          currentDurationInSeconds++;
          progressValue = currentDurationInSeconds /
              ((double.parse(
                          _controller.value.duration.toString().split(':')[2]) *
                      10) +
                  1.0);
          if (isEnd) {
            progressValue = 0.0;
            currentDurationInSeconds = 0;
          } /*else {
            progressValue += 1.0 /
                (double.parse(
                        _controller.value.duration.toString().split(':')[2]) *
                    10);
          }*/
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = (VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        initialize = false;
        _controller.addListener(() {
          print(
              'position==${_controller.value.position.inMilliseconds} duration==${_controller.value.duration.inMilliseconds}');
          print(
              'isEnd==${_controller.value.position >= _controller.value.duration}');
          setState(() {
            isEnd = _controller.value.position >= _controller.value.duration;
          });
        });
        // _controller.setLooping(true);
        setState(() {});
        _controller.play();
        startProgress(); // Auto-play video
      }))
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero);
          _controller.play();
        }
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: initialize
          ? const CircularProgressIndicator()
          : Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                LinearProgressIndicator(
                  value: _controller.value.position.inMilliseconds /
                      _controller.value.duration.inMilliseconds,
                ),
                TextButton(
                    onPressed: () async {
                      loading=true;
                      Uint8List videoFile = await widget.file.readAsBytes();
                      await FireStoreMethods()
                          .uploadReels(user.uid, user.username, videoFile);
                      loading=false;
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const MobileScreenLayout();
                        },
                      ));
                    },
                    child: Text('Upload')),
                if(loading)const LinearProgressIndicator()
              ],
            ),
    );
  }
}
