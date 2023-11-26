import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PickImageOrVideoBottomsheet extends StatelessWidget {
  const PickImageOrVideoBottomsheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_source'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "select_img_or_vid".tr,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          getImagePickerOptionList(context),
        ],
      ),
    );
  }

  Widget getImagePickerOptionList(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              context.pop(false);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/icons/common_icons/camera.png",
                //   width: 50,
                //   height: 50,
                // ),
                const Icon(Icons.image, size: 34),
                Text(
                  'image'.tr,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              context.pop(true);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/icons/common_icons/gallery.png",
                //   width: 50,
                //   height: 50,
                // ),
                const Icon(Icons.video_camera_back, size: 34),

                Text(
                  'video'.tr,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // void pickImage(bool video, {required BuildContext context}) async {
  //   XFile? result;

  //   if (video == true) {
  //     result = await ImagePicker().pickVideo(
  //       source: ImageSource.camera,
  //     );
  //   } else {
  //     result = await ImagePicker().pickImage(
  //       source: ImageSource.camera,
  //       maxHeight: 1500,
  //       maxWidth: 1500,
  //     );
  //   }
  //   if (result != null) {
  //     // Get.back(result: result);
  //     context.pop(result);
  //   } else {
  //     // Get.back();
  //     context.pop();
  //   }
  // }
}
