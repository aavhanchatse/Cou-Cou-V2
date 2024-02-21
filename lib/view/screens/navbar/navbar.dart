import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/rating_dialog.dart';
import 'package:coucou_v2/view/screens/activity/my_activity_widget.dart';
import 'package:coucou_v2/view/screens/home/home_screen.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/select_image_screen_2.dart';
import 'package:coucou_v2/view/widgets/reels_page_view_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:showcaseview/showcaseview.dart';

class NavBar extends StatefulWidget {
  final bool? fromLogin;
  static const routeName = '/';

  const NavBar({super.key, this.fromLogin});

  @override
  State<NavBar> createState() => _NavBarState();
}

final GlobalKey firstShowCaseKey = GlobalKey();
final GlobalKey secondShowCaseKey = GlobalKey();
final GlobalKey thirdShowCaseKey = GlobalKey();
final GlobalKey fourthShowCaseKey = GlobalKey();
final GlobalKey fifthShowCaseKey = GlobalKey();

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

    debugPrint("fromLogin: ${widget.fromLogin}");

    if (widget.fromLogin == true) {
      _showRatingDialog();
    } else {
      getUser();
    }

    _checkNotification();
    handleDeepLink(context);

    checkForInAppUpdate();
  }

  Future<void> checkForInAppUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => debugPrint(e.toString()));
      } else if (info.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate()
            .catchError((e) => debugPrint(e.toString()));
      }
    }).catchError((e) => {debugPrint(e.toString())});
  }

  void getUser() async {
    debugPrint("inside getUser");

    Future.delayed(
      const Duration(seconds: 2),
      () async {
        await userController.getUserDataById().then(
          (value) {
            debugPrint("inside get user by id then block");
            _showRatingDialog();
          },
        );
      },
    );
  }

  void _showRatingDialog() {
    debugPrint("inside showRating dialog");

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.fromLogin == true) {
          if (userController.userData.value.id != null &&
              userController.userData.value.ratingVerify != true) {
            ratingDialog();
          }

          ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context).startShowCase([
              firstShowCaseKey,
              secondShowCaseKey,
              thirdShowCaseKey,
              fourthShowCaseKey,
              fifthShowCaseKey
            ]),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return WillPopScope(
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
                _bottomNav(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomNav() {
    return Positioned(
      bottom: 4.w,
      left: 15.w,
      right: 15.w,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.w),
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: Constants.white,
              boxShadow: StyleUtil.cardShadow(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _profileButton(),
                // _uploadPostButton(),
                _notificationButton(),
              ],
            ),
          ),
          _uploadPostButton(),
        ],
      ),
    );
  }

  Widget _dividerLine() {
    return Container(
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      height: 4,
      width: 20.w,
    );
  }

  Widget _uploadPostButton() {
    return Positioned.fill(
      child: Column(
        children: [
          Showcase(
            key: firstShowCaseKey,
            description: "Start adding posts from here",
            disableDefaultTargetGestures: false,
            onBarrierClick: () => debugPrint('Barrier clicked'),
            child: InkWell(
              onTap: () async {
                if (userController.userData.value.username != null &&
                    userController.userData.value.username!.isNotEmpty) {
                  await analytics.logEvent(name: "post_upload");

                  final ps = await PhotoManager.requestPermissionExtend();
                  if (ps.isAuth || ps.hasAccess) {
                    final PostController postController =
                        Get.find<PostController>();

                    postController.unselectImages();
                    postController.unselectMusic();
                    postController.unselectVideo();

                    context.push(SelectImageScreen2.routeName);
                  } else {
                    return;
                  }
                } else {
                  context.push(CompleteDetailsScreen.routeName);
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: StyleUtil.uploadButtonShadow(),
                  gradient: LinearGradient(
                    colors: [
                      Constants.yellowGradient1,
                      Constants.yellowGradient2,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Constants.black,
                  size: 40,
                ),
              ),
            ),
          ),
          Text(
            "participate_now".tr,
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              // fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationButton() {
    return Showcase(
      key: thirdShowCaseKey,
      description: "Tap to see the latest activity",
      onBarrierClick: () => debugPrint('Barrier clicked'),
      child: InkWell(
        onTap: () async {
          await analytics.logEvent(name: "notifications");

          navbarController.currentIndex.value = 2;
          setState(() {});
        },
        child: Column(
          children: [
            Container(
              decoration: navbarController.currentIndex.value == 2
                  ? BoxDecoration(
                      color: Constants.primaryGrey2,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: StyleUtil.uploadButtonShadow(),
                    )
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.w),
              child: const Center(
                  child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
              )),
            ),
            Text(
              "notifications".tr,
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileButton() {
    return Showcase(
      key: secondShowCaseKey,
      description: "Tap to see the profile",
      onBarrierClick: () => debugPrint('Barrier clicked'),
      child: InkWell(
        onTap: () async {
          await analytics.logEvent(name: "self_profile_tab");

          navbarController.currentIndex.value = 0;
          setState(() {});
        },
        child: Column(
          children: [
            Container(
              decoration: navbarController.currentIndex.value == 0
                  ? BoxDecoration(
                      color: Constants.primaryGrey2,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: StyleUtil.uploadButtonShadow(),
                    )
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.w),
              child: SizedBox(
                height: 30,
                width: 30,
                child: DefaultPicProvider.getCircularUserProfilePic(
                  profilePic: userController.userData.value.imageUrl,
                  userName:
                      "${userController.userData.value.firstname} ${userController.userData.value.lastname}",
                  size: 25,
                ),
              ),
            ),
            Text(
              "profile".tr,
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
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
    debugPrint("inside check notification");

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
          '[NOTIFICATION]: onMessageOpenedApp: ${message.notification?.title}');

      _handleNotificationOperation(message);
      _handleNotificationRedirect(message);
    });
  }

  void _handleNotificationRedirect(RemoteMessage? message) async {
    if (message != null) {
      if (message.data['type'] == "NewPost") {
        // redirect to post screen

        final postId = message.data['id'];
        final data = await PostRepo().getPostData(postId);

        // Get.to(() => ReelsPageViewWidget(item: data.data!));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                body: SafeArea(child: ReelsPageViewWidget(item: data.data!))),
          ),
        );
      } else if (message.data['type'] == "like") {
        // redirect to post screen

        final postId = message.data['id'];
        final data = await PostRepo().getPostData(postId);

        // Get.to(() => ReelsPageViewWidget(item: data.data!));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                body: SafeArea(child: ReelsPageViewWidget(item: data.data!))),
          ),
        );
      }
    }
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
