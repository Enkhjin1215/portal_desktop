import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Custom class to hold auth result for BYOI approach
class BYOIAuthResult {
  final bool isSignedIn;
  final String? accessToken;
  final String? idToken;
  final String? refreshToken;
  final String? error;

  BYOIAuthResult({
    this.isSignedIn = false,
    this.accessToken,
    this.idToken,
    this.refreshToken,
    this.error,
  });

  factory BYOIAuthResult.success({
    required String accessToken,
    required String idToken,
    required String refreshToken,
  }) {
    return BYOIAuthResult(
      isSignedIn: true,
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
    );
  }

  factory BYOIAuthResult.error(String error) {
    return BYOIAuthResult(
      isSignedIn: false,
      error: error,
    );
  }
}

class BringYourOwnIdentityService {
  static const String baseUrl = 'http://192.168.1.16:3030';

  // Exchange social provider token for Cognito tokens
  static Future<BYOIAuthResult> exchangeTokenForCognitoCredentials({
    required String provider,
    required String token,
    String? email,
    String? name,
  }) async {
    try {
      // Use the same endpoint for all social providers
      final response = await http.post(
        Uri.parse('$baseUrl/v1/auth/federated-identity'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'provider': provider, // 'apple', 'google', 'facebook'
          'token': token,
          'email': email,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (!data.containsKey('access_token') || !data.containsKey('idToken') || !data.containsKey('refresh_token')) {
          return BYOIAuthResult.error('Invalid response from server');
        }

        return BYOIAuthResult.success(
          accessToken: data['access_token'],
          idToken: data['idToken'],
          refreshToken: data['refresh_token'],
        );
      } else {
        debugPrint('Error exchanging token: ${response.statusCode}, ${response.body}');
        return BYOIAuthResult.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception exchanging token: $e');
      return BYOIAuthResult.error('Network error: $e');
    }
  }

  // Sign in with Apple using the "Bring Your Own Identity" approach
  static Future<BYOIAuthResult> signInWithAppleBYOI({
    required String appleIdToken,
    String? email,
    String? name,
  }) async {
    try {
      // Exchange Apple token for Cognito tokens via your backend
      return await exchangeTokenForCognitoCredentials(
        provider: 'apple',
        token: appleIdToken,
        email: email,
        name: name,
      );
    } catch (e) {
      debugPrint('Error in BYOI flow: $e');
      return BYOIAuthResult.error('Authentication failed: $e');
    }
  }
}
