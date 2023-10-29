import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectImageScreen extends StatefulWidget {
  static const routeName = '/selectImage';

  const SelectImageScreen({super.key});

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  List<Album>? _albums;
  List<Medium>? _media;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
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
          icon: Icon(
            Icons.arrow_back,
            color: Constants.black,
          ),
        ),
      ),
      body: _loading == true
          ? Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            )
          : _media == null
              ? const SizedBox()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3.w,
                    crossAxisSpacing: 3.w,
                  ),
                  itemCount: _media!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.w),
                  itemBuilder: (BuildContext context, int index) {
                    // _setUserTemplateValues(index);
                    return InkWell(
                      onTap: () {
                        _selectImage(index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: PhotoProvider(mediumId: _media![index].id),
                        ),
                      ),
                    );
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

      context.push(EditImageScreen.routeName);
    }
  }

  void _selectImage(int index) async {
    final File image = await _media![index].getFile();
    final bytes = await image.readAsBytes();

    final controller = Get.find<PostController>();
    controller.filePath.value = image.path;
    controller.fileBytes.value = bytes;
    controller.videoFilePath.value = "";
    controller.musicName.value = "";

    context.push(EditImageScreen.routeName);
  }

  Future<void> getImages() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);

      _albums = albums;
      _loading = false;

      MediaPage mediaPage = await _albums!.first.listMedia();
      _media = mediaPage.items;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }
}
