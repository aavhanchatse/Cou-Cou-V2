import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/user_repo.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserData> userData = UserData().obs;
  var followingList = <UserData>[].obs;
  RxString token = ''.obs;
  // var addressList = <AddressData>[].obs;

  var newNotification = false.obs;
  var orderNotification = false.obs;
  var chatNotification = false.obs;
  var videoMute = true.obs;

  void getUserDataById() async {
    final userId = StorageManager().getUserId();

    final SuperResponse<UserData?> result =
        await UserRepo().getUserDataById(userId);

    if (result.data != null) {
      setValues(result.data!);
    }
  }

  void setValues(UserData result) {
    userData.value = result;
    StorageManager().setUserData(result);
  }

  // void getUserAddress([bool? refresh = true]) async {
  //   if (refresh == true) {
  //     ProgressDialog.showProgressDialog(Get.context!);
  //   }

  //   final isInternet = await InternetUtil.isInternetConnected();

  //   if (isInternet) {
  //     try {
  //       final result = await UserRepo().getUserAddress();
  //       if (refresh == true) {
  //         Get.back();
  //       }

  //       if (result.status == true && result.data != null) {
  //         addressList.clear();
  //         addressList.addAll(result.data!);
  //       } else {
  //         SnackBarUtil.showSnackBar(result.message!);
  //       }
  //     } catch (error) {
  //       if (refresh == true) {
  //         Get.back();
  //       }
  //       // SnackBarUtil.showSnackBar('Something went wrong');
  //       debugPrint('error: $error');
  //     }
  //   } else {
  //     if (refresh == true) {
  //       Get.back();
  //     }
  //     SnackBarUtil.showSnackBar('No Internet Connected');
  //   }
  // }
}
