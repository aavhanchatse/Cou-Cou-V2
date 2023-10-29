import 'package:coucou_v2/models/user_data.dart';
import 'package:get_storage/get_storage.dart';

class StorageManager {
  final box = GetStorage();

  String SPLASH = 'splash';
  String TOKEN = 'token';
  String USER_PROFILE_PHOTO = 'profile_image';
  String USER_DATA = 'user_data';
  String USER_ID = 'user_id';
  String CURRENT_PLAN_ID = 'current_plan_id';
  String REEL_WATCH_DOG = 'reel_watch_dog';

  void setInroScreenValue() {
    setData(SPLASH, true);
  }

  bool? getIntoScreenValue() {
    bool? value = getData(SPLASH);
    return value;
  }

  void setToken(String token) {
    setData(TOKEN, token);
  }

  String? getToken() {
    String token = getData(TOKEN);
    return token;
  }

  void setUserData(UserData userData) {
    setData(USER_DATA, userData);
    setUserId(userData.id!);
  }

  UserData? getUserData() {
    var data = getData(USER_DATA);
    if (data != null) {
      return UserData.fromJson(data);
    } else {
      return null;
    }
  }

  void setUserId(String id) {
    setData(USER_ID, id);
  }

  void setReelWatchIndex(String reelId, bool isWatched) {
    setData(reelId, isWatched);
  }

  bool getReelWatchIndex(String reelId) {
    bool id = getData(reelId) ?? false;
    return id;
  }

  String getUserId() {
    String id = getData(USER_ID);
    return id;
  }

  void setCurrentPlanId(int id) {
    setData(CURRENT_PLAN_ID, id);
  }

  int getCurrentPlanId() {
    int id = getData(CURRENT_PLAN_ID);
    return id;
  }

  // --------- default functions ---------
  void setData(String key, dynamic value) {
    box.write(key, value);
    box.save();
  }

  dynamic getData(String key) {
    return box.read(key);
  }

  dynamic clearData() {
    box.erase();
  }

  void eraseStorage() async {
    await box.erase();
  }
}
