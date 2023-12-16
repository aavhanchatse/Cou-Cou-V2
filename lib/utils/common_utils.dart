import 'dart:developer';
import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void consoleLog(
    {required String tag, required String message, bool showFullLog = false}) {
  if (showFullLog) {
    log("$tag : $message");
  } else {
    if (kDebugMode) {
      debugPrint("$tag : $message");
    }
  }
}

Future<String> getTempImageFilePath(String ext) async {
  String dir;
  if (Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  } else {
    dir = (await getExternalStorageDirectories())![0].path;
  }

  final currentTimeMillisecond =
      DateTime.now().millisecondsSinceEpoch.toString();
  String filePath = '$dir/${currentTimeMillisecond}_cou_cou$ext';

  return filePath;
}

Future<File> saveImageToTempStorage(File filePath) async {
  Uint8List imageBytes = await filePath.readAsBytes();
  String dir;
  if (Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  } else {
    dir = (await getExternalStorageDirectories())![0].path;
  }

  final currentTimeMillisecond =
      DateTime.now().millisecondsSinceEpoch.toString();
  File file = File(
      '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_cou_cou.${filePath.path.split(".").last}');
  await file.writeAsBytes(imageBytes);
  return file;
}

Future<File> saveUint8ListToTempStorage(Uint8List filePath) async {
  String dir;
  if (Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  } else {
    dir = (await getExternalStorageDirectories())![0].path;
  }

  final currentTimeMillisecond =
      DateTime.now().millisecondsSinceEpoch.toString();
  File file = File(
      '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_cou_cou.png');
  await file.writeAsBytes(filePath);
  return file;
}

Future<File> saveUint8ListToTempStorageGif(Uint8List filePath) async {
  String dir;
  if (Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  } else {
    dir = (await getExternalStorageDirectories())![0].path;
  }

  final currentTimeMillisecond =
      DateTime.now().millisecondsSinceEpoch.toString();
  File file = File(
      '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_cou_cou.gif');
  await file.writeAsBytes(filePath);
  return file;
}

Future<File> saveUint8ListToTempStorageVideo(Uint8List filePath) async {
  String dir;
  if (Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  } else {
    dir = (await getExternalStorageDirectories())![0].path;
  }

  final currentTimeMillisecond =
      DateTime.now().millisecondsSinceEpoch.toString();
  File file = File(
      '$dir/${currentTimeMillisecond.substring(currentTimeMillisecond.length - 6)}_cou_cou.mp4');
  await file.writeAsBytes(filePath);
  return file;
}

showSnackBar(String text,
    {Widget? actionButton, Color? color, int time = 2000}) {
  var snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Constants.primaryColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Constants.black,
        ),
      ),
    ),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(milliseconds: 1500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
    // margin: EdgeInsets.only(bottom: 10),
    backgroundColor: Colors.transparent,
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

//   Get.showSnackbar(GetSnackBar(
//     duration: Duration(milliseconds: time),
//     borderRadius: 16.0,
//     margin: EdgeInsets.all(4.w),
//     // boxShadows: CommonStyle.primaryShadowLight(),
//     backgroundColor: Constants.lightGreen,
//     animationDuration: const Duration(milliseconds: 500),
//     mainButton: actionButton,
//     messageText: Text(
//       text,
//       style: TextStyle(
//         color: Constants.black,
//       ),
//     ),
//   ));
// }
}

String getDifferenceOfPeriodForNews(String postedDate) {
  DateTime dob = DateTime.parse(postedDate);
  Duration dur = DateTime.now().difference(dob);

  if (dur.inDays >= 1) {
    return "${dur.inDays} ${"days ago".tr}";
  }
  if (dur.inHours >= 1) {
    return "${dur.inHours} ${"hr ago".tr}";
  } else if (dur.inMinutes > 0 && dur.inMinutes < 60) {
    return "${dur.inMinutes} ${"min ago".tr}";
  } else {
    return "0" " ${"min ago".tr}";
  }
}

Future<void> shareImageWithText(String url, String textToShare) async {
  final response = await get(Uri.parse(url));
  // final bytes = response.bodyBytes;
  final Directory temp = await getTemporaryDirectory();
  final File imageFile = File('${temp.path}/tempImage.jpg');
  imageFile.writeAsBytesSync(response.bodyBytes);
  Share.shareXFiles(
    [XFile('${temp.path}/tempImage.jpg')],
    text: textToShare,
  );
}

launchUrlType(String type,
    {String email = "",
    String subject = "",
    String url = "",
    String phoneNumber = "",
    String smsBody = ""}) async {
  if (type == "email") {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );

    await launchUrl(emailLaunchUri);
  } else if (type == "url") {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  } else if (type == "sms") {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': smsBody,
      },
    );

    await launchUrl(smsLaunchUri);
  } else if (type == "telephone") {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}

// Future<List<String>> uploadImageToCloudStorage(List<String> _imageFile) async {
//
// }
