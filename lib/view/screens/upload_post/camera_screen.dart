import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class CameraScreen extends StatefulWidget {
  static const routeName = '/cameraScreen';

  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  List<CameraImage> capturedFrames = [];

  List<XFile> capturedFiles = [];
  // VideoPlayerController? boomerangController;
  bool isExecuting = false; // Flag to track whether the function is executing.

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
    cameras = await availableCameras();
    debugPrint("cameras: $cameras");

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
    );
    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void stopContinuousExecution() {
    isExecuting = false;
    setState(() {});
  }

  Future<void> startRecording() async {
    // isExecuting = true;
    // setState(() {});

    // Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    //   if (!isExecuting) {
    //     timer.cancel();
    //   } else {
    //     final file = await _controller!.takePicture();
    //     capturedFiles.add(file);
    //   }
    // });

    // setState(() {});
    await _controller?.startImageStream((CameraImage image) {
      capturedFrames.add(image);
      // Capture frames here and store them in the 'capturedFrames' list
      // You may need to convert the CameraImage to a format that can be displayed
    });
  }

  Future<void> stopRecording() async {
    await _controller?.stopImageStream();
    // stopContinuousExecution();

    debugPrint('capturedFrames: $capturedFiles');

    List<Uint8List> list = [];

    for (var element in capturedFrames) {
      final item = convertYUV420ToUint8List(element);
      list.add(item);
    }

    debugPrint('list: ${list.length}');

    // Create the Boomerang loop by reversing 'capturedFrames'
    var reversedFrames = list.reversed.toList();
    var boomerangFrames = [...list, ...reversedFrames];

    // Uint8List concatenatedFrames =
    //     Uint8List.fromList(boomerangFrames.expand((x) => x).toList());

    final result = await generateGIF(boomerangFrames);
    debugPrint('result: $result');
  }

  Future generateGIF(List<Uint8List> frames) async {
    final gif = img.GifEncoder();

    final frame = img.decodeImage(frames.first);
    debugPrint('frame: $frame');

    for (final frameBytes in frames) {
      final frame = img.decodeImage(frameBytes);
      if (frame != null) {
        gif.addFrame(frame);
      }
    }

    final result = gif.finish();

    if (result != null) {
      final file = await saveUint8ListToTempStorageGif(result);

      return file.path;
    }
  }

  Uint8List convertYUV420ToUint8List(CameraImage image) {
    // Calculate the size of the Y, U, and V planes
    int ySize = image.planes[0].bytes.length;
    int uSize = image.planes[1].bytes.length;
    int vSize = image.planes[2].bytes.length;

    // Create a Uint8List with the combined size
    Uint8List result = Uint8List(ySize + uSize + vSize);

    // Copy the Y plane
    result.setAll(0, image.planes[0].bytes);

    // Copy the U and V planes
    result.setAll(ySize, image.planes[1].bytes);
    result.setAll(ySize + uSize, image.planes[2].bytes);

    return result;
  }

  // List<int>? generateGIF(List<Uint8List> boomerangFrames) {
  //   final List<img.Image?> images = [];
  //   for (var l in boomerangFrames) {
  //     images.add(img.decodeImage(l));
  //   }

  //   final gif = img.GifEncoder();

  //   for (final frameBytes in boomerangFrames) {
  //   final frame = img.decodeImage(Uint8List.fromList(frameBytes));

  //   gif.addFrame(frame!);

  //   return null;

  //   }
  //   return null;

  //       //  `

  //       // final outputGif = gif.encode();

  //       // final directory = await getTemporaryDirectory();
  //       // final gifFile = File('${directory.path}/$outputPath');

  //       // await gifFile.writeAsBytes(outputGif);

  //       // print('GIF saved at: ${gifFile.path}');
  //       // return null;`

  //   // img.Animation animation = img.Animation();

  //   // for (var element in images) {
  //   //   animation.addFrame(element!);
  //   // }

  //   // return img.encodeGifAnimation(animation);
  // }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container();
    }

    // return CameraPreview(
    //   _controller!,
    //   child: Column(
    //     children: [
    //       Container(
    //         color: Colors.black.withOpacity(0.7),
    //         child: const Icon(Icons.photo),
    //       ),
    //     ],
    //   ),
    // );

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Boomerang Camera App'),
        //   backgroundColor: Colors.transparent,
        // ),
        // body: _controller != null
        //     ? CameraPreview(
        //         _controller!,
        //         child: Column(
        //           children: [
        //             Container(
        //               color: Colors.black.withOpacity(0.7),
        //               child: const Icon(Icons.photo),
        //             ),
        //           ],
        //         ),
        //       )
        //     : const CircularProgressIndicator(),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: CameraPreview(
                _controller!,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.black,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // body: Column(
        //   children: [
        //     Expanded(
        //       child: Center(
        //         child: _controller != null
        //             ? CameraPreview(_controller!)
        //             : const CircularProgressIndicator(),
        //       ),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         startRecording();
        //       },
        //       child: const Text('Start Recording'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         stopRecording();
        //       },
        //       child: const Text('Stop Recording'),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }
}

// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: BoomerangCameraApp(),
//     );
//   }
// }

// class BoomerangCameraApp extends StatefulWidget {
//   const BoomerangCameraApp({super.key});

//   @override
//   _BoomerangCameraAppState createState() => _BoomerangCameraAppState();
// }

// class _BoomerangCameraAppState extends State<BoomerangCameraApp> {
//   CameraController? _controller;
//   List<CameraDescription> cameras = [];
//   List<Uint8List> capturedFrames = [];
//   VideoPlayerController? boomerangController;

//   @override
//   void initState() {
//     super.initState();
//     setupCamera();
//   }

//   Future<void> setupCamera() async {
//     cameras = await availableCameras();
//     _controller = CameraController(cameras[0], ResolutionPreset.high);
//     await _controller!.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> startRecording() async {
//     await _controller?.startImageStream((CameraImage image) {
//       // Capture frames here and store them in the 'capturedFrames' list
//       // You may need to convert the CameraImage to a format that can be displayed
//     });
//   }

//   Future<void> stopRecording() async {
//     await _controller?.stopImageStream();
//     // Create the Boomerang loop by reversing 'capturedFrames'
//     var reversedFrames = capturedFrames.reversed.toList();
//     var boomerangFrames = [...capturedFrames, ...reversedFrames];

//     // Display the Boomerang loop as a video
//     boomerangController = VideoPlayerController.memory(boomerangFrames[0]);
//     await boomerangController?.initialize();
//     boomerangController?.play();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Boomerang Camera App'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: _controller != null
//                   ? CameraPreview(_controller!)
//                   : const CircularProgressIndicator(),
//             ),
//           ),
//           boomerangController != null
//               ? SizedBox(
//                   height: 200,
//                   child: VideoPlayer(boomerangController!),
//                 )
//               : ElevatedButton(
//                   onPressed: () {
//                     startRecording();
//                   },
//                   child: const Text('Start Recording'),
//                 ),
//           boomerangController != null
//               ? ElevatedButton(
//                   onPressed: () {
//                     boomerangController?.dispose();
//                     capturedFrames.clear();
//                     boomerangController = null;
//                     setState(() {});
//                   },
//                   child: const Text('Clear Boomerang'),
//                 )
//               : ElevatedButton(
//                   onPressed: () {
//                     stopRecording();
//                   },
//                   child: const Text('Stop Recording'),
//                 ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     boomerangController?.dispose();
//     super.dispose();
//   }
// }

// // import 'dart:io';

// // import 'package:camera/camera.dart';
// // import 'package:coucou_v2/app_constants/constants.dart';
// // import 'package:coucou_v2/utils/size_config.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';

// // class CameraScreen extends StatefulWidget {
// //   static const routeName = '/cameraScreen';

// //   const CameraScreen({super.key});

// //   @override
// //   CameraScreenState createState() => CameraScreenState();
// // }

// // class CameraScreenState extends State<CameraScreen> {
// //   late CameraController _controller;
// //   late Future<void> _initializeControllerFuture;
// //   bool loading = true;

// //   @override
// //   void initState() {
// //     super.initState();

// //     initCamera();
// //   }

// //   void initCamera() async {
// //     final cameras = await availableCameras();
// //     debugPrint('cameras: $cameras');

// //     final first = cameras.first;

// //     _controller = CameraController(
// //       first,
// //       ResolutionPreset.veryHigh,
// //     );

