import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtil {
  ImageUtil._();

  static CachedNetworkImage networkImage(
          {required String imageUrl,
          double? height,
          double? width,
          Key? key}) =>
      CachedNetworkImage(
          key: key,
          placeholder: (context, url) =>
              NoImageWidget(height: height, width: width, fit: BoxFit.cover),
          errorWidget: (context, url, error) =>
              NoImageWidget(height: height, width: width, fit: BoxFit.cover),
          imageUrl: imageUrl /*?? Constants.placeholderImageUrl*/,
          height: height,
          // 9.h,
          width: width,
          // 30.w,
          // maxHeightDiskCache: (height * 3).ceil(),
          // maxWidthDiskCache: (width * 3).ceil(),
          placeholderFadeInDuration: Constants.placeholderFadeInDuration,
          fit: BoxFit.cover);

  static CachedNetworkImageProvider netWorkImageProvider(
          {required String imageUrl}) =>
      CachedNetworkImageProvider(
        imageUrl,
        errorListener: (data) {
          debugPrint("Failed to load image: $imageUrl");
        },
      );

  static Future<File> saveImageToTempStorage(Uint8List imageBytes) async {
    String dir;
    if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    } else {
      dir = (await getExternalStorageDirectories())![0].path;
    }
    final currentTimeMillisecond =
        DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(
        '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_image.png');
    await file.writeAsBytes(imageBytes);
    return file;
  }
}

class NoImageWidget extends StatelessWidget {
  const NoImageWidget({
    Key? key,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Constants.primaryGrey,
      child: Image.asset(
        Constants.noImage,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}
