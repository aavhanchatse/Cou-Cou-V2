import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/comment/comment_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
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

  void getPostData() async {
    post = widget.item;
    setState(() {});
  }

  @override
  void initState() {
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
        : SizedBox(
            // height: 100.h,
            // width: 100.w,
            child: Stack(
              children: [
                _contentImage(),
                _buttons(context),
                _descriptionWidget(),
                _headerWidget(),
              ],
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
                Text(
                  post?.voiceUrl ?? "",
                  style: TextStyle(
                    fontFamily: "Inika",
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

  Widget _contentImage() {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: post!.challengeVideo!.endsWith(".mp4")
          ? InViewVideoPlayerCouCou(
              data: post!.challengeVideo!,
              postDataList: post!,
              isViewChanged: true,
              blackMute: true,
            )
          : Image.network(
              post?.challengeVideo ?? "",
            ),
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
                  post?.likeCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.w),
          InkWell(
            onTap: () {
              context.push(CommentScreen.routeName, extra: post);
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/icons/comment2.png",
                  height: 6.w,
                ),
                SizedBox(height: 1.w),
                Text(
                  post?.commentCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.w),
          InkWell(
            onTap: () {
              shareImageWithText(
                  post?.challengeVideo ?? "", post?.deepLinkUrl ?? "");
            },
            child: Image.asset(
              "assets/icons/share2.png",
              height: 6.w,
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
              colorClickableText: Colors.black,
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

    final userController = Get.find<UserController>();

    var payLoad = {
      "postOwnerId": post?.userSingleData!.id!,
      "postId": post?.id,
      "userId": userController.userData.value.id
    };

    PostRepo().addPostLike(payLoad).then((value) async {
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
