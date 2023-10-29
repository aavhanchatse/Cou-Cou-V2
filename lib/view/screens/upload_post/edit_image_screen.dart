import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/helpers/ffmpeg_helper.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/bottomsheets/local_audio_bottomsheet.dart';
import 'package:coucou_v2/view/screens/upload_post/upload_post_details_screen.dart';
import 'package:coucou_v2/view/widgets/edit_image_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class EditImageScreen extends StatelessWidget {
  static const routeName = '/edit-image';

  const EditImageScreen({super.key});

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
          icon: Icon(
            Icons.arrow_back,
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
          Positioned(
            bottom: 10.h,
            right: 3.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const ImageIcon(
                //     AssetImage("assets/icons/Infinity.png"),
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {
                //     // checkAndRequestPermissions();
                //     // showAudioBottomsheet(context);
                //     selectAudioFromDevice();
                //     // FfmpegHelper.combineAudioWithImage(
                //     //     imagePath, audioFilePath);
                //   },
                //   icon: const ImageIcon(
                //     AssetImage("assets/icons/music.png"),
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const ImageIcon(
                //     AssetImage("assets/icons/mic.png"),
                //   ),
                // ),
                IconButton(
                  onPressed: () async {
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

  // checkAndRequestPermissions({bool retry = false}) async {
  //   final OnAudioQuery audioQuery = OnAudioQuery();

  //   // The param 'retryRequest' is false, by default.
  //   bool hasPermission = await audioQuery.checkAndRequest(
  //     retryRequest: retry,
  //   );

  //   if (hasPermission == true) {
  //     List<SongModel> audios = await audioQuery.querySongs();
  //     debugPrint("list audios: $audios");
  //   }
  // }

  void selectAudioFromDevice() async {
    FilePickerResult? pickedAudio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3'],
    );

    if (pickedAudio != null) {
      final controller = Get.find<PostController>();

      final output = await FfmpegHelper.combineAudioWithImage(
          controller.filePath.value, pickedAudio.paths.first!);

      debugPrint("output: $output");

      if (output != null) {
        controller.videoFilePath.value = output;
        controller.musicName.value = pickedAudio.files.first.name;

        // final uint8list = await VideoThumbnail.thumbnailData(
        //   video: output,
        //   imageFormat: ImageFormat.PNG,
        //   maxWidth:
        //       720, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        //   quality: 80,
        // );
        // if (uint8list != null) {
        //   final thumbnailFile = await saveUint8ListToTempStorage(uint8list);
        //   debugPrint('thumbnailFile: $thumbnailFile');
        //   controller.videoFilePath.value = output;
        //   controller.videoThumbnailFilePath.value = thumbnailFile.path;
        // }
      }
    }
  }

  void showAudioBottomsheet(BuildContext context) async {
    final file = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0))),
        builder: (builder) {
          return const LocalAudioBottomsheet();
        });

    if (file != null) {
      debugPrint("file: $file");
      // final controller = Get.find<PostController>();

      // final output = await FfmpegHelper.combineAudioWithImage(
      //     controller.filePath.value, file);

      // debugPrint("output: $output");
    }
  }
}