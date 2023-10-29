import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/models/user_data.dart';

class MyActivityModelData {
  MyActivityModelData({
    this.id,
    this.userId,
    this.postId,
    this.postOwnerId,
    this.likeStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.userData,
    this.postData,
    this.postOwnerData,
    this.postComment,
  });

  String? id;
  String? userId;
  String? postId;
  String? postOwnerId;
  bool? likeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  UserData? userData;
  PostData? postData;
  UserData? postOwnerData;
  String? postComment;

  factory MyActivityModelData.fromMap(Map<String, dynamic> json) =>
      MyActivityModelData(
        id: json["_id"],
        userId: json["userId"],
        postId: json["postId"],
        postOwnerId: json["postOwnerId"],
        likeStatus: json["likeStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
        postData: json["postData"] == null
            ? null
            : PostData.fromJson(json["postData"]),
        postOwnerData: json["postOwnerData"] == null
            ? null
            : UserData.fromJson(json["postOwnerData"]),
        postComment: json["postComment"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "userId": userId,
        "postId": postId,
        "postOwnerId": postOwnerId,
        "likeStatus": likeStatus,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "userData": userData!.toJson(),
        "postData": postData!.toJson(),
        "postOwnerData": postOwnerData!.toJson(),
        "postComment": postComment,
      };
}
