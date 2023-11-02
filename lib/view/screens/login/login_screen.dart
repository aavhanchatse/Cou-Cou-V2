import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/device_info_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/screens/login/phone_number_otp_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/widgets/custom_outline_button.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final LOGO = 'assets/images/login_screen_images/logo.png';

  String? _phone;
  String? _password;
  bool showPassword = true;

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
                SizedBox(height: 1.h),
                _mainBody(),
                SizedBox(height: 22.h),
                // const Spacer(),
                _bottomLine(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomLine() {
    return Text(
      'Eng(UK)  हिन्दी  मराठी',
      style: TextStyle(
        color: Constants.textColor,
      ),
    );
  }

  Widget _mainBody() {
    return Container(
      padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 4.w, bottom: 4.w),
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
            _signUpButton(),
            SizedBox(height: 2.w),
            _phoneNumberTextField(),
            SizedBox(height: 2.w),
            _passwordTextField(),
            SizedBox(height: 4.w),
            CustomOutlineButton(onTap: _login, title: "login".tr),
            _forgotPasswordButton(),
            // _googleFacebookLogin(),
          ],
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        context.push(PhoneNumberOTPScreen.routeName, extra: true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${"new_user".tr}?",
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Inika",
              fontSize: 16,
            ),
          ),
          Text(
            " ${"sign_up".tr}",
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Inika",
              decoration: TextDecoration.underline,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: () {
        context.push(PhoneNumberOTPScreen.routeName, extra: false);
      },
      child: Text(
        '${"forgot_password".tr} ?',
        style: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.bold,
          fontFamily: "Inika",
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "password".tr,
          style: const TextStyle(
            fontSize: 16,
            // fontFamily: "Inika",
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          // obscureText: showPassword,
          // suffixIcon: InkWell(
          //   onTap: () {
          //     showPassword = showPassword ? false : true;
          //     setState(() {});
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(right: 2.w),
          //     child: Icon(
          //       showPassword ? Icons.remove_red_eye : Icons.visibility_off,
          //       color: Constants.black,
          //     ),
          //   ),
          // ),
          obscureText: true,
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'enter_valid_password'.tr;
            }
            return null;
          },
          onChanged: (value) {
            _password = value;
            setState(() {});
          },
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _phoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "phone_number".tr,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Inika",
            fontWeight: FontWeight.bold,
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
              return 'enter_valid_mobile'.tr;
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
          height: 17.h,
          width: 17.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Constants.white,
            boxShadow: [StyleUtil.shadow3()],
          ),
          child: Image.asset(LOGO),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Cou Cou!',
          style: TextStyle(
            fontSize: 3.5.t,
            fontFamily: "Inika",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _login() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      //try {
      final deviceId = await DeviceInfoUtil.getDeviceId();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      debugPrint('deviceId: $deviceId');
      debugPrint('fcmToken: $fcmToken');

      Map payload = {
        'number': _phone!.trim(),
        'password': _password!.trim(),
        "deviceId": deviceId,
        "FCMToken": fcmToken,
      };

      final result = await AuthRepo().loginUser(payload);
      // Get.back();
      context.pop();

      if (result.status == true) {
        _storeData(result.data!, result.token!);

        context.go(NavBar.routeName);
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

  void _storeData(UserData userData, String token) {
    StorageManager().setToken(token);
    StorageManager().setUserData(userData);
  }
}
