import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/image_utility.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:coucou_v2/view/dialogs/prize_image_view_dialgo.dart';
import 'package:coucou_v2/view/screens/challenge/all_challenges_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/search/search_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/select_image_screen_2.dart';
import 'package:coucou_v2/view/widgets/post_card.dart';
import 'package:coucou_v2/view/widgets/reels_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_manager/photo_manager.dart';
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
  List<PostData> top5Post = [];

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _fab(),
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return LiquidPullToRefresh(
      onRefresh: _onRefresh,
      backgroundColor: Constants.primaryColor,
      showChildOpacityTransition: false,
      color: Constants.secondaryColor.withOpacity(0.2),
      child: InViewNotifierList(
        controller: _scrollController,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        initialInViewIds: const ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount: mainPost.isEmpty ? 2 : mainPost.length + 2,
        builder: (BuildContext context, int index) {
          if (index == 0) {
            return _banner();
          }
          if (index == 1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 4.w),
              child: _latestPostWidget(),
            );
          }

          final item = mainPost[index - 2];

          return mainPost.isEmpty ? const SizedBox() : _postItem(index, item);
        },
      ),
    );
  }

  Widget _postItem(int index, PostData item) {
    return InViewNotifierWidget(
      id: '$index',
      builder: (
        BuildContext context,
        bool isInView,
        Widget? child,
      ) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.5.w),
          child: PostCard(
            isInView: isInView,
            postData: item,
          ),
        );
      },
    );
  }

  Widget _bodyWithoutInView() {
    return LiquidPullToRefresh(
      onRefresh: _onRefresh,
      backgroundColor: Constants.primaryColor,
      showChildOpacityTransition: false,
      color: Constants.secondaryColor.withOpacity(0.2),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _banner(),
            _latestPostWidget(),
            SizedBox(height: 4.w),
            if (mainPost.isNotEmpty)
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                // padding: EdgeInsets.symmetric(horizontal: 4.w),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = mainPost[index];

                  return PostCard(postData: item);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 0.5.w);
                },
                itemCount: mainPost.length,
              )
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.w, bottom: 4.w),
          height: 15.w,
          width: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: Constants.white,
            boxShadow: StyleUtil.cardShadow(),
          ),
        ),
        _uploadPostButton(),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Constants.white,
      leading: IconButton(
        onPressed: () async {
          await analytics.logEvent(name: "challenge_details_back_button");

          final userController = Get.find<UserController>();

          await analytics.logEvent(
            name: "home_click_event",
            parameters: {
              "home_clicks": "back button tapped",
              "username": userController.userData.value.username ??
                  "not logged in user",
              "mobile_num":
                  userController.userData.value.number ?? "not logged in user",
              "gender":
                  userController.userData.value.gender ?? "not logged in user",
              "dob": userController.userData.value.dob.toString(),
              // "home_values": rating.toString(),
              // "content_details": item.challengeData?.challengeName,
              // "content_posted_by": item.userSingleData!.id!,
              // "content_posted_date": item.createdAt,
              // "username": item.userSingleData!.username,
              // "mobile_num": item.userSingleData!.number,
              // "gender": item.userSingleData!.gender,
              // "dob": item.userSingleData!.dob,
            },
          );

          final navbarController = Get.find<NavbarController>();
          navbarController.currentIndex.value = 1;
          context.go(NavBar.routeName);
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
    );
  }

  Widget _banner() {
    return (bannerLoading == false && challengeData != null)
        ? Column(
            children: [
              _infoVideosCarousel(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await analytics.logEvent(
                          name: "all_challenge_button_clicked");

                      context.push(AllChallengesScreen.routeName);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.w, top: 2.w),
                      child: Text(
                        "view_challenge".tr,
                        style: TextStyle(
                          color: Constants.black,
                          height: 1,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _uploadPostButton() {
    return Positioned.fill(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final userController = Get.find<UserController>();

              if (userController.userData.value.username != null &&
                  userController.userData.value.username!.isNotEmpty) {
                await analytics.logEvent(name: "post_upload");

                final ps = await PhotoManager.requestPermissionExtend();
                if (ps.isAuth || ps.hasAccess) {
                  final PostController postController =
                      Get.find<PostController>();

                  postController.unselectImages();
                  postController.unselectMusic();
                  postController.unselectVideo();

                  context.push(SelectImageScreen2.routeName);
                } else {
                  return;
                }
              } else {
                context.push(CompleteDetailsScreen.routeName);
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: StyleUtil.uploadButtonShadow(),
                gradient: LinearGradient(
                  colors: [
                    Constants.yellowGradient1,
                    Constants.yellowGradient2,
                  ],
                ),
              ),
              child: Icon(
                Icons.add,
                color: Constants.black,
                size: 40,
              ),
            ),
          ),
          Text(
            "participate_now".tr,
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              // fontSize: 12,
            ),
          ),
        ],
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
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.w),
                  SizedBox(
                    // color: Colors.orange,
                    height: 27.w,
                    width: 100.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: top5Post.map(
                        (item) {
                          final index = topPost
                              .indexWhere((element) => element.id == item.id);

                          // return Container(
                          //   color: Colors.blue,
                          //   height: 27.w,
                          //   width: 15.w,
                          // );
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateToReelView(index);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  // child: Image.network(
                                  //   item.thumbnail ?? "",
                                  //   height: 15.w,
                                  //   width: 15.w,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  child: ImageUtil.networkImage(
                                    imageUrl: item.thumbnail ?? "",
                                    height: 13.w,
                                    width: 13.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.w),
                              SizedBox(
                                // height: 15.w,
                                width: 13.w,
                                child: Column(
                                  children: [
                                    if (item.userSingleData != null)
                                      Text(
                                        item.userSingleData!.firstname ?? "",
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
                        },
                      ).toList(),
                    ),
                    // child: ListView.builder(
                    //   itemCount: 5,
                    //   padding: EdgeInsets.zero,
                    //   scrollDirection: Axis.horizontal,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //     final item = topPost[index];

                    //     return Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             navigateToReelView(index);
                    //           },
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(100),
                    //             // child: Image.network(
                    //             //   item.thumbnail ?? "",
                    //             //   height: 15.w,
                    //             //   width: 15.w,
                    //             //   fit: BoxFit.cover,
                    //             // ),
                    //             child: ImageUtil.networkImage(
                    //               imageUrl: item.thumbnail ?? "",
                    //               height: 13.w,
                    //               width: 13.w,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(height: 2.w),
                    //         SizedBox(
                    //           height: 15.w,
                    //           width: 13.w,
                    //           child: Column(
                    //             children: [
                    //               if (item.userSingleData != null)
                    //                 Text(
                    //                   item.userSingleData!.firstname ?? "",
                    //                   style: TextStyle(
                    //                     color: Constants.black,
                    //                     fontSize: 12,
                    //                   ),
                    //                 ),
                    //               Row(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   Image.asset(
                    //                     "assets/icons/cookie_selected.png",
                    //                     height: 3.w,
                    //                   ),
                    //                   SizedBox(width: 1.w),
                    //                   Text(
                    //                     item.likeCount.toString(),
                    //                     style: TextStyle(
                    //                       color: Constants.black,
                    //                       fontSize: 12,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                    // child: Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 4.w),
                    //   child: Wrap(
                    //     // mainAxisSize: MainAxisSize.max,
                    //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     spacing: 4.w,
                    //     children: topPost.map((item) {
                    //       final index = topPost
                    //           .indexWhere((element) => element.id == item.id);

                    //       return index > 4
                    //           ? const SizedBox()
                    //           : Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 InkWell(
                    //                   onTap: () {
                    //                     navigateToReelView(index);
                    //                   },
                    //                   child: ClipRRect(
                    //                     borderRadius:
                    //                         BorderRadius.circular(100),
                    //                     // child: Image.network(
                    //                     //   item.thumbnail ?? "",
                    //                     //   height: 15.w,
                    //                     //   width: 15.w,
                    //                     //   fit: BoxFit.cover,
                    //                     // ),
                    //                     child: ImageUtil.networkImage(
                    //                       imageUrl: item.thumbnail ?? "",
                    //                       height: 13.w,
                    //                       width: 13.w,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 SizedBox(height: 2.w),
                    //                 // SizedBox(
                    //                 //   height: 15.w,
                    //                 //   width: 13.w,
                    //                 //   child: Column(
                    //                 //     children: [
                    //                 //       if (item.userSingleData != null)
                    //                 //         Text(
                    //                 //           item.userSingleData!.firstname ??
                    //                 //               "",
                    //                 //           style: TextStyle(
                    //                 //             color: Constants.black,
                    //                 //             fontSize: 12,
                    //                 //           ),
                    //                 //         ),
                    //                 //       Row(
                    //                 //         mainAxisSize: MainAxisSize.min,
                    //                 //         children: [
                    //                 //           Image.asset(
                    //                 //             "assets/icons/cookie_selected.png",
                    //                 //             height: 3.w,
                    //                 //           ),
                    //                 //           SizedBox(width: 1.w),
                    //                 //           Text(
                    //                 //             item.likeCount.toString(),
                    //                 //             style: TextStyle(
                    //                 //               color: Constants.black,
                    //                 //               fontSize: 12,
                    //                 //             ),
                    //                 //           ),
                    //                 //         ],
                    //                 //       ),
                    //                 //     ],
                    //                 //   ),
                    //                 // ),
                    //               ],
                    //             );
                    //     }).toList(),
                    //   ),
                    // ),
                  ),
                ],
              );
  }

  void navigateToReelView(int index) async {
    await analytics.logEvent(name: "top_5_post_clicked");

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
      height: 100.w,
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
                child: SizedBox(
                  // color: Colors.blue,
                  // padding: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 100.w,
                  height: 62.w,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: challengeData!.challengeLogo ?? "",
                      // fit: BoxFit.cover,
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
            top5Post.clear();
          }
          topPost.addAll(result.data!);
          for (int i = 0; i < 5 && i < topPost.length; i++) {
            top5Post.add(topPost[i]);
          }

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
