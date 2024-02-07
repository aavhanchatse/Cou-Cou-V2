import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/widgets/reels_page_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ReelsPageView extends StatefulWidget {
  // final List<PostData> postList;
  final int? initialIndex;
  final bool latest;
  final String? id;
  final bool? singlePost;

  const ReelsPageView({
    super.key,
    // required this.postList,
    this.initialIndex = 0,
    required this.latest,
    this.id,
    this.singlePost = false,
  });

  @override
  State<ReelsPageView> createState() => _ReelsPageViewState();
}

class _ReelsPageViewState extends State<ReelsPageView> {
  late PageController _pageController;

  List<PostData> list = [];
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.singlePost == false) {
      getData();
    }

    _pageController = PageController(
        initialPage: widget.initialIndex ?? 0, viewportFraction: 1);

    setAnalytics();
  }

  void getData() {
    if (widget.latest == true) {
      getHomeScreenLatestPost();
    } else {
      getTopPost();
    }
  }

  void getHomeScreenLatestPost() async {
    // topPostLoading.value = true;
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getHomeScreenTopPost(page);
        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          if (page == 1) {
            list.clear();
          }
          list.addAll(result.data!);
          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        // topPostLoading.value = false;
      } catch (error) {
        debugPrint('error: $error');
        // topPostLoading.value = false;
      }
    } else {
      // topPostLoading.value = false;
    }
  }

  void getTopPost() async {
    // topLoading = true;
    // setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getChallengeTopPost(page, widget.id!);

        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          if (page == 1) {
            list.clear();
          }
          list.addAll(result.data!);

          setState(() {});
        } else {
          debugPrint('something went wrong');
        }
        // topLoading = false;
        // setState(() {});
      } catch (error) {
        debugPrint('error: $error');

        // topLoading = false;
        // setState(() {});
      }
    } else {
      // topLoading = false;
      // setState(() {});
    }
  }

  void setAnalytics() async {
    await analytics.setCurrentScreen(screenName: 'reels_screen');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        centerTitle: true,
        title: InkWell(
          onTap: () {
            final navbarController = Get.find<NavbarController>();
            navbarController.currentIndex.value = 1;
            context.go(NavBar.routeName);
          },
          child: Text(
            "Cou Cou!",
            style: TextStyle(
              color: Constants.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: "Inika",
            ),
          ),
        ),
      ),
      body: list.isEmpty
          ? const SizedBox()
          : PageView.builder(
              controller: _pageController,
              itemCount: list.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index == list.length - 2 && widget.singlePost == false) {
                  page++;
                  getData();
                }

                final item = list[index];

                return ReelsPageViewWidget(item: item);
              },
            ),
    );
  }
}
