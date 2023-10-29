// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.location,
    this.id,
    this.number,
    this.email,
    this.firstname,
    this.lastname,
    this.dob,
    this.username,
    this.password,
    this.accountType,
    this.gender,
    this.followId,
    this.followingId,
    this.website,
    this.followers,
    this.following,
    this.bio,
    this.imageUrl,
    this.occupation,
    this.profilePrivacy,
    this.accountBlock,
    this.rewardsPoint,
    this.status,
    this.authProvider,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.postCount,
    this.verifyed,
  });

  Location? location;
  String? id;
  String? number;
  String? email;
  String? firstname;
  String? lastname;
  DateTime? dob;
  String? username;
  String? password;
  String? accountType;
  String? gender;
  List<String>? followId;
  List<String>? followingId;
  String? website;
  int? followers;
  int? following;
  String? bio;
  String? imageUrl;
  String? occupation;
  String? profilePrivacy;
  List<String>? accountBlock;
  int? rewardsPoint;
  bool? status;
  String? authProvider;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? postCount;
  bool? verifyed;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        id: json["_id"],
        number: json["number"],
        email: json["email"],
        firstname: json["firstname"] ?? "",
        lastname: json["lastname"] ?? "",
        dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
        username: json["username"],
        password: json["password"],
        accountType: json["accountType"],
        gender: json["gender"],
        followId: json["followId"] == null
            ? null
            : List<String>.from(json["followId"].map((x) => x)),
        followingId: json["followingId"] == null
            ? null
            : List<String>.from(json["followingId"].map((x) => x)),
        website: json["website"],
        followers: json["followers"],
        following: json["following"],
        bio: json["bio"],
        imageUrl: json["imageUrl"],
        occupation: json["occupation"],
        profilePrivacy: json["profilePrivacy"],
        accountBlock: json["accountBlock"] == null
            ? null
            : List<String>.from(json["accountBlock"].map((x) => x)),
        rewardsPoint: json["rewardsPoint"],
        status: json["status"],
        authProvider: json["authProvider"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        verifyed: json["verifyed"] ?? false,
        postCount: json["PostCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "location": location == null ? null : location!.toJson(),
        "_id": id,
        "number": number,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "DOB": dob == null ? null : dob!.toIso8601String(),
        "username": username,
        "password": password,
        "accountType": accountType,
        "gender": gender,
        "followId": followId == null
            ? null
            : List<dynamic>.from(followId!.map((x) => x)),
        "followingId": followingId == null
            ? null
            : List<dynamic>.from(followingId!.map((x) => x)),
        "website": website,
        "followers": followers,
        "following": following,
        "bio": bio,
        "imageUrl": imageUrl,
        "occupation": occupation,
        "profilePrivacy": profilePrivacy,
        "accountBlock": accountBlock == null
            ? null
            : List<dynamic>.from(accountBlock!.map((x) => x)),
        "rewardsPoint": rewardsPoint,
        "status": status,
        "authProvider": authProvider,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v,
        "verifyed": verifyed,
        "PostCount": postCount,
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  String? type;
  List<double>? coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(
                json["coordinates"].map((x) => x == null ? 0.0 : x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
