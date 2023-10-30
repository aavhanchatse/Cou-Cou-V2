import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/decorated_input_border.dart';
import 'package:coucou_v2/utils/hex_color_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';

class StyleUtil {
  static BoxDecoration defaultBoxDecoration() {
    return BoxDecoration(
      color: Constants.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Constants.primaryBorderColor, width: 1),
      boxShadow: [StyleUtil.textFieldShadow()],
    );
  }

  static BoxDecoration defaultBoxDecoration2() {
    return BoxDecoration(
      color: Constants.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Constants.black, width: 1),
    );
  }

  static BoxDecoration defaultBoxDecoration3() {
    return BoxDecoration(
      color: Constants.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Constants.primaryBorderColor, width: 1),
      boxShadow: [StyleUtil.textFieldShadow()],
    );
  }

  static List<BoxShadow> primaryShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        offset: const Offset(0, 12),
        blurRadius: 24,
        spreadRadius: 0,
      )
    ];
  }

  static List<BoxShadow> uploadButtonShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.35),
        offset: const Offset(-2, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> buttonshadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.35),
        offset: const Offset(2, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Constants.black.withOpacity(0.5),
        blurRadius: 6,
        offset: const Offset(2, 2),
      ),
    ];
  }

  static BoxShadow textFieldShadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(-2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    );
  }

  static BoxShadow shadow2() {
    return BoxShadow(
      color: Constants.black.withOpacity(0.5),
      blurRadius: 6,
      offset: const Offset(0, 0),
    );
  }

  static BoxShadow shadow3() {
    return BoxShadow(
      color: Constants.black.withOpacity(0.8),
      blurRadius: 6,
      spreadRadius: 2,
      offset: const Offset(0, 0),
    );
  }

  static List<BoxShadow> jobCardShadow() {
    return [
      BoxShadow(color: HexColor('C7C7DE').withOpacity(0.5), blurRadius: 8)
    ];
  }

  static primaryTextFieldDecoration({String? hintText, Widget? prefix}) {
    return InputDecoration(
      prefixIcon: prefix,
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
      hintText: hintText,
      hintStyle: TextStyle(color: Constants.primaryGrey),
      fillColor: Constants.white,
      filled: true,
      focusedBorder: primaryOutlineInputBorderLight(),
      enabledBorder: primaryOutlineInputBorderLight(),
      border: primaryOutlineInputBorderLight(),
      errorBorder: primaryOutlineInputBorderLight(),
      disabledBorder: primaryOutlineInputBorderLight(),
    );
  }

  static primaryDropDownDecoration({
    String? hintText,
    Widget? prefix,
    String? labelText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Constants.white,
      labelText: labelText,
      labelStyle: TextStyle(color: Constants.primaryGrey, fontSize: 15),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.w),
      focusedBorder: StyleUtil.defaultTextFieldBorder(),
      enabledBorder: StyleUtil.defaultTextFieldBorder(),
      border: StyleUtil.defaultTextFieldBorder(),
      errorBorder: StyleUtil.defaultTextFieldBorder(),
      disabledBorder: StyleUtil.defaultTextFieldBorder(),
    );
  }

  static primaryDropDownDecoration2({
    String? hintText,
    Widget? prefix,
    String? labelText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Constants.white,
      labelText: labelText,
      labelStyle: TextStyle(color: Constants.primaryGrey, fontSize: 15),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.w),
      focusedBorder: StyleUtil.defaultTextFieldBorder2(),
      enabledBorder: StyleUtil.defaultTextFieldBorder2(),
      border: StyleUtil.defaultTextFieldBorder2(),
      errorBorder: StyleUtil.defaultTextFieldBorder2(),
      disabledBorder: StyleUtil.defaultTextFieldBorder2(),
    );
  }

  static defaultTextFieldBorder() {
    return DecoratedInputBorder(
      child: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Constants.primaryBorderColor, width: 1),
      ),
      shadow: StyleUtil.textFieldShadow(),
    );
  }

  static defaultTextFieldBorder2() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Constants.black, width: 1),
    );
  }

  static defaultCommentTextFieldBorder() {
    return DecoratedInputBorder(
      child: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        borderSide: BorderSide(color: Constants.white, width: 1),
      ),
      shadow: StyleUtil.textFieldShadow(),
    );
  }

  static primaryOutlineInputBorderLight() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }

  static formTextFieldInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Constants.primaryGrey),
    );
  }
}
