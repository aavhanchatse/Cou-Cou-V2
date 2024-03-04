import 'dart:async';
import 'dart:convert';

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
import 'package:coucou_v2/localization/localization_service.dart';
import 'package:coucou_v2/models/user_data.dart';
import 'package:coucou_v2/repo/post_repo.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/storage_manager.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/widgets/reels_page_view_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

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

  analytics.setAnalyticsCollectionEnabled(true);

  await FlutterBranchSdk.init(
      useTestKey: true, enableLogging: true, disableTracking: false);

  runApp(const MyApp());

  // handleDeepLink();
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
  String localeLan = "en";

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    var result = StorageManager().getData("language");
    if (result != null) {
      localeLan = result;
      Get.updateLocale(Locale(result));
    }
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

    return ShowCaseWidget(
      onStart: (index, key) {
        debugPrint('onStart: $index, $key');
      },
      onComplete: (index, key) {
        debugPrint('onComplete: $index, $key');
        if (index == 4) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
            ),
          );
        }
      },
      blurValue: 1,
      builder: Builder(builder: (context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
              builder: (BuildContext context2, Orientation orientation) {
            SizeConfig.init(constraints, orientation);

            return GetMaterialApp.router(
              title: 'Cou Cou',
              navigatorObservers: <NavigatorObserver>[observer],
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
              theme: Themes.light,
              debugShowCheckedModeBanner: false,
              locale: Locale(localeLan),
              fallbackLocale: LocalizationService.fallbackLocale,
              translations: LocalizationService(),
            );

            // return MaterialApp.router(
            //   title: 'Cou Cou',
            //   routerConfig: AppRouter.router,
            //   theme: Themes.light,
            //   localizationsDelegates: [
            //     S.delegate,
            //     GlobalMaterialLocalizations.delegate,
            //     GlobalWidgetsLocalizations.delegate,
            //     GlobalCupertinoLocalizations.delegate,
            //   ],
            //   // locale: Locale(localeLan),
            //   // fallbackLocale: LocalizationService.fallbackLocale,
            //   // translations: LocalizationService(),
            //   debugShowCheckedModeBanner: false,
            // );
          });
        });
      }),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

void handleDeepLink(BuildContext context) {
  debugPrint("inside deeplink");

  streamSubscription.onData((data) async {
    debugPrint("branch_key : ${jsonEncode(data)}");
    debugPrint("data['+clicked_branch_link'] ${data['+clicked_branch_link']}");
    debugPrint("data['~channel'] ${data['~channel']}");

    if (data['+clicked_branch_link']) {
      if (data['~channel'] == "challengePost") {
        String postId = data['post_id'];

        final result = await PostRepo().getPostData(postId);

        // Get.to(() => ReelsPageViewWidget(item: result.data!));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                body: SafeArea(child: ReelsPageViewWidget(item: result.data!))),
          ),
        );
      }
    } else {
      var box = StorageManager();

      UserData? userData = box.getUserData();

      if (userData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavBar(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  });
}

StreamSubscription<Map> streamSubscription =
    FlutterBranchSdk.listSession().listen((data) {
  if (data.containsKey("+clicked_branch_link") &&
      data["+clicked_branch_link"] == true) {
    //Link clicked. Add logic to get link data and route user to correct screen
    debugPrint('Custom string: ${data["custom_string"]}');
  }
}, onError: (error) {
  PlatformException platformException = error as PlatformException;
  debugPrint(
      'InitSession error: ${platformException.code} - ${platformException.message}');
});

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(minutes: 5),
  ));

  await remoteConfig.fetchAndActivate();

  RemoteConfigValue(null, ValueSource.valueStatic);

  return remoteConfig;
}
