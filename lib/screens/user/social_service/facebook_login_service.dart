// // lib/screens/user/facebook_login_service.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class FacebookLoginService {
//   // Singleton pattern
//   static final FacebookLoginService _instance = FacebookLoginService._internal();
//   factory FacebookLoginService() => _instance;
//   FacebookLoginService._internal();

//   /// Perform native Facebook Sign In
//   static Future<Map<String, dynamic>?> performFacebookSignIn() async {
//     try {
//       // Attempt login
//       final LoginResult result = await FacebookAuth.instance.login(
//         permissions: ['public_profile'],
//       );
//       print('result in facebook login service: $result');

//       if (result.status == LoginStatus.success) {
//         // Get access token
//         final String token = result.accessToken!.tokenString;

//         // Get user data (optional - can be useful for your backend)
//         final userData = await FacebookAuth.instance.getUserData(
//           fields: "id,name,email,picture.width(200)",
//         );

//         return {
//           'token': token,
//           'userData': userData,
//         };
//       } else if (result.status == LoginStatus.cancelled) {
//         debugPrint('Facebook login cancelled by user');
//         return null;
//       } else {
//         debugPrint('Facebook login failed: ${result.message}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error during Facebook Sign In: $e');
//       return null;
//     }
//   }

//   // Logout from Facebook
//   static Future<void> logOut() async {
//     await FacebookAuth.instance.logOut();
//   }
// }
