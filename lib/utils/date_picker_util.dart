import 'package:coucou_v2/app_constants/constants.dart';
import 'package:flutter/material.dart';

class DatePickerUtil {
  static Future<DateTime?> getMaterialDatePicker(BuildContext context,
      [bool? showFuture = false]) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: showFuture == true
            ? DateTime.now()
            : DateTime(DateTime.now().year - 8),
        firstDate: DateTime(1900),
        lastDate: showFuture == true
            ? DateTime(2050)
            : DateTime(DateTime.now().year - 8),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Constants.primaryColor,
              colorScheme: ColorScheme.light(primary: Constants.primaryColor),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });

    return date;
  }
}
