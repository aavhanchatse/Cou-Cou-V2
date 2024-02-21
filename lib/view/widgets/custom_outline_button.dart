import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const CustomOutlineButton(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Constants.white,
          border: Border.all(
            color: Constants.black,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Inika",
          ),
        ),
      ),
    );
  }
}
