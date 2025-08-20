import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class WalletHistory {
  String? id;
  String? martketType;
  var amt;
  String? type;
  String? createdAt;
  WalletHistory({this.id, this.martketType, this.amt, this.type, this.createdAt});
  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
        id: json['_id'], martketType: json['marketType'], amt: json['transaction']['amount'], type: json['type'], createdAt: json['createdAt']);
  }
  static Resource<List<WalletHistory>> get getWalletHistory {
    return Resource(
        url: APILIST.walletHistory,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result['data'];
          List<WalletHistory> history = [];
          history = list.map((data) => WalletHistory.fromJson(data)).toList();

          return history;
        });
  }
}
