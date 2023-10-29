import 'dart:convert';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/api_methods.dart';
import 'package:coucou_v2/utils/device_info_util.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthRepo {
  final API _api = API();

  Future<SuperResponse<UserData?>> loginUser(Map payLoad) async {
    debugPrint('inside login auth repo');

    final response = await _api.postMethod(Constants.login, payLoad);

    Map<String, dynamic> map = (jsonDecode(response.body));
    if (map['status'] == true) {
      var data = map['payload'];
      return SuperResponse<UserData>.fromJson(map, UserData.fromJson(data));
    }
    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<UserData?>> loginUserGoogleOrFacebook(
      Map payLoad) async {
    final response =
        await _api.postMethod(Constants.loginWithGoogleOrFacebook, payLoad);

    Map<String, dynamic> map = (jsonDecode(response.body));
    if (map['status'] == true) {
      var data = map['payload'];
      return SuperResponse<UserData>.fromJson(
          map, data == null ? null : UserData.fromJson(data));
    }
    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> checkUser(String number) async {
    final response =
        await _api.getMethod(Constants.checkUser, {}, "number=$number");

    Map<String, dynamic> map = (jsonDecode(response.body));

    return SuperResponse.fromJson(map, null);
  }

  Future<SuperResponse> signUp(Map payLoad) async {
    final response = await _api.postMethod(Constants.signupUser, payLoad);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  // Future<SuperResponse<String?>> validateOtp(Map payLoad) async {
  //   final response = await _api.postMethod(Constants.verifyOtp, payLoad);

  //   Map<String, dynamic> map = response.body;
  //   if (map['status'] == true) {
  //     return SuperResponse<String>.fromJson(map, map["data"]["uid"].toString());
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<String?>> forgotPassword(Map payLoad) async {
  //   final response = await _api.postMethod(Constants.forgetPassword, payLoad);

  //   Map<String, dynamic> map = response.body;
  //   if (map['status'] == true) {
  //     var uid = map['data']['uid'];
  //     return SuperResponse<String>.fromJson(map, uid?.toString());
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  Future<SuperResponse> updatePassword(Map payload) async {
    final response = await _api.postMethod(Constants.updatePassword, payload);

    Map<String, dynamic> map = jsonDecode(response.body);
    return SuperResponse.fromJson(map);
  }

  // Future<SuperResponse> checkCurrentPassword(String currentPassword) async {
  //   final userId = StorageManager().getUserId();
  //   Map payLoad = {"user_id": userId.toString(), "password": currentPassword};
  //   final response = await _api.postMethod(Constants.checkOldPassword, payLoad);

  //   Map<String, dynamic> map = response.body;
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> changePassword(String newPassword) async {
  //   final userId = StorageManager().getUserId();
  //   Map payLoad = {"user_id": userId.toString(), "password": newPassword};
  //   final response = await _api.postMethod(Constants.changePassword, payLoad);

  //   Map<String, dynamic> map = response.body;
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<UserData?>> completeSignUp(Map payLoad) async {
  //   final response = await _api.postMethod(Constants.completeSignUp, payLoad);

  //   Map<String, dynamic> map = response.body;
  //   if (map['status'] == true) {
  //     var data = map['data'];
  //     return SuperResponse<UserData>.fromJson(map, UserData.fromJson(data));
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  Future<SuperResponse> logout() async {
    final userId = StorageManager().getUserId();
    final deviceId = await DeviceInfoUtil.getDeviceId();

    Map payLoad = {"userId": userId.toString(), "deviceId": deviceId};
    final response = await _api.postMethod(Constants.logoutUser, payLoad);

    Map<String, dynamic> map = jsonDecode(response.body);
    return SuperResponse.fromJson(map);
  }
}
