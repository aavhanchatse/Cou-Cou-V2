import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/bottomsheets/pick_image_or_video_bottomsheet.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SelectImageScreen2 extends StatefulWidget {
  static const routeName = '/selectImage2';

  const SelectImageScreen2({super.key});

  @override
  State<SelectImageScreen2> createState() => _SelectImageScreen2State();
}

class _SelectImageScreen2State extends State<SelectImageScreen2> {
  bool _loading = true;
  List<AssetEntity> assets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAssets();

    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'image_select_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 6.w),
        child: FloatingActionButton(
          onPressed: () async {
            // context.push(CameraScreen.routeName);
            // _getImageFromCamera();
            openImagePickerDialog();
          },
          backgroundColor: Constants.white,
          child: Icon(
            Icons.camera_alt,
            color: Constants.black,
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        centerTitle: true,
        title: InkWell(
          onTap: () {},
          child: Text(
            "Cou Cou!",
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: "Inika",
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
      ),
      body: _loading == true
          ? Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            )
          : assets.isEmpty
              ? const SizedBox()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3.w,
                    crossAxisSpacing: 3.w,
                  ),
                  itemCount: assets.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.w),
                  itemBuilder: (BuildContext context, int index) {
                    return AssetThumbnail(asset: assets[index]);

                    // return InkWell(
                    //   onTap: () {
                    //     _selectImage(index);
                    //   },
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(8),
                    //     child: FadeInImage(
                    //       fit: BoxFit.cover,
                    //       placeholder: MemoryImage(kTransparentImage),
                    //       image: ThumbnailProvider(
                    //         mediumId: _media![index].id,
                    //       ),
                    //       // image: PhotoProvider(
                    //       //   mediumId: _media![index].id,
                    //       // ),
                    //     ),
                    //   ),
                    // );
                  },
                ),
    );
  }

  void _getImageFromCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1500,
      maxWidth: 1500,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      final controller = Get.find<PostController>();
      controller.filePath.value = image.path;
      controller.fileBytes.value = bytes;
      controller.videoFilePath.value = "";
      controller.musicName.value = "";

      await analytics.logEvent(name: "upload_image_camera");

      context.push(EditImageScreen.routeName, extra: false);
    }
  }

  void _getVideoFromCamera() async {
    final XFile? image = await ImagePicker().pickVideo(
      source: ImageSource.camera,
    );

    if (image != null) {
      final controller = Get.find<PostController>();
      final userController = Get.find<UserController>();

      final currentTimeMillisecond =
          DateTime.now().millisecondsSinceEpoch.toString();

      final userId = userController.userData.value.id!;

      var filePath =
          'Video_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond${".mp4"}';

      ProgressDialog.showProgressDialog(context);

      final output = await S3Util.uploadFileToAws(File(image.path), filePath);

      if (output != null) {
        context.pop();

        final Uint8List? uint8list = await VideoThumbnail.thumbnailData(
          video: image.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );

        if (uint8list != null) {
          final File thumbnailFile =
              await ImageUtil.saveImageToTempStorage(uint8list);

          final thumbnailBytes = await thumbnailFile.readAsBytes();

          controller.filePath.value = thumbnailFile.path;
          controller.fileBytes.value = thumbnailBytes;
          controller.videoFilePath.value = output;
          controller.musicName.value = "";

          await analytics.logEvent(name: "select_gallery_video");

          context.push(EditImageScreen.routeName, extra: true);
        }
      }
    }
  }

  void openImagePickerDialog() async {
    final bool? filePath = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0))),
        builder: (builder) {
          return const PickImageOrVideoBottomsheet();
        });

    if (filePath == true) {
      // select video
      _getVideoFromCamera();
    } else if (filePath == false) {
      // select image
      _getImageFromCamera();
    }
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    debugPrint('albums: $albums');

    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    List<AssetEntity> recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // recentAssets = recentAssets
    //     .where((element) => element.type == AssetType.image)
    //     .toList();

    // Update the state and notify UI
    setState(() {
      assets = recentAssets;
      _loading = false;
    });
  }
}

class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;

  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // If there's data, display it as an image
        return InkWell(
          onTap: () {
            if (asset.type == AssetType.video) {
              _selectVideo(context);
            } else {
              _selectImage(context);
            }
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              if (asset.type == AssetType.video)
                Container(
                  color: Colors.white.withOpacity(0.5),
                  height: double.infinity,
                  width: double.infinity,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _selectImage(BuildContext context) async {
    final File? image = await asset.originFile;
    final bytes = await image?.readAsBytes();

    if (image != null && bytes != null) {
      final controller = Get.find<PostController>();
      controller.filePath.value = image.path;
      controller.fileBytes.value = bytes;
      controller.videoFilePath.value = "";
      controller.musicName.value = "";

      await analytics.logEvent(name: "select_gallery_image");

      context.push(EditImageScreen.routeName, extra: false);
    }
  }

  void _selectVideo(BuildContext context) async {
    final File? image = await asset.originFile;
    final bytes = await image?.readAsBytes();

    if (image != null && bytes != null) {
      final controller = Get.find<PostController>();
      final userController = Get.find<UserController>();

      final currentTimeMillisecond =
          DateTime.now().millisecondsSinceEpoch.toString();

      final userId = userController.userData.value.id!;

      var filePath =
          'Video_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond${".mp4"}';

      ProgressDialog.showProgressDialog(context);

      final output = await S3Util.uploadFileToAws(image, filePath);

      if (output != null) {
        context.pop();

        final Uint8List? uint8list = await VideoThumbnail.thumbnailData(
          video: image.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );

        if (uint8list != null) {
          final File thumbnailFile =
              await ImageUtil.saveImageToTempStorage(uint8list);

          final thumbnailBytes = await thumbnailFile.readAsBytes();

          controller.filePath.value = thumbnailFile.path;
          controller.fileBytes.value = thumbnailBytes;
          controller.videoFilePath.value = output;
          controller.musicName.value = "";

          await analytics.logEvent(name: "select_gallery_video");

          context.push(EditImageScreen.routeName, extra: true);
        }
      }
    }
  }
}
