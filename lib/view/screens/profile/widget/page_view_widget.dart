import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/common_utils.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/dialogs/delete_post_dialog.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/comment/comment_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/upload_post_details_screen.dart';
import 'package:coucou_v2/view/widgets/in_view_video_player_cou_cou.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class PageViewWidget extends StatefulWidget {
  final String id;

  const PageViewWidget({super.key, required this.id});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  PostData? post;

  final userController = Get.find<UserController>();

  void getPostData() async {
    await PostRepo().getPostData(widget.id).then(
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
        : Column(
            children: [
              _contentImage(),
              SizedBox(height: 2.w),
              _buttons(context),
              SizedBox(height: 2.w),
              _descriptionWidget(),
            ],
          );
  }

  Widget _contentImage() {
    return Expanded(
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
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              likePost();
            },
            child: Row(
              children: [
                Image.asset(
                  post?.like == true
                      ? "assets/icons/cookie_selected.png"
                      : "assets/icons/cookie_unselected.png",
                  height: 6.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  post?.likeCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          InkWell(
            onTap: () {
              context.push(CommentScreen.routeName, extra: post);
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/comment.png",
                  height: 6.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  post?.commentCount?.toString() ?? "0",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          InkWell(
            onTap: () {
              shareImageWithText(
                  post?.challengeVideo ?? "", post?.deepLinkUrl ?? "");
            },
            child: Image.asset(
              "assets/icons/share.png",
              height: 6.w,
            ),
          ),
          const Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Constants.black,
          //   ),
          // ),
          if (post!.userSingleData!.id == userController.userData.value.id)
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // popupmenu item 1
                PopupMenuItem(
                  value: 1,
                  // row has two child icon and text.
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      SizedBox(width: 2.w),
                      const Text("Edit"),
                    ],
                  ),
                ),
                // popupmenu item 2
                PopupMenuItem(
                  value: 2,
                  // row has two child icon and text
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outlined),
                      SizedBox(width: 2.w),
                      const Text("Delete"),
                    ],
                  ),
                ),
              ],
              offset: const Offset(0, 100),
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: Constants.black,
              ),
              elevation: 2,
              onSelected: (value) {
                // debugPrint('selected value: $value');

                if (value == 1) {
                  editChallenge();
                } else if (value == 2) {
                  deleteStory();
                }
              },
            ),
        ],
      ),
    );
  }

  void editChallenge() async {
    // Get.back();
    await PostRepo().getPostData(post!.id!).then(
          (value) => context.push(
            UploadPostDetailsScreen.routeName,
            extra: value.data,
          ),
        );
    // Get.to(() => CreateChallengeScreen(
    //       challengeData: widget.challengeData,
    //       edit: true,
    //     ));
  }

  void deleteStory() async {
    final result = await showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return DeletePostDialog(
            text: "Delete".tr,
          );
        });

    if (result == true) {
      _deleteStory();
      // }
    }
  }

  void _deleteStory() async {
    // ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        Map payload = {"id": post!.id};

        final result = await PostRepo().deletePost(payload);

        // context.pop();

        if (result.status == true) {
          context.pop(true);
          SnackBarUtil.showSnackBar(result.message!, context: context);

          // final navbarController = Get.find<NavbarController>();
          // navbarController.currentIndex.value = 0;
          // context.go(NavBar.routeName);
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
      } catch (error) {
        // Get.back();
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      // Get.back();
      SnackBarUtil.showSnackBar('No Internet Connected', context: context);
    }
  }

  Widget _descriptionWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
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
                    "#${post!.challengeData!.challengeName}",
                    style: TextStyle(
                      color: Constants.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Text(
                //   post?.caption ?? "",
                //   style: TextStyle(
                //     color: Constants.black,
                //   ),
                // ),
                ReadMoreText(
                  post?.caption ?? "",
                  trimLines: 1,
                  colorClickableText: Colors.black,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
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
