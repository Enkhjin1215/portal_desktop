import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Price {
  int? amt;
  String? currency;
  Price({this.amt});
  Price.fromJson(Map<String, dynamic> json) {
    amt = json['amount'];
    currency = json['currency'];
  }
}

class Option {
  String? value;
  Option({this.value});
  Option.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}

class Attribte {
  String? name;
  String? nameEn;
  List<Option>? optionList;
  Attribte({this.name, this.nameEn, this.optionList});
  factory Attribte.fromJson(Map<String, dynamic> json) {
    Iterable rawOptionList = json['options'] ?? [];
    List<Option> options = rawOptionList.map((data) => Option.fromJson(data)).toList();
    return Attribte(name: json['name'], nameEn: json['name_en'], optionList: options);
  }
}

class Merch {
  String? id;
  String? merchTemplateId;
  int? qty;
  int? avail;
  int? sold;
  int? onHold;
  Price? sellPrice;
  dynamic attrs;

  Merch({this.id, this.merchTemplateId, this.qty, this.avail, this.sold, this.onHold, this.sellPrice, this.attrs});

  factory Merch.fromJson(Map<String, dynamic> json) {
    Price price = Price.fromJson(json['sellPrice']);
    // Attribte attr = Attribte.fromJson(json['attrs']);
    return Merch(
        id: json['_id'],
        merchTemplateId: json['merchTemplateId'],
        qty: json['qty'],
        avail: json['avail'],
        sold: json['sold'],
        onHold: json['on_hold'],
        sellPrice: price,
        attrs: json['attrs']);
  }
}

class Merchs {
  String? id;
  dynamic eventId;
  String? type;
  String? name;
  String? nameEn;
  dynamic? description;
  List<dynamic>? images;
  String? startDate;
  String? endDate;
  int? royalty;
  bool? isHidden;
  List<dynamic>? artistList;
  List<Price>? priceList;
  List<Attribte>? attributeList;
  List<Merch>? itemList;
  Merchs(
      {this.id,
      this.eventId,
      this.type,
      this.name,
      this.nameEn,
      this.description,
      this.images,
      this.startDate,
      this.endDate,
      this.royalty,
      this.isHidden,
      this.artistList,
      this.priceList,
      this.attributeList,
      this.itemList});
  factory Merchs.fromJson(Map<String, dynamic> json) {
    Iterable rawPrice = json['sellPrice'] ?? [];
    List<Price> price = rawPrice.map((data) => Price.fromJson(data)).toList();
    Iterable rawAttr = json['attrs'] ?? [];
    List<Attribte> attr = rawAttr.map((data) => Attribte.fromJson(data)).toList();
    Iterable rawMerch = json['items'] ?? [];
    List<Merch> merchs = rawMerch.map((data) => Merch.fromJson(data)).toList();
    return Merchs(
        id: json['_id'],
        eventId: json['eventId'],
        type: json['type'],
        name: json['name'],
        nameEn: json['name_en'],
        description: json['description'],
        images: json['imageUrl'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        royalty: json['royalty'],
        isHidden: json['isHidden'],
        artistList: json['artists'],
        priceList: price,
        attributeList: attr,
        itemList: merchs);
  }
  static Resource<List<Merchs>> get getMerch {
    return Resource(
        url: APILIST.eventMerch,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result;
          List<Merchs> merchs = list.map((e) => Merchs.fromJson(e)).toList();
          return merchs;
        });
  }

  static Resource<List<Merchs>> get onlyMerchs {
    return Resource(
        url: APILIST.merchList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          print('------->${result['list']}');
          Iterable list = result['list'];
          List<Merchs> merchs = list.map((e) => Merchs.fromJson(e)).toList();
          return merchs;
        });
  }

  static Resource<Merchs> get singleMerch {
    return Resource(
        url: APILIST.merchList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Merchs merchs = Merchs.fromJson(result);
          return merchs;
        });
  }
}
