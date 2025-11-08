import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class TicketListResponse {
  final List<TicketItem2> list;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  TicketListResponse({
    required this.list,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) {
    return TicketListResponse(
      list: (json['list'] as List<dynamic>).map((e) => TicketItem2.fromJson(e as Map<String, dynamic>)).toList(),
      totalCount: json['totalCount'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }

  static Resource<List<TicketItem2>> get purchaseList {
    return Resource(
        url: APILIST.purchaseList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          TicketListResponse response2 = TicketListResponse.fromJson(result);
          return response2.list;
        });
  }
}

class TicketItem2 {
  final String id;
  final Event eventId;
  final String templateId;
  final String type;
  final bool isSeat;
  final SellPrice sellPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketItem2({
    required this.id,
    required this.eventId,
    required this.templateId,
    required this.type,
    required this.isSeat,
    required this.sellPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketItem2.fromJson(Map<String, dynamic> json) {
    return TicketItem2(
      id: json['_id'] as String,
      eventId: Event.fromJson(json['eventId'] as Map<String, dynamic>),
      templateId: json['templateId'] as String,
      type: json['type'] as String,
      isSeat: json['isSeat'] as bool,
      sellPrice: SellPrice.fromJson(json['sellPrice'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventId': eventId.toJson(),
      'templateId': templateId,
      'type': type,
      'isSeat': isSeat,
      'sellPrice': sellPrice.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Event {
  final String id;
  final String name;
  final String coverImage;
  final String coverImageV;

  Event({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.coverImageV,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String,
      name: json['name'] as String,
      coverImage: json['cover_image'] as String,
      coverImageV: json['cover_image_v'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'cover_image': coverImage,
      'cover_image_v': coverImageV,
    };
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
      amount: json['amount'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }
}
