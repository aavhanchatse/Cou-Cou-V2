// To parse this JSON data, do
//
//     final postData = postDataFromJson(jsonString);

import 'dart:convert';

import 'package:coucou_v2/models/challenge_data.dart';
import 'package:coucou_v2/models/user_data.dart';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  String? id;
  String? userId;
  String? challengeId;
  String? challengeVideo;
  String? voiceUrl;
  bool? like;
  int? likeCount;
  int? commentCount;
  String? postLocation;
  String? recipeLocation;
  int? viewCount;
  String? thumbnail;
  String? caption;
  String? deepLinkUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserData? userSingleData;
  ChallengeData? challengeData;
  List<String>? imagesMultiple;
  bool? isVideo;
  bool? isVeg;
  String? videoUrl;

  PostData({
    this.id,
    this.userId,
    this.challengeId,
    this.challengeVideo,
    this.voiceUrl,
    this.like,
    this.likeCount,
    this.commentCount,
    this.postLocation,
    this.recipeLocation,
    this.viewCount,
    this.thumbnail,
    this.caption,
    this.deepLinkUrl,
    this.createdAt,
    this.updatedAt,
    this.userSingleData,
    this.challengeData,
    this.imagesMultiple,
    this.isVeg,
    this.isVideo,
    this.videoUrl,
  });

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
        id: json["_id"],
        userId: json["userId"],
        challengeId: json["challengeId"],
        challengeVideo: json["challengeVideo"],
        voiceUrl: json["voice_URL"],
        likeCount: json["likeCount"],
        like: json["like"],
        commentCount: json["CommentCount"],
        postLocation: json["postLocation"],
        recipeLocation: json["recipeLocation"],
        viewCount: json["viewCount"],
        thumbnail: json["thumbnail"],
        caption: json["caption"],
        deepLinkUrl: json["deepLink_URL"],
        isVideo: json["isVideo"],
        isVeg: json["isVeg"],
        videoUrl: json["videoUrl"],
        userSingleData: json["userSingleData"] == null
            ? null
            : UserData.fromJson(json["userSingleData"]),
        challengeData: json["challengeData"] == null
            ? null
            : ChallengeData.fromJson(json["challengeData"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        imagesMultiple: json["imagesMultiple"] == null
            ? []
            : List<String>.from(json["imagesMultiple"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "challengeId": challengeId,
        "challengeVideo": challengeVideo,
        "voice_URL": voiceUrl,
        "likeCount": likeCount,
        "like": like,
        "CommentCount": commentCount,
        "postLocation": postLocation,
        "recipeLocation": recipeLocation,
        "viewCount": viewCount,
        "thumbnail": thumbnail,
        "caption": caption,
        "deepLink_URL": deepLinkUrl,
        "isVeg": isVeg,
        "isVideo": isVideo,
        "videoUrl": videoUrl,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "userSingleData": userSingleData?.toJson(),
        "challengeData": challengeData?.toJson(),
        "imagesMultiple": imagesMultiple == null
            ? []
            : List<dynamic>.from(imagesMultiple!.map((x) => x)),
      };
}
