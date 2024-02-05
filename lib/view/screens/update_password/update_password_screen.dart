import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
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

class UpdatePasswordScreen extends StatefulWidget {
  static const routeName = '/updatePassword';

  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  bool showPassword = true;
  bool showCPassword = true;

  final formKey = GlobalKey<FormState>();

  String? _password;
  String? _confirmPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'password_update_screen');
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
          backgroundColor: Constants.white,
          centerTitle: true,
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
                  "Reset Password",
                  style: TextStyle(
                    color: Constants.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
              "New Password",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2.w),
            DefaultTextField2(
              onChanged: (value) {
                _password = value;
                setState(() {});
              },
              validator: _validatePassword,
              obscureText: showPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  showPassword = showPassword ? false : true;
                  setState(() {});
                },
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Constants.black,
                ),
              ),
              hintText: '',
            ),
            SizedBox(height: 4.w),
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2.w),
            DefaultTextField2(
              onChanged: (value) {
                _confirmPassword = value;
                setState(() {});
              },
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return 'Enter valid password'.tr;
                } else if (value.trim() != _password!.trim()) {
                  return 'Password and confirm password\nshould be same'.tr;
                }
                return null;
              },
              obscureText: showCPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  showCPassword = showCPassword ? false : true;
                  setState(() {});
                },
                icon: Icon(
                  showCPassword ? Icons.visibility : Icons.visibility_off,
                  color: Constants.black,
                ),
              ),
              hintText: '',
            ),
            SizedBox(height: 12.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryButton(
                    title: "Update Password",
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

  String? _validatePassword(String value) {
    // Check if password length is at least 6 characters
    if (value.length < 6) {
      return 'Password must be at least 6 characters'.tr;
    }

    // Check if password contains at least one special character
    const pattern = r'^(?=.*?[!@#\$&*~]).{6,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Password must contain at least\none special character'.tr;
    }

    // Check if password contains any spaces
    if (value.contains(' ')) {
      return 'Password cannot contain spaces'.tr;
    }

    return null; // Return null to indicate no validation errors
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
        final userController = Get.find<UserController>();

        final phone = userController.userData.value.number;

        Map payload = {
          "number": phone!.trim(),
          "newPassword": _password,
          "confirmPassword": _password
        };

        final result = await AuthRepo().updatePassword(payload);
        // Get.back();
        context.pop();

        if (result.status == true) {
          await analytics.logEvent(name: "password_update");

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
