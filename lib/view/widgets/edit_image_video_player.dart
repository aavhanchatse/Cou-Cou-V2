import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EditImageVideoPlayer extends StatefulWidget {
  const EditImageVideoPlayer({Key? key}) : super(key: key);

  @override
  State<EditImageVideoPlayer> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<EditImageVideoPlayer>
    with TickerProviderStateMixin {
  final postController = Get.find<PostController>();

  late VideoPlayerController _controller;
  late AnimationController _animationController;

  bool isPlaying = false;
  bool isPlayed = false;
  bool isLoaded = false;

  bool isMusicOn = true;

  @override
  void initState() {
    super.initState();
    // consoleLog(tag: "thumbanil_video :: ", message: widget.data);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(postController.videoFilePath.value),
    )..initialize().then((_) {
        setState(() {
          isPlaying = true;
        });
      });

    _controller.addListener(checkVideo);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _animationController.dispose();
  }

  void checkVideo() {
    if (_controller.value.isCompleted) {
      _animationController.reverse();
    }
    // if (_controller!.value.position ==
    //     Duration(seconds: 0, minutes: 0, hours: 0)) {
    //   // setState(() {
    //   //   isPlaying=true;
    //   // });
    // }

    // if (_controller.value.position == _controller.value.duration) {
    //   if (mounted) {
    //     setState(() {
    //       isPlaying = false;
    //     });
    //   }
    //   //_controller!.seekTo(const Duration(seconds: 0, minutes: 0, hours: 0));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? InkWell(
              onTap: () {
                // if (isPlaying) {
                //   isPlayed = true;
                //   isPlaying = false;
                //   _controller!.pause();
                // } else {
                //   isPlaying = true;
                //   _controller!.play();
                // }
                // setState(() {});
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                              // _animationController.forward();
                              _animationController.reverse();
                            } else {
                              _controller.play();
                              // _animationController.reverse();
                              _animationController.forward();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: AnimatedIcon(
                              // color: Colors.white,
                              icon: AnimatedIcons.pause_play,
                              progress: _animationController,
                              semanticLabel: 'Play',
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isPlaying)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                          child: Image.asset('assets/icons/play_white_icon.png',
                              width: 50, height: 50)),
                    ),
                  // Positioned(
                  //   left: 10,
                  //   // right: 0,
                  //   // top: 0,
                  //   bottom: 10,
                  //   child: ,
                  //   // child: InkWell(
                  //   //   onTap: () {
                  //   //     soundToggle();
                  //   //   },
                  //   //   child: Image.asset(
                  //   //     isMusicOn == true
                  //   //         ? 'assets/icons/common_icons/mute.png'
                  //   //         : 'assets/icons/common_icons/mute_off.png',
                  //   //     width: 50,
                  //   //     height: 50,
                  //   //   ),
                  //   // ),
                  // ),
                  Positioned(
                    bottom: 5.h,
                    child: SizedBox(
                      width: 100.w,
                      height: 4,
                      child: VideoProgressIndicator(
                        _controller,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        allowScrubbing: false,
                        colors: VideoProgressColors(
                          backgroundColor: Colors.grey,
                          // bufferedColor: Colors.pink,
                          playedColor: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100.w,
                    child: Image.file(
                      File(postController.filePath.value),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        _controller = VideoPlayerController.file(
                            File(postController.videoFilePath.value))
                          ..initialize().then((_) {
                            setState(() {
                              isPlaying = true;
                            });
                          });
                      },
                      child: Image.asset('assets/icons/play_white_icon.png',
                          width: 50, height: 50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void soundToggle() {
    setState(() {
      isMusicOn = !isMusicOn;

      isMusicOn == true
          ? _controller.setVolume(0.0)
          : _controller.setVolume(1.0);
    });
  }
}
