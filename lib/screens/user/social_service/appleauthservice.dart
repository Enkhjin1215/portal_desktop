import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppleAuthService {
  static const MethodChannel _channel = MethodChannel('apple_auth_channel');

  // Check if device supports Apple Sign In
  static Future<bool> isAppleSignInAvailable() async {
    if (!Platform.isIOS) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod('testAppleAuthConnection');
      return result != null;
    } catch (e) {
      debugPrint('Error checking Apple Sign In availability: $e');
      return false;
    }
  }

  // Perform native Apple Sign In
  static Future<Map<String, dynamic>?> performAppleSignIn() async {
    if (!Platform.isIOS) {
      return null;
    }

    try {
      final result = await _channel.invokeMethod('initiateAppleSignIn');
      return result is Map ? Map<String, dynamic>.from(result) : null;
    } catch (e) {
      debugPrint('Error during Apple Sign In: $e');
      return null;
    }
  }
}
