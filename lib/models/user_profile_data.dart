// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  String? id;
  String? number;
  String? email;
  String? firstname;
  String? lastname;
  DateTime? dob;
  String? username;
  String? accountType;
  String? gender;
  List<String>? followId;
  List<String>? followingId;
  dynamic website;
  int? followers;
  int? following;
  String? bio;
  String? imageUrl;
  String? deepLinkUrl;
  Location? location;
  dynamic occupation;
  String? profilePrivacy;
  List<dynamic>? accountBlock;
  int? rewardsPoint;
  bool? status;
  String? authProvider;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? verifyed;
  List<UserPost>? userPost;
  int? postCount;

  UserProfile({
    this.id,
    this.number,
    this.email,
    this.firstname,
    this.lastname,
    this.dob,
    this.username,
    this.accountType,
    this.gender,
    this.followId,
    this.followingId,
    this.website,
    this.followers,
    this.following,
    this.bio,
    this.imageUrl,
    this.deepLinkUrl,
    this.location,
    this.occupation,
    this.profilePrivacy,
    this.accountBlock,
    this.rewardsPoint,
    this.status,
    this.authProvider,
    this.createdAt,
    this.updatedAt,
    this.verifyed,
    this.userPost,
    this.postCount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["_id"],
        number: json["number"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
        username: json["username"],
        accountType: json["accountType"],
        gender: json["gender"],
        followId: json["followId"] == null
            ? []
            : List<String>.from(json["followId"]!.map((x) => x)),
        followingId: json["followingId"] == null
            ? []
            : List<String>.from(json["followingId"]!.map((x) => x)),
        website: json["website"],
        followers: json["followers"],
        following: json["following"],
        bio: json["bio"],
        imageUrl: json["imageUrl"],
        deepLinkUrl: json["deepLink_URL"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        occupation: json["occupation"],
        profilePrivacy: json["profilePrivacy"],
        accountBlock: json["accountBlock"] == null
            ? []
            : List<dynamic>.from(json["accountBlock"]!.map((x) => x)),
        rewardsPoint: json["rewardsPoint"],
        status: json["status"],
        authProvider: json["authProvider"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        verifyed: json["verifyed"],
        userPost: json["userPost"] == null
            ? []
            : List<UserPost>.from(
                json["userPost"]!.map((x) => UserPost.fromJson(x))),
        postCount: json["postCount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "number": number,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "DOB": dob?.toIso8601String(),
        "username": username,
        "accountType": accountType,
        "gender": gender,
        "followId":
            followId == null ? [] : List<dynamic>.from(followId!.map((x) => x)),
        "followingId": followingId == null
            ? []
            : List<dynamic>.from(followingId!.map((x) => x)),
        "website": website,
        "followers": followers,
        "following": following,
        "bio": bio,
        "imageUrl": imageUrl,
        "deepLink_URL": deepLinkUrl,
        "location": location?.toJson(),
        "occupation": occupation,
        "profilePrivacy": profilePrivacy,
        "accountBlock": accountBlock == null
            ? []
            : List<dynamic>.from(accountBlock!.map((x) => x)),
        "rewardsPoint": rewardsPoint,
        "status": status,
        "authProvider": authProvider,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "verifyed": verifyed,
        "userPost": userPost == null
            ? []
            : List<dynamic>.from(userPost!.map((x) => x.toJson())),
        "postCount": postCount,
      };
}

class Location {
  String? type;
  List<double?>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double?>.from(
                json["coordinates"]?.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class UserPost {
  String? id;
  String? userId;
  String? challengeId;
  String? challengeVideo;
  int? viewCount;
  String? thumbnail;
  String? caption;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? likeCount;
  String? postLocation;
  String? recipeLocation;
  String? music;
  String? deepLinkUrl;
  String? voiceUrl;

  UserPost({
    this.id,
    this.userId,
    this.challengeId,
    this.challengeVideo,
    this.viewCount,
    this.thumbnail,
    this.caption,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.likeCount,
    this.postLocation,
    this.recipeLocation,
    this.music,
    this.deepLinkUrl,
    this.voiceUrl,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        id: json["_id"],
        userId: json["userId"],
        challengeId: json["challengeId"],
        challengeVideo: json["challengeVideo"],
        viewCount: json["viewCount"],
        thumbnail: json["thumbnail"],
        caption: json["caption"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        likeCount: json["likeCount"],
        postLocation: json["postLocation"],
        recipeLocation: json["recipeLocation"],
        music: json["music"],
        deepLinkUrl: json["deepLink_URL"],
        voiceUrl: json["voice_URL"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "challengeId": challengeId,
        "challengeVideo": challengeVideo,
        "viewCount": viewCount,
        "thumbnail": thumbnail,
        "caption": caption,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "likeCount": likeCount,
        "postLocation": postLocation,
        "recipeLocation": recipeLocation,
        "music": music,
        "deepLink_URL": deepLinkUrl,
        "voice_URL": voiceUrl,
      };
}
