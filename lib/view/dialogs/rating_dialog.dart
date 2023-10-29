import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const LOGO = 'assets/icons/coucouimage.png';
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.only(top: 4.w, left: 8.w, right: 8.w, bottom: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              LOGO,
              height: 10.h,
              width: 10.h,
            ),
            Text(
              "Enjoying Cou Cou!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Constants.textColor,
                fontWeight: FontWeight.w700,
                fontFamily: "Inika",
              ),
            ),
            Text(
              "Tap a star to rate it on the\nApp Store",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Constants.textColor,
                fontFamily: "Inika",
              ),
            ),
            SizedBox(height: 4.w),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Constants.primaryColor,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
