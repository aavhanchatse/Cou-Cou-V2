import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

class FfmpegHelper {
  static Future<String?> combineAudioWithImage(
      String audioFilePath, BuildContext context) async {
    ProgressDialog.showProgressDialog(context);

    final controller = Get.find<PostController>();

    var result = await FlutterImageCompress.compressWithFile(
      controller.filePath.value,
      minWidth: 1080,
      minHeight: 1350,
      quality: 70,
    );

    if (result != null) {
      final file = await saveUint8ListToTempStorage(result);

      Directory? appDocumentDir;

      if (Platform.isIOS) {
        appDocumentDir = (await getApplicationDocumentsDirectory());
      } else {
        appDocumentDir = (await getExternalStorageDirectory());
      }

      var now = DateTime.now().millisecondsSinceEpoch;

      var fileName = '${now}output.mp4';

      String rawDocumentPath = appDocumentDir!.path;
      String outputPath = "$rawDocumentPath/$fileName";

      debugPrint('imagePath in ffmpeg: ${file.path}');

      // final rc = await _flutterFFmpeg.execute(
      //     "-loop 1 -y -i $imagePath -i $audioFilePath -shortest $outputPath");

      final rc = await _flutterFFmpeg.execute(
        "-loop 1 -y -i ${file.path} -i $audioFilePath -vf fps=30,format=yuv420p -shortest $outputPath",
      );

      // final rc = await _flutterFFmpeg.execute(
      //     "-i $imagePath -i $audioFilePath -b:v libx264 -vf fps=25,format=yuv420p -b 4k $outputPath");

      // "-framerate 1/5 -i $imagePath -i $audioFilePath -c:v libx264 -preset ultrafast -b 800k -vf fps=25,format=yuv420p $outputPath");

      // ffmpeg -framerate 1/5 -i {{input_image}} -i {{audio_file.mp3}} -c:v libx264 -preset ultrafast -b 800k -vf fps=25,format=yuv420p {{output_file.mp4}}

      debugPrint('rc: $rc');

      if (rc == 0) {
        // Get.back();
        context.pop();
        return outputPath;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<String?> generateVideo(
      List<Uint8List> frames, BuildContext context) async {
    final ffmpeg = FlutterFFmpeg();
    final directory = await getTemporaryDirectory();
    final tempDir = directory.path;

    if (await Permission.storage.request().isGranted) {
      for (int i = 0; i < frames.length; i++) {
        final frameFile = File('$tempDir/frame_$i.png');
        await frameFile.writeAsBytes(frames[i]);
      }

      // Define the output path for the video.
      Directory? appDocumentDir;
      if (Platform.isIOS) {
        appDocumentDir = (await getApplicationDocumentsDirectory());
      } else {
        appDocumentDir = (await getExternalStorageDirectory());
      }
      var now = DateTime.now().millisecondsSinceEpoch;
      var fileName = '${now}output.mp4';
      String rawDocumentPath = appDocumentDir!.path;
      String outputPath = "$rawDocumentPath/$fileName";

      final videoOutputPath = outputPath;

      // Use the `flutter_ffmpeg` package to create the video from the frames.
      // "-framerate 30 -i ${tempDir}/frame_%d.png -c:v libx264 -pix fmt yuv420p -b:v 16M -y $videoOutputPath";

      final result = await ffmpeg.execute(
          "-framerate 30 -i $tempDir/frame_%d.png -c:v libx264 fmt yuv420p -b:v 16M -y $videoOutputPath");

      // final result = await ffmpeg.execute([
      //   '-framerate',
      //   '30', // Frame rate (adjust as needed)
      //   '-i',
      //   '$tempDir/frame_%d.png', // Input image files
      //   '-c:v',
      //   'libx264', // H.264 video codec
      //   '-pix_fmt',
      //   'yuv420p',
      //   '-b:v',
      //   '16M', // Target bitrate (16MB per second)
      //   '-y',
      //   videoOutputPath, // Output video path
      // ]);

      if (result == 0) {
        print('Video generation successful.');
        context.pop();
        return videoOutputPath;
      } else {
        print('Video generation failed. Error code: $result');
      }
    } else {
      print('Permission to access storage was not granted.');
    }
    return null;
  }
}
