import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class BarItem {
  String? type;
  List<dynamic>? buffer;
  String? nameEn;
  String? name;
  String? itemType;
  int? qnt;
  int? avl;
  int? sold;
  int? onHold;
  int? sellPrice;
  String? image;
  BarItem({this.type, this.buffer, this.nameEn, this.name, this.itemType, this.qnt, this.avl, this.sold, this.onHold, this.sellPrice, this.image});
  BarItem.fromJson(Map<String, dynamic> json) {
    type = json['id']['type'];
    buffer = json['id']['data'];
    name = json['name'];
    nameEn = json['name_en'];
    itemType = json['type'];
    qnt = json['qty'];
    avl = json['avail'];
    sold = json['sold'];
    onHold = json['on_hold'];
    sellPrice = json['sellPrice']['amount'];
    image = json['image'];
  }
}

class Bar {
  List<BarItem>? barList = [];
  String? id;
  String? eventId;
  String? closeDate;
  String? openDate;
  Bar({this.barList, this.id, this.eventId, this.closeDate, this.openDate});
  factory Bar.fromJson(Map<String, dynamic> json) {
    Iterable rawItems = json['items'];
    List<BarItem> items = rawItems.map((data) => BarItem.fromJson(data)).toList();

    return Bar(barList: items, id: json['_id'], eventId: json['eventId'], closeDate: json['closeDate'], openDate: json['openDate']);
  }
  static Resource<Bar> get getBar {
    return Resource(
        url: APILIST.eventBar,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Bar bar = Bar.fromJson(result);
          return bar;
        });
  }
}
