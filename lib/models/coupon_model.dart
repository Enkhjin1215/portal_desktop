import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Promo {
  String? id;
  List<String>? merchants;
  String? code;
  String? discountType;
  double? discountValue;
  DateTime? expiryDate;
  int? usageLimit;
  int? currentUsage;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<dynamic>? templateId;
  String? eventId;

  Promo(
      {this.id,
      this.merchants,
      this.code,
      this.discountType,
      this.discountValue,
      this.expiryDate,
      this.usageLimit,
      this.currentUsage,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.templateId,
      this.eventId});

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
        id: json['_id'],
        merchants: json['merchants'] != null ? List<String>.from(json['merchants']) : null,
        code: json['code'],
        discountType: json['discountType'],
        discountValue: json['discountValue']?.toDouble(),
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
        usageLimit: json['usageLimit'],
        currentUsage: json['currentUsage'],
        createdBy: json['createdBy'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        eventId: json['eventId'] ?? '',
        v: json['__v'],
        templateId: json['templateId'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (merchants != null) data['merchants'] = merchants;
    if (code != null) data['code'] = code;
    if (discountType != null) data['discountType'] = discountType;
    if (discountValue != null) data['discountValue'] = discountValue;
    if (expiryDate != null) data['expiryDate'] = expiryDate!.toIso8601String();
    if (usageLimit != null) data['usageLimit'] = usageLimit;
    if (currentUsage != null) data['currentUsage'] = currentUsage;
    if (createdBy != null) data['createdBy'] = createdBy;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (v != null) data['__v'] = v;
    if (templateId != null) data['templateId'] = templateId;
    return data;
  }

  static Resource<Promo> get checkPromo {
    return Resource(
        url: APILIST.promoCheck,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Promo coupon = Promo.fromJson(result);
          return coupon;
        });
  }
}
