import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const LOGO = 'assets/icons/coucouimage.png';
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.only(top: 4.w, left: 4.w, right: 4.w, bottom: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              LOGO,
              height: 10.h,
              width: 10.h,
            ),
            Text(
              "enjoying_cou_cou".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Constants.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "tap_star_to_rate".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Constants.textColor,
              ),
            ),
            SizedBox(height: 4.w),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Constants.primaryColor,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
                // context.pop();
                giveRating(context, rating.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }

  void giveRating(BuildContext context, int rating) async {
    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      //try {

      final result = await UserRepo().appRating(rating);
      // Get.back();
      context.pop();

      if (result.status == true) {
        final userController = Get.find<UserController>();
        userController.getUserDataById();
        await analytics.logEvent(name: "rating_star_clicked");

        await analytics.logEvent(
          name: "home_click_event",
          parameters: {
            "home_clicks": "Click on rating star",
            "home_values": rating.toString(),
            "username":
                userController.userData.value.username ?? "not logged in user",
            "mobile_num":
                userController.userData.value.number ?? "not logged in user",
            "gender":
                userController.userData.value.gender ?? "not logged in user",
            "dob": userController.userData.value.dob.toString(),
            // "content_details": item.challengeData?.challengeName,
            // "content_posted_by": item.userSingleData!.id!,
            // "content_posted_date": item.createdAt,
            // "username": item.userSingleData!.username,
            // "mobile_num": item.userSingleData!.number,
            // "gender": item.userSingleData!.gender,
            // "dob": item.userSingleData!.dob,
          },
        );

        context.pop();
      } else {
        SnackBarUtil.showSnackBar(result.message!, context: context);
      }
      // } catch (error) {
      //   Get.back();
      //   SnackBarUtil.showSnackBar('Something went wrong');
      //   debugPrint('error: $error');
      // }
    } else {
      // Get.back();
      context.pop();
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }
}
