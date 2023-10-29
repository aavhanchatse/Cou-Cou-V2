import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment';

  final PostData postData;

  const CommentScreen({super.key, required this.postData});

  @override
  State<CommentScreen> createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  final userController = Get.find<UserController>();
  var commentTextController = TextEditingController();

  bool loading = true;

  List<CommentData> commentDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCommentData();
  }

  @override
  void dispose() {
    super.dispose();
    commentTextController.dispose();
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
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Constants.black,
              )),
          title: Text(
            "Comments",
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
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                  itemCount: commentDataList.length,
                  itemBuilder: (context, index) {
                    final item = commentDataList[index];

                    return _commentItem(item);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 6.w);
                  },
                ),
              ),
            _postComment(),
          ],
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
                size: 45,
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
            if (widget.postData.userSingleData!.id ==
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
            if (item.userData!.id == userController.userData.value.id)
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
    loading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        Map payload = {"postId": widget.postData.id};

        final result = await PostRepo().getPostComments(payload);

        if (result.status == true) {
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
          "postId": widget.postData.id,
          "postOwnerId": widget.postData.userSingleData!.id,
          "postComment": commentTextController.text.trim(),
        };

        final result = await PostRepo().addComment(payload);

        if (result.status == true) {
          commentTextController.text = "";
          // await analytics.logEvent(name: "post_comment");
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
          "postId": widget.postData.id,
          "commentId": commentId,
          "postOwnerId": widget.postData.userSingleData!.id,
          "postComment": comment.trim(),
        };

        final result = await PostRepo().addSubComment(payload);

        if (result.status == true) {
          // await analytics.logEvent(name: "post_comment");
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

  Widget _postComment() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () {
                navigateToProfileScreen(userController.userData.value.id!);
              },
              child: DefaultPicProvider.getCircularUserProfilePic(
                profilePic: userController.userData.value.imageUrl,
                userName:
                    "${userController.userData.value.firstname} ${userController.userData.value.lastname}",
                size: 45,
              ),
            ),
            SizedBox(width: 4.w),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                minLines: 1,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Your Comment...",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.black),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.black),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.black),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.black),
                  ),
                ),
                controller: commentTextController,
              ),
            ),
            InkWell(
              onTap: () {
                addComment();
              },
              child: Container(
                padding: EdgeInsets.all(1.w),
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryGrey3,
                ),
                child: Image.asset("assets/icons/send_icon.png"),
              ),
            ),
          ],
        ),
      );
}
