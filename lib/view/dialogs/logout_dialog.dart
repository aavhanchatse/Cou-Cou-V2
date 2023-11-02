import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LogoutDialog {
  static showLogoutDialog(BuildContext context) {
    return Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('logout_from_cou_cou'.tr),
                  content: Text("you_wont_receive_existing".tr),
                  actions: [
                    CupertinoDialogAction(
                        child: Text('cancel'.tr),
                        onPressed: () {
                          context.pop();
                        }),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('logout'.tr),
                      onPressed: () {
                        LogoutDialog().logout(context);
                      },
                    )
                  ],
                ))
        : showCupertinoDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: Constants.primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('logout_from_cou_cou'.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Constants.textColor,
                                        fontWeight: FontWeight.w500))
                              ],
                            )),
                        const SizedBox(height: 16),
                        Row(children: [
                          Container(
                              margin: const EdgeInsets.only(left: 16),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.black54)),
                              child: const Icon(Icons.logout, size: 20)),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("you_wont_receive_existing".tr),
                          )),
                        ]),
                        const SizedBox(height: 16),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(
                                color: Constants.primaryGrey, height: 0)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Constants.textColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Constants.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6))),
                                  onPressed: () async {
                                    LogoutDialog().logout(context);
                                  },
                                  child: Text(
                                    'logout'.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Constants.textColor,
                                    ),
                                  )),
                            ])
                      ]));
            });
  }

  void logout(BuildContext context) async {
    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();
    if (isInternet) {
      try {
        final result = await AuthRepo().logout();

        // context.pop();
        if (result.status == true) {
          StorageManager().eraseStorage();
          Get.find<UserController>().userData.value = UserData();

          // Get.offAll(() => const LoginScreen());
          context.go(LoginScreen.routeName);
          SnackBarUtil.showSnackBar('Logged out', context: context);
        } else {
          SnackBarUtil.showSnackBar("Logout failed" /*result.message ?? ""*/,
              context: context);
        }
      } catch (error) {
        // Get.back();
        context.pop();
        SnackBarUtil.showSnackBar('something_went_wrong'.tr, context: context);
        debugPrint('error[logout-user]: $error');
      }
    } else {
      // Get.back();
      context.pop();
      SnackBarUtil.showSnackBar('internet_not_available'.tr, context: context);
    }
  }
}
