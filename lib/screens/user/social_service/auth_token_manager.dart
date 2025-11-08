import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthTokenManager {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _idTokenKey = 'auth_id_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  // Store tokens in secure storage
  static Future<void> storeTokens({
    required String accessToken,
    required String idToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_idTokenKey, idToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    debugPrint('Tokens stored successfully');
  }

  // Get stored tokens
  static Future<Map<String, String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'access_token': prefs.getString(_accessTokenKey),
      'idToken': prefs.getString(_idTokenKey),
      'refresh_token': prefs.getString(_refreshTokenKey),
    };
  }

  // Clear stored tokens (for logout)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_idTokenKey);
    await prefs.remove(_refreshTokenKey);

    debugPrint('Tokens cleared successfully');
  }

  // Check if tokens are valid
  static Future<bool> hasValidTokens() async {
    try {
      final tokens = await getTokens();
      final accessToken = tokens['access_token'];

      if (accessToken == null) {
        return false;
      }

      // Check if token is expired
      final decodedToken = JwtDecoder.decode(accessToken);
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);

      return DateTime.now().isBefore(expirationDate);
    } catch (e) {
      debugPrint('Error checking token validity: $e');
      return false;
    }
  }

  // Get user info from ID token
  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final tokens = await getTokens();
      final idToken = tokens['idToken'];

      if (idToken == null) {
        return null;
      }

      return JwtDecoder.decode(idToken);
    } catch (e) {
      debugPrint('Error getting user info: $e');
      return null;
    }
  }
}
