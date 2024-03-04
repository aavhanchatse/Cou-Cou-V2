import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/bottomsheets/pick_image_or_video_bottomsheet.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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

  final PostController postController = Get.find<PostController>();

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
              fontFamily: "Inika",
              fontSize: 24,
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
        actions: [
          IconButton(
            onPressed: () {
              if (postController.filesSelected.isNotEmpty) {
                postController.setThumbnailOfFirstImage();

                context.push(EditImageScreen.routeName, extra: false);
              } else {
                SnackBarUtil.showSnackBar(
                  "select_one_picture".tr,
                  context: context,
                );
              }
            },
            icon: Icon(
              Icons.check,
              color: Constants.black,
            ),
          ),
        ],
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
                  itemCount: assets.length + 1,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.w),
                  itemBuilder: (BuildContext context, int index) {
                    // return AssetEntityImage(
                    //   assets[index],
                    //   isOriginal: false, // Defaults to `true`.
                    //   thumbnailSize:
                    //       const ThumbnailSize.square(200), // Preferred value.
                    //   thumbnailFormat:
                    //       ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                    // );

                    if (index == 0) {
                      return InkWell(
                        onTap: () {
                          context.push(VideoListScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Constants.primaryColor,
                          ),
                          child: Icon(
                            Icons.video_camera_back_rounded,
                            color: Constants.black,
                            size: 40,
                          ),
                        ),
                      );
                    }

                    return AssetThumbnail(asset: assets[index - 1]);

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
      postController.getVideoFromCamera(context);
    } else if (filePath == false) {
      // select image
      postController.getImageFromCamera(context);
    }
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      hasAll: true,
      type: RequestType.all,
    );
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

class AssetThumbnail extends StatefulWidget {
  final AssetEntity asset;

  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  late File assetFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFile();
  }

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    // We're using a FutureBuilder since thumbData is a future

    return FutureBuilder<Uint8List?>(
      future: widget.asset.thumbnailData,
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
            if (widget.asset.type == AssetType.video) {
              postController.selectVideo1(context, widget.asset);
            } else {
              postController.selectImage(context, widget.asset);
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
              if (widget.asset.type == AssetType.video)
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
              Obx(
                () {
                  return (widget.asset.type != AssetType.video &&
                          postController.filesSelected.any(
                              (element) => element.filePath == assetFile.path))
                      ? Container(
                          color: Colors.white.withOpacity(0.5),
                          height: double.infinity,
                          width: double.infinity,
                          child: const Center(
                            child: Icon(
                              Icons.check,
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> getFile() async {
    final file = await widget.asset.originFile;
    if (file != null) {
      assetFile = file;
      setState(() {});
    }
  }
}
