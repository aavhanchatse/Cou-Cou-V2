import 'dart:convert';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/my_activity_model_data.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/models/user_profile_data.dart';
import 'package:coucou_v2/repo/api_methods.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:flutter/material.dart';

class UserRepo {
  final API _api = API();

  Future<SuperResponse<UserData?>> getUserDataById(String userId) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    debugPrint('userId: $userId');

    final headers = {'Authorization': token!};

    final payload = {'userId': userId};

    final response =
        await _api.postMethod(Constants.getUserDataById, payload, headers);

    Map<String, dynamic> map = (jsonDecode(response.body));
    if (map['status'] == true) {
      var data = map['data'][0];
      return SuperResponse<UserData>.fromJson(map, UserData.fromJson(data));
    }
    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> updateUserProfile(Map payLoad) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.updateUserProfile, payLoad, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<List<UserData>?>> getFollowersList(
      int page, String userId) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        Constants.getFollowersList, headers, "userId=$userId");

    Map<String, dynamic> map = jsonDecode(response.body);

    Iterable data = map['data'];

    if (data.isNotEmpty) {
      var list =
          data.map((dynamic element) => UserData.fromJson(element)).toList();

      return SuperResponse.fromJson(map, list);
    } else {
      return SuperResponse.fromJson(map, null);
    }
  }

  Future<SuperResponse<List<UserData>?>> getFollowingList(
      int page, String userId) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        Constants.getFollowingList, headers, "userId=$userId");

    Map<String, dynamic> map = jsonDecode(response.body);

    Iterable data = map['data'];

    if (data.isNotEmpty) {
      var list =
          data.map((dynamic element) => UserData.fromJson(element)).toList();

      return SuperResponse.fromJson(map, list);
    } else {
      return SuperResponse.fromJson(map, null);
    }
  }

  Future<SuperResponse> addAddress(Map payLoad) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.addAddress, payLoad, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<UserProfile?>> getUserProfile(String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.getMethod("${Constants.getUserProfile}?userId=$id", headers);

    Map<String, dynamic> map = (jsonDecode(response.body));
    if (map['status'] == true) {
      var data = map['data'];
      return SuperResponse<UserProfile>.fromJson(
          map, UserProfile.fromJson(data));
    }
    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<List<MyActivityModelData?>?>> getUserActivity(
      bool isActivity) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');
    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        isActivity
            ? Constants.getUserActivityLog
            : Constants.getOtherUserActivityLog,
        headers);

    Map<String, dynamic> map = (jsonDecode(response.body));
    Iterable data = map['data'];

    if (data.isNotEmpty) {
      var list = data
          .map((dynamic element) => MyActivityModelData.fromMap(element))
          .toList();

      return SuperResponse.fromJson(map, list);
    } else {
      return SuperResponse.fromJson(map, null);
    }
  }

  // Future<SuperResponse<List<AddressData>?>> getUserAddress() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(Constants.getUserAddress, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];

  //   if (data.isNotEmpty) {
  //     var list =
  //         data.map((dynamic element) => AddressData.fromJson(element)).toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<UserData?>?>> getUserListDataById(
  //     List userIds) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   debugPrint('userId: $userIds');

  //   final headers = {'Authorization': token!};

  //   final payload = {'userId': userIds};

  //   final response =
  //       await _api.postMethod(Constants.getUsersById, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));
  //   Iterable data = map['data'];

  //   if (data.isNotEmpty) {
  //     var list =
  //         data.map((dynamic element) => UserData.fromJson(element)).toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<MyActivityModelData?>?>> getUserActivity(
  //     bool isActivity) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(
  //       isActivity
  //           ? Constants.getUserActivityLog
  //           : Constants.getOtherUserActivityLog,
  //       headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));
  //   Iterable data = map['data'];

  //   if (data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => MyActivityModelData.fromMap(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<BuySellDataModel>?>> getMyBuyItemsData(
  //     bool isBuy) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(
  //       isBuy ? Constants.getBuyOrderData : Constants.getSellOrderData,
  //       headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));
  //   Iterable data = map['data'];

  //   if (data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => BuySellDataModel.fromMap(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, []);
  //   }
  // }

  // Future<SuperResponse> changeOrderStatus(Map payload) async {
  //   // final token = StorageManager().getToken();
  //   // debugPrint('token: $token');
  //   // final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateOrderStatus, payload);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> addReelPost(Map payload) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.addUserStory, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> updateStory(Map payload) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateStory, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> deleteStory(String id) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod("${Constants.deleteStory}?_id=$id", headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> deleteChallenge(String id) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod("${Constants.deleteChallenge}?_id=$id", headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> deleteReel(String id) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod("${Constants.deleteReel}?_id=$id", headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse> storyLike(Map payload) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.storyLike, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<SuperResponse<List<StoryReelModel>?>> getTodayReelsStory() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(Constants.getReelsStory, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));
  //   Iterable data = map['data'];

  //   if (data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => StoryReelModel.fromMap(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, []);
  //   }
  // }

  // Future<SuperResponse> sendChatNotification(Map payload) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');
  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.sendChatNotification, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));

  //   return SuperResponse.fromJson(map, null);
  // }

  // Future<PaymentModel?> makePayment(
  //     Map payLoad, Map<String, String> headers) async {
  //   const String url =
  //       "https://100088.pythonanywhere.com/api/stripe/initialize/fd510288-6994-433d-8642-80a39f493b2e";

  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode(payLoad),
  //     headers: headers,
  //   );

  //   final res = await _handledResponse(response, url);

  //   Map<String, dynamic> map = (jsonDecode(res.body));

  //   if (map['approval_url'] != null) {
  //     return PaymentModel.fromJson(map);
  //   }
  //   return null;
  //   // return SuperResponse.fromJson(map);
  // }

  // Future<http.Response> _handledResponse(
  //     http.Response response, String endpoint) async {
  //   debugPrint('status code: ${response.statusCode}');
  //   debugPrint('response[$endpoint]: ${response.body}');

  //   // if (response.body!['auth'] == false) {
  //   //   LogoutDialog().logout();
  //   //   return null;
  //   // }

  //   switch (response.statusCode) {
  //     case 200:
  //       return response;
  //     case 201:
  //       return response;
  //     case 400:
  //       throw BadRequestException(response.toString());
  //     case 401:
  //     case 403:
  //       throw UnauthorizedException(response.toString());
  //     case 500:
  //     default:
  //       throw FetchDataException(
  //           "Error occurred while communicating with server with StatusCode : ${response.statusCode}");
  //   }
  // }
}
