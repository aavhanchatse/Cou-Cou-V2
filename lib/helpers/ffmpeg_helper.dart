import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

class FfmpegHelper {
  static Future<String?> combineAudioWithImage(
      String imagePath, String audioFilePath) async {
    // ProgressDialog.showProgressDialog(context);
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

    debugPrint('imagePath in ffmpeg: $imagePath');

    // final rc = await _flutterFFmpeg.execute(
    //     "-loop 1 -y -i $imagePath -i $audioFilePath -shortest $outputPath");

    final rc = await _flutterFFmpeg.execute(
      "-loop 1 -y -i $imagePath -i $audioFilePath -vf fps=30,format=yuv420p -shortest $outputPath",
    );

    // final rc = await _flutterFFmpeg.execute(
    //     "-i $imagePath -i $audioFilePath -b:v libx264 -vf fps=25,format=yuv420p -b 4k $outputPath");

    // "-framerate 1/5 -i $imagePath -i $audioFilePath -c:v libx264 -preset ultrafast -b 800k -vf fps=25,format=yuv420p $outputPath");

    // ffmpeg -framerate 1/5 -i {{input_image}} -i {{audio_file.mp3}} -c:v libx264 -preset ultrafast -b 800k -vf fps=25,format=yuv420p {{output_file.mp4}}

    debugPrint('rc: $rc');

    if (rc == 0) {
      // Get.back();
      return outputPath;
    } else {
      return null;
    }
  }
}
