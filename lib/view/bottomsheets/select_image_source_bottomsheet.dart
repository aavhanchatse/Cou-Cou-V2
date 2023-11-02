import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageSourceBottomsheet extends StatelessWidget {
  final bool? video;

  const SelectImageSourceBottomsheet({Key? key, this.video = false})
      : super(key: key);

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
            'select_img'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "select_img_where_you_want_to_pickup".tr,
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
              pickImage(ImageSource.camera, context: context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/common_icons/camera.png",
                  width: 50,
                  height: 50,
                ),
                Text(
                  'camera'.tr,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              pickImage(ImageSource.gallery, context: context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/common_icons/gallery.png",
                  width: 50,
                  height: 50,
                ),
                Text(
                  'gallery'.tr,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void pickImage(ImageSource source, {required BuildContext context}) async {
    XFile? result;

    if (video == true) {
      result = await ImagePicker().pickVideo(
        source: source,
      );
    } else {
      result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 1500,
        maxWidth: 1500,
      );
    }
    if (result != null) {
      // Get.back(result: result);
      context.pop(result);
    } else {
      // Get.back();
      context.pop();
    }
  }
}
