// import 'dart:io';

// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/screens/user/appleauthservice.dart';
// import 'package:portal/screens/user/auth_token_manager.dart';
// import 'package:portal/screens/user/bringyourownidentity.dart';
// import 'package:portal/screens/user/facebook_login_service.dart';

// class AuthService {
//   // Determine if we should use BYOI or standard Cognito flow
//   static bool get shouldUseBYOI => true; // Set to true to use BYOI approach

//   // Sign in with Apple
//   static Future<bool> signInWithApple(BuildContext context) async {
//     try {
//       if (Platform.isIOS) {
//         // Get Apple credentials
//         final appleCredentials = await AppleAuthService.performAppleSignIn();

//         // if (appleCredentials == null || !appleCredentials.containsKey('identityToken') || appleCredentials['identityToken'] == null) {
//         //   debugPrint('Failed to get Apple credentials');
//         //   return false;
//         // }
//         print('appleCreditanls:$appleCredentials');
//         final appleIdToken = appleCredentials!['identityToken'] as String;
//         final email = appleCredentials['email'] as String?;
//         final givenName = appleCredentials['givenName'] as String?;
//         final familyName = appleCredentials['familyName'] as String?;

//         final name = [givenName, familyName].where((e) => e != null && e.isNotEmpty).join(' ');

//         if (shouldUseBYOI) {
//           // BYOI approach
//           return await _handleBYOISignIn(
//             context: context,
//             provider: 'apple',
//             token: appleIdToken,
//             email: email,
//             name: name.isNotEmpty ? name : null,
//           );
//         } else {
//           // Standard Cognito WebUI approach
//           return await _handleStandardSignIn(
//             context: context,
//             provider: AuthProvider.apple,
//           );
//         }
//       } else {
//         // For Android, always use the standard WebUI approach
//         return await _handleStandardSignIn(
//           context: context,
//           provider: AuthProvider.apple,
//         );
//       }
//     } catch (e) {
//       debugPrint('Apple Sign In error: $e');
//       application.showToastAlert("Apple Sign In failed");
//       return false;
//     }
//   }

//   // Sign in with Google
//   static Future<bool> signInWithGoogle(BuildContext context) async {
//     try {
//       // For simplicity, we always use standard Cognito flow for Google
//       return await _handleStandardSignIn(
//         context: context,
//         provider: AuthProvider.google,
//       );
//     } catch (e) {
//       debugPrint('Google Sign In error: $e');
//       application.showToastAlert("Google Sign In failed");
//       return false;
//     }
//   }

// // Update lib/screens/user/authservice.dart
// // Add this method:

// // Sign in with Facebook
//   static Future<bool> signInWithFacebook(BuildContext context) async {
//     try {
//       // Get Facebook credentials
//       final facebookCredentials = await FacebookLoginService.performFacebookSignIn();
//       print('facebookCredentials:$facebookCredentials');
//       Clipboard.setData(ClipboardData(text: facebookCredentials.toString()));

//       if (facebookCredentials == null || !facebookCredentials.containsKey('token')) {
//         debugPrint('Failed to get Facebook credentials');
//         return false;
//       }

//       final facebookToken = facebookCredentials['token'] as String;
//       final userData = facebookCredentials['userData'] as Map<String, dynamic>?;
//       final email = userData?['email'] as String?;
//       final name = userData?['name'] as String?;

//       if (shouldUseBYOI) {
//         // BYOI approach
//         return await _handleBYOISignIn(
//           context: context,
//           provider: 'facebook',
//           token: facebookToken,
//           email: email,
//           name: name,
//         );
//       } else {
//         // Standard Cognito WebUI approach
//         return await _handleStandardSignIn(
//           context: context,
//           provider: AuthProvider.facebook,
//         );
//       }
//     } catch (e) {
//       debugPrint('Facebook Sign In error: $e');
//       application.showToastAlert("Facebook Sign In failed");
//       return false;
//     }
//   }

//   // Handle sign-in with standard Cognito WebUI flow
//   static Future<bool> _handleStandardSignIn({
//     required BuildContext context,
//     required AuthProvider provider,
//   }) async {
//     try {
//       final result = await Amplify.Auth.signInWithWebUI(
//         provider: provider,
//         options: const SignInWithWebUIOptions(
//           pluginOptions: CognitoSignInWithWebUIPluginOptions(
//             isPreferPrivateSession: false,
//           ),
//         ),
//       );

//       if (result.isSignedIn) {
//         // Fetch the session
//         CognitoAuthSession session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

//         // Store tokens in application
//         await application.setUserType(2);
//         application.setAccessToken(session.userPoolTokensResult.value.accessToken.raw);
//         application.setRefreshToken(session.userPoolTokensResult.value.refreshToken);
//         application.setIdToken(session.userPoolTokensResult.value.idToken.raw);

//         // Also store in token manager for BYOI compatibility
//         await AuthTokenManager.storeTokens(
//           accessToken: session.userPoolTokensResult.value.accessToken.raw,
//           idToken: session.userPoolTokensResult.value.idToken.raw,
//           refreshToken: session.userPoolTokensResult.value.refreshToken,
//         );

//         return true;
//       }

//       return false;
//     } catch (e) {
//       debugPrint('Standard sign in error: $e');
//       return false;
//     }
//   }

//   // Handle sign-in with BYOI approach
//   static Future<bool> _handleBYOISignIn({
//     required BuildContext context,
//     required String provider,
//     required String token,
//     String? email,
//     String? name,
//   }) async {
//     try {
//       // Exchange token with backend
//       final result = await BringYourOwnIdentityService.exchangeTokenForCognitoCredentials(
//         provider: provider,
//         token: token,
//         email: email,
//         name: name,
//       );

//       if (!result.isSignedIn) {
//         debugPrint('Failed to exchange token: ${result.error}');
//         return false;
//       }

//       // Get the tokens
//       final accessToken = result.accessToken!;
//       final idToken = result.idToken!;
//       final refreshToken = result.refreshToken!;

//       // Store tokens in application
//       await application.setUserType(2);
//       application.setAccessToken(accessToken);
//       application.setRefreshToken(refreshToken);
//       application.setIdToken(idToken);

//       // Also store in token manager
//       await AuthTokenManager.storeTokens(
//         accessToken: accessToken,
//         idToken: idToken,
//         refreshToken: refreshToken,
//       );

//       return true;
//     } catch (e) {
//       debugPrint('BYOI sign in error: $e');
//       return false;
//     }
//   }

//   // Sign out user
//   static Future<void> signOut() async {
//     try {
//       // Sign out from Amplify
//       await Amplify.Auth.signOut();

//       // Clear tokens from storage
//       await AuthTokenManager.clearTokens();

//       // Clear application state
//       await application.setUserType(0);
//       application.setAccessToken('');
//       application.setRefreshToken('');
//       application.setIdToken('');
//     } catch (e) {
//       debugPrint('Sign out error: $e');
//       // Still clear local tokens even if Amplify sign out fails
//       await AuthTokenManager.clearTokens();
//     }
//   }
// }
