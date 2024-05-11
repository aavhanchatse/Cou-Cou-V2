import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AllChallengesScreen extends StatefulWidget {
  static const routeName = '/allChallenges';

  const AllChallengesScreen({super.key});

  @override
  State<AllChallengesScreen> createState() => _AllChallengesScreenState();
}

class _AllChallengesScreenState extends State<AllChallengesScreen> {
  bool bannerLoading = true;
  List<ChallengeData> challengeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChallengeBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.white,
        centerTitle: true,
        title: Text(
          "all_challenges".tr,
          style: TextStyle(
            color: Constants.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            final userController = Get.find<UserController>();

            await analytics.logEvent(
              name: "home_click_event",
              parameters: {
                "home_clicks": "back button tapped",
                "username": userController.userData.value.username ??
                    "not logged in user",
                "mobile_num": userController.userData.value.number ??
                    "not logged in user",
                "gender": userController.userData.value.gender ??
                    "not logged in user",
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
      ),
      body: bannerLoading == true
          ? Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            )
          : challengeList.isEmpty
              ? Center(
                  child: Text("no_data_available".tr),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3.w,
                    crossAxisSpacing: 3.w,
                  ),
                  itemCount: challengeList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.w),
                  itemBuilder: (BuildContext context, int index) {
                    final item = challengeList[index];

                    return InkWell(
                      onTap: () async {
                        final userController = Get.find<UserController>();

                        await analytics.logEvent(
                          name: "challenge_clicks",
                          parameters: {
                            "challenge_events":
                                "tap on challenge :${item.challengeName}",
                            // "challenge_events":
                            //     "tap on challenge :${item.challengeName}",
                            "username":
                                userController.userData.value.username ??
                                    "not logged in user",
                            "mobile_num":
                                userController.userData.value.number ??
                                    "not logged in user",
                            "gender": userController.userData.value.gender ??
                                "not logged in user",
                            "dob": userController.userData.value.dob.toString(),
                            // "content_details": item.challengeData?.challengeName,
                            // "content_posted_by": item.userSingleData!.id!,
                            // "content_posted_date": item.createdAt,
                            // "username": item.userSingleData!.username,
                            // "mobile_num": item.userSingleData!.number,
                            // "gender": item.userSingleData!.gender,
                            // "dob": item.userSingleData!.dob,
                          },
                        );

                        context.push(
                          ChallengeDetailsScreen.routeName,
                          extra: {"id": item.id},
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.challengeLogo ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void getChallengeBanner() async {
    bannerLoading = true;
    setState(() {});

    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getAllChallenges();

        if (result.status == true && result.data != null) {
          challengeList = result.data!;

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
}
