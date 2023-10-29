import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/screens/login/otp_screen.dart';
import 'package:coucou_v2/view/widgets/custom_outline_button.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberOTPScreen extends StatefulWidget {
  static const routeName = '/phoneNumberOTP';

  final bool register;

  const PhoneNumberOTPScreen({super.key, required this.register});

  @override
  State<PhoneNumberOTPScreen> createState() => _PhoneNumberOTPScreenState();
}

class _PhoneNumberOTPScreenState extends State<PhoneNumberOTPScreen> {
  final formKey = GlobalKey<FormState>();

  final LOGO = 'assets/images/login_screen_images/logo.png';

  String? _phone;

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
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Constants.white,
          boxShadow: [StyleUtil.textFieldShadow()],
        ),
        child: Column(
          children: [
            Text(
              widget.register == true
                  ? "Mobile Verification".tr
                  : 'Mobile Verification'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Inika",
                fontSize: 2.2.t,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              widget.register == true
                  ? "Enter Phone Number".tr
                  : "Enter Phone Number".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4.h),
            _phoneNumberTextField(),
            SizedBox(height: 4.h),
            CustomOutlineButton(onTap: _continue, title: "Send OTP".tr),
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

  Widget _phoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone number",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _phone = value;
            setState(() {});
          },
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter Valid Number'.tr;
            } else if (value.trim().length < 10) {
              return 'Enter Valid Number'.tr;
            }
            return null;
          },
          hintText: ''.tr,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          prefixIcon: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('+91')],
          ),
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

    // check if user exists in our database

    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await AuthRepo().checkUser(_phone!.trim());

        context.pop();

        // SnackBarUtil.showSnackBar(result.message!, context: context);

        if (widget.register == false && result.status == true) {
          debugPrint('inside first');

          context.push(
            OTPScreen.routeName,
            extra: {
              "register": widget.register,
              "phoneNumber": _phone,
            },
          );
        } else if (widget.register == true && result.status == false) {
          debugPrint('inside second');

          context.push(
            OTPScreen.routeName,
            extra: {
              "register": widget.register,
              "phoneNumber": _phone,
            },
          );
        } else {
          debugPrint('inside third');
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
        // SnackBarUtil.showSnackBar(result.message!);
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
