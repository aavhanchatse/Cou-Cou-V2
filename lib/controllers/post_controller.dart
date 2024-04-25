import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/mediaModel.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/view/dialogs/audio_recorder_dialog.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostController extends GetxController {
  // var filePath = "".obs;
  // var fileBytes = [].obs;

  var filesSelected = <MediaModel>[].obs;

  var isVideo = false.obs;

  var videoFilePath = "".obs;
  // var videoThumbnailFilePath = "".obs;

  var thumbnailFilePath = "".obs;

  var musicName = "".obs;

  var audioUrl = "".obs;

  var editScreenCurrentIndex = 0.obs;

  void unselectVideo() {
    isVideo.value = false;
    videoFilePath.value = "";
  }

  void unselectMusic() {
    musicName.value = "";
    audioUrl.value = "";
  }

  void unselectImages() {
    filesSelected.clear();
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath,
      [int? quality]) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality ?? 60,
      format: CompressFormat.webp,
    );

    if (result != null) {
      return result;
    }
    return null;
  }

  void setThumbnailOfFirstImage() {
    setImageThumbnail(filesSelected.first.filePath);
  }

  void setImageThumbnail(String filePath) {
    thumbnailFilePath.value = filePath;
  }

  Future<String?> getImageThumbnailUrl() async {
    String ext = ".webp";

    // if (thumbnailFilePath.value.endsWith('.jpg') ||
    //     thumbnailFilePath.value.endsWith('.jpeg')) {
    //   ext = ".jpg";
    // } else {
    //   ext = ".png";
    // }

    final targetPath = await getTempImageFilePath(ext);

    final compressedImage = await testCompressAndGetFile(
      File(thumbnailFilePath.value),
      targetPath,
      50,
    );

    if (compressedImage != null) {
      debugPrint("compressedImage: $compressedImage");

      final String downloadUrl = await uploadToAws(compressedImage.path, ext);

      debugPrint("thumbnail url: $downloadUrl");

      return downloadUrl;
    }
    return null;
  }

  Future<String?>? uploadFile(String path, String ext) async {
    debugPrint("path: $path");
    debugPrint("ext: $ext");

    final tempFilePath = await getTempImageFilePath(ext);

    final File? compressedImage = await testCompressAndGetFile(
      File(path),
      tempFilePath,
    );

    if (compressedImage != null) {
      final String downloadUrl = await uploadToAws(compressedImage.path, ext);

      return downloadUrl;
    }
    return null;
  }

  Future<String> uploadToAws(String path, String ext) async {
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

  Future<void> getImageFromCamera(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1500,
      maxWidth: 1500,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      MediaModel media = MediaModel(filePath: image.path, fileBytes: bytes);
      unselectVideo();
      unselectMusic();

      filesSelected.clear();
      filesSelected.add(media);
      setImageThumbnail(image.path);

      await analytics.logEvent(name: "upload_image_camera");

      context.push(EditImageScreen.routeName, extra: false);
    }
  }

  Future<void> getVideoFromCamera(BuildContext context) async {
    final XFile? image = await ImagePicker().pickVideo(
      source: ImageSource.camera,
    );

    if (image != null) {
      var fileSize = await image.length();
      if (fileSize > 30000000) {
        showSnackBar("Kindly upload Video less than 50 Mb");
        return;
      }

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

          // final thumbnailBytes = await thumbnailFile.readAsBytes();

          videoFilePath.value = output;
          isVideo.value = true;
          setImageThumbnail(thumbnailFile.path);
          unselectImages();
          unselectMusic();

          await analytics.logEvent(name: "select_gallery_video");

          context.push(EditImageScreen.routeName, extra: true);
        }
      }
    }
  }

  Future<void> selectImage(BuildContext context, AssetEntity asset) async {
    debugPrint("inside selectImage");

    final File? image = await asset.originFile;
    final bytes = await image?.readAsBytes();

    if (image != null && bytes != null) {
      if (filesSelected.any((element) => element.filePath == image.path)) {
        debugPrint("unselect image");

        filesSelected.removeWhere((element) => element.filePath == image.path);

        debugPrint("image list : ${filesSelected.length}");
      } else {
        debugPrint("select image");

        MediaModel media = MediaModel(filePath: image.path, fileBytes: bytes);
        filesSelected.add(media);
        unselectMusic();
        unselectVideo();

        debugPrint("image list : ${filesSelected.length}");
      }

      // final controller = Get.find<PostController>();
      // controller.filePath.value = image.path;
      // controller.fileBytes.value = bytes;
      // controller.videoFilePath.value = "";
      // controller.musicName.value = "";

      await analytics.logEvent(name: "select_gallery_image");

      // context.push(EditImageScreen.routeName, extra: false);
    }
  }

  Future<void> selectVideo1(BuildContext context, AssetEntity asset) async {
    final File? image = await asset.originFile;
    final bytes = await image?.readAsBytes();

    if (image != null && bytes != null) {
      var fileSize = await image.length();
      if (fileSize > 30000000) {
        showSnackBar("Kindly upload Video less than 50 Mb");
        return;
      }

      await selectVideo2(context, image);
    }
  }

  Future<void> selectVideo2(BuildContext context, File image,
      [String? thumbnailPath]) async {
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

      if (thumbnailPath == null) {
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

          videoFilePath.value = output;
          isVideo.value = true;
          setImageThumbnail(thumbnailFile.path);
          unselectImages();
          unselectMusic();

          await analytics.logEvent(name: "select_gallery_video");

          context.push(EditImageScreen.routeName, extra: true);
        }
      } else {
        File thFile = File(thumbnailPath);

        final uint8list = await thFile.readAsBytes();

        final File thumbnailFile =
            await ImageUtil.saveImageToTempStorage(uint8list);

        videoFilePath.value = output;
        isVideo.value = true;
        setImageThumbnail(thumbnailFile.path);
        unselectImages();
        unselectMusic();

        await analytics.logEvent(name: "select_gallery_video");

        context.push(EditImageScreen.routeName, extra: true);
      }
    }
  }

  Future<void> filterFunction(BuildContext context) async {
    await analytics.logEvent(name: "image_filter_icon");

    final Uint8List? editedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: filesSelected[editScreenCurrentIndex.value].fileBytes,
          cropOption: null,
        ),
      ),
    );

    if (editedImage != null) {
      final File file = await ImageUtil.saveImageToTempStorage(editedImage);

      filesSelected[editScreenCurrentIndex.value].filePath = file.path;
      filesSelected[editScreenCurrentIndex.value].fileBytes = editedImage;
      setThumbnailOfFirstImage();
      unselectVideo();
      unselectMusic();
    }
  }

  Future<void> cropImageFunction(BuildContext context) async {
    await analytics.logEvent(name: "image_cropper_icon");

    final Uint8List? editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropper(
          image: filesSelected[editScreenCurrentIndex.value].fileBytes
              as Uint8List,
        ),
      ),
    );

    if (editedImage != null) {
      final File file = await ImageUtil.saveImageToTempStorage(editedImage);

      filesSelected[editScreenCurrentIndex.value].filePath = file.path;
      filesSelected[editScreenCurrentIndex.value].fileBytes = editedImage;
      setThumbnailOfFirstImage();
      unselectVideo();
      unselectMusic();
    }
  }

  Future<String?> getVideoFromImage(
      String audioUrl, BuildContext context) async {
    FocusManager.instance.primaryFocus!.unfocus();

    ProgressDialog.showProgressDialogWithMessage(
        context, "Creating your video.\nPlease wait");

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        String? imageUrl;

        imageUrl = await uploadToAws(
            filesSelected[editScreenCurrentIndex.value].filePath, ".png");

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

  Future<void> recordAudio(BuildContext context) async {
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
          final videoUrl = await getVideoFromImage(output, context);

          if (videoUrl != null) {
            isVideo.value = true;
            videoFilePath.value = videoUrl;
            musicName.value = "Custom Audio";
            unselectImages();

            await analytics.logEvent(name: "image_audio_combined_successfully");
          }
        }
      } else {
        SnackBarUtil.showSnackBar('select_audio_file_less_than_5'.tr,
            context: context);
      }
    }
  }

  Future<void> selectAudioFromDevice(BuildContext context) async {
    await analytics.logEvent(name: "upload_audio_from_device");

    FilePickerResult? pickedAudio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3'],
    );

    if (pickedAudio != null) {
      final size = pickedAudio.files.first.size;

      if (size < 5000000) {
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
          final videoUrl = await getVideoFromImage(output, context);

          if (videoUrl != null) {
            isVideo.value = true;
            videoFilePath.value = videoUrl;
            musicName.value = pickedAudio.files.first.name;
            unselectImages();

            await analytics.logEvent(name: "image_audio_combined_successfully");
          }
        }
      } else {
        SnackBarUtil.showSnackBar(
          'select_audio_file_less_than_5'.tr,
          context: context,
        );
      }
    }
  }

  Future<List<String>> getImageUrlList() async {
    List<String> urlList = [];

    for (var element in filesSelected) {
      String ext = ".webp";

      // if (element.filePath.endsWith('.jpg') ||
      //     element.filePath.endsWith('.jpeg')) {
      //   ext = ".jpg";
      // } else {
      //   ext = ".png";
      // }

      final url = await uploadFile(element.filePath, ext);

      if (url != null) {
        urlList.add(url);
      }
    }
    debugPrint("urlList: $urlList");

    return urlList;
  }

  Future<File?> compressVideo(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );

    if (mediaInfo != null) {
      return mediaInfo.file;
    }

    return null;
  }
}
