class SuperResponse<T> {
  bool? status;
  String? title;
  String? message;
  String? token;
  T? data;
  bool? auth;
  String? fileUrl;

  SuperResponse({
    this.status,
    this.title,
    this.message,
    this.token,
    this.data,
    this.auth,
    this.fileUrl,
  });

  factory SuperResponse.fromJson(Map<String, dynamic> json, [T? t]) {
    return SuperResponse<T>(
      status: json['status'],
      title: json['title'],
      message: json['message'],
      token: json['token'],
      data: t,
      auth: json['auth'],
      fileUrl: json['fileUrl'],
    );
  }
}
