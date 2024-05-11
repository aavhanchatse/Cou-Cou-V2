import 'dart:io';
import 'dart:typed_data';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/user_profile_data.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/bottomsheets/select_image_source_bottomsheet.dart';
import 'package:coucou_v2/view/dialogs/language_dialog.dart';
import 'package:coucou_v2/view/dialogs/logout_dialog.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/profile/profile_page_view.dart';
import 'package:coucou_v2/view/screens/profile/update_profile_screen.dart';
import 'package:coucou_v2/view/screens/update_address/update_address_screen.dart';
import 'package:coucou_v2/view/widgets/dismissible_page.dart';
import 'package:coucou_v2/view/widgets/image_cropper_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/userProfile';

  final String? userId;

  const UserProfileScreen({super.key, this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserProfile? userProfile;
  bool loading = true;
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    getProfile();
    setAnalytics();
    _disableScreenshot();
  }

  void _disableScreenshot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void setAnalytics() async {
    if (widget.userId == null) {
      await analytics.setCurrentScreen(screenName: 'self_profile_screen');
    } else {
      await analytics.setCurrentScreen(screenName: 'other_profile_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: (widget.userId == null)
          ? SafeArea(
              child: Drawer(
                width: 50.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cou Cou!',
                          style: TextStyle(
                            color: Constants.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: "Inika",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // InkWell(
                          //   child: Text(
                          //     'reset_password'.tr,
                          //     style: TextStyle(
                          //       color: Constants.black,
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          //   onTap: () {
                          //     context.push(UpdatePasswordScreen.routeName);
                          //   },
                          // ),
                          // SizedBox(height: 2.w),
                          InkWell(
                            child: Text(
                              'update_address'.tr,
                              style: TextStyle(
                                color: Constants.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              if (userController.userData.value.username !=
                                      null &&
                                  userController
                                      .userData.value.username!.isNotEmpty) {
                                context.push(UpdateAddressScreen.routeName);
                              } else {
                                final result = await context
                                    .push(CompleteDetailsScreen.routeName);
                                if (result == true) {
                                  getProfile();
                                }
                              }
                            },
                          ),
                          SizedBox(height: 2.w),
                          InkWell(
                            child: Text(
                              'policy_tc'.tr,
                              style: TextStyle(
                                color: Constants.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              await analytics.logEvent(name: "privacy_policy");
                            },
                          ),
                          SizedBox(height: 2.w),
                          InkWell(
                            child: Text(
                              'language'.tr,
                              style: TextStyle(
                                color: Constants.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const LanguageDialog();
                                  });
                            },
                          ),
                          SizedBox(height: 2.w),
                          InkWell(
                            child: Text(
                              'support'.tr,
                              style: TextStyle(
                                color: Constants.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              await analytics.logEvent(name: "support");
                            },
                          ),
                          SizedBox(height: 2.w),
                          InkWell(
                            child: Text(
                              'logout'.tr,
                              style: TextStyle(
                                color: Constants.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              await analytics.logEvent(name: "logout");

                              LogoutDialog.showLogoutDialog(context);
                            },
                          ),
                          SizedBox(height: 52.h),
                          _getVersionNumber(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            final navbarController = Get.find<NavbarController>();
            navbarController.currentIndex.value = 1;
            context.go(NavBar.routeName);
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
        backgroundColor: Constants.white,
        iconTheme: IconThemeData(color: Constants.black),
        title: InkWell(
          onTap: () {
            final navbarController = Get.find<NavbarController>();
            navbarController.currentIndex.value = 1;
            context.go(NavBar.routeName);
          },
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
        actions: (widget.userId == null)
            ? [
                IconButton(
                  onPressed: () async {
                    await analytics.logEvent(name: "open_drawer");

                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: ImageIcon(
                    const AssetImage("assets/icons/drawer_icon.png"),
                    color: Constants.black,
                  ),
                ),
              ]
            : null,
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Constants.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    _userImage(),
                    SizedBox(height: 2.w),
                    Text(
                      "@${userProfile?.username}",
                      style: TextStyle(
                        color: Constants.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.w),
                    Row(
                      children: [
                        Text(
                          "${"posts".tr} (${userProfile?.postCount})",
                          style: TextStyle(
                            color: Constants.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.w),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 3.w,
                        crossAxisSpacing: 3.w,
                      ),
                      itemCount: userProfile?.userPost?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item = userProfile?.userPost?[index];

                        return InkWell(
                          onTap: () async {
                            await analytics.logEvent(name: "view_profile_post");

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePageView(
                                  postList: userProfile?.userPost ?? [],
                                  initialIndex: index,
                                ),
                              ),
                            );

                            if (result == true) {
                              getProfile();
                            }
                            // await PostRepo().getPostData(item!.id!).then(
                            //       (value) => context.push(
                            //         UploadPostDetailsScreen.routeName,
                            //         extra: value.data,
                            //       ),
                            //     );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ImageUtil.networkImage(
                              imageUrl: item?.thumbnail ?? "",
                            ),
                            // child: Image.network(
                            //   item?.thumbnail ?? "",
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _userImage() {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              await analytics.logEvent(name: "view_profile_image");

              context.push(
                DismissPage.routeName,
                extra: {
                  "initialIndex": 0,
                  "imageList": [userProfile?.imageUrl],
                  "isVideo": false,
                  "disableScreenshot": true,
                },
              );
            },
            child: DefaultPicProvider.getCircularUserProfilePic(
              profilePic: userProfile?.imageUrl,
              userName:
                  "${userProfile?.firstname ?? "N"} ${userProfile?.lastname ?? "N"}",
              size: 100,
            ),
          ),
          if (userProfile?.id == userController.userData.value.id)
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  if (userController.userData.value.username != null &&
                      userController.userData.value.username!.isNotEmpty) {
                    await analytics.logEvent(
                      name: "login_click_event",
                      parameters: {
                        "login_clicks": "Edit Profile tapped",
                        "username":
                            userController.userData.value.username ?? "",
                        "mobile_num": userController.userData.value.number ??
                            "not logged in user",
                        "gender": userController.userData.value.gender ??
                            "not logged in user",
                        "dob": userController.userData.value.dob.toString(),
                        // "login_values": "Failure",
                        // "content_details": item.challengeData?.challengeName,
                        // "content_posted_by": item.userSingleData!.id!,
                        // "content_posted_date": item.createdAt,
                        // "username": item.userSingleData!.username,
                        // "mobile_num": item.userSingleData!.number,
                        // "gender": item.userSingleData!.gender,
                        // "dob": item.userSingleData!.dob,
                      },
                    );
                    await context.push(UpdateProfileScreen.routeName);
                    getProfile();
                  } else {
                    final result =
                        await context.push(CompleteDetailsScreen.routeName);
                    if (result == true) {
                      getProfile();
                    }
                  }
                  // openImagePickerDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Constants.black,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.edit,
                      size: 2.t,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void openImagePickerDialog() async {
    await analytics.logEvent(name: "edit_profile_image");

    final XFile? filePath = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0))),
        builder: (builder) {
          return const SelectImageSourceBottomsheet();
        });

    if (filePath != null) {
      final Uint8List bytes = await filePath.readAsBytes();
      final croppedImage =
          await context.push(CropImagePage.routeName, extra: bytes);
      // final croppedImage = await Get.to(() => CropImagePage(imageBytes: bytes));

      if (croppedImage != null) {
        final File finalImage =
            await ImageUtil.saveImageToTempStorage(croppedImage as Uint8List);

        // save image on aws
        updateUserProfile(finalImage);
      }
    }
  }

  Widget _getVersionNumber() => FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snap) {
          if (snap.hasData) {
            return Text(
              '${"app_version".tr} ${snap.data!.version}',
              style: TextStyle(
                color: Constants.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            );
          }
          return Container();
        },
      );

  Future<String>? _uploadFile(File file) async {
    final currentTimeMillisecond =
        DateTime.now().millisecondsSinceEpoch.toString();

    final userId = userController.userData.value.id!;

    var filePath =
        'Profile_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond';

    final downloadUrl = await S3Util.uploadFileToAws(file, filePath);

    debugPrint('downloadUrl: $downloadUrl');

    return downloadUrl!;
  }

  void updateUserProfile(File file) async {
    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final String? imageUrl = await _uploadFile(file);

        String id = userController.userData.value.id!;

        Map payload = {
          "id": id,
          "imageUrl": imageUrl ?? "",
        };

        final result = await UserRepo().updateUserProfile(payload);

        if (result.status == true) {
          await analytics.logEvent(name: "profile_image_update_success");

          userProfile!.imageUrl = imageUrl;
          userController.getUserDataById();
          setState(() {});
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
        loading = false;
        setState(() {});
      } catch (error) {
        loading = false;
        setState(() {});
        SnackBarUtil.showSnackBar('something_went_wrong'.tr, context: context);
        debugPrint('error: $error');
      }
    } else {
      loading = false;
      setState(() {});
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }

  void getProfile() async {
    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        String id;

        if (widget.userId != null) {
          id = widget.userId!;
        } else {
          id = userController.userData.value.id!;
        }

        final result = await UserRepo().getUserProfile(id);

        if (result.status == true) {
          userProfile = result.data;
          setState(() {});
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
        loading = false;
        setState(() {});
      } catch (error) {
        loading = false;
        setState(() {});
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      loading = false;
      setState(() {});
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }
}
