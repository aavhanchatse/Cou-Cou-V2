import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class InViewVideoPlayerCouCou extends StatefulWidget {
  final bool isViewChanged;
  final String data;
  final PostData postDataList;
  final bool? blackMute;

  const InViewVideoPlayerCouCou(
      {Key? key,
      required this.data,
      required this.isViewChanged,
      required this.postDataList,
      this.blackMute = false})
      : super(key: key);

  @override
  State<InViewVideoPlayerCouCou> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<InViewVideoPlayerCouCou> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool isPlaying = false;
  bool isPlayed = false;
  bool isLoaded = false;

  // bool isMusicOn = true;

  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // consoleLog(tag: "thumbanil_video :: ", message: widget.data);
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.data));
    // ..initialize().then((_) {
    //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //   // if (mounted) {
    //   //   setState(() {
    //   //     _controller!.play();
    //   //     isPlaying = true;
    //   //     isLoaded = true;
    //   //   });
    //   // }
    //   setState(() {
    //     isPlaying = true;
    //   });
    // });

    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        isPlaying = true;
      });
    });

    _controller!.addListener(checkVideo);

    if (userController.videoMute.value == true) {
      _controller!.setVolume(0.0);
    } else {
      _controller!.setVolume(1.0);
    }

    if (widget.isViewChanged) {
      _controller!.play();
      _controller!.setLooping(true);
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  void didUpdateWidget(InViewVideoPlayerCouCou oldWidget) {
    if (oldWidget.isViewChanged != widget.isViewChanged) {
      if (widget.isViewChanged) {
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {
          isPlaying = true;
        });
      } else {
        _controller!.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void checkVideo() {
    if (_controller != null) {
      // if (_controller!.value.position ==
      //     Duration(seconds: 0, minutes: 0, hours: 0)) {
      //   // setState(() {
      //   //   isPlaying=true;
      //   // });
      // }

      if (_controller!.value.position == _controller!.value.duration) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
        //_controller!.seekTo(const Duration(seconds: 0, minutes: 0, hours: 0));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller!.value.isInitialized
          ? InkWell(
              onTap: () {
                if (isPlaying) {
                  isPlayed = true;
                  isPlaying = false;
                  _controller!.pause();
                } else {
                  isPlaying = true;
                  _controller!.play();
                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                  if (!isPlaying)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/play_white_icon.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 10,
                    // right: 0,
                    // top: 0,
                    bottom: 10,
                    child: InkWell(
                      onTap: () {
                        soundToggle();
                      },
                      child: Image.asset(
                        userController.videoMute.value == true
                            ? 'assets/icons/common_icons/unmute.png'
                            : 'assets/icons/common_icons/mute.png',
                        width: 20,
                        height: 20,
                        color: widget.blackMute == true
                            ? Constants.primaryGrey2
                            : null,
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
                      child: ImageUtil.networkImage(
                          imageUrl: widget.postDataList.thumbnail!)),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                      child: Image.asset('assets/icons/play_white_icon.png',
                          width: 50, height: 50)),
                ),
              ],
            ),
    );
  }

  void soundToggle() {
    setState(() {
      userController.videoMute.value = !userController.videoMute.value;

      userController.videoMute.value == true
          ? _controller!.setVolume(0.0)
          : _controller!.setVolume(1.0);
    });
  }
}
