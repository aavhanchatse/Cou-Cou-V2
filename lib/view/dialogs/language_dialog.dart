import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  int _selectedLanguage = 0;

  @override
  void initState() {
    super.initState();
    var result = StorageManager().getData("language");
    if (result != null) {
      if (result == "en") {
        _selectedLanguage = 0;
      } else if (result == "hi") {
        _selectedLanguage = 1;
      } else if (result == "mr") {
        _selectedLanguage = 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 3.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.w, bottom: 4.h),
                child: Text(
                  "Select Language",
                  style:
                      TextStyle(fontSize: 1.9.t, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _lanButtonWidget("English", () async {
                    StorageManager().setData("language", "en");
                    Get.updateLocale(const Locale("en"));
                    setState(() {
                      _selectedLanguage = 0;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    context.pop();
                  }, _selectedLanguage == 0),
                  _lanButtonWidget("हिंदी", () async {
                    StorageManager().setData("language", "hi");
                    Get.updateLocale(const Locale("hi"));
                    setState(() {
                      _selectedLanguage = 1;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    context.pop();
                  }, _selectedLanguage == 1),
                  _lanButtonWidget("मराठी", () async {
                    StorageManager().setData("language", "mr");
                    Get.updateLocale(const Locale("mr"));
                    setState(() {
                      _selectedLanguage = 2;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    context.pop();
                  }, _selectedLanguage == 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lanButtonWidget(String title, VoidCallback onTap, bool isSelected) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? Constants.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 1.8.t),
            )
          ],
        ),
      ),
    );
  }
}
