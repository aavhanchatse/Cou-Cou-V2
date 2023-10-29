import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeletePostDialog extends StatelessWidget {
  final String text;
  const DeletePostDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Constants.textColor,
                fontWeight: FontWeight.w700,
                fontFamily: "Inika",
              ),
            ),
            SizedBox(height: 4.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    context.pop(true);
                  },
                  child: Container(
                    width: 20.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.w),
                    decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ]),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Constants.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inika",
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    width: 20.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.w),
                    decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: StyleUtil.buttonshadow(),
                    ),
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Constants.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inika",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
