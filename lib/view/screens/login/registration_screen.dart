import 'dart:io';
import 'dart:math';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/repo/auth_repo.dart';
import 'package:coucou_v2/utils/date_picker_util.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/device_info_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/location_util.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/bottomsheets/select_image_source_bottomsheet.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/widgets/custom_outline_button.dart';
import 'package:coucou_v2/view/widgets/default_container.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/image_cropper_screen.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/register';

  final String phoneNumber;

  const RegistrationScreen({super.key, required this.phoneNumber});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  var emailTextController = TextEditingController();

  List<String> genderList = ['Male', 'Female', 'Other'];

  bool showPassword = true;
  bool showCPassword = true;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _userName;
  String? _phone;
  String? _gender;
  String? _dob;
  String? _password;
  String? _confirmPassword;
  File? _profileImage;
  double? _latitude;
  double? _longitude;
  String? _city;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phone = widget.phoneNumber;

    setState(() {});
    // _getLocation();
    setAnalytics();
  }

  void setAnalytics() async {
    // await analytics.setCurrentScreen(screenName: 'sign_up_page_visit');
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  void _getLocation() async {
    final Position? location = await LocationUtils.getCurrentLocation();

    if (location != null) {
      _latitude = location.latitude;
      _longitude = location.longitude;

      final Placemark? placemark =
          await LocationUtils.getLocationFromCoordinates(location);

      if (placemark != null) {
        _city = placemark.locality;
      }
    }
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
              'New User'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4.h),
            // _userImage(),
            // SizedBox(height: 4.w),
            _nameContainer(),
            SizedBox(height: 3.w),
            _emailTextField(),
            SizedBox(height: 3.w),
            _userNameTextField(),
            SizedBox(height: 3.w),
            _phoneNumberTextField(),
            SizedBox(height: 3.w),
            _genderAndDobContainer(),
            SizedBox(height: 3.w),
            _passwordTextField(),
            SizedBox(height: 3.w),
            _confirmPasswordTextField(),
            SizedBox(height: 7.h),
            CustomOutlineButton(onTap: _continue, title: "Sign In".tr),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _nameContainer() {
    return Row(
      children: [
        Expanded(child: _fNameTextField()),
        SizedBox(width: 2.w),
        Expanded(child: _lNameTextField()),
      ],
    );
  }

  Widget _fNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "First Name",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Inika",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _firstName = value;
            setState(() {});
          },
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$')),
          ],
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter Valid Name'.tr;
            }
            return null;
          },
          textCapitalization: TextCapitalization.words,
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _lNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Last Name",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$')),
          ],
          onChanged: (value) {
            _lastName = value;
            setState(() {});
          },
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter valid last name'.tr;
            }
            return null;
          },
          textCapitalization: TextCapitalization.words,
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          textEditingController: emailTextController,
          onChanged: (value) {
            _email = value;
            setState(() {});
          },
          validator: (value) =>
              EmailValidator.validate(value) ? null : "Enter valid email".tr,
          keyboardType: TextInputType.emailAddress,
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _userNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _userName = value;
            setState(() {});
          },
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter valid username'.tr;
            }
            return null;
          },
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _genderAndDobContainer() {
    return Row(
      children: [
        Expanded(child: _genderDropDown()),
        SizedBox(width: 2.w),
        Expanded(child: _dobContainer()),
      ],
    );
  }

  Widget _genderDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: StyleUtil.primaryDropDownDecoration2(
              labelText: "".tr,
            ),
            menuMaxHeight: 300.0,
            dropdownColor: Constants.white,
            borderRadius: BorderRadius.circular(16),
            value: _gender,
            icon: const Icon(Icons.arrow_drop_down),
            items: genderList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (String? value) {
              if (value == null) {
                return "select_gender".tr;
              }
              return null;
            },
            onChanged: (String? newValue) {
              _gender = newValue!;
            },
          ),
        ),
      ],
    );
  }

  Widget _dobContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date of Birth",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        InkWell(
          onTap: _showDatePicker,
          child: SizedBox(
            width: double.infinity,
            child: DefaultContainer(
              child: Text(
                _dob != null ? _dob! : 'DOB',
                style: TextStyle(
                  color: _dob != null ? Constants.black : Constants.primaryGrey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    FocusManager.instance.primaryFocus!.unfocus();

    _materialDatePicker();
  }

  void _materialDatePicker() async {
    DateTime? date = await DatePickerUtil.getMaterialDatePicker(context);
    if (date != null) {
      _dob = DateUtil.getServerFormatDateString(date);
      setState(() {});
    }
  }

  String? _validatePassword(String value) {
    // Check if password length is at least 6 characters
    if (value.length < 6) {
      return '6_letter_password'.tr;
    }

    // Check if password contains at least one special character
    const pattern = r'^(?=.*?[!@#\$&*~]).{6,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'password_must_contain_special_character'.tr;
    }

    // Check if password contains any spaces
    if (value.contains(' ')) {
      return 'password_cannot_have_space'.tr;
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
            fontWeight: FontWeight.bold,
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
          validator: _validatePassword,
          // validator: (String? value) {
          //   if (value!.trim().isEmpty) {
          //     return 'enter_valid_password'.tr;
          //   }
          //   return null;
          // },
          obscureText: showPassword,
          suffixIcon: InkWell(
            onTap: () {
              showPassword = showPassword ? false : true;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: Icon(
                showPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Constants.black,
              ),
            ),
          ),
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
            fontWeight: FontWeight.bold,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          onChanged: (value) {
            _confirmPassword = value;
            setState(() {});
          },
          obscureText: showCPassword,
          suffixIcon: InkWell(
            onTap: () {
              showCPassword = showCPassword ? false : true;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: Icon(
                showCPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Constants.black,
              ),
            ),
          ),
          validator: (String? value) {
            if (value!.trim().isEmpty) {
              return 'Enter valid password'.tr;
            } else if (value.trim() != _password!.trim()) {
              return 'password_and_confirm_password_error'.tr;
            }
            return null;
          },
          hintText: ''.tr,
        ),
      ],
    );
  }

  Widget _userImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [StyleUtil.textFieldShadow()],
              color: Constants.white,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 15.h,
            width: 15.h,
            child: _profileImage != null
                ? ClipOval(
                    child: Image.file(_profileImage!, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.person,
                    color: Constants.primaryGrey,
                    size: 80,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                openImagePickerDialog();
              },
              icon: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: StyleUtil.primaryShadow(),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: Constants.black,
                ),
              ),
            ),
          ),
        ],
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
            fontWeight: FontWeight.bold,
            fontFamily: "Inika",
          ),
        ),
        SizedBox(height: 2.w),
        DefaultTextField2(
          enabled: false,
          initialValue: widget.phoneNumber,
          onChanged: (value) {
            // _phone = value;
            // setState(() {});
          },
          hintText: ''.tr,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: const Text(
              'Verified',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          prefixIcon: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('+91')],
          ),
        ),
      ],
    );
  }

  void openImagePickerDialog() async {
    final XFile? filePath = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0))),
        builder: (builder) {
          return const SelectImageSourceBottomsheet();
        });

    if (filePath != null) {
      final Uint8List bytes = await filePath.readAsBytes();
      final croppedImage =
          await context.push(CropImagePage.routeName, extra: bytes);

      if (croppedImage != null) {
        final File finalImage =
            await ImageUtil.saveImageToTempStorage(croppedImage as Uint8List);

        _profileImage = finalImage;
        setState(() {});
      }
    }
  }

  Future<String>? _uploadFile() async {
    String random = getRandomString(3);

    String date = DateUtil.getChatDisplayDate(DateTime.now());

    var filePath = 'Profile_${Constants.ENVIRONMENT}/$date/$random';

    final downloadUrl = await S3Util.uploadFileToAws(_profileImage!, filePath);

    debugPrint('downloadUrl: $downloadUrl');

    return downloadUrl!;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void _continue() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    ProgressDialog.showProgressDialog(context);
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        // String? imageUrl;

        // if (_profileImage != null) {
        //   imageUrl = await _uploadFile();
        // }

        final deviceId = await DeviceInfoUtil.getDeviceId();
        final fcmToken = await FirebaseMessaging.instance.getToken();

        debugPrint('deviceId: $deviceId');
        debugPrint('fcmToken: $fcmToken');

        Map payload = {
          "number": widget.phoneNumber,
          "firstname": _firstName,
          "lastname": _lastName,
          "username": _userName,
          "DOB": _dob,
          "password": _password,
          "location": {
            "type": _city ?? "",
            "coordinates": [_latitude, _longitude]
          },
          "FCMToken": fcmToken,
          "deviceId": deviceId,
          "email": _email,
          "gender": _gender,
          "imageUrl": "",
        };

        final result = await AuthRepo().signUp(payload);
        // Get.back();
        context.pop();

        if (result.status == true) {
          // await analytics.logEvent(name: "registration");

          context.go(LoginScreen.routeName);
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
