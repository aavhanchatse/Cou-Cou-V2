import 'dart:math' as math;

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/comment_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/comment/dialog/upload_sub_comment_dialog.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/widgets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment';

  final PostData post;

  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  final userController = Get.find<UserController>();
  var commentTextController = TextEditingController();

  bool loading = true;

  List<CommentData> commentDataList = [];

  PostData? postData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postData = widget.post;
    setState(() {});

    _getCommentData();
    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'comments_screen');
  }

  @override
  void dispose() {
    super.dispose();
    commentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.pop(postData);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          GestureDetectorUtil.onScreenTap(context);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                context.pop(postData);
              },
              icon: ImageIcon(
                const AssetImage("assets/icons/back_arrow.png"),
                color: Constants.black,
              ),
            ),
            title: Text(
              "comments".tr,
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (loading == false && commentDataList.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                    itemCount: commentDataList.length,
                    itemBuilder: (context, index) {
                      final item = commentDataList[index];

                      return _commentItem(item);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 2.w);
                    },
                  ),
                ),
              _postComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentItem(CommentData item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                navigateToProfileScreen(item.userData!.id!);
              },
              child: DefaultPicProvider.getCircularUserProfilePic(
                profilePic: item.userData!.imageUrl,
                userName:
                    "${item.userData!.firstname} ${item.userData!.lastname}",
                size: 35,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.userData!.username!,
                    style: TextStyle(
                      color: Constants.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    item.postComment ?? "",
                    style: TextStyle(
                      color: Constants.black,
                    ),
                  ),
                ],
              ),
            ),
            if (postData!.userSingleData!.id ==
                    userController.userData.value.id &&
                item.subcomment!.isEmpty)
              IconButton(
                onPressed: () {
                  showReplyDialog(item.id!);
                },
                icon: const Icon(Icons.reply),
              ),
            Text(
              DateUtil.timeAgo3(item.createdAt!.toLocal()),
              style: TextStyle(
                color: Constants.black,
              ),
            ),
            if (item.userData!.id == userController.userData.value.id ||
                postData!.userSingleData!.id ==
                    userController.userData.value.id)
              IconButton(
                onPressed: () {
                  deleteComment(item);
                },
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
        if (item.subcomment!.isNotEmpty) _subCommentWidget(item),
      ],
    );
  }

  Widget _subCommentWidget(CommentData item) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 2.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              navigateToProfileScreen(item.subuserData!.first.id!);
            },
            child: DefaultPicProvider.getCircularUserProfilePic(
              profilePic: item.subuserData!.first.imageUrl,
              userName:
                  "${item.subuserData!.first.firstname} ${item.subuserData!.first.lastname}",
              size: 45,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subuserData!.first.username!,
                  style: TextStyle(
                    color: Constants.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.subcomment!.first.postComment ?? "",
                  style: TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateUtil.timeAgo3(item.createdAt!.toLocal()),
            style: TextStyle(
              color: Constants.black,
            ),
          ),
          if (item.subuserData!.first.id == userController.userData.value.id)
            IconButton(
              onPressed: () {
                deleteSubComment(item.subcomment!.first.id!);
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    );
  }

  void deleteComment(CommentData item) async {
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().deleteComment(item.id!);

        if (result.status == true) {
          await analytics.logEvent(name: "delete_comment");
          postData = result.data;
          setState(() {});

          debugPrint("comment deleted");

          _getCommentData();
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
      } catch (error) {
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }

  void deleteSubComment(String id) async {
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().deleteSubComment(id);

        if (result.status == true) {
          await analytics.logEvent(name: "delete_sub_comment");
          postData = result.data;
          setState(() {});

          _getCommentData();
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
      } catch (error) {
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }

  void _getCommentData() async {
    debugPrint("inside get comment");

    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        Map payload = {"postId": postData!.id};

        final result = await PostRepo().getPostComments(payload);

        if (result.status == true) {
          debugPrint("inside get comment success");

          commentDataList = result.data!;
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

  void addComment() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (commentTextController.text.trim().isEmpty) {
      SnackBarUtil.showSnackBar('Enter valid comment', context: context);
      return;
    }

    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        Map payload = {
          "userId": userController.userData.value.id,
          "postId": postData!.id,
          "postOwnerId": postData!.userSingleData!.id,
          "postComment": commentTextController.text.trim(),
        };

        final result = await PostRepo().addComment(payload);

        if (result.status == true) {
          commentTextController.text = "";
          await analytics.logEvent(name: "post_comment");

          postData = result.data;
          setState(() {});

          _getCommentData();
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

  void addSubComment(
      {required String comment, required String commentId}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        Map payload = {
          "userId": userController.userData.value.id,
          "postId": postData!.id,
          "commentId": commentId,
          "postOwnerId": postData!.userSingleData!.id,
          "postComment": comment.trim(),
        };

        final result = await PostRepo().addSubComment(payload);

        if (result.status == true) {
          await analytics.logEvent(name: "user_sub_comment");

          postData = result.data;
          setState(() {});

          _getCommentData();
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

  void navigateToProfileScreen(String userId) {
    if (userController.userData.value.id == userId) {
      context.push(UserProfileScreen.routeName);
    } else {
      context.push(UserProfileScreen.routeName, extra: userId);
    }
  }

  void showReplyDialog(String commentId) async {
    final String? result = await showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const UploadSubCommentDialog();
        });

    if (result != null && result.isNotEmpty) {
      // add sub commnet

      addSubComment(comment: result, commentId: commentId);
    }
  }

  Widget _postComment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      child: DefaultTextField(
        onChanged: (String value) {},
        prefixIcon: InkWell(
          onTap: () {
            navigateToProfileScreen(userController.userData.value.id!);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: DefaultPicProvider.getCircularUserProfilePic(
              profilePic: userController.userData.value.imageUrl,
              userName:
                  "${userController.userData.value.firstname} ${userController.userData.value.lastname}",
              size: 30,
            ),
          ),
        ),
        minLines: 1,
        maxLines: 6,
        keyboardType: TextInputType.multiline,
        hintText: "your_comment".tr,
        textEditingController: commentTextController,
        suffixIcon: InkWell(
          onTap: () {
            addComment();
          },
          child: Container(
            padding: EdgeInsets.all(1.w),
            margin: const EdgeInsets.all(5),
            height: 9.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.primaryGrey3,
            ),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Image.asset("assets/icons/send_icon.png"),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _postComment() => Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           InkWell(
  //             onTap: () {
  //               navigateToProfileScreen(userController.userData.value.id!);
  //             },
  //             child: DefaultPicProvider.getCircularUserProfilePic(
  //               profilePic: userController.userData.value.imageUrl,
  //               userName:
  //                   "${userController.userData.value.firstname} ${userController.userData.value.lastname}",
  //               size: 45,
  //             ),
  //           ),
  //           SizedBox(width: 4.w),
  //           Flexible(
  //             fit: FlexFit.loose,
  //             child: TextField(
  //               minLines: 1,
  //               maxLines: 6,
  //               keyboardType: TextInputType.multiline,
  //               decoration: InputDecoration(
  //                 hintText: "your_comment".tr,
  //                 focusedBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Constants.black),
  //                 ),
  //                 enabledBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Constants.black),
  //                 ),
  //                 border: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Constants.black),
  //                 ),
  //                 errorBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Constants.black),
  //                 ),
  //                 disabledBorder: UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Constants.black),
  //                 ),
  //               ),
  //               controller: commentTextController,
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               addComment();
  //             },
  //             child: Container(
  //               padding: EdgeInsets.all(1.w),
  //               height: 12.w,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Constants.primaryGrey3,
  //               ),
  //               child: Image.asset("assets/icons/send_icon.png"),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
}
