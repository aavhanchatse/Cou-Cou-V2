import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:coucou_v2/amplifyconfiguration.dart';
import 'package:coucou_v2/app_constants/router.dart';
import 'package:coucou_v2/app_constants/themes.dart';
import 'package:coucou_v2/controllers/homescreen_controller.dart';
import 'package:coucou_v2/controllers/navbar_controller.dart';
import 'package:coucou_v2/controllers/post_controller.dart';
import 'package:coucou_v2/controllers/user_controller.dart';
import 'package:coucou_v2/firebase_options.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  await GetStorage.init();

  checkNotificationPermissions();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.subscribeToTopic("all");

  runApp(const MyApp());
}

Future<void> checkNotificationPermissions() async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  debugPrint('Handling a background message $message');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String localeLan = "en";

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    // var result = StorageManager().getData("language");
    // if (result != null) {
    //   localeLan = result;
    //   Get.updateLocale(Locale(result));
    // }
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      debugPrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NavbarController());
    Get.put(UserController());
    Get.put(HomescreenController());
    Get.put(PostController());

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OrientationBuilder(
          builder: (BuildContext context2, Orientation orientation) {
        SizeConfig.init(constraints, orientation);

        return MaterialApp.router(
          title: 'Cou Cou',
          routerConfig: AppRouter.router,
          theme: Themes.light,
          // locale: Locale(localeLan),
          // fallbackLocale: LocalizationService.fallbackLocale,
          // translations: LocalizationService(),
          debugShowCheckedModeBanner: false,
        );
      });
    });
  }
}
