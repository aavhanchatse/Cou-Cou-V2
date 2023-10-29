// To parse this JSON data, do
//
//     final commentData = commentDataFromJson(jsonString);

import 'dart:convert';

import 'package:coucou_v2/models/user_data.dart';

CommentData commentDataFromJson(String str) =>
    CommentData.fromJson(json.decode(str));

String commentDataToJson(CommentData data) => json.encode(data.toJson());

class CommentData {
  String? id;
  String? userId;
  String? postId;
  String? postComment;
  String? postOwnerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<CommentData>? subcomment;
  UserData? userData;
  List<UserData>? subuserData;
  String? commentId;

  CommentData({
    this.id,
    this.userId,
    this.postId,
    this.postComment,
    this.postOwnerId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.subcomment,
    this.userData,
    this.commentId,
    this.subuserData,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["_id"],
        userId: json["userId"],
        postId: json["postId"],
        postComment: json["postComment"],
        postOwnerId: json["postOwnerId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        subcomment: json["subcomment"] == null
            ? []
            : List<CommentData>.from(
                json["subcomment"]!.map((x) => CommentData.fromJson(x))),
        subuserData: json["subuserData"] == null
            ? []
            : List<UserData>.from(
                json["subuserData"]!.map((x) => UserData.fromJson(x))),
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
        commentId: json["commentId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "postId": postId,
        "postComment": postComment,
        "postOwnerId": postOwnerId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "subcomment": subcomment == null
            ? []
            : List<dynamic>.from(subcomment!.map((x) => x.toJson())),
        "subuserData": subuserData == null
            ? []
            : List<dynamic>.from(subuserData!.map((x) => x.toJson())),
        "userData": userData?.toJson(),
        "commentId": commentId,
      };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
