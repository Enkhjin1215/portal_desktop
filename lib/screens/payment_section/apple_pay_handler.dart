import 'package:flutter/services.dart';

class ApplePayItemDetail {
  final String label;
  final double amount;

  ApplePayItemDetail({required this.label, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'amount': amount,
    };
  }
}

class ApplePayHandler {
  static const _channel = MethodChannel('apple_pay_channel');

  static Future<void> initApplePay({
    required String orderId,
    required List<ApplePayItemDetail> items,
    required String token,
  }) async {
    print('test connection waiting');
    await _channel.invokeMethod('testConnection');
    print('test connection done');

    try {
      await _channel.invokeMethod('initApplePay', {
        'orderId': orderId,
        'bearerToken': token,
        'items': items.map((item) => item.toMap()).toList(),
      });
    } on PlatformException catch (e) {
      print("Apple Pay Error: ${e.message}");
    }
  }

  static Future<void> presentApplePay() async {
    try {
      await _channel.invokeMethod('presentApplePay');
    } on PlatformException catch (e) {
      print("Apple Pay Presentation Error: ${e.message}");
    }
  }
}
