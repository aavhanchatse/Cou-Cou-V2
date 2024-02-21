import 'dart:typed_data';

import 'package:coucou_v2/models/post_data.dart';
import 'package:coucou_v2/view/screens/challenge/all_challenges_screen.dart';
import 'package:coucou_v2/view/screens/challenge/challenge_details_screen.dart';
import 'package:coucou_v2/view/screens/comment/comment_screen.dart';
import 'package:coucou_v2/view/screens/home/home_screen.dart';
import 'package:coucou_v2/view/screens/login/login_screen.dart';
import 'package:coucou_v2/view/screens/login/otp_screen.dart';
import 'package:coucou_v2/view/screens/login/phone_number_otp_screen.dart';
import 'package:coucou_v2/view/screens/login/registration_screen.dart';
import 'package:coucou_v2/view/screens/login/reset_password_screen.dart';
import 'package:coucou_v2/view/screens/navbar/navbar.dart';
import 'package:coucou_v2/view/screens/profile/complete_details_screen.dart';
import 'package:coucou_v2/view/screens/profile/update_profile_screen.dart';
import 'package:coucou_v2/view/screens/profile/user_profile_screen.dart';
import 'package:coucou_v2/view/screens/search/search_screen.dart';
import 'package:coucou_v2/view/screens/splashscreen/splash_screen.dart';
import 'package:coucou_v2/view/screens/update_address/update_address_screen.dart';
import 'package:coucou_v2/view/screens/update_password/update_password_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/camera_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/edit_image_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/select_image_screen.dart';
import 'package:coucou_v2/view/screens/upload_post/select_image_screen_2.dart';
import 'package:coucou_v2/view/screens/upload_post/upload_post_details_screen.dart';
import 'package:coucou_v2/view/widgets/dismissible_page.dart';
import 'package:coucou_v2/view/widgets/image_cropper_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    // initialLocation: CameraScreen.routeName,
    initialLocation: SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: NavBar.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final bool? fromLogin = state.extra as bool?;

          return NavBar(fromLogin: fromLogin);
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: ChallengeDetailsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final Map map = state.extra as Map;

          final String? id = map['id'];

          return ChallengeDetailsScreen(challengeId: id ?? "");
        },
      ),
      GoRoute(
        path: AllChallengesScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const AllChallengesScreen();
        },
      ),
      GoRoute(
        path: SelectImageScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SelectImageScreen();
        },
      ),
      GoRoute(
        path: CameraScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const CameraScreen();
        },
      ),
      GoRoute(
        path: UploadPostDetailsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final PostData? data = state.extra as PostData?;
          return UploadPostDetailsScreen(postData: data);
        },
      ),
      GoRoute(
        path: UserProfileScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final String? id = state.extra as String?;

          return UserProfileScreen(userId: id);
        },
      ),
      GoRoute(
        path: UpdatePasswordScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UpdatePasswordScreen();
        },
      ),
      GoRoute(
        path: UpdateAddressScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UpdateAddressScreen();
        },
      ),
      GoRoute(
        path: SearchScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SearchScreen();
        },
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: PhoneNumberOTPScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final bool registerValue = state.extra as bool;

          return PhoneNumberOTPScreen(register: registerValue);
        },
      ),
      GoRoute(
        path: OTPScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final Map map = state.extra as Map;
          final bool? registerValue = map["register"];
          final String phoneNumber = map["phoneNumber"];

          return OTPScreen(
            phoneNumber: phoneNumber,
            register: registerValue,
          );
        },
      ),
      GoRoute(
        path: RegistrationScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final String phoneNumber = state.extra as String;

          return RegistrationScreen(
            phoneNumber: phoneNumber,
          );
        },
      ),
      GoRoute(
        path: ResetPasswordScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final String phoneNumber = state.extra as String;

          return ResetPasswordScreen(
            phoneNumber: phoneNumber,
          );
        },
      ),
      GoRoute(
        path: DismissPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final Map map = state.extra as Map;

          return DismissPage(
            initialIndex: map["initialIndex"] ?? "",
            imageList: map["imageList"],
            isVideo: map["isVideo"],
            disableScreenshot: map["disableScreenshot"],
            localList: map["localList"],
          );
        },
      ),
      GoRoute(
        path: CommentScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final PostData data = state.extra as PostData;

          return CommentScreen(post: data);
        },
      ),
      GoRoute(
        path: CropImagePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final Uint8List bytes = state.extra as Uint8List;

          return CropImagePage(imageBytes: bytes);
        },
      ),
      GoRoute(
        path: EditImageScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final bool isVideo = state.extra as bool;

          return EditImageScreen(
            isVideo: isVideo,
          );
        },
      ),
      GoRoute(
        path: SelectImageScreen2.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SelectImageScreen2();
        },
      ),
      GoRoute(
        path: UpdateProfileScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UpdateProfileScreen();
        },
      ),
      GoRoute(
        path: CompleteDetailsScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const CompleteDetailsScreen();
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text("${state.error}"),
        ),
      );
    },
  );
}
