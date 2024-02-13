import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_name_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/address_search.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/location_util.dart';
import 'package:coucou_v2/utils/place_service%20copy.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/post_uploaded_success_dialog.dart';
import 'package:coucou_v2/view/widgets/default_container_2.dart';
import 'package:coucou_v2/view/widgets/default_text_field.dart';
import 'package:coucou_v2/view/widgets/dismissible_page.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:coucou_v2/view/widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class UploadPostDetailsScreen extends StatefulWidget {
  static const routeName = '/uploadPostDetails';

  final PostData? postData;

  const UploadPostDetailsScreen({super.key, this.postData});

  @override
  State<UploadPostDetailsScreen> createState() =>
      _UploadPostDetailsScreenState();
}

class _UploadPostDetailsScreenState extends State<UploadPostDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  final controller = Get.find<PostController>();

  bool bannerLoading = true;

  String? imageUrl;
  String? caption;
  String? location;
  String? rlocation;
  List<ChallengeNameData> list = [];
  ChallengeNameData? selectedChallenge;
  bool? isVeg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getChallengeNames();
    setAnalytics();
  }

  void setAnalytics() async {
    if (widget.postData == null) {
      await analytics.setCurrentScreen(
          screenName: 'upload_post_details_screen');
    } else {
      await analytics.setCurrentScreen(
          screenName: 'update_post_details_screen');
    }
  }

  void setData() {
    imageUrl = widget.postData!.thumbnail;
    caption = widget.postData!.caption;
    location = widget.postData!.postLocation;
    rlocation = widget.postData!.recipeLocation;
    selectedChallenge = list
        .where((element) => element.id == widget.postData!.challengeId)
        .toList()
        .first;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap(context);
      },
      child: Scaffold(
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
        ),
        body: bannerLoading == true
            ? Center(
                child: CircularProgressIndicator(color: Constants.primaryColor),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: widget.postData != null
                                    ? Image.network(
                                        imageUrl!,
                                        fit: BoxFit.cover,
                                        height: 20.h,
                                        width: 20.h,
                                      )
                                    : InkWell(
                                        onTap: controller.isVideo.value == true
                                            ? null
                                            : () {
                                                List<String> imageList = [];

                                                for (var element in controller
                                                    .filesSelected) {
                                                  imageList
                                                      .add(element.filePath);
                                                }

                                                context.push(
                                                  DismissPage.routeName,
                                                  extra: {
                                                    "initialIndex": 0,
                                                    "imageList": imageList,
                                                    "isVideo": false,
                                                    "localList": true,
                                                  },
                                                );
                                              },
                                        child: Image.file(
                                          File(
                                            controller.thumbnailFilePath.value,
                                          ),
                                          // File(controller.filePath.value),
                                          fit: BoxFit.cover,
                                          height: 20.h,
                                          width: 20.h,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.w),
                        Text(
                          "location".tr,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        InkWell(
                          onTap: widget.postData != null
                              ? null
                              : () {
                                  addLocation(1);
                                },
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultContainer2(
                              child: Text(location ?? ""),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          "recipe_location".tr,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        InkWell(
                          onTap: widget.postData != null
                              ? null
                              : () {
                                  addLocation(2);
                                },
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultContainer2(
                              child: Text(rlocation ?? ""),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          "is_veg".tr,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: true,
                                groupValue: isVeg,
                                activeColor: Constants.primaryColor,
                                onChanged: (val) {
                                  isVeg = val;
                                  setState(() {});
                                },
                                title: Text("veg".tr),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                activeColor: Constants.primaryColor,
                                value: false,
                                groupValue: isVeg,
                                onChanged: (val) {
                                  isVeg = val;
                                  setState(() {});
                                },
                                title: Text("non_veg".tr),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          "${"choose_challenge".tr} *",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<ChallengeNameData>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: StyleUtil.primaryDropDownDecoration(
                              labelText: "",
                            ),
                            menuMaxHeight: 300.0,
                            dropdownColor: Constants.white,
                            borderRadius: BorderRadius.circular(16),
                            value: selectedChallenge,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: list
                                .map<DropdownMenuItem<ChallengeNameData>>(
                                    (ChallengeNameData value) {
                              return DropdownMenuItem<ChallengeNameData>(
                                value: value,
                                child: Text(value.challengeName ?? ""),
                              );
                            }).toList(),
                            validator: (ChallengeNameData? value) {
                              if (value == null) {
                                return "select_challenge".tr;
                              }
                              return null;
                            },
                            onChanged: (ChallengeNameData? newValue) {
                              selectedChallenge = newValue!;
                            },
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Row(
                          children: [
                            Text(
                              "caption".tr,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              " (*${"max_250_words".tr})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.w),
                        DefaultTextField(
                          enabled: widget.postData == null ? true : false,
                          initialValue: caption,
                          onChanged: (String value) {
                            caption = value.trim();
                            setState(() {});
                          },
                          hintText: "",
                          maxLines: 3,
                        ),
                        SizedBox(height: 12.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryButton(
                                title: "submit".tr,
                                onTap: () {
                                  uploadPost();
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void addLocation(int value) async {
    final sessionToken = const Uuid().v4();

    final Suggestion? result = await showSearch(
      context: context,
      delegate: AddressSearch(sessionToken),
    );

    if (result != null) {
      final placeDetails = await PlaceApiProvider(sessionToken)
          .getPlaceDetailFromId(result.placeId);
      // consoleLog(tag: "placeDetails :: ", message: jsonEncode(placeDetails));

      if (value == 1) {
        location = placeDetails!.city!;
      } else {
        rlocation = placeDetails!.city!;
      }

      setState(() {});
    }
  }

  void successDialog(BuildContext context) async {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PostUploadedSuccessDialog(
            update: widget.postData == null ? false : true,
          );
        });
  }

  void getChallengeNames() async {
    bannerLoading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getAllChallengeNames();

        if (result.status == true && result.data != null) {
          list = result.data!;

          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        if (widget.postData != null) {
          setData();
        }

        bannerLoading = false;
        setState(() {});
      } catch (error) {
        debugPrint('error: $error');

        bannerLoading = false;
        setState(() {});
      }
    } else {
      bannerLoading = false;
      setState(() {});
    }
  }

  Future<String?>? _uploadFile(String path, String ext) async {
    debugPrint("path: $path");
    debugPrint("ext: $ext");

    final tempFilePath = await getTempImageFilePath(ext);

    final File? compressedImage = await controller.testCompressAndGetFile(
      File(path),
      tempFilePath,
    );

    if (compressedImage != null) {
      final currentTimeMillisecond =
          DateTime.now().millisecondsSinceEpoch.toString();

      final userId = userController.userData.value.id!;

      var filePath =
          'Post_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond$ext';

      final downloadUrl =
          await S3Util.uploadFileToAws(File(compressedImage.path), filePath);

      debugPrint('downloadUrl: $downloadUrl');

      return downloadUrl!;
    }
    return null;
  }

  // Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 80,
  //   );

  //   if (result != null) {
  //     // print(file.lengthSync());
  //     // print(result.lengthSync());

  //     return result;
  //   }
  //   return null;
  // }

  Future<String?> _getLocation() async {
    final Position? location = await LocationUtils.getCurrentLocation();

    if (location != null) {
      final Placemark? placemark =
          await LocationUtils.getLocationFromCoordinates(location);

      if (placemark != null) {
        final city = placemark.locality;
        return city;
      }
    }
    return null;
  }

  void uploadPost() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final city = await _getLocation();

        Map payload = {
          "challengeId": selectedChallenge!.id,
          "challengeVideo": null,
          "caption": caption,
          "postLocation": location ?? city,
          "recipeLocation": rlocation,
          "voice_URL": controller.musicName.value,
        };

        if (widget.postData == null) {
          if (controller.isVideo.value == true) {
            payload['isVideo'] = true;
            payload['videoUrl'] = controller.videoFilePath.value;
          } else {
            final list = await _getImageUrlList();
            payload['imagesMultiple'] = list;
          }

          final String? thumbnail = await controller.getImageThumbnailUrl();

          payload['thumbnail'] = thumbnail ?? "";
          payload['isVeg'] = isVeg;
        } else {
          payload['isVideo'] = widget.postData!.isVideo;
          payload['videoUrl'] = widget.postData!.videoUrl;
          payload['imagesMultiple'] = widget.postData!.imagesMultiple;
          payload['thumbnail'] = widget.postData!.thumbnail;
          payload['isVeg'] = widget.postData!.isVeg;
        }

        // String challengeVideo = '';

        // Map payload = {
        //   "challengeId": selectedChallenge!.id,
        //   "challengeVideo": null,

        //   "videoUrl": videoUrl,
        //   "isVideo": controller.isVideo.value,

        //   // "challengeVideo": challengeVideo,
        //   "caption": caption,
        //   "postLocation": location ?? city,
        //   "recipeLocation": rlocation,
        //   "voice_URL": controller.musicName.value,
        //   "thumbnail": widget.postData != null
        //       ? widget.postData!.thumbnail
        //       : imageUrl ?? "",
        //   "imagesMultiple": [
        //     "https://images.unsplash.com/photo-1707246519904-82761aaa1efa?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        //     "https://images.unsplash.com/photo-1707045130985-35f4f74235c0?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        //   ],
        // };

        SuperResponse result;

        if (widget.postData != null) {
          payload["id"] = widget.postData!.id;
          result = await PostRepo().updatePost(payload);
        } else {
          result = await PostRepo().uploadPost(payload);
        }

        // context.pop();

        if (result.status == true) {
          if (widget.postData == null) {
            await analytics.logEvent(name: "post_uploaded_successfully");
          } else {
            await analytics.logEvent(name: "post_updated_successfully");
          }

          // context.go(NavBar.routeName);
          final homescreenController = Get.find<HomescreenController>();

          homescreenController.getHomeScreenBanners();
          homescreenController.getHomeScreenLatestPost();
          homescreenController.getHomeScreenMainPostList();

          successDialog(context);
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
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
  }

  Future<List<String>> _getImageUrlList() async {
    List<String> urlList = [];

    for (var element in controller.filesSelected) {
      String ext;

      if (element.filePath.endsWith('.jpg') ||
          element.filePath.endsWith('.jpeg')) {
        ext = ".jpg";
      } else {
        ext = ".png";
      }

      final url = await _uploadFile(element.filePath, ext);

      if (url != null) {
        urlList.add(url);
      }
    }
    debugPrint("urlList: $urlList");

    return urlList;
  }

  String _getVideoUrl() {
    return controller.videoFilePath.value;
  }
}
