import 'package:coucou_v2/app_constants/constants.dart';
import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Constants.pageBackgroundLight,
    primaryColor: Constants.primaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Constants.primaryColor,
    ),
    // iconTheme: IconThemeData(color: Constant.generalBlack),
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Playfair Display',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Playfair Display',
        ),

    // textTheme: TextTheme(
    //   bodyText1: TextStyle(color: Constant.textColor),
    //   bodyText2: TextStyle(color: Constant.textColor),
    // ),
    // cardTheme: CardTheme(color: Constant.lightPrimaryColor),
    // cardColor: Constant.generalBlack.withOpacity(0.7),
    // backgroundColor: Constant.drawerRectangleCard,
    // buttonColor: Constant.colorPrimary,
    // canvasColor: Constant.generalWhite,
    // secondaryHeaderColor: Constant.lightPrimaryColor,
    // bannerTheme:
    //     MaterialBannerThemeData(backgroundColor: Constant.drawerRectangleCard),
    // dialogBackgroundColor: Constant.otpBoxFillLightColor,
    // colorScheme: const ColorScheme.light(),
  );
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Constants.pageBackgroundLight,
    primaryColor: Constants.primaryColor,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Constants.primaryColor),
    // iconTheme: IconThemeData(color: Constant.generalWhite),
    // textTheme: TextTheme(
    //   bodyText1: TextStyle(color: Constant.whiteText),
    //   bodyText2: TextStyle(color: Constant.whiteText),
    // ),
    // cardTheme: CardTheme(color: Constant.darkPrimaryColor),
    // cardColor: Constant.darkPrimaryColor,
    // backgroundColor: Constant.darkPrimaryColor,
    // buttonColor: Constant.generalWhite,
    // canvasColor: Constant.darkPrimaryColor,
    // bannerTheme:
    //     MaterialBannerThemeData(backgroundColor: Constant.colorPrimary),
    // secondaryHeaderColor: Constant.scaffoldDark,
    // dialogBackgroundColor: Constant.darkPrimaryColor,
    // colorScheme: const ColorScheme.dark(),
  );
}
