import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AppBarUtil {
  static const HOTEL_JOBS_LOGO = "assets/images/logos/hj_logo_horizontal.png";

  static defaultAppBar({bool automaticallyImplyLeading = true}) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Image.asset(HOTEL_JOBS_LOGO),
        ),
      ),
      backgroundColor: Colors.transparent,
      // backgroundColor: Constants.white,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: IconButton(
        onPressed: () {
          // Get.back();
        },
        icon: Icon(
          Icons.chevron_left,
          color: Constants.black,
        ),
      ),
    );
  }

  // static primaryAppBar(
  //     {bool? showActions = true, String? title, bool? inPlans = false}) {
  //   UserController userController = Get.find<UserController>();

  //   return AppBar(
  //     title: showActions == false
  //         ? Text(
  //             title!,
  //             style: TextStyle(
  //               fontSize: 20,
  //               color: Constants.textColor,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           )
  //         : Image.asset(HOTEL_JOBS_LOGO, height: 32),
  //     automaticallyImplyLeading: showActions == false ? true : false,
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     leading: showActions == true
  //         ? null
  //         : InkWell(
  //             onTap: () {
  //               Get.back();
  //             },
  //             child: Container(
  //               margin: EdgeInsets.all(3.w),
  //               decoration: BoxDecoration(
  //                 color: Constants.white,
  //                 borderRadius: BorderRadius.circular(2.w),
  //                 boxShadow: StyleUtil.cardShadow(),
  //               ),
  //               child: Icon(
  //                 Icons.chevron_left,
  //                 color: Constants.black,
  //               ),
  //             ),
  //           ),
  //     actions: showActions == false
  //         ? null
  //         : [
  //             // IconButton(
  //             //   onPressed: () {},
  //             //   icon: Icon(
  //             //     Icons.notifications,
  //             //     color: Constants.primaryColor,
  //             //   ),
  //             // ),
  //             IconButton(
  //               onPressed: () {
  //                 showProfileDialog();
  //               },
  //               icon: Icon(
  //                 Icons.more_vert,
  //                 color: Constants.grey,
  //               ),
  //             ),
  //           ],
  //     bottom: PreferredSize(
  //       preferredSize: const Size.fromHeight(30),
  //       child: Padding(
  //         padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 3.w),
  //         child: Obx(
  //           () => Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               InkWell(
  //                 onTap: inPlans == true
  //                     ? null
  //                     : () {
  //                         Get.to(() => const PlansAndPricingScreen());
  //                       },
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 4.w,
  //                       width: 4.w,
  //                       decoration: BoxDecoration(
  //                         color: userController.currentPlanId.value != 0
  //                             ? Constants.green
  //                             : Constants.red1,
  //                         borderRadius: BorderRadius.circular(100),
  //                       ),
  //                     ),
  //                     SizedBox(width: 2.w),
  //                     userController.currentPlanId.value != 0
  //                         ? Text(
  //                             'Plan Active',
  //                             style: TextStyle(fontSize: 12),
  //                           )
  //                         : Text(
  //                             'Plan Inactive',
  //                             style: TextStyle(fontSize: 12),
  //                           )
  //                   ],
  //                 ),
  //               ),
  //               Row(
  //                 children: [
  //                   Container(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
  //                     decoration: BoxDecoration(
  //                       color: Constants.grey4,
  //                       borderRadius: BorderRadius.circular(2),
  //                     ),
  //                     child:
  //                         userController.employerData.value.totalContactCount ==
  //                                 null
  //                             ? Text(
  //                                 '0',
  //                                 style: TextStyle(
  //                                   color: Constants.textWhite,
  //                                 ),
  //                               )
  //                             : Text(
  //                                 "${userController.employerData.value.totalContactCount - userController.employerData.value.viewContactCount}",
  //                                 style: TextStyle(
  //                                   color: Constants.textWhite,
  //                                 ),
  //                               ),
  //                   ),
  //                   SizedBox(width: 2.w),
  //                   Text(
  //                     'BALANCE\nCONTACTS',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 10),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
