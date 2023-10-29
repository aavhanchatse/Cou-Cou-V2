import 'package:app_settings/app_settings.dart';
import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/default_snackbar_util.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as locationData;

class LocationUtils {
  static Future<Location?> getLocationCoordinates(String place) async {
    var locations = await locationFromAddress(place);
    if (locations.isNotEmpty) {
      return locations.first;
    }
    return null;
  }

  static Future<Position?>? getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    locationData.Location locationDatum = locationData.Location();

    // Test if location services are enabled.
    serviceEnabled = await locationDatum.serviceEnabled();
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('serviceEnabled: $serviceEnabled');

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      debugPrint('Location services are disabled, requesting again');

      serviceEnabled = await locationDatum.requestService();

      debugPrint('requested again: $serviceEnabled');
      if (!serviceEnabled) {
        return null;
      }

      // return null;
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    debugPrint('permission: $permission');

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        debugPrint('Location permissions are denied');

        // SnackBarUtil.showSnackBar('Location permission denied');
        return null;
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      debugPrint(
          'Location permissions are permanently denied, we cannot request permissions.');

      // SnackBarUtil.showSnackBar(
      //   'Location permission disabled',
      //   actionButton: TextButton(
      //     onPressed: () {
      //       AppSettings.openAppSettings();
      //     },
      //     child: Text(
      //       'App Settings',
      //       style: TextStyle(color: Constants.white, fontSize: 1.8.t),
      //     ),
      //   ),
      // );
      return null;
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  static Future<Placemark?> getLocationFromCoordinates(
      Position position) async {
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(18.592347, 73.785125);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    debugPrint(placemarks.first.toString());

    if (placemarks.isNotEmpty) {
      return placemarks.first;
    }
    return null;
  }

  static String getCompleteAddress(Placemark placemark) {
    return '${placemark.subLocality}${placemark.subLocality!.isEmpty ? '' : ','} ${placemark.locality}${placemark.locality!.isEmpty ? '' : ','} ${placemark.subAdministrativeArea}${placemark.subAdministrativeArea!.isEmpty ? '' : ','} ${placemark.administrativeArea}${placemark.administrativeArea!.isEmpty ? '' : ','} ${placemark.country}${placemark.country!.isEmpty ? '' : ','} ${placemark.postalCode}'
        .trim();
  }

  static String? getShortAddress(Placemark placemark) {
    if (placemark.subLocality!.isNotEmpty &&
        placemark.subAdministrativeArea!.isNotEmpty) {
      return '${placemark.subLocality}, ${placemark.subAdministrativeArea}';
    }

    if (placemark.subAdministrativeArea!.isNotEmpty) {
      return placemark.subAdministrativeArea;
    }

    return null;
  }
}
