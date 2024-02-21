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
          BoxFit? fit,
          BlendMode? colorBlendMode,
          Color? color,
          String? errorImage,
          Key? key}) =>
      CachedNetworkImage(
        key: key,
        placeholder: (context, url) => NoImageWidget(
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorImage: errorImage),
        errorWidget: (context, url, error) => NoImageWidget(
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorImage: errorImage,
        ),
        imageUrl: imageUrl /*?? Constants.placeholderImageUrl*/,
        height: height,
        width: width,
        // maxHeightDiskCache: (height * 3).ceil(),
        // maxWidthDiskCache: (width * 3).ceil(),
        color: color,
        colorBlendMode: colorBlendMode,
        placeholderFadeInDuration: Constants.placeholderFadeInDuration,
        fit: fit ?? BoxFit.cover,
      );

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
        '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_image.webp');
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
    this.errorImage,
  }) : super(key: key);

  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? errorImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Constants.primaryGrey,
      child: errorImage != null
          ? Image.network(
              errorImage!,
              fit: fit ?? BoxFit.cover,
            )
          : Image.asset(
              Constants.noImage,
              fit: fit ?? BoxFit.cover,
            ),
    );
  }
}
