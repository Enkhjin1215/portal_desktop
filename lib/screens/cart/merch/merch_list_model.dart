// class UserModel {
//   final String id;
//   final String username;
//   final List<MyMerchModel> merches;

//   UserModel({
//     required this.id,
//     required this.username,
//     required this.merches,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id'],
//       username: json['username'],
//       merches: (json['merches'] as List).map((e) => MyMerchModel.fromJson(e)).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'username': username,
//         'merches': merches.map((e) => e.toJson()).toList(),
//       };
// }

import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class MyMerchModel {
  final String id;
  final String ownerId;
  final TemplateId templateId;
  final MyMerchModelItemId merchItemId;
  final String name;
  final String nameEn;
  final bool isUsed;
  final SellPrice sellPrice;
  final String? deliveryId;
  final String qrText;

  MyMerchModel({
    required this.id,
    required this.ownerId,
    required this.templateId,
    required this.merchItemId,
    required this.name,
    required this.nameEn,
    required this.isUsed,
    required this.sellPrice,
    this.deliveryId,
    required this.qrText,
  });

  factory MyMerchModel.fromJson(Map<String, dynamic> json) {
    return MyMerchModel(
      id: json['_id'],
      ownerId: json['ownerId'],
      templateId: TemplateId.fromJson(json['templateId']),
      merchItemId: MyMerchModelItemId.fromJson(json['merchItemId']),
      name: json['name'],
      nameEn: json['name_en'],
      isUsed: json['isUsed'],
      sellPrice: SellPrice.fromJson(json['sellPrice']),
      deliveryId: json['deliveryId'],
      qrText: json['qrText'],
    );
  }

  static Resource<List<MyMerchModel>> get getMyMerchModels {
    return Resource(
        url: APILIST.myMerchList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable itList = result['merches'];
          List<MyMerchModel> list = itList.map((data) => MyMerchModel.fromJson(data as Map<String, dynamic>)).toList();
          return list;
        });
  }
}

class TemplateId {
  final String id;
  final List<String> imageUrl;

  TemplateId({
    required this.id,
    required this.imageUrl,
  });

  factory TemplateId.fromJson(Map<String, dynamic> json) {
    return TemplateId(
      id: json['id'],
      imageUrl: List<String>.from(json['imageUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        '_id': id,
      };
}

class MyMerchModelItemId {
  final String id;
  final Map<String, dynamic> attrs;

  MyMerchModelItemId({
    required this.id,
    required this.attrs,
  });

  factory MyMerchModelItemId.fromJson(Map<String, dynamic> json) {
    print('------->${json['attrs']}');
    return MyMerchModelItemId(
      id: json['id'],
      attrs: Map<String, dynamic>.from(json['attrs']),
    );
  }
}

class SellPrice {
  final int amount;
  final String currency;

  SellPrice({
    required this.amount,
    required this.currency,
  });

  factory SellPrice.fromJson(Map<String, dynamic> json) {
    return SellPrice(
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
      };
}
