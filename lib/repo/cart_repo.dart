// import 'dart:convert';

// import 'package:coucou/app_constants/constants.dart';
// import 'package:coucou/models/cart_model_data.dart';
// import 'package:coucou/models/order_data_model.dart';
// import 'package:coucou/models/super_response.dart';
// import 'package:coucou/repo/api_methods.dart';
// import 'package:coucou/utils/storage_manager.dart';
// import 'package:flutter/material.dart';

// class CartRepo {
//   final API _api = API();

//   Future<SuperResponse> addToCart(Map payLoad) async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response =
//         await _api.postMethod(Constants.addToCart, payLoad, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     return SuperResponse.fromJson(map);
//   }

//   Future<SuperResponse> removeFromCart(Map payLoad) async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response =
//         await _api.postMethod(Constants.removeFromCart, payLoad, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     return SuperResponse.fromJson(map);
//   }

//   Future<SuperResponse?> getAllCartData() async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response =
//         await _api.postMethod(Constants.getAllCart, {"pageNo": 1}, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     Iterable data = map['data'];

//     if (data != null && data.isNotEmpty) {
//       var list = data
//           .map((dynamic element) => CartDataModel.fromMap(element))
//           .toList();

//       return SuperResponse.fromJson(map, list);
//     } else {
//       return SuperResponse.fromJson(map, <CartDataModel>[]);
//     }
//   }

//   Future<SuperResponse> addRazorPayOrderDetail(Map payLoad) async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response = await _api.postMethod(
//         Constants.addRazorpayOrderDetail, payLoad, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     return SuperResponse.fromJson(map, OrderDataModel.fromMap(map['data']));
//   }

//   Future<SuperResponse?> checkRazorPayPayment(Map payload) async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response =
//         await _api.postMethod(Constants.checkoutRazorpayment, payload, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     return SuperResponse.fromJson(map);
//   }

//   Future<SuperResponse?> clearCartData() async {
//     final token = StorageManager().getToken();
//     debugPrint('token: $token');

//     final headers = {'Authorization': token!};

//     final response = await _api.getMethod(Constants.clearCartData, headers);

//     Map<String, dynamic> map = jsonDecode(response.body);

//     return SuperResponse.fromJson(map);
//   }
// }
