import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class PendingInvoiceModel {
  String? id;
  List<String>? merchants;
  String? userId;
  EventInfo? eventId;
  String? lang;
  String? status;
  List<TemplateItem>? templates;
  String? invoiceDescription;
  PaymentResult? paymentResult;
  String? ebarimtReceiver;
  List<dynamic>? nfts;
  String? promo;
  double? amount;
  String? method;
  String? createdAt;
  String? updatedAt;
  int? v;

  PendingInvoiceModel({
    this.id,
    this.merchants,
    this.userId,
    this.eventId,
    this.lang,
    this.status,
    this.templates,
    this.invoiceDescription,
    this.paymentResult,
    this.ebarimtReceiver,
    this.nfts,
    this.promo,
    this.amount,
    this.method,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PendingInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PendingInvoiceModel(
      id: json['_id'],
      merchants: json['merchants'] != null ? List<String>.from(json['merchants']) : null,
      userId: json['userId'],
      eventId: json['eventId'] != null ? EventInfo.fromJson(json['eventId']) : null,
      lang: json['lang'],
      status: json['status'],
      templates: json['templates'] != null ? List<TemplateItem>.from(json['templates'].map((x) => TemplateItem.fromJson(x))) : null,
      invoiceDescription: json['invoiceDescription'],
      paymentResult: json['paymentResult'] != null ? PaymentResult.fromJson(json['paymentResult']) : null,
      ebarimtReceiver: json['ebarimtReceiver'],
      nfts: json['nfts'],
      promo: json['promo'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
      method: json['method'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (merchants != null) {
      data['merchants'] = merchants;
    }
    data['userId'] = userId;
    if (eventId != null) {
      data['eventId'] = eventId!.toJson();
    }
    data['lang'] = lang;
    data['status'] = status;
    if (templates != null) {
      data['templates'] = templates!.map((v) => v.toJson()).toList();
    }
    data['invoiceDescription'] = invoiceDescription;
    if (paymentResult != null) {
      data['paymentResult'] = paymentResult!.toJson();
    }
    data['ebarimtReceiver'] = ebarimtReceiver;
    if (nfts != null) {
      data['nfts'] = nfts;
    }
    data['promo'] = promo;
    data['amount'] = amount;
    data['method'] = method;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }

  static Resource<PendingInvoiceModel> get getPendingInvoice {
    return Resource(
        url: APILIST.pendingInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          PendingInvoiceModel detail = PendingInvoiceModel.fromJson(result);
          return detail;
        });
  }
}

class EventInfo {
  String? id;
  String? name;
  String? coverImage;
  String? coverImageV;
  String? customUrl;

  EventInfo({
    this.id,
    this.name,
    this.coverImage,
    this.coverImageV,
    this.customUrl,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      id: json['_id'],
      name: json['name'],
      coverImage: json['cover_image'],
      coverImageV: json['cover_image_v'],
      customUrl: json['customUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['cover_image'] = coverImage;
    data['cover_image_v'] = coverImageV;
    data['customUrl'] = customUrl;
    return data;
  }
}

class TemplateItem {
  TemplateInfo? templateId;
  PriceInfo? sellPrice;
  dynamic seats;

  TemplateItem({
    this.templateId,
    this.sellPrice,
    this.seats,
  });

  factory TemplateItem.fromJson(Map<String, dynamic> json) {
    return TemplateItem(
      templateId: json['templateId'] != null ? TemplateInfo.fromJson(json['templateId']) : null,
      sellPrice: json['sellPrice'] != null ? PriceInfo.fromJson(json['sellPrice']) : null,
      seats: json['seats'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (templateId != null) {
      data['templateId'] = templateId!.toJson();
    }
    if (sellPrice != null) {
      data['sellPrice'] = sellPrice!.toJson();
    }
    data['seats'] = seats;
    return data;
  }
}

class TemplateInfo {
  String? id;
  String? name;
  PriceInfo? sellPrice;
  String? type;
  bool? isSeat;

  TemplateInfo({
    this.id,
    this.name,
    this.sellPrice,
    this.type,
    this.isSeat,
  });

  factory TemplateInfo.fromJson(Map<String, dynamic> json) {
    return TemplateInfo(
      id: json['_id'],
      name: json['name'],
      sellPrice: json['sellPrice'] != null ? PriceInfo.fromJson(json['sellPrice']) : null,
      type: json['type'],
      isSeat: json['isSeat'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    if (sellPrice != null) {
      data['sellPrice'] = sellPrice!.toJson();
    }
    data['type'] = type;
    data['isSeat'] = isSeat;
    return data;
  }
}

class PriceInfo {
  int? amount;
  String? currency;

  PriceInfo({
    this.amount,
    this.currency,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}

class PaymentResult {
  String? invoiceId;
  String? link;

  PaymentResult({
    this.invoiceId,
    this.link,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      invoiceId: json['invoiceId'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceId'] = invoiceId;
    data['link'] = link;
    return data;
  }
}
