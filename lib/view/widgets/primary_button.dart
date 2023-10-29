import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  const PrimaryButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Constants.primaryColor,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Constants.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
