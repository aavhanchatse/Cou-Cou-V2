import 'package:flutter/cupertino.dart';

class SizeConfig {
  SizeConfig._();

  // static MediaQueryData _mediaQueryData;

  static double? screenHeight;
  static double? screenWidth;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  // static double _safeAreaHorizontal;
  // static double _safeAreaVertical;
  // static double safeBlockHorizontal;
  // static double safeBlockVertical;

  static void init(BoxConstraints constraints, Orientation orientation) {
    // _mediaQueryData = MediaQuery.of(Get.context);

    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;

      // _safeAreaHorizontal =
      //     _mediaQueryData.padding.left + _mediaQueryData.padding.right;
      // _safeAreaVertical =
      //     _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    } else {
      screenHeight = constraints.maxWidth;
      screenWidth = constraints.maxHeight;

      // _safeAreaVertical =
      //     _mediaQueryData.padding.left + _mediaQueryData.padding.right;
      // _safeAreaHorizontal =
      //     _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    }
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    // safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    // safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double setSp(num size) => size * blockSizeVertical!;
  static double setHeight(num size) => size * blockSizeVertical!;
  static double setWidth(num size) => size * blockSizeHorizontal!;

  // static double setSafeSp(num size) => size * safeBlockVertical;
  // static double setSafeHeight(num size) => size * safeBlockVertical;
  // static double setSafeWidth(num size) => size * safeBlockHorizontal;
}

extension SizeExtensionInteger on num {
  double get t => SizeConfig.setSp(this);
  double get h => SizeConfig.setHeight(this);
  double get w => SizeConfig.setWidth(this);
}
