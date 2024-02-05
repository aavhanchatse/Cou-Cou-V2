import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/screens/login/registration_screen.dart';
import 'package:coucou_v2/view/screens/login/reset_password_screen.dart';
import 'package:coucou_v2/view/widgets/custom_outline_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/enterOTP';

  final String phoneNumber;
  final bool? register;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    this.register = false,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final LOGO = 'assets/images/login_screen_images/logo.png';

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
    verifyPhone();
    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'otp_screen');
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
      padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 2.w),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Constants.white,
        boxShadow: [StyleUtil.textFieldShadow()],
      ),
      child: Column(
        children: [
          Text(
            'mobile_verification'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 2.2.t,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '${"phone_no".tr}\n+91 ${widget.phoneNumber}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'otp'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          _pinCodeField(),
          SizedBox(height: 1.h),
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
              title: "verify".tr),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "back".tr,
              style: TextStyle(
                color: Constants.black,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
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
    codeSent(String verificationId, [int? forceResendingToken]) async {
      actualCode = verificationId;
      debugPrint('Code sent to ${widget.phoneNumber}');
      SnackBarUtil.showSnackBar("Enter the code sent to ${widget.phoneNumber}",
          context: context);
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

    debugPrint("OTP send start +91${widget.phoneNumber}");

    return firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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

    if (widget.register == true) {
      context.pushReplacement(RegistrationScreen.routeName,
          extra: widget.phoneNumber);
    } else {
      context.pushReplacement(ResetPasswordScreen.routeName,
          extra: widget.phoneNumber);
    }
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
            boxShadow: [StyleUtil.shadow2()],
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
}
