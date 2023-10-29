class UserSearchHistory {
  UserSearchHistory({
    this.id,
    this.userId,
    this.keys,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? userId;
  String? keys;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory UserSearchHistory.fromMap(Map<String, dynamic> json) =>
      UserSearchHistory(
        id: json["_id"],
        userId: json["userId"],
        keys: json["keys"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "userId": userId,
        "keys": keys,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
