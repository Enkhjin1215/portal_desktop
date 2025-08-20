import 'dart:convert';

import '../service/api_list.dart';
import '../service/web_service.dart';

class Orders {
  String? sId;
  String? username;
  List<BarItems>? baritems;

  Orders({this.sId, this.username, this.baritems});

  Orders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    if (json['baritems'] != null) {
      baritems = <BarItems>[];
      json['baritems'].forEach((v) {
        baritems!.add(BarItems.fromJson(v));
      });
    }
  }
}


class BarItems {
  List<Null>? merchants;
  String? sId;
  String? eventId;
  String? ownerId;
  String? barId;
  List<Items>? items;
  bool? isUsed;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  BarItems(
      {this.merchants,
        this.sId,
        this.eventId,
        this.ownerId,
        this.barId,
        this.items,
        this.isUsed,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  BarItems.fromJson(Map<String, dynamic> json) {
    // if (json['merchants'] != null) {
    //   merchants = <Null>[];
    //   json['merchants'].forEach((v) {
    //     merchants!.add(new Null.fromJson(v));
    //   });
    // }
    sId = json['_id'];
    eventId = json['eventId'];
    ownerId = json['ownerId'];
    barId = json['barId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    isUsed = json['isUsed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }
}

class Items {
  ItemId? itemId;
  String? name;
  String? nameEn;
  int? qty;
  String? cover;

  Items({this.itemId, this.name, this.nameEn, this.qty, this.cover});

  Items.fromJson(Map<String, dynamic> json) {
    itemId =
    json['itemId'] != null ? ItemId.fromJson(json['itemId']) : null;
    name = json['name'];
    nameEn = json['name_en'];
    qty = json['qty'];
    cover = json['cover'];
  }
}

class ItemId {
  String? type;
  List<int>? data;

  ItemId({this.type, this.data});

  ItemId.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }
}

class OrderList {
  Orders? item;

  OrderList({this.item});

  factory OrderList.fromJson(Map<String, dynamic> json) {
    Orders? item = Orders.fromJson(json);
    return OrderList(item: item);
  }

  static Resource<OrderList> get orderList {
    return Resource(
        url: APILIST.orderList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          OrderList model = OrderList.fromJson(result);
          return model;
        });
  }
}