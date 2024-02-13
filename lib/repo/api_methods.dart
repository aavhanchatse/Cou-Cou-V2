import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/main.dart';
import 'package:coucou_v2/utils/custom_exceptions.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class API<T> {
  // @override
  // void onInit() {
  //   httpClient.timeout;
  //   httpClient.baseUrl = Constants.baseURL;
  //   httpClient.defaultContentType = "application/json";
  //   super.onInit();
  // }

  Future<http.Response> postMethod(String endpoint, Map payLoad,
      [Map<String, String>? headers]) async {
    debugPrint(
        '${Constants.baseURL + endpoint}  + payload = ${json.encode(payLoad)}');

    Map<String, String> head = {};

    head["Content-Type"] = 'application/json';

    if (headers != null) {
      final token = StorageManager().getToken();
      debugPrint('token: $token');

      head["Authorization"] = token ?? "";
    }

    var body = json.encode(payLoad);

    final config = await setupRemoteConfig();
    final networkAvailable = config.getBool("local_notification");
    debugPrint("networkAvailable = $networkAvailable");

    if (networkAvailable == false) {
      return http.Response("", 404);
    }

    var response = await http.post(
      Uri.parse(Constants.baseURL + endpoint),
      body: body,
      headers: head,
    );

    return _handledResponse(response, endpoint);
  }

  // Future<Response?> postMethod(String endpoint, Map payLoad,
  //     [Map<String, String>? headers = const {}]) async {
  //   debugPrint(
  //       '${Constants.baseURL + endpoint}  + payload = ${jsonEncode(payLoad)}');
  //   final response =
  //       await post<T>(Constants.baseURL + endpoint, payLoad, headers: headers);
  //   return _handledResponse(response, endpoint);
  // }

  // Future<Response<T>> formPostMethod(
  //     String endpoint, Map<String, dynamic> payLoad,
  //     [Map<String, MultipartFile> filesPayload = const {}]) async {
  //   debugPrint('payload: $payLoad');
  //   debugPrint('files: $filesPayload');

  //   FormData formData = FormData({});

  //   formData.files.addAll(filesPayload.entries.toList());

  //   formData.fields.addAll(payLoad
  //       .map((key, value) => MapEntry(key.toString(), value.toString()))
  //       .entries
  //       .toList());

  //   debugPrint(
  //       '${Constants.baseURL + endpoint}  + payload = ${jsonEncode(formData.fields)}');

  //   final response = await post<T>(Constants.baseURL + endpoint, formData);
  //   return _handledResponse(response, endpoint);
  // }

  Future<http.Response> getMethod(
    String endpoint, [
    Map<String, String>? headers = const {},
    String parameterString = "",
  ]) async {
    debugPrint(
        '${Constants.baseURL + endpoint}${parameterString.isNotEmpty ? "?" : ""}$parameterString');

    Map<String, String> head = {};

    head["Content-Type"] = 'application/json';

    final config = await setupRemoteConfig();
    final networkAvailable = config.getBool("local_notification");
    debugPrint("networkAvailable = $networkAvailable");

    if (networkAvailable == false) {
      return http.Response("", 404);
    }

    final response = await retry(
      () async => await http.get(
          Uri.parse(
              "${Constants.baseURL}$endpoint${parameterString.isNotEmpty ? "?" : ""}$parameterString"),
          headers: headers),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return _handledResponse(response, endpoint);
  }

  // Future<Response?> getMethod(
  //   String endpoint, [
  //   Map<String, String>? headers = const {},
  //   String parameterString = "",
  // ]) async {
  //   debugPrint(
  //       '${Constants.baseURL + endpoint}${parameterString.isNotEmpty ? "?" : ""}$parameterString');
  //   final response = await get<T>(
  //       "${Constants.baseURL}$endpoint${parameterString.isNotEmpty ? "?" : ""}$parameterString",
  //       headers: headers);
  //   return _handledResponse(response, endpoint);
  // }

  Future<http.Response> _handledResponse(
      http.Response response, String endpoint) async {
    debugPrint('status code: ${response.statusCode}');
    debugPrint('response[$endpoint]: ${response.body}');

    // if (response.body!['auth'] == false) {
    //   LogoutDialog().logout();
    //   return null;
    // }

    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.toString());
      case 500:
      default:
        throw FetchDataException(
            "Error occurred while communicating with server with StatusCode : ${response.statusCode}");
    }
  }

  // Response? _handledResponse(Response response, String endpoint) {
  //   debugPrint('status code: ${response.statusCode}');
  //   // debugPrint('response[$endpoint]: ${response.body}');

  //   if (response.body!['auth'] == false) {
  //     LogoutDialog().logout();
  //     return null;
  //   }

  //   switch (response.statusCode) {
  //     case 200:
  //       return response;
  //     case 201:
  //       return response;
  //     case 400:
  //       throw BadRequestException(response.body.toString());
  //     case 401:
  //     case 403:
  //       throw UnauthorizedException(response.body.toString());
  //     case 500:
  //     default:
  //       throw FetchDataException(
  //           "Error occurred while communicating with server with StatusCode : ${response.statusCode}");
  //   }
  //   // if ((response.statusCode ?? 199) < 200 || (response.statusCode ?? 401) > 400) {
  //   //   throw Exception("Error while fetching data");
  //   // } else {
  //   //   debugPrint('response[$endpoint]: ${response.body}');
  //   //   return response;
  //   // }
  // }
}
