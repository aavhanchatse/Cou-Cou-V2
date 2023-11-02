import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/prize_image_view_dialgo.dart';
import 'package:coucou_v2/view/screens/challenge/all_challenges_screen.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final controller = Get.find<HomescreenController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getHomeScreenBanners();
    setAnalytics();
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'home_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.bannerLoading.value == true
          ? const SizedBox()
          : controller.bannerList.isEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    _infoVideosCarousel(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.push(AllChallengesScreen.routeName);
                          },
                          child: Text(
                            "view_all".tr,
                            style: TextStyle(
                              color: Constants.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
    });
  }

  Widget _priceWidget(BuildContext context, ChallengeData item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 2.w),
            _priceContainer(item.rewardsPrize!.first, item, "1st_prize".tr),
            SizedBox(width: 2.w),
            _priceContainer(item.rewardsPrize![1], item, "2nd_prize".tr),
            SizedBox(width: 2.w),
            _priceContainer(item.rewardsPrize![2], item, "3rd_prize".tr),
            SizedBox(width: 2.w),
          ],
        ),
      ],
    );
  }

  void successDialog(
      BuildContext context, RewardsPrize prize, ChallengeData item) async {
    await analytics.logEvent(name: "prize_image_clicked");

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return PrizeImageViewDialog(prize: prize, challengeData: item);
        });
  }

  Widget _priceContainer(RewardsPrize prize, ChallengeData item, String text) {
    return Expanded(
      child: Container(
        height: 32.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Constants.white,
          boxShadow: StyleUtil.cardShadow(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                // context.push(
                //   DismissPage.routeName,
                //   extra: {
                //     "initialIndex": 0,
                //     "imageList": [prize.link],
                //     "isVideo": false
                //   },
                // );
                successDialog(context, prize, item);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  prize.link ?? "",
                  height: 15.w,
                  width: 15.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 2.w),
            Text(
              text,
              style: TextStyle(
                color: Constants.black,
              ),
            ),
            Text(
              prize.name ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Constants.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoVideosCarousel(BuildContext context) {
    return SizedBox(
      height: 88.w,
      child: CarouselSlider.builder(
        itemCount: controller.bannerList.length,
        itemBuilder: (_, index, __) {
          final item = controller.bannerList[index];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  context.push(
                    ChallengeDetailsScreen.routeName,
                    extra: {"id": item.id},
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 100.w,
                  height: 50.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.challengeLogo ?? "",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        width: 10.w,
                        height: 10.w,
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.w),
              _priceWidget(context, item),
            ],
          );
        },
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          viewportFraction: 1.0,
          disableCenter: true,
          initialPage: 0,
          autoPlay: false,
          enableInfiniteScroll: true,
        ),
      ),
    );
  }
}
