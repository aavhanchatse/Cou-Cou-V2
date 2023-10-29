import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/widgets/custom_outline_button.dart';
import 'package:coucou_v2/view/widgets/default_text_field.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/primary_button.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/resetPassword';

  final String phoneNumber;
  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final LOGO = 'assets/images/login_screen_images/logo.png';

  String? _password;
  String? _confirmPassword;

  bool hide1 = false;
  bool hide2 = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                _logo(),
                SizedBox(height: 3.h),
                _mainBody(),
                // SizedBox(height: 7.h),
                // _bottomLine(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Made with ',
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.favorite,
          color: Constants.red2,
          size: 20,
        ),
        Text(
          ' by Cou Cou',
          style: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _mainBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.w),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Constants.white,
        boxShadow: [StyleUtil.textFieldShadow()],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Reset Password'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 2.2.t,
              ),
            ),
            SizedBox(height: 4.h),
            _passwordTextField(),
            SizedBox(height: 4.w),
            _confirmPasswordTextField(),
            SizedBox(height: 4.h),
            CustomOutlineButton(onTap: _continue, title: "Submit".tr),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                "Back",
                style: TextStyle(
                  color: Constants.black,
                  fontSize: 16,
                ),
              ),
            )
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

  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _password = value;
            setState(() {});
          },
          // validator: (String? value) {
          //   if (value!.trim().isEmpty) {
          //     return 'enter_valid_password'.tr;
          //   }
          //   return null;
          // },
          obscureText: hide1,
          suffixIcon: IconButton(
            onPressed: () {
              hide1 = !hide1;
              setState(() {});
            },
            icon:
                Icon(hide1 == false ? Icons.visibility_off : Icons.visibility),
          ),
          validator: _validatePassword,
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _confirmPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm Password",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _confirmPassword = value;
            setState(() {});
          },
          obscureText: hide2,
          suffixIcon: IconButton(
            onPressed: () {
              hide2 = !hide2;
              setState(() {});
            },
            icon:
                Icon(hide2 == false ? Icons.visibility_off : Icons.visibility),
          ),
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter valid password'.tr;
            } else if (value.trim() != _password!.trim()) {
              return 'Password and confirm password\nshould be same'.tr;
            }
            return null;
          },
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          height: 20.h,
          width: 20.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Constants.white,
            boxShadow: [StyleUtil.shadow2()],
          ),
          child: Image.asset(LOGO),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Cou-Cou!',
          style: TextStyle(
            fontSize: 3.5.t,
            fontFamily: "Inika",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
        Map payload = {
          "number": widget.phoneNumber.trim(),
          "newPassword": _password,
          "confirmPassword": _password
        };

        final result = await AuthRepo().updatePassword(payload);
        // Get.back();
        context.pop();

        if (result.status == true) {
          context.push(LoginScreen.routeName);
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
