import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

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
            _getImageFromCamera();
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

      context.push(EditImageScreen.routeName);
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

    recentAssets = recentAssets
        .where((element) => element.type == AssetType.image)
        .toList();

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
        if (bytes == null) return const CircularProgressIndicator();
        // If there's data, display it as an image
        return InkWell(
          onTap: () {
            _selectImage(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  void _selectImage(BuildContext context) async {
    asset.originFile;
    final File? image = await asset.originFile;
    final bytes = await image?.readAsBytes();

    if (image != null && bytes != null) {
      final controller = Get.find<PostController>();
      controller.filePath.value = image.path;
      controller.fileBytes.value = bytes;
      controller.videoFilePath.value = "";
      controller.musicName.value = "";

      await analytics.logEvent(name: "select_gallery_image");

      context.push(EditImageScreen.routeName);
    }
  }
}
