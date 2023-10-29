import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UploadSubCommentDialog extends StatefulWidget {
  const UploadSubCommentDialog({super.key});

  @override
  State<UploadSubCommentDialog> createState() => _UploadSubCommentDialogState();
}

class _UploadSubCommentDialogState extends State<UploadSubCommentDialog> {
  final userController = Get.find<UserController>();

  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
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
                onChanged: (value) {
                  comment = value.trim();
                  setState(() {});
                },
                minLines: 1,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Reply...",
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
              ),
            ),
            InkWell(
              onTap: () {
                context.pop(comment);
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
      ),
    );
  }

  void navigateToProfileScreen(String userId) {
    if (userController.userData.value.id == userId) {
      context.push(UserProfileScreen.routeName);
    } else {
      context.push(UserProfileScreen.routeName, extra: userId);
    }
  }
}
