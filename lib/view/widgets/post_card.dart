import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
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

class PostCard extends StatefulWidget {
  final PostData postData;
  final bool isInView;

  const PostCard({super.key, required this.postData, this.isInView = false});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  PostData? item;

  @override
  void initState() {
    super.initState();

    item = widget.postData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return item == null
        ? const SizedBox()
        : Column(
            children: [
              _headerWidget(context),
              SizedBox(height: 2.w),
              _contentImage(),
              SizedBox(height: 2.w),
              _buttons(context),
              SizedBox(height: 2.w),
              _descriptionWidget(),
            ],
          );
  }

  Widget _descriptionWidget() {
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Text(
    //         item?.caption ?? "",
    //         style: TextStyle(
    //           color: Constants.black,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  context.push(
                    ChallengeDetailsScreen.routeName,
                    extra: {"id": item!.challengeData!.id},
                  );
                },
                child: Text(
                  "#${item!.challengeData!.challengeName}",
                  style: TextStyle(
                    color: Constants.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ReadMoreText(
                item?.caption ?? "",
                trimLines: 1,
                trimLength: 25,
                colorClickableText: Colors.black,
                trimMode: TrimMode.Length,
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
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            likePost();
          },
          child: Row(
            children: [
              Image.asset(
                item?.like == true
                    ? "assets/icons/cookie_selected.png"
                    : "assets/icons/cookie_unselected.png",
                height: 6.w,
              ),
              SizedBox(width: 1.w),
              Text(
                item?.likeCount?.toString() ?? "0",
                style: TextStyle(
                  color: Constants.black,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            context.push(CommentScreen.routeName, extra: item);
          },
          child: Row(
            children: [
              Image.asset(
                "assets/icons/comment.png",
                height: 6.w,
              ),
              SizedBox(width: 1.w),
              Text(
                item?.commentCount?.toString() ?? "0",
                style: TextStyle(
                  color: Constants.black,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            await analytics.logEvent(name: "share_post");

            shareImageWithText(
                item?.challengeVideo ?? "", item?.deepLinkUrl ?? "");
          },
          child: Row(
            children: [
              Image.asset(
                "assets/icons/share.png",
                height: 6.w,
              ),
              SizedBox(width: 1.w),
              Text(
                "share".tr,
                style: TextStyle(
                  color: Constants.black,
                ),
              ),
            ],
          ),
        ),
      ],
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
      "postOwnerId": item?.userSingleData!.id!,
      "postId": item?.id,
      "userId": userController.userData.value.id
    };

    PostRepo().addPostLike(payLoad).then((value) async {
      await analytics.logEvent(name: "like_clicked");

      item = value.data;
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

  Widget _contentImage() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: 50.h,
      ),
      child: item!.challengeVideo!.endsWith(".mp4")
          ? InViewVideoPlayerCouCou(
              data: item!.challengeVideo!,
              postDataList: item!,
              isViewChanged: widget.isInView,
            )
          : ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Image.network(
                item?.challengeVideo ?? "",
              ),
            ),
    );
  }

  Widget _headerWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(UserProfileScreen.routeName,
            extra: item?.userSingleData?.id);
      },
      child: Row(
        children: [
          DefaultPicProvider.getCircularUserProfilePic(
            profilePic: item?.userSingleData!.imageUrl,
            userName:
                "${item?.userSingleData!.firstname} ${item?.userSingleData!.lastname}",
            size: 60,
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item?.userSingleData!.username ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                item?.postLocation ?? "",
                style: TextStyle(
                  fontFamily: "Inika",
                  color: Constants.black,
                  fontSize: 12,
                ),
              ),
              Text(
                DateUtil.timeAgo2(item!.createdAt!),
                // DateUtil.timeAgo(item!.createdAt!),
                style: TextStyle(
                  color: Constants.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
