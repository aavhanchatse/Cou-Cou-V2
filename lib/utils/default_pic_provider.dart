import 'package:cached_network_image/cached_network_image.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DefaultPicProvider {
  // static const _colors = [
  //   Color(0xffD87400),
  //   Color(0xff0057A0),
  //   Color(0xff008C31),
  //   Color(0xffC72C1C),
  //   Color(0xff008B80),
  //   Color(0xff201E56),
  //   Color(0xffB33771),
  // ];

  // static const _lightColorList = [
  //   Color(0xffF5DDC2),
  //   Color(0xffC2D7E8),
  //   Color(0xffC2E3CE),
  //   Color(0xffF2CDC8),
  //   Color(0xffC2E3E0),
  //   Color(0xffCAC9D6),
  //   Color(0xffEDCFDD),
  // ];

  static Widget getCircularUserProfilePic(
      {required String? profilePic,
      required String userName,
      required double size,
      fontSize = 19.0,
      borderRadius = 100.0}) {
    if (profilePic != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Constants.white),
          // boxShadow: StyleUtil.cardShadow(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: profilePic,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: SpinKitChasingDots(
                  color: Constants.primaryColor,
                  size: 28,
                ),
              ),
            ),
            errorWidget: (context, url, error) => getDefaultProfilePic(
              userName,
              size,
              fontSize,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );
    } else {
      return getDefaultProfilePic(userName, size, fontSize,
          borderRadius: borderRadius);
    }
  }

  static Widget getDefaultProfilePic(String text, double size, double fontSize,
      {borderRadius = 100.0}) {
    String displayName = getDisplayText(text);
    // var position = displayName.hashCode % _lightColorList.length;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Constants.pageBackgroundLight,
        boxShadow: StyleUtil.primaryShadow(),
        // color: _lightColorList[position],
      ),
      child: Center(
        child: Text(
          displayName.toUpperCase(),
          style: TextStyle(
            color: Constants.textColor,
            // color: _colors[position],
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  static String getDisplayText(String text) {
    if (text.isNotEmpty) {
      var textArray = text.split(" ");
      if (textArray.length > 1) {
        String sortName = textArray[0].isNotEmpty ? textArray[0][0] : "";
        sortName += textArray[1].isNotEmpty ? textArray[1][0] : "";
        return sortName;
      } else if (textArray.isNotEmpty) {
        String sortName = textArray[0][0];
        sortName += textArray[0].length > 1 ? textArray[0][1] : "";
        return sortName;
      } else {
        return "";
      }
    }
    return "";
  }
}
