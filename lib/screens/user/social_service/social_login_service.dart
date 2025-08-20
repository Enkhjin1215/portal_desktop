// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/helper/constant.dart';
// import 'package:portal/router/route_path.dart';

// class SocialAuthService {
//   // Singleton pattern
//   static final SocialAuthService _instance = SocialAuthService._internal();
//   factory SocialAuthService() => _instance;
//   SocialAuthService._internal();

//   // Flag to prevent multiple sign-in attempts
//   bool _isSigningIn = false;

//   /// Signs in with the provided social provider
//   Future<bool> signInWithSocial(AuthProvider provider, BuildContext context) async {
//     if (_isSigningIn) {
//       debugPrint('Sign in already in progress');
//       return false;
//     }

//     _isSigningIn = true;
//     try {
//       final result = await Amplify.Auth.signInWithWebUI(
//         provider: provider,
//         options: const SignInWithWebUIOptions(
//           pluginOptions: CognitoSignInWithWebUIPluginOptions(
//             isPreferPrivateSession: false, // For persistent session
//           ),
//         ),
//       );

//       if (result.isSignedIn) {
//         // Get user details and tokens
//         final user = await Amplify.Auth.getCurrentUser();
//         debugPrint('Social login successful for user: ${user.username}');

//         // Fetch session information
//         final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

//         // Store tokens in application state
//         await application.setUserType(2);
//         application.setAccessToken(session.userPoolTokensResult.value.accessToken.raw);
//         application.setRefreshToken(session.userPoolTokensResult.value.refreshToken);
//         application.setIdToken(session.userPoolTokensResult.value.idToken.raw);

//         // Navigate to home
//         NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);

//         return true;
//       } else {
//         debugPrint('User not signed in after social auth flow');
//         _isSigningIn = false;
//         return false;
//       }
//     } on UserCancelledException {
//       // User cancelled the sign-in flow
//       debugPrint('User cancelled the sign in flow');
//     } on AmplifyException catch (e) {
//       debugPrint('Error signing in: ${e.message}');

//       // Handle specific errors
//       if (e.message.contains('NOT_AUTHORIZED') || e.message.contains('User does not exist')) {
//         // Attempt to sign up if user doesn't exist
//         try {
//           return await _handleNewSocialUser(provider, context);
//         } catch (signUpError) {
//           debugPrint('Error signing up new social user: $signUpError');
//           return false;
//         }
//       }

//       // Show error to user
//       application.showToastAlert('Login failed: ${e.message}');
//     } catch (e) {
//       debugPrint('Unexpected error during social sign-in: $e');
//       application.showToastAlert('An unexpected error occurred');
//     } finally {
//       _isSigningIn = false;
//     }

//     return false;
//   }

//   /// Handles a new social user that needs to be created
//   Future<bool> _handleNewSocialUser(AuthProvider provider, BuildContext context) async {
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
//         // Get user details
//         final user = await Amplify.Auth.getCurrentUser();
//         final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

//         debugPrint('New social user registered: ${user.username}');

//         // Save authentication tokens
//         await application.setUserType(2);
//         application.setAccessToken(session.userPoolTokensResult.value.accessToken.raw);
//         application.setRefreshToken(session.userPoolTokensResult.value.refreshToken);
//         application.setIdToken(session.userPoolTokensResult.value.idToken.raw);

//         // Navigate to home
//         NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);

//         return true;
//       }
//       return false;
//     } on AuthException catch (e) {
//       debugPrint('Error during social sign-up: ${e.message}');
//       application.showToastAlert('Registration failed: ${e.message}');
//       return false;
//     }
//   }

//   /// Signs out the current user
//   Future<void> signOut() async {
//     try {
//       await Amplify.Auth.signOut(options: const SignOutOptions(globalSignOut: true));
//       debugPrint('User signed out successfully');
//     } on AuthException catch (e) {
//       debugPrint('Error signing out: ${e.message}');
//     }
//   }
// }
