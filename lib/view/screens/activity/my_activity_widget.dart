import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/my_activity_model_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/widgets/reels_page_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyActivityWidget extends StatefulWidget {
  final bool isFromNavBar;

  const MyActivityWidget({Key? key, this.isFromNavBar = false})
      : super(key: key);

  @override
  State<MyActivityWidget> createState() => _MyActivityWidgetState();
}

class _MyActivityWidgetState extends State<MyActivityWidget> {
  var userActivityData = <MyActivityModelData?>[];

  bool isMyActivityClicked = false;

  @override
  void initState() {
    super.initState();
    setAnalytics();
    _getData(isMyActivityClicked);
  }

  void setAnalytics() async {
    // await analytics.setCurrentScreen(screenName: 'activity_tab');
  }

  void _getData(bool isActivity) {
    userActivityData.clear();
    UserRepo().getUserActivity(isActivity).then((value) {
      userActivityData = value.data!;
      userActivityData.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    isMyActivityClicked = false;
                    setState(() {});
                    _getData(isMyActivityClicked);

                    await analytics.logEvent(name: "other_activity");
                  },
                  child: Container(
                    width: 35.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.w),
                    decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: StyleUtil.buttonshadow(),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "other_activity".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          if (!isMyActivityClicked)
                            Container(
                              decoration: BoxDecoration(
                                color: Constants.black,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              height: 1,
                              width: 20.w,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    isMyActivityClicked = true;
                    setState(() {});
                    _getData(isMyActivityClicked);

                    await analytics.logEvent(name: "my_activity");
                  },
                  child: Container(
                    width: 35.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.w),
                    decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: StyleUtil.buttonshadow(),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "my_activity".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          if (isMyActivityClicked)
                            Container(
                              decoration: BoxDecoration(
                                color: Constants.black,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              height: 1,
                              width: 20.w,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
              physics: const BouncingScrollPhysics(),
              children: [
                ...userActivityData
                    .map((e) => e!.likeStatus != null
                        ? _likePostWidget(e)
                        // : const SizedBox())
                        : _commentPostWidget(e))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _likePostWidget(MyActivityModelData e) {
    return InkWell(
      onTap: () async {
        final postId = e.postData?.id;
        final data = await PostRepo().getPostData(postId!);

        Get.to(() => ReelsPageViewWidget(item: data.data!));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4.w),
        padding: EdgeInsets.only(left: 4.w, right: 1.w, top: 2.w, bottom: 1.w),
        decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: StyleUtil.uploadButtonShadow(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                DefaultPicProvider.getCircularUserProfilePic(
                  profilePic: e.userData!.imageUrl ?? "",
                  userName:
                      "${e.postOwnerData!.firstname ?? ""} ${e.postOwnerData!.lastname ?? ""}",
                  size: 40,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Row(
                  children: [
                    Text(
                      isMyActivityClicked
                          ? "${"you_have_liked_on".tr} "
                          : "${e.userData!.firstname}",
                      style: TextStyle(
                        fontSize: 1.9.t,
                      ),
                    ),
                    Text(
                      isMyActivityClicked
                          ? "${e.postOwnerData!.firstname} Post"
                          : " ${"liked_your_post".tr}",
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getDifferenceOfPeriodForNews(e.createdAt!.toIso8601String()),
                  style: TextStyle(
                    fontSize: 1.3.t,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentPostWidget(MyActivityModelData e) {
    return InkWell(
      onTap: () async {
        final postId = e.postData?.id;
        final data = await PostRepo().getPostData(postId!);

        Get.to(() => ReelsPageViewWidget(item: data.data!));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4.w),
        padding: EdgeInsets.only(left: 4.w, right: 1.w, top: 2.w, bottom: 1.w),
        decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: StyleUtil.uploadButtonShadow(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                DefaultPicProvider.getCircularUserProfilePic(
                  profilePic: e.postOwnerData?.imageUrl ?? "",
                  userName:
                      "${e.postOwnerData?.firstname ?? ""} ${e.postOwnerData?.lastname ?? ""}",
                  size: 40,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        isMyActivityClicked
                            ? "${"you_have_commented_on".tr}  "
                            : "${e.userData!.firstname} ${e.userData!.lastname}",
                        style: TextStyle(
                          fontSize: 1.9.t,
                        ),
                      ),
                      Text(
                        isMyActivityClicked
                            ? "${e.userData!.firstname} Post"
                            : " ${"comment_on_your_post".tr}",
                        style: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getDifferenceOfPeriodForNews(e.createdAt!.toIso8601String()),
                  style: TextStyle(fontSize: 1.3.t, color: Colors.black),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Constants.white,
      iconTheme: IconThemeData(color: Constants.black),
      leading: IconButton(
        onPressed: () {
          final navbarController = Get.find<NavbarController>();
          navbarController.currentIndex.value = 1;
        },
        icon: ImageIcon(
          const AssetImage("assets/icons/back_arrow.png"),
          color: Constants.black,
        ),
      ),
      centerTitle: true,
      title: Text(
        "notifications".tr,
        style: TextStyle(
          color: Constants.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
