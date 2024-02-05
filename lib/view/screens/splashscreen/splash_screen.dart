import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.asset("assets/lottie/splash.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller!.play();
          // isPlaying = true;
        });
      });

    _controller!.addListener(checkVideo);
    // _checkLogin();

    setAnalytics();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'splash_screen');
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
        _checkLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  void _checkLogin() {
    // context.go(LoginScreen.routeName);

    // context.go(HomeScreen.routeName);

    var box = StorageManager();

    UserData? userData = box.getUserData();

    if (userData != null) {
      context.go(NavBar.routeName);
      // Get.offAll(
      //   () => const NavBar(),
      //   transition: Transition.fade,
      //   duration: const Duration(milliseconds: 300),
      // );
    } else {
      context.go(LoginScreen.routeName);
      // Get.offAll(
      //   () => const LoginScreen(),
      //   transition: Transition.fade,
      //   duration: const Duration(milliseconds: 300),
      // );
    }
  }
}
