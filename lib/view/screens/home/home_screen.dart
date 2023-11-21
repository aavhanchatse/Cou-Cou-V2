import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/home/widgets/banner_widget.dart';
import 'package:coucou_v2/view/screens/home/widgets/latest_post.dart';
import 'package:coucou_v2/view/screens/home/widgets/timeline_widget.dart';
import 'package:coucou_v2/view/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final controller = Get.find<HomescreenController>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.mainPostListPage.value = 1;

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (controller.mainPostList.isNotEmpty) {
          // if (controller.mainPostList.length >=
          //     (15 * controller.mainPostListPage.value)) {
          callApiAgain();
          // }
        }
      }
    });
  }

  void callApiAgain() {
    controller.mainPostListPage.value++;

    controller.getHomeScreenMainPostList().then((value) {
      setState(() {});
    });
  }

  Future<void> _onRefresh() async {
    controller.mainPostListPage.value = 1;

    controller.getHomeScreenBanners();
    controller.getHomeScreenLatestPost();
    controller.getHomeScreenMainPostList();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        title: InkWell(
          onTap: () {},
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
        actions: [
          IconButton(
            onPressed: () {
              context.push(SearchScreen.routeName);
            },
            icon: Icon(
              Icons.search,
              color: Constants.black,
              size: 32,
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
              const BannerWidget(),
              const LatestPostWidget(),
              SizedBox(height: 8.w),
              const TimeLineWidget(),
              SizedBox(height: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}
