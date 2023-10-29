import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/gesturedetector_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/default_text_field_2.dart';
import 'package:coucou_v2/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateAddressScreen extends StatelessWidget {
  static const routeName = '/updateAddress';

  const UpdateAddressScreen({super.key});

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
            icon: Icon(
              Icons.arrow_back,
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
    return Column(
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
          enabled: false,
          onChanged: (value) {},
          maxLines: 3,
          validator: (String? value) {
            // if (value!.trim().isEmpty) {
            //   return 'enter_valid_password'.tr;
            // }
            return null;
          },
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
          onChanged: (value) {},
          maxLines: 3,
          validator: (String? value) {
            // if (value!.trim().isEmpty) {
            //   return 'enter_valid_password'.tr;
            // }
            return null;
          },
          hintText: '',
        ),
        SizedBox(height: 12.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SecondaryButton(title: "Update Address", onTap: () {}),
          ],
        ),
      ],
    );
  }
}
