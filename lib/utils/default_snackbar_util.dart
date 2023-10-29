import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_constants/constants.dart';

class SnackBarUtil {
  static showSnackBar(String text,
      {Widget? actionButton, Color? color, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Constants.textColor,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        // margin: EdgeInsets.all(4.w),
        duration: const Duration(milliseconds: 2000),
      ),
    );

    // Get.showSnackbar(GetSnackBar(
    //   duration: const Duration(milliseconds: 2000),
    //   borderRadius: 16.0,
    //   margin: EdgeInsets.all(4.w),
    //   // boxShadows: CommonStyle.primaryShadowLight(),
    //   backgroundColor: Constants.primaryColor,
    //   animationDuration: const Duration(milliseconds: 500),
    //   mainButton: actionButton,
    //   messageText: Text(
    //     text,
    //     style: TextStyle(
    //       color: Constants.textColor,
    //     ),
    //   ),
    // ));
  }
}
