import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostUploadedSuccessDialog extends StatelessWidget {
  const PostUploadedSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final navbarController = Get.find<NavbarController>();

    return WillPopScope(
      onWillPop: () {
        navbarController.currentIndex.value = 0;

        context.go(NavBar.routeName);
        return Future.value(false);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your Post\nSuccessfully Uploaded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Constants.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inika",
                  ),
                ),
                SizedBox(height: 4.w),
                SecondaryButton(
                  title: "Okay",
                  onTap: () {
                    navbarController.currentIndex.value = 0;
                    context.go(NavBar.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
