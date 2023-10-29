import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/home/widgets/banner_widget.dart';
import 'package:coucou_v2/view/screens/home/widgets/latest_post.dart';
import 'package:coucou_v2/view/screens/home/widgets/timeline_widget.dart';
import 'package:coucou_v2/view/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BannerWidget(),
            const LatestPostWidget(),
            SizedBox(height: 4.w),
            const TimeLineWidget(),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }
}
