import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Account {
  String? id;
  String? accntNumber;
  String? accntName;
  bool? isVerify;
  String? bankType;
  String? createdAt;

  Account({this.id, this.accntNumber, this.accntName, this.isVerify, this.bankType, this.createdAt});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    accntNumber = json['accountNumber'];
    accntName = json['accountName'];
    isVerify = json['isVerify'];
    bankType = json['bankType'];
    createdAt = json['createdAt'];
  }
  static Resource<List<Account>> get getAccnts {
    return Resource(
        url: APILIST.userbankAccount,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
          List<Account> list = result.map((data) => Account.fromJson(data as Map<String, dynamic>)).toList();
          return list;
        });
  }

  static Resource<Account> get bankAdd {
    return Resource(
        url: APILIST.userbankAccount,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Account acc = Account.fromJson(result);
          return acc;
        });
  }
}
