import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/utils/date_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/reels_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LatestPostWidget extends StatefulWidget {
  const LatestPostWidget({super.key});

  @override
  State<LatestPostWidget> createState() => _LatestPostWidgetState();
}

class _LatestPostWidgetState extends State<LatestPostWidget> {
  final controller = Get.find<HomescreenController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getHomeScreenLatestPost();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.topPostLoading.value == true
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Latest Posts",
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
                  height: 22.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        children: controller.topPostList.map((item) {
                          final index = controller.topPostList
                              .indexWhere((element) => element.id == item.id);

                          return Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReelsPageView(
                                          postList: controller.topPostList,
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 15.w,
                                    width: 15.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
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
                                Text(
                                  DateUtil.timeAgo(item.createdAt!),
                                  // DateUtil.timeAgo3(item.createdAt!),
                                  style: TextStyle(
                                    color: Constants.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // child: ListView.separated(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.w),
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.horizontal,
                  //   itemBuilder: (context, index) {
                  //     final item = controller.topPostList[index];
                  //     return Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(100),
                  //           child: Image.network(
                  //             item.challengeVideo ?? "",
                  //             height: 15.w,
                  //             width: 15.w,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         SizedBox(height: 2.w),
                  //         Text(
                  //           // DateUtil.timeAgo(item.createdAt!),
                  //           DateUtil.timeAgo2(item.createdAt!),
                  //           style: TextStyle(
                  //             color: Constants.black,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return SizedBox(width: 3.w);
                  //   },
                  //   itemCount: controller.topPostList.length,
                  // ),
                ),
              ],
            );
    });
  }
}
