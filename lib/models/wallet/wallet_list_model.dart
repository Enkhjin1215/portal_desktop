import 'dart:convert';

import 'package:portal/models/wallet/wallet_model.dart';
import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class WalletList {
  String? userID;
  List<Wallet>? walletList;
  WalletList({this.userID, this.walletList});
  factory WalletList.fromJson(Map<String, dynamic> json) {
    Iterable rawItems = json['walledId'];
    List<Wallet> items = rawItems.map((data) => Wallet.fromJson(data)).toList();

    return WalletList(userID: json['_id'], walletList: items);
  }
  static Resource<WalletList> get getWalletList {
    return Resource(
        url: APILIST.wallet,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          WalletList list = WalletList.fromJson(result);
          return list;
        });
  }
}
