import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/repo/user_repo.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

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

  bool codeIsSent = false;

  String? _otp = '';
  bool hasError = false;

  var firebaseAuth = FirebaseAuth.instance;
  String? actualCode;
  ConfirmationResult? _confirmationResult;
  AuthCredential? _authCredential;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'login');
  }

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
            // _signUpButton(),
            SizedBox(height: 2.w),
            _phoneNumberTextField(),
            // SizedBox(height: 2.w),
            // _passwordTextField(),
            SizedBox(height: 4.w),
            if (codeIsSent == false)
              CustomOutlineButton(
                onTap: verifyPhone,
                title: "verify".tr,
              ),

            if (codeIsSent == true) ...[
              Text(
                'otp'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 1.h),
              _pinCodeField(),
              SizedBox(height: 4.w),
              CustomOutlineButton(
                onTap: () {
                  if (_otp!.length == 6) {
                    _signInWithPhoneNumber(_otp!);
                    // _goToPasswordSetupPage();
                  } else {
                    SnackBarUtil.showSnackBar('enter_correct_otp'.tr,
                        context: context);
                  }
                },
                title: "login".tr,
              ),
            ],
            // _forgotPasswordButton(),
            // _googleFacebookLogin(),
          ],
        ),
      ),
    );
  }

  void _signInWithPhoneNumber(String smsCode) async {
    _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode!, smsCode: smsCode);

    debugPrint('authCredentials: $_authCredential');

    firebaseAuth.signInWithCredential(_authCredential!).catchError((error) {
      debugPrint('error in signing with creds: $error');

      SnackBarUtil.showSnackBar('enter_correct_otp'.tr, context: context);
    }).then((result) {
      debugPrint('result : $result');

      if (result.user != null) _goToPasswordSetupPage();
    });
  }

  void _goToPasswordSetupPage() async {
    await analytics.logEvent(name: "otp_validated");

    // call the new login api and navigate to navbar
    _login2();
  }

  void _login2() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (_otp == null || _otp!.length < 6) {
      SnackBarUtil.showSnackBar("enter_valid_otp".tr, context: context);
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
        "deviceId": deviceId,
        "FCMToken": fcmToken,
      };

      final result = await UserRepo().getUserDataByIdLogin(payload);
      // Get.back();
      // context.pop();

      if (result.status == true) {
        _storeData(result.data!, result.token!);
        await analytics.logEvent(name: "user_logged_in");

        debugPrint("navigating user to navbar");
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

  Widget _pinCodeField() => Center(
        child: PinFieldAutoFill(
          decoration: BoxLooseDecoration(
            textStyle: TextStyle(fontSize: 3.t, color: Colors.black),
            strokeColorBuilder: FixedColorBuilder(Constants.primaryGrey),
            gapSpace: 2.w,
          ),
          currentCode: _otp,
          onCodeSubmitted: (code) {
            debugPrint("CODE RETRIEVED = $code");
            setState(() {
              _otp = code;
            });
            // _signInWithPhoneNumber(_otp!);
          },
          codeLength: 6,
          onCodeChanged: (code) {
            setState(() {
              _otp = code;
            });

            // if (code!.length == 6) {
            //   debugPrint('code; $code');
            //   _signInWithPhoneNumber(code);
            // }
          },
        ),
      );

  Future<void> verifyPhone() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      actualCode = verificationId;
      debugPrint('Code sent to $_phone');
      SnackBarUtil.showSnackBar("Enter the code sent to $_phone",
          context: context);

      codeIsSent = true;
      setState(() {});
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // actualCode = verificationId;

      debugPrint("Firebase otp auto retrive time out");
    }

    verificationFailed(authException) {
      debugPrint("authException.message: ${authException.message}");

      if (authException.message!.contains('not authorized')) {
        SnackBarUtil.showSnackBar('Something has gone wrong, please try later',
            context: context);
      } else if (authException.message!.contains('Network')) {
        SnackBarUtil.showSnackBar(
            'Please check your internet connection and try again',
            context: context);
      } else {
        SnackBarUtil.showSnackBar('Something has gone wrong, please try later',
            context: context);
      }
    }

    verificationCompleted(AuthCredential auth) {
      debugPrint('Auto retrieving verification code');
      // _authCredential = auth;
      // firebaseAuth.signInWithCredential(_authCredential!).then((value) {
      //   if (value.user != null) {
      //     _goToPasswordSetupPage();
      //   } else {
      //     SnackBarUtil.showSnackBar('Invalid OTP');
      //   }
      // }).catchError((error) {
      //   SnackBarUtil.showSnackBar('Something has gone wrong, please try later');
      // });
    }

    debugPrint("OTP send start +91$_phone");

    return firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91$_phone",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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
              fontSize: 16,
            ),
          ),
          Text(
            " ${"sign_up".tr}",
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.bold,
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
            //
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "mobile_number".tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.w),
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
      // context.pop();

      if (result.status == true) {
        _storeData(result.data!, result.token!);
        await analytics.logEvent(name: "user_logged_in");

        debugPrint("navigating user to navbar");
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
