import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/bloc/on_click_bloc.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/screens/camera_module/widgets/camera_preview_widget.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../responsive/mobile_screen_layout.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  int direction = 0;
  bool recordingStart = false;
  bool isRecording = false;
  double timerValue = 0.0;
  late File videoFile;

  double value = 0.0;
  late Timer timer;
  final double incrementAmount = 0.0033;
  final double totalTimeInSeconds = 3100;
  int currentTimeInSeconds = 0;
  bool isTimerPaused = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        if (!isTimerPaused && currentTimeInSeconds < totalTimeInSeconds) {
          value += incrementAmount;
          currentTimeInSeconds++;
        } else {
          timer.cancel(); // Stop the timer when reaching the total time
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startCamera(direction);
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    _cameraController =
        CameraController(cameras[direction], ResolutionPreset.high);
    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    try {
      return WillPopScope(onWillPop: () {

        return Future.value(true);
      },
        child: Scaffold(
            body: _cameraController.value.isInitialized
                ? Stack(
                    children: [
                      GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              direction = direction == 0 ? 1 : 0;
                              startCamera(direction);
                            });
                          },
                          child: CameraPreview(_cameraController)),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: isRecording == false && recordingStart == false
                              ? GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      startTimer();
                                      isRecording = true;
                                      recordingStart = true;
                                    });
                                    await _cameraController.startVideoRecording();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 32,
                                    child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.black),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: ()  async{
                                    isTimerPaused = !isTimerPaused;
                                    if (!isTimerPaused) {
                                      startTimer();
                                      await _cameraController
                                          .resumeVideoRecording();
                                    } else {
                                      await _cameraController
                                          .pauseVideoRecording();
                                    }
                                    setState(()  {

                                      isRecording = false;
                                    });
                                    /*await _cameraController
                                        .stopVideoRecording()
                                        .then((XFile file) async {
                                      final Uint8List _file =
                                      await file.readAsBytes();
                                      await FireStoreMethods().uploadReels(
                                          user.uid, user.username, _file);
                                    });*/
                                  },
                                  child: Stack(
                                    children: [
                                      const Icon(Icons.stop_circle_rounded,
                                          size: 65),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 4),
                                        height: 60,
                                        width: 60,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          value: value,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.only(bottom: 35, right: 20),
                        child: TextButton(
                            onPressed: () async {
                              await _cameraController
                                  .stopVideoRecording()
                                  .then((XFile value) {
                                videoFile = File(value.path);
                              });
                              Future.delayed(const Duration(microseconds: 2000),() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CameraPreviewWidget(file: videoFile),
                                    ));
                              },);
                            },
                            child: const Text('Next')),
                      )
                    ],
                  )
                : const Center(child: CircularProgressIndicator())),
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
