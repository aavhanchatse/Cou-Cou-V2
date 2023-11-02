import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
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
        title: Text(
          "all_challenges".tr,
          style: TextStyle(
            color: Constants.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: "Inika",
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
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
                      onTap: () {
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
