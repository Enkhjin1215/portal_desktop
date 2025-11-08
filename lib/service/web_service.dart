// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/models/token_model.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/provider/provider_core.dart';

/// Resource class that holds information needed to make an API request.
class Resource<T> {
  final String url;
  T Function(http.Response response) parse;

  Resource({required this.url, required this.parse});
}

/// Result class to standardize API responses.
class ApiResult<T> {
  final T? data;
  final String? error;
  final int statusCode;

  ApiResult({this.data, this.error, required this.statusCode});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isUnauthorized => statusCode == 401;
}

/// Main service class for handling API requests.
class Webservice {
  final _client = http.Client();

  /// Makes a POST request to the API.
  Future<dynamic> loadPost<T>(Resource<T> resource, BuildContext context, dynamic body, {String parameter = ''}) async {
    await _checkTokenExpiration(context);

    try {
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(true);
      }

      final headers = await application.getHeaders();
      final url = Uri.parse(resource.url + parameter);
      final encodedBody = jsonEncode(body);

      _logRequest('POST', url, body: encodedBody, headers: headers);

      final response = await _client.post(url, headers: headers, body: encodedBody);

      _logResponse(response);
      final result = await _handleResponse(response, context);

      Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      if (result.isSuccess) {
        if (response.body == '') {
        } else {
          return resource.parse(response);
        }
      } else if (result.isUnauthorized) {
        _handleUnauthorized(context);
      } else {
        _showErrorMessage(context, result.error);
        throw Exception(result.error);
      }
    } catch (e) {
      debugPrint('Web Service exception: $e');
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      }
      throw Exception(e);
    }
  }

  /// Makes a GET request to the API.
  Future<T> loadGet<T>(Resource<T> resource, BuildContext context, {String parameter = ''}) async {
    await _checkTokenExpiration(context);
    print('parameter:$parameter');
    if (context.mounted) {
      Provider.of<ProviderCoreModel>(context, listen: false).setLoading(true);
    }

    try {
      final headers = await application.getHeaders();
      final url = Uri.parse(resource.url + parameter);

      _logRequest('GET', url, headers: headers);

      final response = await _client.get(url, headers: headers);

      _logResponse(response);

      final result = await _handleResponse(response, context);

      Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      print('result isSucces:${result.isSuccess}\n${result.isUnauthorized}');

      if (result.isUnauthorized) {
        _handleUnauthorized(context);
      } else if (result.isSuccess) {
        return resource.parse(response);
      } else {
        _showErrorMessage(context, result.error);
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      debugPrint('Web Service exception: $e');
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      }
      throw Exception('Failed to load data!');
    }

    // This is to satisfy the compiler, but should never be reached due to exceptions
    throw Exception('Failed to load data!');
  }

  Future<dynamic> loadPatch<T>(Resource<T> resource, BuildContext context, dynamic body, {String parameter = ''}) async {
    await _checkTokenExpiration(context);

    try {
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(true);
      }

      final headers = await application.getHeaders();
      final url = Uri.parse(resource.url + parameter);
      final encodedBody = jsonEncode(body);

      _logRequest('PATCH', url, body: encodedBody, headers: headers);

      final response = await _client.patch(url, headers: headers, body: encodedBody);

      _logResponse(response);
      final result = await _handleResponse(response, context);

      Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      if (result.isSuccess) {
        return resource.parse(response);
      } else if (result.isUnauthorized) {
        _handleUnauthorized(context);
      } else {
        _showErrorMessage(context, result.error);
        throw Exception(result.error);
      }
    } catch (e) {
      debugPrint('Web Service exception: $e');
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      }
      throw Exception(e);
    }
  }

  /// Makes a DELETE request to the API.
  Future<T> loadDelete<T>(Resource<T> resource, BuildContext context, {String parameter = '', bool alertShow = true}) async {
    await _checkTokenExpiration(context);

    if (context.mounted) {
      Provider.of<ProviderCoreModel>(context, listen: false).setLoading(true);
    }

    try {
      final headers = await application.getHeaders();
      final url = Uri.parse(resource.url + parameter);

      _logRequest('DELETE', url, headers: headers);

      final response = await _client.delete(url, headers: headers);

      _logResponse(response);

      final result = await _handleResponse(response, context);

      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      }

      if (result.isSuccess) {
        return resource.parse(response);
      } else if (result.isUnauthorized) {
        _handleUnauthorized(context);
      } else {
        if (alertShow) {
          _showErrorMessage(context, result.error);
        }
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      debugPrint('Web Service exception: $e');
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
      }
      throw Exception('Failed to load data!');
    }

    // This is to satisfy the compiler, but should never be reached due to exceptions
    throw Exception('Failed to load data!');
  }

  /// Refreshes the authentication token.
  Future<dynamic> loadRefreshToken<T>(Resource<T> resource, BuildContext context) async {
    String token = await application.getRefreshToken();
    final Map<String, dynamic> body = <String, dynamic>{'refreshToken': token};
    try {
      final headers = {"Content-Type": "application/json", "charset": "UTF-8", "merchange": "portal"};

      final url = Uri.parse(resource.url);

      _logRequest('POST', url, body: body, headers: headers);

      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return resource.parse(response);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        _handleTokenRefreshFailure(context);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      debugPrint('Token refresh exception: $e');
      _handleTokenRefreshFailure(context);
    }

    throw Exception('Failed to refresh token');
  }

  /// Checks if the token is expired and refreshes it if needed.
  Future<void> _checkTokenExpiration(BuildContext context) async {
    final jwtToken = await application.getAccessToken();
    debugPrint('JWT TOKEN: $jwtToken');
    if (jwtToken.isNotEmpty) {
      debugPrint('JWT TOKEN expired: ${JwtDecoder.isExpired(jwtToken)}');
    }

    if (jwtToken.isNotEmpty && JwtDecoder.isExpired(jwtToken)) {
      try {
        final response = await loadRefreshToken(RefreshModel.refreshTkn, context);

        if (response.token != '') {
          await application.setAccessToken(response.token);
          await application.setRefreshToken(response.refreshToken);
          // await application.setIdToken(response.idToken);
        }
      } catch (e) {
        if (context.mounted) {
          await Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);
          Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
          NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
        }
      }
    }
  }

  /// Processes the HTTP response and standardizes the result.
  Future<ApiResult> _handleResponse(http.Response response, BuildContext context) async {
    final statusCode = response.statusCode;
    String? errorMessage;

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResult(statusCode: statusCode);
    } else {
      try {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        errorMessage = responseBody['message'] ?? responseBody['Message'] ?? 'Алдаа гарлаа';
      } catch (e) {
        errorMessage = 'Алдаа гарлаа';
      }

      return ApiResult(error: errorMessage, statusCode: statusCode);
    }
  }

  /// Handles the case when the user is not authorized.
  void _handleUnauthorized(BuildContext context) {
    Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
    NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
  }

  /// Handles failure in token refresh.
  void _handleTokenRefreshFailure(BuildContext context) {
    if (context.mounted) {
      Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
      application.showToast('Интернет холболтоо шалгана уу', isConnect: true);
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
    }
  }

  /// Shows an error message to the user.
  void _showErrorMessage(BuildContext context, String? message) {
    if (context.mounted && message != null) {
      application.showToastAlert(message);
    }
  }

  /// Logs the request details for debugging.
  void _logRequest(String method, Uri url, {dynamic body, Map<String, String>? headers}) {
    debugPrint('$method Request: $url');
    if (body != null) debugPrint('Request Body: $body');
    if (headers != null) debugPrint('Request Headers: $headers');
  }

  /// Logs the response details for debugging.
  void _logResponse(http.Response response) {
    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
  }

  /// Checks if the device is connected to the internet.
  Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
