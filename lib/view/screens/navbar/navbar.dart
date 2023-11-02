import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/rating_dialog.dart';
import 'package:coucou_v2/view/screens/activity/my_activity_widget.dart';
import 'package:coucou_v2/view/screens/home/home_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/select_image_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';

class NavBar extends StatefulWidget {
  static const routeName = '/';

  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  final navbarController = Get.find<NavbarController>();
  final userController = Get.find<UserController>();

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() {
    debugPrint('inside will pop');
    DateTime now = DateTime.now();
    navbarController.currentIndex.value = 1;

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();

    getUser();
    // _checkNotification();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ratingDialog();
    });

    // checkForInAppUpdate();
  }

  Future<void> checkForInAppUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate().catchError((e) => debugPrint(e));
      } else if (info.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate().catchError((e) => debugPrint(e));
      }
    }).catchError((e) => {debugPrint(e)});
  }

  void getUser() async {
    userController.getUserDataById();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final postController = Get.find<PostController>();
    //   postController.init();

    //   userController.getUserAddress(false);
    //   userController.getFollowingList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: WillPopScope(
          onWillPop: () {
            if (navbarController.currentIndex == 1) {
              return _onWillPop();
            } else {
              navbarController.currentIndex.value = 1;
              return Future.value(false);
            }
          },
          child: Stack(
            children: [
              navbarController.currentIndex.value == 0
                  ? const UserProfileScreen()
                  : navbarController.currentIndex.value == 1
                      ? const HomeScreen()
                      : const MyActivityWidget(isFromNavBar: true),
              Positioned(
                bottom: 4.w,
                left: 25.w,
                right: 25.w,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: Constants.white,
                        boxShadow: StyleUtil.cardShadow(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              await analytics.logEvent(
                                  name: "self_profile_tab");

                              navbarController.currentIndex.value = 0;
                              setState(() {});
                            },
                            child: Container(
                              decoration: navbarController.currentIndex.value ==
                                      0
                                  ? BoxDecoration(
                                      color: Constants.primaryGrey2,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: StyleUtil.uploadButtonShadow(),
                                    )
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.w),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: DefaultPicProvider
                                    .getCircularUserProfilePic(
                                  profilePic:
                                      userController.userData.value.imageUrl,
                                  userName:
                                      "${userController.userData.value.firstname} ${userController.userData.value.lastname}",
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await analytics.logEvent(name: "post_upload");

                              context.push(SelectImageScreen.routeName);
                            },
                            child: Container(
                              decoration: navbarController.currentIndex.value ==
                                      1
                                  ? BoxDecoration(
                                      color: Constants.primaryGrey2,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: StyleUtil.uploadButtonShadow(),
                                    )
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.w),
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: Constants.black,
                                size: 26,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await analytics.logEvent(name: "notifications");

                              navbarController.currentIndex.value = 2;
                              setState(() {});
                            },
                            child: Container(
                              decoration: navbarController.currentIndex.value ==
                                      2
                                  ? BoxDecoration(
                                      color: Constants.primaryGrey2,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: StyleUtil.uploadButtonShadow(),
                                    )
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.w),
                              child: const Center(
                                  child: Icon(
                                Icons.notifications_none_outlined,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      height: 4,
                      width: 20.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ratingDialog() {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const RatingDialog();
        });
  }

  void _checkNotification() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      debugPrint('[NOTIFICATION]: initial messages: $message');

      _handleNotificationOperation(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('[NOTIFICATION]: Got a message whilst in the foreground!');

      _handleNotificationOperation(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint(
          '[NOTIFICATION]: onMessageOpenedApp: ${message.notification!.title}');

      _handleNotificationOperation(message);
      _handleNotificationRedirect(message);
    });
  }

  void _handleNotificationRedirect(RemoteMessage message) async {
    // if (message.data['type'] == "orderCreated") {
    //   setIndex(3);
    // } else if (message.data['type'] == "order") {
    //   setIndex(3);
    // } else if (message.data['type'] == "chat") {
    //   // redirect to chat screen

    //   final userId1 = message.data['id'];
    //   final userId2 = StorageManager().getUserId();

    //   int largest = max(userId1.hashCode, userId2.hashCode);
    //   int smallest = min(userId1.hashCode, userId2.hashCode);

    //   final chatId = "${smallest}_$largest";

    //   Get.to(
    //     () => ChatDetailsScreen(
    //         chatId: chatId, userId1: userId1, userId2: userId2),
    //   );
    // } else if (message.data['type'] == "NewPost") {
    //   // redirect to post screen

    //   final postId = message.data['id'];
    //   final data = await PostRepo().getPostDetailsById(postId);

    //   Get.to(() => CouCouListCartScreen(
    //         postDataModelList: [data.data!],
    //         index: 0,
    //       ));
    // } else if (message.data['type'] == "like") {
    //   // redirect to post screen

    //   final postId = message.data['id'];
    //   final data = await PostRepo().getPostDetailsById(postId);

    //   Get.to(() => CouCouListCartScreen(
    //         postDataModelList: [data.data!],
    //         index: 0,
    //       ));
    // } else if (message.data['type'] == "follow") {
    //   // redirect to user profile screen

    //   final userId = message.data['id'];

    //   final SuperResponse<UserData?> result =
    //       await UserRepo().getUserDataById(userId);

    //   Get.to(() => ProfileDetailsScreen(user: result.data!));
    // } else if (message.data['type'] == "story") {
    //   // redirect to story screen

    //   final storyId = message.data['id'];

    //   final SuperResponse<StoryReelModel?> result =
    //       await PostRepo().getStoryDetailsById(storyId);

    //   Get.to(() => PageViewForStory(
    //         storyReelList: [result.data!],
    //         index: 0,
    //       ));
    // }
  }

  void _handleNotificationOperation(RemoteMessage? message) {
    if (message != null) {
      debugPrint('Message data: ${message.data}');

      if (message.data["type"] == "like") {
        userController.newNotification.value = true;
      } else if (message.data["type"] == "order") {
        userController.orderNotification.value = true;
      } else if (message.data["type"] == "chat") {
        userController.chatNotification.value = true;
      }
    }
  }
}