// //     _initializeControllerFuture = _controller.initialize();

// //     loading = false;
// //     setState(() {});

// //     debugPrint("_initializeControllerFuture: $_initializeControllerFuture");
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (!_controller.value.isInitialized) {
// //       return;
// //     }

// //     if (state == AppLifecycleState.inactive) {
// //       _controller.dispose();
// //     } else if (state == AppLifecycleState.resumed) {
// //       initCamera();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Constants.white,
// //         title: InkWell(
// //           onTap: () {},
// //           child: Text(
// //             "Capture Picture",
// //             style: TextStyle(
// //               color: Constants.black,
// //               fontWeight: FontWeight.bold,
// //               fontSize: 24,
// //               
// //             ),
// //           ),
// //         ),
// //         leading: IconButton(
// //           onPressed: () {
// //             // context.pop();
// //           },
// //           icon: ImageIcon(
// //             const AssetImage("assets/icons/back_arrow.png"),
// //             color: Constants.black,
// //           ),
// //         ),
// //       ),
// //       body: loading == true
// //           ? Center(
// //               child: CircularProgressIndicator(
// //                 color: Constants.primaryColor,
// //               ),
// //             )
// //           : FutureBuilder<void>(
// //               future: _initializeControllerFuture,
// //               builder: (context, snapshot) {
// //                 debugPrint('snapshot: $snapshot');
// //                 if (snapshot.connectionState == ConnectionState.done) {
// //                   return SizedBox(
// //                     height: double.infinity,
// //                     width: 100.w,
// //                     child: CameraPreview(_controller),
// //                   );
// //                 } else {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }
// //               },
// //             ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       floatingActionButton: Padding(
// //         padding: EdgeInsets.only(bottom: 6.w),
// //         child: FloatingActionButton(
// //           backgroundColor: Constants.white,
// //           onPressed: () async {
// //             try {
// //               // Ensure that the camera is initialized.
// //               await _initializeControllerFuture;

// //               final image = await _controller.takePicture();

// //               if (!mounted) return;

// //               debugPrint('image.path: ${image.path}');
// //             } catch (e) {
// //               // If an error occurs, log the error to the console.
// //               debugPrint(e.toString());
// //             }
// //           },
// //           child: Icon(Icons.camera_alt, color: Constants.black),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> captureImages() async {
// //     try {
// //       await _controller.initialize();

// //       final Directory appDirectory = await getTemporaryDirectory();

// //       final String storageDirectory =
// //           join(appDirectory.path, 'boomerang_frames');

// //       if (!Directory(storageDirectory).existsSync()) {
// //         Directory(storageDirectory).createSync(recursive: true);
// //       }

// //       for (int i = 0; i < 10; i++) {
// //         final String filePath = join(storageDirectory, 'frame_$i.jpg');
// //         await _controller.takePicture(filePath);
// //       }

// //       // Create Boomerang from captured images
// //       createBoomerang(storageDirectory);
// //     } catch (e) {
// //       print('Error capturing images: $e');
// //     }
// //   }

// //   void createBoomerang(String storageDirectory) {
// //     final sequenceAnimation = SequenceAnimationBuilder()
// //         .addAnimatable(
// //           animatable: Tween<double>(begin: 0, end: 1),
// //           from: Duration.zero,
// //           to: const Duration(milliseconds: 500),
// //           tag: "opacity",
// //         )
// //         .addAnimatable(
// //           animatable: Tween<double>(begin: 1, end: 0),
// //           from: const Duration(milliseconds: 500),
// //           to: const Duration(milliseconds: 1000),
// //           tag: "opacity",
// //         )
// //         .animate(controller);

// //     sequenceAnimation.addListener(() {
// //       // Display the frame based on the current animation value
// //       final int frameIndex =
// //           (numberOfFramesToCapture - 1) * sequenceAnimation["opacity"].value;
// //       final String filePath = join(storageDirectory, 'frame_$frameIndex.jpg');

// //       // Display the image using an Image widget or custom painting
// //       // You may need to use a different package for efficient image display.
// //     });

// //     sequenceAnimation.addStatusListener((status) {
// //       if (status == AnimationStatus.completed) {
// //         // The boomerang animation is complete, do something
// //       }
// //     });

// //     sequenceAnimation.forward();
// //   }
// // }
