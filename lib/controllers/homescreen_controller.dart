import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/models/challenge_name_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/internet_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomescreenController extends GetxController {
  var bannerLoading = true.obs;
  var bannerList = <ChallengeData>[].obs;

  var topPostLoading = true.obs;
  var topPostList = <PostData>[].obs;
  var topPostListPage = 1.obs;

  var mainPostLoading = true.obs;
  var mainPostList = <PostData>[].obs;
  var mainPostListPage = 1.obs;

  var allChallengeNames = <ChallengeNameData>[].obs;

  void getHomeScreenBanners() async {
    bannerLoading.value = true;
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getHomeScreenBanner();
        if (result.status == true && result.data != null) {
          bannerList.value = result.data!;
        } else {
          debugPrint('something went wrong');
        }
        bannerLoading.value = false;
      } catch (error) {
        debugPrint('error: $error');
        bannerLoading.value = false;
      }
    } else {
      bannerLoading.value = false;
    }
  }

  void getHomeScreenLatestPost() async {
    topPostLoading.value = true;
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result =
            await PostRepo().getHomeScreenTopPost(topPostListPage.value);
        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          if (topPostListPage.value == 1) {
            topPostList.clear();
          }
          topPostList.addAll(result.data!);
        } else {
          debugPrint('something went wrong');
        }
        topPostLoading.value = false;
      } catch (error) {
        debugPrint('error: $error');
        topPostLoading.value = false;
      }
    } else {
      topPostLoading.value = false;
    }
  }

  Future<void> getHomeScreenMainPostList() async {
    mainPostLoading.value = true;
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result =
            await PostRepo().getHomeScreenMainPostList(mainPostListPage.value);

        if (result.status == true &&
            result.data != null &&
            result.data!.isNotEmpty) {
          final userController = Get.find<UserController>();

          await analytics.logEvent(name: "home_click_event", parameters: {
            "home_clicks": "Scroll Depth",
            "home_values": mainPostListPage.value,
            "username": userController.userData.value.username,
            "mobile_num": userController.userData.value.number,
            "gender": userController.userData.value.gender,
            "dob": userController.userData.value.dob.toString(),
          });

          if (mainPostListPage.value == 1) {
            mainPostList.clear();
          }
          mainPostList.addAll(result.data!);
        } else {
          debugPrint('something went wrong');
        }
        mainPostLoading.value = false;
      } catch (error) {
        debugPrint('error: $error');
        mainPostLoading.value = false;
      }
    } else {
      mainPostLoading.value = false;
    }
  }

  void getAllChallengeNames() async {
    final isInternet = await InternetUtil.isInternetConnected();

    if (isInternet) {
      try {
        final result = await PostRepo().getAllChallengeNames();
        if (result.status == true && result.data != null) {
          allChallengeNames.value = result.data!;
        } else {
          debugPrint('something went wrong');
        }
      } catch (error) {
        debugPrint('error: $error');
      }
    } else {}
  }
}
