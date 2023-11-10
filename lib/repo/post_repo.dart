import 'dart:convert';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/models/challenge_name_data.dart';
import 'package:coucou_v2/models/comment_data.dart';
import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/models/super_response.dart';
import 'package:coucou_v2/models/user_search_history_model.dart';
import 'package:coucou_v2/repo/api_methods.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:flutter/material.dart';

class PostRepo {
  final API _api = API();

  Future<SuperResponse<List<ChallengeData>>> getHomeScreenBanner() async {
    final response = await _api.getMethod(Constants.homeScreenBanner);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList = data
          .map((dynamic element) => ChallengeData.fromJson(element))
          .toList();

      return SuperResponse<List<ChallengeData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<PostData>>> getHomeScreenTopPost(int page) async {
    final response =
        await _api.getMethod("${Constants.homeScreenTopPost}?pageNo=$page");

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => PostData.fromJson(element)).toList();

      return SuperResponse<List<PostData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<PostData>>> getHomeScreenMainPostList(
      int page) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        "${Constants.homeScreenMainPostList}?pageNo=$page", headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => PostData.fromJson(element)).toList();

      return SuperResponse<List<PostData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<ChallengeNameData>>> getAllChallengeNames() async {
    final response = await _api.getMethod(Constants.allChallengeNames);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList = data
          .map((dynamic element) => ChallengeNameData.fromJson(element))
          .toList();

      return SuperResponse<List<ChallengeNameData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<ChallengeData>> getChallengeBanner(String id) async {
    final response =
        await _api.getMethod("${Constants.getChallengeBanner}?id=$id");

    Map<String, dynamic> map = jsonDecode(response.body);
    Map<String, dynamic> data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      return SuperResponse<ChallengeData>.fromJson(
          map, ChallengeData.fromJson(data));
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<ChallengeData>>> getAllChallenges() async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(Constants.getAllChallenges2, headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList = data
          .map((dynamic element) => ChallengeData.fromJson(element))
          .toList();

      return SuperResponse<List<ChallengeData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse> uploadPost(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.uploadPost, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> updatePost(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.updatePost, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<List<PostData>>> getChallengeTopPost(
      int page, String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        "${Constants.challengeTopPost}?pageNo=$page&id=$id", headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => PostData.fromJson(element)).toList();

      return SuperResponse<List<PostData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<PostData>>> getChallengeMainPostList(
      int page, String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        "${Constants.challengeMainPost}?pageNo=$page&id=$id", headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => PostData.fromJson(element)).toList();

      return SuperResponse<List<PostData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<PostData>> getPostData(String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.getMethod("${Constants.getPostData}?postId=$id", headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      return SuperResponse<PostData>.fromJson(
          map, PostData.fromJson(data.first));
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<List<UserSearchHistory>>> getUserHistory() async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.getMethod(Constants.getUserSearchHistory, headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList = data
          .map((dynamic element) => UserSearchHistory.fromMap(element))
          .toList();

      return SuperResponse<List<UserSearchHistory>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse> deleteSearchHistoryItem(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.deleteSearchKey, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse<List<PostData>>> getSearchData(String keyword) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response = await _api.getMethod(
        "${Constants.searchPost}?search=$keyword", headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => PostData.fromJson(element)).toList();

      return SuperResponse<List<PostData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map);
    }
  }

  Future<SuperResponse<PostData>> addPostLike(Map payLoad) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.postLike, payLoad, headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    var data = map['data'][0];

    return SuperResponse.fromJson(map, PostData.fromJson(data));
  }

  Future<SuperResponse<List<CommentData>>> getPostComments(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.getPostComments, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);
    Iterable data = map['data'];

    if (map['status'] == true && data.isNotEmpty) {
      var dataList =
          data.map((dynamic element) => CommentData.fromJson(element)).toList();

      return SuperResponse<List<CommentData>>.fromJson(map, dataList);
    } else {
      return SuperResponse.fromJson(map, []);
    }
  }

  Future<SuperResponse> addComment(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.addComment, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> deleteComment(String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.getMethod("${Constants.deleteComment}?id=$id", headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> deleteSubComment(String id) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.getMethod("${Constants.deleteSubComment}?id=$id", headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> addSubComment(Map payload) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.addSubComment, payload, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> deletePost(Map payLoad) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.deleteUserPost, payLoad, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  Future<SuperResponse> getVideoFromUrl(Map payLoad) async {
    final token = StorageManager().getToken();
    debugPrint('token: $token');

    final headers = {'Authorization': token!};

    final response =
        await _api.postMethod(Constants.getVideoFromImage, payLoad, headers);

    Map<String, dynamic> map = jsonDecode(response.body);

    return SuperResponse.fromJson(map);
  }

  // Future<SuperResponse<List<UserData>>> getUserTagSearch(
  //     String userName, int pageNo) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final payload = {'userId': userId};

  //   final response = await _api.getMethod(
  //       "${Constants.searchUserTag}?search=$userName&pageNo=$pageNo", headers);

  //   // final response = await _api.getMethod(
  //   //     "${Constants.searchUserPostTag}?search=$userName&pageNo=$pageNo", headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];

  //   if (map['status'] == true && data.isNotEmpty) {
  //     var dataList =
  //         data.map((dynamic element) => UserData.fromJson(element)).toList();

  //     return SuperResponse<List<UserData>>.fromJson(map, dataList);
  //   } else {
  //     return SuperResponse.fromJson(map);
  //   }
  // }

  // Future<SuperResponse<List<UserSearchHistory>>> getUserHistory() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod("${Constants.getUserSearchHistory}", headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];

  //   if (map['status'] == true && data.isNotEmpty) {
  //     var dataList = data
  //         .map((dynamic element) => UserSearchHistory.fromMap(element))
  //         .toList();

  //     return SuperResponse<List<UserSearchHistory>>.fromJson(map, dataList);
  //   } else {
  //     return SuperResponse.fromJson(map);
  //   }
  // }

  // Future<SuperResponse<List<PostDataModel>>> getAllPost(int pageNo) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final payload = {'userId': userId};

  //   final response = await _api.getMethod(
  //       "${Constants.getAllPostType}?&pageNo=$pageNo", headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];
  //   if (map['status'] == true) {
  //     var dataList = data
  //         .map((dynamic element) => PostDataModel.fromMap(element))
  //         .toList();
  //     return SuperResponse<List<PostDataModel>>.fromJson(map, dataList);
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<List<PostDataModel>>> getAllHungryPost(
  //     Map payload) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.postMethod(
  //     "${Constants.getAllHungryPost}",
  //     payload,
  //     headers,
  //   );

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];
  //   if (map['status'] == true) {
  //     var dataList = data
  //         .map((dynamic element) => PostDataModel.fromMap(element))
  //         .toList();
  //     return SuperResponse<List<PostDataModel>>.fromJson(map, dataList);
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<List<PostDataModel>>> getAllMyProductPost(
  //     int pageNo) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final payload = {'userId': userId};

  //   final response = await _api.getMethod(
  //       "${Constants.getAllMyProductPost}?&pageNo=$pageNo", headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];
  //   if (map['status'] == true) {
  //     var dataList = data
  //         .map((dynamic element) => PostDataModel.fromMap(element))
  //         .toList();
  //     return SuperResponse<List<PostDataModel>>.fromJson(map, dataList);
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> getAllUser() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final payload = {'userId': userId};

  //   final response =
  //       await _api.postMethod(Constants.addUserPost, payload, headers);

  //   Map<String, dynamic> map = (jsonDecode(response.body));
  //   if (map['status'] == true) {
  //     var data = map['data'][0];
  //     return SuperResponse<UserData>.fromJson(map, UserData.fromJson(data));
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> addUserPost(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.addUserPost, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> updateUserPost(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateUserPost, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> addReelViewCount(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.addReelViewCount, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> enableDisableProduct(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateFoodStatus, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> addQuizResult(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.addQuizPost, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse?> postComment(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   try {
  //     final headers = {'Authorization': token!};

  //     final response =
  //         await _api.postMethod(Constants.postComments, payLoad, headers);

  //     Map<String, dynamic> map = jsonDecode(response.body);

  //     return SuperResponse.fromJson(map);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<SuperResponse<List<CommentData>>> getComment(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('userId: $userId');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.postMethod(
  //     "${Constants.getComments}",
  //     payLoad,
  //     headers,
  //   );

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Iterable data = map['data'];
  //   if (map['status'] == true) {
  //     var dataList =
  //         data.map((dynamic element) => CommentData.fromMap(element)).toList();
  //     return SuperResponse<List<CommentData>>.fromJson(map, dataList);
  //   }
  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<ChallengeData?>> createChallenge(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.createChallenge, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   final data = map["data"];

  //   if (data != null) {
  //     return SuperResponse.fromJson(map, ChallengeData.fromJson(data));
  //   } else {
  //     return SuperResponse.fromJson(map);
  //   }
  // }

  // Future<SuperResponse<ChallengeData?>> updateChallenge(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateChallenge, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   final data = map["data"];

  //   if (data != null) {
  //     return SuperResponse.fromJson(map, ChallengeData.fromJson(data));
  //   } else {
  //     return SuperResponse.fromJson(map);
  //   }
  // }

  // Future<SuperResponse<List<ChallengeData>?>> getChallenge() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(Constants.getAllChallenges, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => ChallengeData.fromJson(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<ChallengeData>?>> getTopChallenge() async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod(Constants.getTopAllChallenges, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => ChallengeData.fromJson(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse> createReel(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.createReel, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> updateReel(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.updateReel, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<List<ReelData>?>> getChallengeReels(
  //     String challengeId, int page) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(Constants.getChallengeReels, headers,
  //       "challengeId=${challengeId}&pageNo=$page");

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list =
  //         data.map((dynamic element) => ReelData.fromJson(element)).toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<ReelData>?>> getWinnerChallengeReels(
  //     String challengeId) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(Constants.getWinnerChallengeReels,
  //       headers, "challengeId=${challengeId}");

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list =
  //         data.map((dynamic element) => ReelData.fromJson(element)).toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse> addUserFollow(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.userFollow, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse> addBookmark(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.addBookmark, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   return SuperResponse.fromJson(map);
  // }

  // Future<SuperResponse<List<PostDataModel>?>> getUserPosts(Map payLoad) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.postMethod(Constants.getUserPosts, payLoad, headers);

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => PostDataModel.fromMap(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<List<PostDataModel>?>> getSavedPosts(int page) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(
  //       Constants.getSavedPosts, headers, "userId=${userId}&pageNo=$page");

  //   Map<String, dynamic> map = jsonDecode(response.body);

  //   Iterable data = map['data'];

  //   if (data != null && data.isNotEmpty) {
  //     var list = data
  //         .map((dynamic element) => PostDataModel.fromMap(element))
  //         .toList();

  //     return SuperResponse.fromJson(map, list);
  //   } else {
  //     return SuperResponse.fromJson(map, null);
  //   }
  // }

  // Future<SuperResponse<PostDataModel>> getPostDetailsById(String id) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response = await _api.getMethod(
  //       Constants.getPostDetailsById, headers, "postId=${id}");

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Map<String, dynamic> data = map['data'];

  //   return SuperResponse.fromJson(map, PostDataModel.fromMap(data));
  // }

  // Future<SuperResponse<StoryReelModel>> getStoryDetailsById(String id) async {
  //   final token = StorageManager().getToken();
  //   debugPrint('token: $token');

  //   final userId = StorageManager().getUserId();
  //   debugPrint('token: $token');

  //   final headers = {'Authorization': token!};

  //   final response =
  //       await _api.getMethod(Constants.getStoryByStoryId, headers, "id=${id}");

  //   Map<String, dynamic> map = jsonDecode(response.body);
  //   Map<String, dynamic> data = map['data'];

  //   return SuperResponse.fromJson(map, StoryReelModel.fromMap(data));
  // }
}
