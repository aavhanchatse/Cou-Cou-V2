import 'package:camera/camera.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/cameraScreen';

  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    initCamera();
  }

  void initCamera() async {
    final cameras = await availableCameras();
    debugPrint('cameras: $cameras');

    final first = cameras.first;

    _controller = CameraController(
      first,
      ResolutionPreset.veryHigh,
    );

    _initializeControllerFuture = _controller.initialize();

    loading = false;
    setState(() {});

    debugPrint("_initializeControllerFuture: $_initializeControllerFuture");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        title: InkWell(
          onTap: () {},
          child: Text(
            "Capture Picture",
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: "Inika",
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Constants.primaryColor,
              ),
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                debugPrint('snapshot: $snapshot');
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: double.infinity,
                    width: 100.w,
                    child: CameraPreview(_controller),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 6.w),
        child: FloatingActionButton(
          backgroundColor: Constants.white,
          onPressed: () async {
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();

              if (!mounted) return;

              debugPrint('image.path: ${image.path}');

              // If the picture was taken, display it on a new screen.
              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => DisplayPictureScreen(
              //       // Pass the automatically generated path to
              //       // the DisplayPictureScreen widget.
              //       imagePath: image.path,
              //     ),
              //   ),
              // );
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
          child: Icon(Icons.camera_alt, color: Constants.black),
        ),
      ),
    );
  }
}
