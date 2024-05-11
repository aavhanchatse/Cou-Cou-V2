import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/comment/comment_screen.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/widgets/heart_animation_widget.dart';
import 'package:coucou_v2/view/widgets/in_view_video_player_cou_cou.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class ReelsPageViewWidget extends StatefulWidget {
  final PostData item;

  const ReelsPageViewWidget({super.key, required this.item});

  @override
  State<ReelsPageViewWidget> createState() => _ReelsPageViewWidgetState();
}

class _ReelsPageViewWidgetState extends State<ReelsPageViewWidget> {
  PostData? post;
  bool isHeartAnimating = false;
  int currentIndex = 0;

  final userController = Get.find<UserController>();

  // void getPostData() async {
  //   post = widget.item;
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getPostData();
  // }

  void getPostData() async {
    await PostRepo().getPostData(widget.item.id!).then(
      (value) {
        post = value.data;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostData();
  }

  @override
  Widget build(BuildContext context) {
    return post == null
        ? Center(
            child: CircularProgressIndicator(
              color: Constants.primaryColor,
            ),
          )
        : GestureDetector(
            onDoubleTap: () {
              if (userController.userData.value.username != null &&
                  userController.userData.value.username!.isNotEmpty) {
                isHeartAnimating = true;
                setState(() {});

                likePost();
              } else {
                context.push(CompleteDetailsScreen.routeName);
              }
            },
            child: SizedBox(
              // height: 100.h,
              // width: 100.w,
              child: Stack(
                children: [
                  _contentImage(),
                  _buttons(context),
                  _descriptionWidget(),
                  _headerWidget(),
                  Positioned.fill(
                    child: Opacity(
                      opacity: isHeartAnimating ? 1 : 0,
                      child: HeartAnimationWidget(
                        isAnimating: isHeartAnimating,
                        duration: const Duration(milliseconds: 700),
                        onEnd: () {
                          isHeartAnimating = false;
                          setState(() {});
                        },
                        // child: Icon(
                        //   Icons.favorite,
                        //   color: Constants.white,
                        //   size: 100,),
                        child: Container(
                          padding: EdgeInsets.all(30.w),
                          height: 10.w,
                          width: 10.w,
                          child: Image.asset(
                            "assets/icons/cookie_selected.png",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget _headerWidget() {
    return Positioned(
      top: 3.w,
      left: 4.w,
      child: InkWell(
        onTap: () {
          context.push(
            UserProfileScreen.routeName,
            extra: post?.userSingleData?.id,
          );
        },
        child: Row(
          children: [
            DefaultPicProvider.getCircularUserProfilePic(
              profilePic: post?.userSingleData!.imageUrl,
              userName:
                  "${post?.userSingleData!.firstname} ${post?.userSingleData!.lastname}",
              size: 40,
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post?.userSingleData!.username ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Constants.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (post?.voiceUrl != null && post!.voiceUrl!.isNotEmpty)
                  Text(
                    post?.voiceUrl ?? "",
                    style: TextStyle(
                      color: Constants.white,
                      fontSize: 12,
                    ),
                  ),
                if (post?.postLocation != null &&
                    post!.postLocation!.isNotEmpty)
                  Text(
                    post?.postLocation ?? "",
                    style: TextStyle(
                      color: Constants.white,
                      fontSize: 12,
                    ),
                  ),
                Text(
                  DateUtil.timeAgo2(post!.createdAt!),
                  // DateUtil.timeAgo(post!.createdAt!),
                  style: TextStyle(
                    color: Constants.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool findIfVideo() {
    if (post!.challengeVideo == null) {
      if (post!.isVideo == true) {
        return true;
      } else {
        return false;
      }
    }

    if (post!.challengeVideo!.endsWith(".mp4")) {
      return true;
    } else {
      return false;
    }
  }

  Widget _contentImage() {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: findIfVideo()
          ? InViewVideoPlayerCouCou(
              data: post!.challengeVideo == null
                  ? post!.videoUrl ?? ""
                  : post!.challengeVideo ?? "",
              postDataList: post!,
              isViewChanged: true,
              blackMute: true,
            )
          : _multipleImage(),
      // : Image.network(
      //     post?.challengeVideo ?? "",
      //     height: 100.h,
      //     width: 100.w,
      //     fit: BoxFit.cover,
      //   ),
    );
  }

  Widget _multipleImage() {
    return CarouselSlider.builder(
      itemCount: post!.imagesMultiple == null || post!.imagesMultiple!.isEmpty
          ? 1
          : post!.imagesMultiple!.length,
      itemBuilder: (context, index, realIndex) {
        final element =
            post!.imagesMultiple != null && post!.imagesMultiple!.isNotEmpty
                ? post!.imagesMultiple![index]
                : post!.challengeVideo ?? "";

        return _singleImage(element);
      },
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        viewportFraction: 1.0,
        disableCenter: true,
        initialPage: 0,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          currentIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Widget _singleImage(String image) {
    return ImageUtil.networkImage(
      imageUrl: image,
      // height: 50.h,
      width: double.infinity,
      // fit: BoxFit.fitWidth,
    );
  }

  Widget _buttons(BuildContext context) {
    return Positioned(
      bottom: 10.h,
      right: 4.w,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              likePost();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    post?.like == true
                        ? "assets/icons/cookie_selected.png"
                        : "assets/icons/cookie_unselected.png",
                    height: 6.w,
                  ),
                ),
                SizedBox(height: 1.w),
                Text(
                  "${post?.likeCount ?? 0}",
                  style: TextStyle(
                    color: Constants.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.w),
          InkWell(
            onTap: () async {
              // context.push(CommentScreen.routeName, extra: post);
              final PostData? data =
                  await context.push(CommentScreen.routeName, extra: post);

              if (data != null) {
                post = data;
                setState(() {});
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    "assets/icons/comment2.png",
                    height: 6.w,
                    color: Constants.black,
                  ),
                ),
                SizedBox(height: 1.w),
                Text(
                  post?.commentCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.w),
          InkWell(
            onTap: () async {
              await analytics.logEvent(name: "share_post");

              String imageUrl = post!.imagesMultiple != null &&
                      post!.imagesMultiple!.isNotEmpty
                  ? post!.imagesMultiple![currentIndex]
                  : post!.challengeVideo ?? post!.videoUrl ?? "";

              bool video = post!.imagesMultiple != null &&
                      post!.imagesMultiple!.isNotEmpty
                  ? false
                  : true;

              await shareImageWithText(
                  imageUrl ?? "", post?.deepLinkUrl ?? "", context, video);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Constants.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                "assets/icons/share2.png",
                height: 6.w,
                color: Constants.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionWidget() {
    return Positioned(
      bottom: 4.w,
      left: 4.w,
      right: 4.w,
      child: SizedBox(
        width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                context.push(
                  ChallengeDetailsScreen.routeName,
                  extra: {"id": post!.challengeData!.id},
                );
              },
              child: Text(
                // "#challengeName",
                "#${post!.challengeData!.challengeName}",
                style: TextStyle(
                  color: Constants.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Text(
            //   post?.caption ?? "",
            //   style: TextStyle(
            //     color: Constants.white,
            //   ),
            // ),
            ReadMoreText(
              post?.caption ?? "",
              trimLines: 1,
              style: TextStyle(color: Constants.white),
              colorClickableText: Colors.white,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'more'.tr,
              trimExpandedText: 'less'.tr,
              lessStyle: TextStyle(
                color: Constants.primaryGrey,
                fontSize: 10,
              ),
              moreStyle: TextStyle(
                color: Constants.primaryGrey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void likePost() async {
    // if (item.like == true) {
    //   item.likeCount = item.likeCount! + 1;
    // } else {
    //   if (item.likeCount != 0) {
    //     item.likeCount = item.likeCount! - 1;
    //   }
    // }

    // setState(() {});

    var payLoad = {
      "postOwnerId": post?.userSingleData!.id!,
      "postId": post?.id,
      "userId": userController.userData.value.id
    };

    PostRepo().addPostLike(payLoad).then((value) async {
      await analytics.logEvent(name: "like_clicked");
      post = value.data;
      setState(() {});

      // if (item.like == true) {
      //   item.likeCount = item.likeCount! + 1;
      // } else {
      //   if (item.likeCount != 0) {
      //     item.likeCount = item.likeCount! - 1;
      //   }
      // }

      // item.like = isLiked;
      // await analytics.logEvent(name: "like_post_button");
      // consoleLog(tag: "addPostLike", message: value.message!);
    });
  }
}
