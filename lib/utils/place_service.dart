// import 'dart:convert';
// import 'dart:io';

// import 'package:coucou/app_constants/constants.dart';
// import 'package:coucou/utils/common_utils.dart';
// import 'package:coucou/utils/date_util.dart';
// import 'package:coucou/utils/s3_util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;

// class Place {
//   String? streetNumber;
//   String? street;
//   String? city;
//   String? zipCode;
//   LocationClass? location;

//   Place(
//       {this.streetNumber, this.street, this.city, this.zipCode, this.location});

//   @override
//   String toString() {
//     return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
//   }
// }

// class LocationClass {
//   LocationClass({
//     this.lat,
//     this.lng,
//   });

//   double? lat;
//   double? lng;

//   factory LocationClass.fromMap(Map<String, dynamic> json) => LocationClass(
//         lat: json["lat"].toDouble(),
//         lng: json["lng"].toDouble(),
//       );

//   Map<String, dynamic> toMap() => {
//         "lat": lat,
//         "lng": lng,
//       };
// }

// class Suggestion {
//   final String placeId;
//   final String description;

//   Suggestion(this.placeId, this.description);

//   @override
//   String toString() {
//     return 'Suggestion(description: $description, placeId: $placeId)';
//   }
// }

// class PlaceApiProvider {
//   // final client = Client();

//   PlaceApiProvider(this.sessionToken);

//   final sessionToken;

//   String baseURL =
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json';

//   String placeUrl = 'https://maps.googleapis.com/maps/api/place/details/json';

//   // static final String androidKey = Constants.MAP_KEY;

//   Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
//     debugPrint("url :: " +
//         '$baseURL?input=$input&language=$lang&components=country:in&key=${Constants.GOOGLE_PLACES_API_KEY}&sessiontoken=$sessionToken');
//     final request = Uri.parse(
//         '$baseURL?input=$input&language=$lang&components=country:in&key=${Constants.GOOGLE_PLACES_API_KEY}&sessiontoken=$sessionToken');
//     // '$baseURL?input=$input&types=address&language=$lang&components=country:in&key=$apiKey&sessiontoken=$sessionToken');
//     // final response = await client.get(request);
//     var response = await http.get(request);
//     debugPrint(response.body);
//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['status'] == 'OK') {
//         // compose suggestions in a list
//         print("Result @ ${result['predictions']}");
//         return result['predictions']
//             .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
//             .toList();
//       }
//       print("Response $response");
//       if (result['status'] == 'ZERO_RESULTS') {
//         return [];
//       }
//       throw Exception(result['error_message']);
//     } else {
//       throw Exception('Failed to fetch suggestion');
//     }
//   }

//   Future<Place?> getPlaceDetailFromId(String placeId) async {
//     final request = Uri.parse(
//         '$placeUrl?place_id=$placeId&fields=address_component,geometry&key=${Constants.GOOGLE_PLACES_API_KEY}&sessiontoken=$sessionToken');

//     consoleLog(
//         tag: "getPlaceDetailFromId",
//         message:
//             '$placeUrl?place_id=$placeId&key=${Constants.GOOGLE_PLACES_API_KEY}&sessiontoken=$sessionToken');
//     // final response = await client.get(request);
//     var response = await http.get(request);

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['status'] == 'OK') {
//         final components =
//             result['result']['address_components'] as List<dynamic>;
//         // build result
//         final place = Place();
//         components.forEach((c) {
//           final List type = c['types'];
//           // if (type.contains('street_number')) {
//           //   place.streetNumber = c['long_name'];
//           // }
//           if (type.contains('route')) {
//             place.street = c['long_name'];
//           }

//           if (type.contains('locality')) {
//             place.city = c['long_name'];
//           }

//           // if (type.contains('postal_code')) {
//           //   place.zipCode = c['long_name'];
//           // }
//         });

//         // location
//         var _coordinateLoc = result['result']['geometry'];
//         if (_coordinateLoc.toString().contains('location')) {
//           place.location = LocationClass();
//           place.location!.lat = _coordinateLoc['location']['lat'];
//           place.location!.lng = _coordinateLoc['location']['lng'];
//         }

//         return place;
//       }
//       // throw Exception(result['error_message}']);
//     } else {
//       throw Exception('Failed to fetch suggestion');
//     }
//   }
// }
