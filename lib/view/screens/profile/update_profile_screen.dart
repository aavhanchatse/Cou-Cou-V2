import 'dart:io';

import 'package:camera/camera.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/date_picker_util.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/default_pic_provider.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/s3_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/bottomsheets/select_image_source_bottomsheet.dart';
import 'package:coucou_v2/view/widgets/default_container_2.dart';
import 'package:coucou_v2/view/widgets/default_text_field.dart';
import 'package:coucou_v2/view/widgets/image_cropper_screen.dart';
import 'package:coucou_v2/view/widgets/progress_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const routeName = '/updateUserProfile';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();

  List<String> genderList = ['Male', 'Female', 'Other'];

  File? _profileImage;
  String? _firstName;
  String? _lastName;
  String? _userName;
  String? _bio;
  String? _gender;
  String? _email;
  String? _website;
  String? _dob;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setData();
  }

  void _setData() {
    _firstName = userController.userData.value.firstname;
    _lastName = userController.userData.value.lastname;
    _userName = userController.userData.value.username;
    _bio = userController.userData.value.bio;
    _gender = userController.userData.value.gender;
    _email = userController.userData.value.email;
    _website = userController.userData.value.website;
    _dob =
        DateUtil.getServerFormatDateString(userController.userData.value.dob!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap(context);
      },
      child: Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  _userImage(),
                  SizedBox(height: 4.h),
                  _nameContainer(),
                  SizedBox(height: 4.w),
                  _userNameTextField(),
                  SizedBox(height: 4.w),
                  _bioTextField(),
                  SizedBox(height: 4.w),
                  // _websiteTextField(),
                  // SizedBox(height: 4.w),
                  _dobContainer(),
                  SizedBox(height: 4.w),
                  _emailTextField(),
                  SizedBox(height: 4.w),
                  _genderDropDown(),
                ],
              ),
            ),
          ),
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
    return DefaultTextField(
      initialValue: userController.userData.value.firstname,
      onChanged: (value) {
        _firstName = value;
        setState(() {});
      },
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return 'enter_valid_name'.tr;
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
      hintText: 'firstName'.tr,
    );
  }

  Widget _lNameTextField() {
    return DefaultTextField(
      initialValue: userController.userData.value.lastname,
      onChanged: (value) {
        _lastName = value;
        setState(() {});
      },
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return 'enter_valid_last_name'.tr;
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
      hintText: 'lastName'.tr,
    );
  }

  Widget _userNameTextField() {
    return DefaultTextField(
      enabled: false,
      initialValue: userController.userData.value.username,
      onChanged: (value) {
        _userName = value;
        setState(() {});
      },
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return 'enter_valid_username'.tr;
        }
        return null;
      },
      hintText: 'user_name'.tr,
    );
  }

  Widget _bioTextField() {
    return DefaultTextField(
      initialValue: userController.userData.value.bio,
      onChanged: (value) {
        _bio = value;
        setState(() {});
      },
      hintText: 'bio'.tr,
    );
  }

  Widget _websiteTextField() {
    return DefaultTextField(
      initialValue: userController.userData.value.website,
      onChanged: (value) {
        _website = value;
        setState(() {});
      },
      hintText: 'website'.tr,
    );
  }

  Widget _emailTextField() {
    return DefaultTextField(
      initialValue: userController.userData.value.email,
      onChanged: (value) {
        _email = value;
        setState(() {});
      },
      validator: (value) =>
          EmailValidator.validate(value) ? null : "enter_valid_email".tr,
      keyboardType: TextInputType.emailAddress,
      hintText: 'email'.tr,
    );
  }

  Widget _dobContainer() {
    return InkWell(
      onTap: _showDatePicker,
      child: SizedBox(
        width: double.infinity,
        child: DefaultContainer2(
          child: Text(
            _dob != null ? _dob! : 'DOB',
            style: TextStyle(
              color: _dob != null ? Constants.black : Constants.primaryGrey,
            ),
          ),
        ),
      ),
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

  Widget _genderDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: StyleUtil.primaryDropDownDecoration(
          labelText: "gender".tr,
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
        // validator: (String? value) {
        //   if (value == null) {
        //     return "select_gender".tr;
        //   }
        //   return null;
        // },
        onChanged: (String? newValue) {
          _gender = newValue!;
        },
      ),
    );
  }

  Widget _userImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: StyleUtil.primaryShadow(),
              color: Constants.white,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 12.h,
            width: 12.h,
            child: _profileImage != null
                ? ClipOval(
                    child: Image.file(_profileImage!, fit: BoxFit.cover),
                  )
                : (userController.userData.value.imageUrl != null &&
                        userController.userData.value.imageUrl!.isNotEmpty)
                    ? DefaultPicProvider.getCircularUserProfilePic(
                        profilePic: userController.userData.value.imageUrl,
                        userName:
                            "${userController.userData.value.firstname} ${userController.userData.value.firstname}",
                        size: 80,
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
            child: InkWell(
              onTap: () {
                openImagePickerDialog();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      StyleUtil.textFieldShadow(),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.edit,
                    size: 2.t,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

    debugPrint("filePath: $filePath");

    if (filePath != null) {
      final Uint8List bytes = await filePath.readAsBytes();
      final croppedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropImagePage(imageBytes: bytes),
        ),
      );
      // await context.push(CropImagePage.routeName);
      // await Get.to(() => CropImagePage(imageBytes: bytes));

      final File finalImage =
          await ImageUtil.saveImageToTempStorage(croppedImage);
      _profileImage = finalImage;
      setState(() {});
    }
  }

  Future<String>? _uploadFile() async {
    final currentTimeMillisecond =
        DateTime.now().millisecondsSinceEpoch.toString();

    final userId = StorageManager().getUserId();

    var filePath =
        'Profile_${Constants.ENVIRONMENT}/$userId/$currentTimeMillisecond';

    final downloadUrl = await S3Util.uploadFileToAws(_profileImage!, filePath);

    debugPrint('downloadUrl: $downloadUrl');

    return downloadUrl!;
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Constants.white,
      elevation: 0,
      shadowColor: Colors.grey.withOpacity(0.2),
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: ImageIcon(
          const AssetImage("assets/icons/back_arrow.png"),
          color: Constants.black,
        ),
      ),
      title: Text(
        "Update Profile",
        style: TextStyle(
          color: Constants.textColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _continue();
          },
          child: Text(
            "Save",
            style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
        String? imageUrl;

        if (_profileImage != null) {
          imageUrl = await _uploadFile();
        }

        if (_profileImage == null &&
            userController.userData.value.imageUrl != null) {
          imageUrl = userController.userData.value.imageUrl;
        }

        final userId = StorageManager().getUserId();

        Map payload = {
          "id": userId,
          "firstname": _firstName,
          "lastname": _lastName,
          // "username": _userName,
          "email": _email,
          "gender": _gender,
          "imageUrl": imageUrl,
          "bio": _bio,
          "DOB": _dob,
        };

        final result = await UserRepo().updateUserProfile(payload);
        context.pop();

        if (result.status == true) {
          context.pop();
          await userController.getUserDataById();
          SnackBarUtil.showSnackBar(result.message!, context: context);
        } else {
          SnackBarUtil.showSnackBar(result.message!, context: context);
        }
      } catch (error) {
        context.pop();
        SnackBarUtil.showSnackBar('Something went wrong', context: context);
        debugPrint('error: $error');
      }
    } else {
      context.pop();
      SnackBarUtil.showSnackBar('No Internet Connected', context: context);
    }
  }
}
