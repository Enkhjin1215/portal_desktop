import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class RefreshModel extends ChangeNotifier {
  String? token;
  String? idToken;
  RefreshModel({required this.token, this.idToken});
  factory RefreshModel.fromJson(Map<String, dynamic> json) {
    return RefreshModel(token: json['accessToken'] ?? '', idToken: json['idToken'] ?? '');
  }
  static Resource<RefreshModel> get refreshTkn {
    return Resource(
        url: APILIST.refreshToken,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return RefreshModel.fromJson(result);
        });
  }
}
