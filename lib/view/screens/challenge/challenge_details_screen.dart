import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/prize_image_view_dialgo.dart';
import 'package:coucou_v2/view/screens/challenge/all_challenges_screen.dart';
import 'package:coucou_v2/view/screens/search/search_screen.dart';
import 'package:coucou_v2/view/widgets/post_card.dart';
import 'package:coucou_v2/view/widgets/reels_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  static const routeName = '/challengeDetails';

  final String challengeId;

  const ChallengeDetailsScreen({
    super.key,
    required this.challengeId,
  });

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  bool bannerLoading = true;

  bool topLoading = true;
  List<PostData> topPost = [];

  bool mainLoading = true;
  List<PostData> mainPost = [];

  ChallengeData? challengeData;

  int page = 1;
  int topPostPage = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getChallengeBanner();
    getTopPost();
    getMainPost();
    setAnalytics();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (mainPost.isNotEmpty) {
          // if (controller.mainPostList.length >=
          //     (15 * controller.mainPostListPage.value)) {
          page++;

          getMainPost();
          // }
        }
      }
    });
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'challenge_details');
  }

  Future<void> _onRefresh() async {
    page = 1;

    getChallengeBanner();
    getTopPost();
    getMainPost();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: ImageIcon(
            const AssetImage("assets/icons/back_arrow.png"),
            color: Constants.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(SearchScreen.routeName);
            },
            icon: Icon(
              Icons.search,
              color: Constants.black,
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: _onRefresh,
        backgroundColor: Constants.primaryColor,
        showChildOpacityTransition: false,
        color: Constants.secondaryColor.withOpacity(0.2),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              if (bannerLoading == false && challengeData != null) ...[
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
              _latestPostWidget(),
              SizedBox(height: 4.w),
              if (mainPost.isNotEmpty)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = mainPost[index];

                    return PostCard(postData: item);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 6.w);
                  },
                  itemCount: mainPost.length,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _latestPostWidget() {
    return topLoading == true
        ? const SizedBox()
        : topPost.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "top_5_post".tr,
                          style: TextStyle(
                            color: Constants.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.w),
                  SizedBox(
                    height: 27.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Wrap(
                        spacing: 4.w,
                        children: topPost.map((item) {
                          final index = topPost
                              .indexWhere((element) => element.id == item.id);

                          return index > 4
                              ? const SizedBox()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await analytics.logEvent(
                                            name: "top_5_post_clicked");

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReelsPageView(
                                              // postList: topPost,
                                              initialIndex: index,
                                              latest: false,
                                              id: widget.challengeId,
                                              // loadNextData: () {
                                              //   topPostPage++;
                                              //   getTopPost();
                                              // },
                                            ),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 15.w,
                                        width: 15.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            item.thumbnail ?? "",
                                            height: 15.w,
                                            width: 15.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2.w),
                                    SizedBox(
                                      height: 15.w,
                                      child: Column(
                                        children: [
                                          if (item.userSingleData != null)
                                            Text(
                                              item.userSingleData!.firstname ??
                                                  "",
                                              style: TextStyle(
                                                color: Constants.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/icons/cookie_selected.png",
                                                height: 3.w,
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                item.likeCount.toString(),
                                                style: TextStyle(
                                                  color: Constants.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
  }

  Widget _priceWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 2.w),
            _priceContainer(challengeData!.rewardsPrize!.first, challengeData!,
                "1st_prize".tr),
            SizedBox(width: 2.w),
            _priceContainer(challengeData!.rewardsPrize![1], challengeData!,
                "2nd_prize".tr),
            SizedBox(width: 2.w),
            _priceContainer(challengeData!.rewardsPrize![2], challengeData!,
                "3rd_prize".tr),
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
                // context.push(DismissPage.routeName, extra: {
                //   "initialIndex": 0,
                //   "imageList": [prize.link],
                //   "isVideo": false
                // });
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
      height: 42.h,
      child: CarouselSlider.builder(
        itemCount: 1,
        itemBuilder: (_, index, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // context.push(
                  //   ChallengeDetailsScreen.routeName,
                  //   extra: challengeData!.id,
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 100.w,
                  height: 50.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: challengeData!.challengeLogo ?? "",
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
              if (challengeData!.rewardsPrize != null &&
                  challengeData!.rewardsPrize!.isNotEmpty)
                _priceWidget(context),
            ],
          );
        },
        options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          viewportFraction: 1.0,
          disableCenter: true,
          initialPage: 0,
          autoPlay: false,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

  void getChallengeBanner() async {
    bannerLoading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getChallengeBanner(widget.challengeId);

        if (result.status == true && result.data != null) {
          challengeData = result.data!;

          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        bannerLoading = false;
        setState(() {});
      } catch (error) {
        debugPrint('error: $error');

        bannerLoading = false;
        setState(() {});
      }
    } else {
      bannerLoading = false;
      setState(() {});
    }
  }

  void getTopPost() async {
    topLoading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo()
            .getChallengeTopPost(topPostPage, widget.challengeId);

        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          if (topPostPage == 1) {
            topPost.clear();
          }
          topPost.addAll(result.data!);

          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        topLoading = false;
        setState(() {});
      } catch (error) {
        debugPrint('error: $error');

        topLoading = false;
        setState(() {});
      }
    } else {
      topLoading = false;
      setState(() {});
    }
  }

  void getMainPost() async {
    mainLoading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result =
            await PostRepo().getChallengeMainPostList(page, widget.challengeId);

        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          if (page == 1) {
            mainPost.clear();
          }

          mainPost.addAll(result.data!);

          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        mainLoading = false;
        setState(() {});
      } catch (error) {
        debugPrint('error: $error');

        mainLoading = false;
        setState(() {});
      }
    } else {
      mainLoading = false;
      setState(() {});
    }
  }
}
