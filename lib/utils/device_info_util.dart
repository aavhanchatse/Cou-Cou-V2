import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoUtil {
  static Future<AndroidDeviceInfo?> getAndroidDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      AndroidDeviceInfo deviceData = await deviceInfoPlugin.androidInfo;
      return deviceData;
    } on PlatformException {
      debugPrint('Failed to get device info');
    }
    return null;
  }

  static Future<IosDeviceInfo?> getIosDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      IosDeviceInfo deviceData = await deviceInfoPlugin.iosInfo;
      return deviceData;
    } on PlatformException {
      debugPrint('Failed to get device info');
    }
    return null;
  }

  static Future<String> getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getDeviceId() async {
    late String deviceId;

    if (GetPlatform.isAndroid) {
      final data = await DeviceInfoUtil.getAndroidDeviceInfo();
      deviceId = data!.androidId!;
    }
    if (GetPlatform.isIOS) {
      final data = await DeviceInfoUtil.getIosDeviceInfo();
      deviceId = data!.identifierForVendor!;
    }

    return deviceId;
  }
}
