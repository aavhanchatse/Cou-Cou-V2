import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:coucou_v2/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UpdateAddressScreen extends StatefulWidget {
  static const routeName = '/updateAddress';

  const UpdateAddressScreen({super.key});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final userController = Get.find<UserController>();
  final formKey = GlobalKey<FormState>();

  String? address;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap(context);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constants.white,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: ImageIcon(
              const AssetImage("assets/icons/back_arrow.png"),
              color: Constants.black,
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Text(
              "Cou Cou!",
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: "Inika",
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 2.w),
                Text(
                  "Update Address",
                  style: TextStyle(
                    color: Constants.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inika",
                  ),
                ),
                SizedBox(height: 8.w),
                _passwordTextField(),
                SizedBox(height: 8.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Old Address",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2.w),
            DefaultTextField2(
              initialValue: userController.userData.value.address ?? "",
              enabled: false,
              readOnly: true,
              onChanged: (value) {},
              maxLines: 3,
              hintText: '',
            ),
            SizedBox(height: 4.w),
            const Text(
              "New Address",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2.w),
            DefaultTextField2(
              onChanged: (String value) {
                address = value.trim();
                setState(() {});
              },
              maxLines: 3,
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return 'Enter Valid Address'.tr;
                }
                return null;
              },
              hintText: '',
            ),
            SizedBox(height: 12.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryButton(
                    title: "Update Address",
                    onTap: () {
                      _continue();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _continue() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        String id = userController.userData.value.id!;

        Map payload = {
          "id": id,
          "address": address,
        };

        final result = await UserRepo().updateUserProfile(payload);
        // Get.back();
        context.pop();

        if (result.status == true) {
          userController.getUserDataById();
          context.pop();
          SnackBarUtil.showSnackBar(result.message!, context: context);
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
      } catch (error) {
        // Get.back();
        context.pop();
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      // Get.back();
      context.pop();
      SnackBarUtil.showSnackBar('No Internet Connected', context: context);
    }
  }
}
