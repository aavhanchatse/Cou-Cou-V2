import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeLineWidget extends StatefulWidget {
  const TimeLineWidget({super.key});

  @override
  State<TimeLineWidget> createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  final controller = Get.find<HomescreenController>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // controller.mainPostListPage.value = 1;
    controller.getHomeScreenMainPostList();

    // _scrollController.addListener(() {
    //   if (_scrollController.offset >=
    //       _scrollController.position.maxScrollExtent) {
    //     // if (controller.mainPostList.isNotEmpty) {
    //     if (controller.mainPostList.length >=
    //         (15 * controller.mainPostListPage.value)) {
    //       controller.mainPostListPage.value++;

    //       controller.getHomeScreenMainPostList().then((value) {
    //         setState(() {});
    //       });
    //     }
    //     // }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.mainPostLoading.value == true &&
              controller.mainPostListPage.value == 1
          ? const SizedBox()
          : controller.mainPostList.isEmpty
              ? const SizedBox()
              // : InViewNotifierList(
              //     padding: EdgeInsets.symmetric(horizontal: 4.w),
              //     // controller: _scrollController,
              //     // scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     initialInViewIds: const ['0'],
              //     // physics: const BouncingScrollPhysics(),
              //     isInViewPortCondition: (
              //       double deltaTop,
              //       double deltaBottom,
              //       double viewPortDimension,
              //     ) {
              //       return deltaTop < (0.5 * viewPortDimension) &&
              //           deltaBottom > (0.5 * viewPortDimension);
              //     },
              //     itemCount: controller.mainPostList.length,
              //     builder: (BuildContext context, int index) {
              //       return InViewNotifierWidget(
              //         id: '$index',
              //         builder: (
              //           BuildContext context,
              //           bool isInView,
              //           Widget? child,
              //         ) {
              //           final item = controller.mainPostList[index];
              //           return Padding(
              //             padding: EdgeInsets.only(bottom: 4.w),
              //             child: PostCard(
              //               isInView: isInView,
              //               postData: item,
              //             ),
              //           );
              //         },
              //       );
              //     },
              //   );

              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.symmetric(horizontal: 4.w),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = controller.mainPostList[index];

                    return PostCard(postData: item);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 6.w);
                  },
                  itemCount: controller.mainPostList.length,
                );
    });
  }
}
