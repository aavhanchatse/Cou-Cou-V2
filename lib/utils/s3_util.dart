import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';
import 'package:flutter/material.dart';

class S3Util {
  static Future<String?> uploadFileToAws(File local, String uploadPath) async {
    debugPrint('inside aws function');
    try {
      local.existsSync();

      // S3UploadFileOptions options = const S3UploadFileOptions(
      //   accessLevel: StorageAccessLevel.guest,
      // );

      final awsFile = AWSFilePlatform.fromFile(local);

      StorageUploadFileResult result = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: uploadPath,
      ).result;

      debugPrint('result; $result');
      debugPrint('result.key: ${result.uploadedItem.key}');

      final downloadUrl =
          "https://coucoustoragebucket152907-dev.s3.ap-south-1.amazonaws.com/public/${result.uploadedItem.key}";

      return downloadUrl;
    } on StorageException catch (e) {
      debugPrint('uploadError ===> ${e.message.toString()}');
      rethrow;
    }
  }
}
