// import 'dart:async';

// // import 'package:apple_sign_in/apple_sign_in.dart' as appleSignin;

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class Authentication {
//   static Future<FirebaseApp> initializeFirebase() async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();

//     return firebaseApp;
//   }

//   static Future<User?> signInWithGoogle(
//       {@required BuildContext? context}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final GoogleSignInAccount? googleSignInAccount =
//         await googleSignIn.signIn();

//     if (googleSignInAccount != null) {
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       try {
//         final UserCredential userCredential =
//             await auth.signInWithCredential(credential);

//         user = userCredential.user!;
//       } on FirebaseAuthException catch (e) {
//         print("firebase_error $e");
//         if (e.code == 'account-exists-with-different-credential') {
//           // handle the error here
//           print("error $e");
//         } else if (e.code == 'invalid-credential') {
//           // handle the error here
//           print("error $e");
//         }
//       } catch (e) {
//         // handle the error here
//         print("error $e");
//       }
//     }

//     return user;
//   }

//   // Future<User> _handleAppleSignIn() async{
//   //
//   //   try {
//   //     final appleSignin.AuthorizationResult results = await appleSignin.AppleSignIn.performRequests([
//   //       appleSignin.AppleIdRequest(requestedScopes: [appleSignin.Scope.email, appleSignin.Scope.fullName])
//   //     ]);
//   //
//   //     switch (results.status) {
//   //       case AuthorizationStatus.authorized:
//   //         try {
//   //           print("successfull sign in");
//   //           final appleSignin.AppleIdCredential appleIdCredential = result.credential;
//   //
//   //           OAuthProvider oAuthProvider =
//   //           new OAuthProvider("apple.com");
//   //           final AuthCredential credential = oAuthProvider.credential(
//   //             idToken:
//   //             String.fromCharCodes(appleIdCredential.identityToken),
//   //             accessToken:
//   //             String.fromCharCodes(appleIdCredential.authorizationCode),
//   //           );
//   //
//   //           await FirebaseAuth.instance.signInWithCredential(credential);
//   //
//   //           final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
//   //           final firebaseUser = authResult.user;
//   //
//   //           final displayName =
//   //               '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
//   //           await firebaseUser.updateDisplayName(displayName);
//   //
//   //           return firebaseUser;
//   //         } catch (e) {
//   //           print('------------------');
//   //           print(e);
//   //           print('error');
//   //           return null;
//   //         }
//   //         break;
//   //       case appleSignin.AuthorizationStatus.error:
//   //         return null;
//   //
//   //       case appleSignin.AuthorizationStatus.cancelled:
//   //         print('User cancelled');
//   //         return null;
//   //     }
//   //   } catch (error) {
//   //     print("error with apple sign in");
//   //     return null;
//   //   }
//   // }

//   static Future<User?> signInWithFacebook() async {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     final LoginResult result = await FacebookAuth.instance.login();

//     // consoleLog(
//     //     tag: "access_token", message: result.accessToken!.isExpired.toString());
//     // Create a credential from the access token
//     final facebookAuthCredential =
//         FacebookAuthProvider.credential(result.accessToken!.token);

//     // Once signed in, return the UserCredential
//     UserCredential? userCredential;

//     userCredential = await FirebaseAuth.instance
//         .signInWithCredential(facebookAuthCredential)
//         .onError((error, stackTrace) async {
//       debugPrint("error_auth : $error");
//       if (error.toString().contains("same email")) {
//         userCredential =
//             await auth.currentUser!.linkWithCredential(facebookAuthCredential);
//         return userCredential!;
//       } else {
//         return userCredential!;
//       }
//     });

//     return userCredential!.user;
//   }

// // static Future<UserDeviceInfoPayLoad> fcmtoken() async {
// //
// //   final fcmToken = await FirebaseMessaging.instance.getToken();
// //   final device = UserDeviceInfoPayLoad();
// //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// //   if (GetPlatform.isAndroid) {
// //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
// //     device.device_unique_id = androidInfo.androidId;
// //     device.phone_OS = androidInfo.version.release;
// //     device.Fcm_token = fcmToken;
// //     device.model_number = androidInfo.model;
// //     device.manufacture = androidInfo.manufacturer;
// //     device.app_version = androidInfo.version.release;
// //     device.phone_version = androidInfo.version.codename;
// //   } else {
// //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
// //     device.device_unique_id = iosInfo.identifierForVendor;
// //     device.phone_OS = iosInfo.systemName;
// //     device.Fcm_token = fcmToken;
// //     device.model_number = iosInfo.model;
// //     device.manufacture = "apple";
// //     device.app_version = iosInfo.utsname.release;
// //     device.phone_version = iosInfo.systemVersion;
// //   }
// //
// //   Preference.setItem("dui", device.device_unique_id);
// //   return device;
// // }
// }
