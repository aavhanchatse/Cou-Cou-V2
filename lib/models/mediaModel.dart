// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MediaModel {
  String filePath;
  List fileBytes;

  MediaModel({
    required this.filePath,
    required this.fileBytes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filePath': filePath,
      'fileBytes': fileBytes,
    };
  }

  String toJson() => json.encode(toMap());
}
