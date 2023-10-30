import 'package:cached_network_image/cached_network_image.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrizeImageViewDialog extends StatelessWidget {
  final RewardsPrize prize;
  final ChallengeData challengeData;

  const PrizeImageViewDialog({
    super.key,
    required this.prize,
    required this.challengeData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Constants.green1,
            ),
            height: 20.h,
            // width: 20.h,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  height: double.infinity,
                  width: double.infinity,
                  imageUrl: prize.link ?? "",
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.cancel,
                color: Constants.white,
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  challengeData.challengeName ?? "",
                  style: TextStyle(
                    color: Constants.white,
                  ),
                ),
                Text(
                  "Prize: ${prize.price ?? ""}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Constants.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
