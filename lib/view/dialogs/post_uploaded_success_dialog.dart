import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostUploadedSuccessDialog extends StatelessWidget {
  final bool update;
  const PostUploadedSuccessDialog({super.key, this.update = false});

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
                const Icon(
                  Icons.check_circle_outline_outlined,
                  size: 42,
                ),
                Text(
                  "Your Post\nSuccessfully ${update == false ? "Uploaded" : "Updated"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Constants.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inika",
                  ),
                ),
                SizedBox(height: 4.w),
                InkWell(
                  onTap: () {
                    navbarController.currentIndex.value = 0;
                    context.go(NavBar.routeName);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Constants.white,
                      boxShadow: [StyleUtil.shadow2()],
                    ),
                    child: const Text(
                      "Okay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Inika",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
