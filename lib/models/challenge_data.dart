// To parse this JSON data, do
//
//     final challengeData = challengeDataFromJson(jsonString);

import 'dart:convert';

ChallengeData challengeDataFromJson(String str) =>
    ChallengeData.fromJson(json.decode(str));

String challengeDataToJson(ChallengeData data) => json.encode(data.toJson());

class ChallengeData {
  String? id;
  String? userId;
  String? challengeLogo;
  String? challengesVideo;
  String? challengesPicture;
  String? challengeName;
  String? theme;
  String? typeOfChallenge;
  String? infoAboutChallenges;
  bool? rewards;
  dynamic coupons;
  List<RewardsPrize>? rewardsPrize;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ChallengeData({
    this.id,
    this.userId,
    this.challengeLogo,
    this.challengesVideo,
    this.challengesPicture,
    this.challengeName,
    this.theme,
    this.typeOfChallenge,
    this.infoAboutChallenges,
    this.rewards,
    this.coupons,
    this.rewardsPrize,
    this.fromDate,
    this.toDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) => ChallengeData(
        id: json["_id"],
        userId: json["userId"],
        challengeLogo: json["challengeLogo"],
        challengesVideo: json["challengesVideo"],
        challengesPicture: json["challengesPicture"],
        challengeName: json["challengeName"],
        theme: json["theme"],
        typeOfChallenge: json["typeOfChallenge"],
        infoAboutChallenges: json["infoAboutChallenges"],
        rewards: json["rewards"],
        coupons: json["coupons"],
        rewardsPrize: json["rewardsPrize"] == null
            ? []
            : List<RewardsPrize>.from(
                json["rewardsPrize"]!.map((x) => RewardsPrize.fromJson(x))),
        fromDate:
            json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "challengeLogo": challengeLogo,
        "challengesVideo": challengesVideo,
        "challengesPicture": challengesPicture,
        "challengeName": challengeName,
        "theme": theme,
        "typeOfChallenge": typeOfChallenge,
        "infoAboutChallenges": infoAboutChallenges,
        "rewards": rewards,
        "coupons": coupons,
        "rewardsPrize": rewardsPrize == null
            ? []
            : List<dynamic>.from(rewardsPrize!.map((x) => x.toJson())),
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class RewardsPrize {
  String? name;
  String? price;
  String? link;

  RewardsPrize({
    this.name,
    this.price,
    this.link,
  });

  factory RewardsPrize.fromJson(Map<String, dynamic> json) => RewardsPrize(
        name: json["name"],
        price: json["price"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "link": link,
      };
}
