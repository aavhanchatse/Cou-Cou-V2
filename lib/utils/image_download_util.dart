import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImageDownloadUtil {
  static void shareImageUtil(BuildContext context, String imageUrl) async {
    ProgressDialog.showProgressDialog(context);
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(imageUrl));
    var bytes = req.bodyBytes;
    context.pop();
    // await Share.file('Share with', 'doctor_image.jpg',
    //     bytes.buffer.asUint8List(), 'image/jpeg');
  }

  static Future<Uint8List> downLoadImage(
      BuildContext context, String imageUrl) async {
    ProgressDialog.showProgressDialog(context);
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(imageUrl));
    var bytes = req.bodyBytes;
    context.pop();

    return bytes;
  }

  static Future<File> downloadImageToGallery(
      BuildContext context, String imageUrl, String imageName,
      {bool isVideo = false, bool isSharing = false}) async {
    ProgressDialog.showProgressDialog(context);
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(imageUrl));
    var bytes = req.bodyBytes;
    String dir;
    if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    } else {
      dir = (await getExternalStorageDirectories())![0].path;
    }
    File file = File('$dir/$imageName');

    final result =
        await ImageGallerySaver.saveImage(bytes, quality: 60, name: imageName);

    debugPrint("result: $result");

    Navigator.pop(context);
    SnackBarUtil.showSnackBar(
        context: context, "Image Downloaded Successfully");
    debugPrint("File saved! At---> $dir/$imageName");

    return file.writeAsBytes(bytes);
  }

  static Future<void> saveImageToGallery({
    required BuildContext context,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    ProgressDialog.showProgressDialog(context);

    final result = await ImageGallerySaver.saveImage(imageBytes,
        quality: 60, name: imageName);

    debugPrint("result: $result");

    Navigator.pop(context);
    SnackBarUtil.showSnackBar(
        context: context, "Image Downloaded Successfully");
  }
}
