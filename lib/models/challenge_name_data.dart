// To parse this JSON data, do
//
//     final challengeNameData = challengeNameDataFromJson(jsonString);

import 'dart:convert';

ChallengeNameData challengeNameDataFromJson(String str) =>
    ChallengeNameData.fromJson(json.decode(str));

String challengeNameDataToJson(ChallengeNameData data) =>
    json.encode(data.toJson());

class ChallengeNameData {
  String? id;
  String? challengeName;

  ChallengeNameData({
    this.id,
    this.challengeName,
  });

  factory ChallengeNameData.fromJson(Map<String, dynamic> json) =>
      ChallengeNameData(
        id: json["_id"],
        challengeName: json["challengeName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "challengeName": challengeName,
      };
}
