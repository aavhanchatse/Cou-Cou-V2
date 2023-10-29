import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialog {
  static void showOneButtonAlert(
      BuildContext context,
      String title,
      String message,
      String buttonName,
      VoidCallback callback,
      AlertDialogType alterType,
      IconData icon) {
    if (Platform.isIOS) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: callback,
              child: Text(buttonName),
            )
          ],
        ),
      );
    } else {
      showModal(
          context: context,
          configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 600),
            barrierDismissible: false,
          ),
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: _getLightColor(alterType),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Text(title,
                            style: TextStyle(
                                color: _getDarkColor(alterType),
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/cancel.png',
                                width: 12, height: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.black54)),
                        child: Icon(icon, color: _getDarkColor(alterType)),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(message),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(color: Colors.grey[400], height: 1),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: _getDarkColor(alterType),
                            ),
                            onPressed: callback,
                            child: Text(buttonName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
                        const SizedBox(width: 12)
                      ],
                    ),
                  ),
                  const SizedBox(height: 6)
                ],
              ),
            );
          });
    }
  }

  static Future showTwoButtonAlert(
      BuildContext context,
      String title,
      String message,
      String positiveButtonName,
      VoidCallback positiveButtonCallback,
      String negativeButtonName,
      VoidCallback negativeButtonCallback,
      AlertDialogType alterType,
      IconData icon) {
    if (Platform.isIOS) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
                onPressed: negativeButtonCallback,
                child: Text(negativeButtonName)),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: positiveButtonCallback,
                child: Text(positiveButtonName)),
          ],
        ),
      );
    } else {
      return showModal(
          context: context,
          configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 600),
            barrierDismissible: false,
          ),
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _getLightColor(alterType),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Text(title,
                            style: TextStyle(
                                color: _getDarkColor(alterType),
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.black54)),
                        child: Icon(icon, color: _getDarkColor(alterType)),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(message),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(color: Colors.grey[400], height: 1),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: negativeButtonCallback,
                            child: Text(negativeButtonName,
                                style: TextStyle(
                                    color: _getDarkColor(alterType),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
                        const SizedBox(width: 8),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: _getDarkColor(alterType),
                            ),
                            onPressed: positiveButtonCallback,
                            child: Text(positiveButtonName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
                        const SizedBox(width: 12)
                      ],
                    ),
                  ),
                  const SizedBox(height: 6)
                ],
              ),
            );
          });
    }
  }

  static Future showAlertWithTextField(
    BuildContext context,
    String title,
    String message,
    String positiveButtonName,
    VoidCallback positiveButtonCallback,
    String negativeButtonName,
    VoidCallback negativeButtonCallback,
    AlertDialogType alterType,
    IconData icon,
    VoidCallback Function(String text) onChangedCallback,
  ) {
    if (Platform.isIOS) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
            child: TextField(
              onChanged: onChangedCallback,
              decoration: InputDecoration(hintText: message),
            ),
          ),
          actions: [
            CupertinoDialogAction(
                onPressed: negativeButtonCallback,
                child: Text(negativeButtonName)),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: positiveButtonCallback,
                child: Text(positiveButtonName)),
          ],
        ),
      );
    } else {
      return showModal(
          context: context,
          configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 600),
            barrierDismissible: false,
          ),
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: _getLightColor(alterType),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Text(title,
                            style: TextStyle(
                                color: _getDarkColor(alterType),
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/cancel.png',
                                width: 12, height: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.black54)),
                        child: Icon(icon, color: _getDarkColor(alterType)),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 20, top: 10),
                          child: TextField(
                            onChanged: onChangedCallback,
                            decoration: InputDecoration(hintText: message),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(color: Colors.grey[400], height: 1),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: negativeButtonCallback,
                            child: Text(negativeButtonName,
                                style: TextStyle(
                                    color: _getDarkColor(alterType),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
                        const SizedBox(width: 8),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: _getDarkColor(alterType),
                            ),
                            onPressed: positiveButtonCallback,
                            child: Text(positiveButtonName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
                        const SizedBox(width: 12)
                      ],
                    ),
                  ),
                  const SizedBox(height: 6)
                ],
              ),
            );
          });
    }
  }

  static _getLightColor(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.success:
        return const Color(0xffC2E3CE);
      case AlertDialogType.fail:
        return const Color(0xffF2CDC8);
      case AlertDialogType.normal:
        return const Color(0xffF5DDC2);
    }
  }

  static _getDarkColor(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.success:
        return const Color(0xff008C31);
      case AlertDialogType.fail:
        return const Color(0xffC72C1C);
      case AlertDialogType.normal:
        return const Color(0xffD87400);
    }
  }
}

enum AlertDialogType { success, fail, normal }
