import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/upload_post/upload_post_details_screen.dart';
import 'package:coucou_v2/view/widgets/edit_image_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EditImageScreen extends StatefulWidget {
  static const routeName = '/edit-image';

  final bool isVideo;

  const EditImageScreen({super.key, required this.isVideo});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  final controller = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        leading: IconButton(
          onPressed: () {
            controller.unselectImages();
            controller.unselectMusic();
            controller.unselectVideo();

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
      body: Obx(
        () => Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Constants.white,
              child: Center(
                  child: controller.isVideo.value == true
                      ? const EditImageVideoPlayer()
                      : _imageCarousal()),
            ),
            if (controller.isVideo.value != true) _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _imageCarousal() {
    return Obx(
      () => SizedBox.expand(
        child: CarouselSlider.builder(
          itemCount: controller.filesSelected.length,
          itemBuilder: (_, index, __) {
            return Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: InteractiveViewer(
                  panEnabled: false,
                  // Set it to false
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 2,
                  child: Image.file(
                    File(controller.filesSelected[index].filePath),
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: widget.imageList![index],
                  //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                  //       Center(
                  //     child: CircularProgressIndicator(
                  //       value: downloadProgress.progress,
                  //       color: Constants.primaryColor,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            viewportFraction: 1.0,
            disableCenter: true,
            initialPage: 0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              controller.editScreenCurrentIndex.value = index;
            },
          ),
        ),
      ),
    );
  }

  Widget _buttons() {
    return Positioned(
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

          _pickAudioButton(),
          _recordAudioButton(),
          _cropImageButton(),
          _filterButton(),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return IconButton(
      onPressed: () async {
        await controller.filterFunction(context);
        setState(() {});
      },
      icon: const ImageIcon(
        AssetImage("assets/icons/filters.png"),
      ),
    );
  }

  Widget _cropImageButton() {
    return IconButton(
      onPressed: () async {
        await controller.cropImageFunction(context);
        setState(() {});
      },
      icon: const ImageIcon(
        AssetImage("assets/icons/crop.png"),
      ),
    );
  }

  Widget _recordAudioButton() {
    return IconButton(
      onPressed: () {
        controller.recordAudio(context);
      },
      icon: const ImageIcon(
        AssetImage("assets/icons/mic.png"),
      ),
    );
  }

  Widget _pickAudioButton() {
    return IconButton(
      onPressed: () {
        controller.selectAudioFromDevice(context);
      },
      icon: const ImageIcon(
        AssetImage("assets/icons/music.png"),
      ),
    );
  }
}
