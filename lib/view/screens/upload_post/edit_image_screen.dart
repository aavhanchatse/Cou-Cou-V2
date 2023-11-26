import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/dialogs/audio_recorder_dialog.dart';
import 'package:coucou_v2/view/screens/upload_post/upload_post_details_screen.dart';
import 'package:coucou_v2/view/widgets/edit_image_video_player.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class EditImageScreen extends StatelessWidget {
  static const routeName = '/edit-image';

  final bool isVideo;

  const EditImageScreen({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(UploadPostDetailsScreen.routeName);
            },
            icon: Icon(
              Icons.check,
              color: Constants.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Constants.white,
              child: Center(
                child: controller.videoFilePath.isEmpty
                    ? Image.file(
                        File(controller.filePath.value),
                        fit: BoxFit.cover,
                        // height: 20.h,
                        // width: 20.h,
                      )
                    : const EditImageVideoPlayer(),
              ),
            );
          }),
          if (isVideo == false)
            Positioned(
              bottom: 10.h,
              right: 3.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //   onPressed: () async {
                  //     final String? path =
                  //         await context.push(CameraScreen.routeName);

                  //     debugPrint("path: $path");
                  //   },
                  //   icon: const ImageIcon(
                  //     AssetImage("assets/icons/Infinity.png"),
                  //   ),
                  // ),

                  IconButton(
                    onPressed: () {
                      // checkAndRequestPermissions();
                      // showAudioBottomsheet(context);
                      selectAudioFromDevice(context);
                      // FfmpegHelper.combineAudioWithImage(
                      //     imagePath, audioFilePath);
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/icons/music.png"),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      recordAudio(context);
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/icons/mic.png"),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await analytics.logEvent(name: "image_cropper_icon");

                      final Uint8List? editedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageCropper(
                            image: controller.fileBytes.value as Uint8List,
                          ),
                        ),
                      );

                      if (editedImage != null) {
                        final File file =
                            await ImageUtil.saveImageToTempStorage(editedImage);

                        controller.filePath.value = file.path;
                        controller.fileBytes.value = editedImage;
                        controller.videoFilePath.value = "";
                        controller.musicName.value = "";
                      }
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/icons/crop.png"),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await analytics.logEvent(name: "image_filter_icon");

                      final Uint8List? editedImage =
                          await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageEditor(
                            image: controller.fileBytes.value,
                          ),
                        ),
                      );

                      if (editedImage != null) {
                        final File file =
                            await ImageUtil.saveImageToTempStorage(editedImage);

                        controller.filePath.value = file.path;
                        controller.fileBytes.value = editedImage;
                        controller.videoFilePath.value = "";
                        controller.musicName.value = "";
                      }
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/icons/filters.png"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void recordAudio(BuildContext context) async {
    await analytics.logEvent(name: "record_audio");

    final String? result = await showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const AudioRecorderDialog();
        });

    if (result != null) {
      File audioFile = File(result);
      final size = await audioFile.length();

      debugPrint('audio file length: ${await audioFile.length()}');

      if (size < 5000000) {
        final controller = Get.find<PostController>();

        // final output =
        //     await FfmpegHelper.combineAudioWithImage(result, context);

        final userController = Get.find<UserController>();

        final currentTimeMillisecond =
            DateTime.now().millisecondsSinceEpoch.toString();

        final userId = userController.userData.value.id!;

        var filePath =
            'Audio_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond${".mp3"}';

        final output = await S3Util.uploadFileToAws(File(result), filePath);

        debugPrint("output: $output");

        if (output != null) {
          final videoUrl = await getVideo(context, output);

          if (videoUrl != null) {
            controller.videoFilePath.value = videoUrl;
            controller.musicName.value = "Custom Audio";

            await analytics.logEvent(name: "image_audio_combined_successfully");
          }
        }
      } else {
        SnackBarUtil.showSnackBar('select_audio_file_less_than_5'.tr,
            context: context);
      }
    }
  }

  void selectAudioFromDevice(BuildContext context) async {
    await analytics.logEvent(name: "upload_audio_from_device");

    FilePickerResult? pickedAudio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3'],
    );

    if (pickedAudio != null) {
      final size = pickedAudio.files.first.size;

      if (size < 5000000) {
        final controller = Get.find<PostController>();

        final userController = Get.find<UserController>();

        final currentTimeMillisecond =
            DateTime.now().millisecondsSinceEpoch.toString();

        final userId = userController.userData.value.id!;

        var filePath =
            'Audio_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond${".mp3"}';

        final output = await S3Util.uploadFileToAws(
            File(pickedAudio.paths.first!), filePath);

        debugPrint("output: $output");

        if (output != null) {
          final videoUrl = await getVideo(context, output);

          if (videoUrl != null) {
            controller.videoFilePath.value = videoUrl;
            controller.musicName.value = pickedAudio.files.first.name;

            await analytics.logEvent(name: "image_audio_combined_successfully");
          }
        }
      } else {
        SnackBarUtil.showSnackBar('select_audio_file_less_than_5'.tr,
            context: context);
      }
    }
  }

  Future<String?> getVideo(BuildContext context, String audioUrl) async {
    FocusManager.instance.primaryFocus!.unfocus();

    ProgressDialog.showProgressDialogWithMessage(
        context, "Creating your video.\nPlease wait");

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        String? imageUrl;

        final controller = Get.find<PostController>();

        imageUrl = await _uploadFile(controller.filePath.value, ".png");

        Map payload = {
          "images": [imageUrl],
          "audio": audioUrl,
        };

        SuperResponse result = await PostRepo().getVideoFromUrl(payload);

        context.pop();

        debugPrint("result.fileUrl: ${result.fileUrl}");
        debugPrint("result.status: ${result.status}");

        if (result.status == true) {
          return result.fileUrl;
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
          return null;
        }
      } catch (error) {
        context.pop();
        SnackBarUtil.showSnackBar('something_went_wrong'.tr, context: context);
        debugPrint('error: $error');
      }
    } else {
      context.pop();
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
    return null;
  }

  Future<String>? _uploadFile(String path, String ext) async {
    final userController = Get.find<UserController>();

    final currentTimeMillisecond =
        DateTime.now().millisecondsSinceEpoch.toString();

    final userId = userController.userData.value.id!;

    var filePath =
        'Post_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond$ext';

    final downloadUrl = await S3Util.uploadFileToAws(File(path), filePath);

    debugPrint('downloadUrl: $downloadUrl');

    return downloadUrl!;
  }
}
