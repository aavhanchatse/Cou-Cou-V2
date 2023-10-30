import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/widgets/reels_page_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ReelsPageView extends StatefulWidget {
  final List<PostData> postList;
  final int? initialIndex;

  const ReelsPageView(
      {super.key, required this.postList, this.initialIndex = 0});

  @override
  State<ReelsPageView> createState() => _ReelsPageViewState();
}

class _ReelsPageViewState extends State<ReelsPageView> {
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(
        initialPage: widget.initialIndex ?? 0, viewportFraction: 1);
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
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.postList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final item = widget.postList[index];

          return ReelsPageViewWidget(item: item);
        },
      ),
    );
  }
}
