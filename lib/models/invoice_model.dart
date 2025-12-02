import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Qpay {
  dynamic invoiceId;
  String? qrText;
  String? link;
  String? deepLink;
  Qpay({this.invoiceId, this.qrText, this.link, this.deepLink});
  Qpay.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'] ?? '';
    qrText = json['qr_text'] ?? '';
    link = json['link'] ?? '';
    deepLink = json['deep_link'];
  }
}

class InvoiceEvent {
  String? name;
  String? coverImage;
  InvoiceEvent([this.name, this.coverImage]);
  InvoiceEvent.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    coverImage = json['cover_image_v'] ?? '';
  }
}

class InvoiceTemplate {
  String? templateId;
  SellPrice? sellPrice;
  dynamic seats;

  InvoiceTemplate.fromJson(Map<String, dynamic> json) {
    templateId = json['templateId'];
    sellPrice = SellPrice.fromJson(json['sellPrice']);
    seats = json['seats']; // sometimes list, sometimes int
  }
}

class SellPrice {
  num? amount;
  String? currency;

  SellPrice.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
  }
}

class QpayInvoice {
  String? id;
  String? userId;
  String? eventId;
  String? lang;
  String? status;
  List<String>? merchants;
  List<InvoiceTemplate>? templates;
  String? invoicedesc;
  Qpay? qpay;
  num? amt;
  String? method;
  String? createdAt;

  QpayInvoice.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    eventId = json['eventId'];
    lang = json['lang'];
    status = json['status'];
    merchants = List<String>.from(json['merchants'] ?? []);
    invoicedesc = json['invoiceDescription'];
    amt = json['amount'];
    method = json['method'];
    createdAt = json['createdAt'];

    // templates
    templates = (json['templates'] as List?)?.map((e) => InvoiceTemplate.fromJson(e)).toList();

    // qpay info
    qpay = Qpay.fromJson(json['paymentResult'] ?? {});
  }

  static Resource<QpayInvoice> get getQpay {
    return Resource(
        url: APILIST.createInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          QpayInvoice detail = QpayInvoice.fromJson(result);
          return detail;
        });
  }

  static Resource<QpayInvoice> get changeMethod {
    return Resource(
        url: APILIST.changeInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          QpayInvoice detail = QpayInvoice.fromJson(result);
          return detail;
        });
  }

  static Resource<QpayInvoice> get getPendingInvoice {
    return Resource(
        url: APILIST.pendingInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          QpayInvoice detail = QpayInvoice.fromJson(result);
          return detail;
        });
  }

  static Resource<List<QpayInvoice>> get getHoldList {
    return Resource(
      url: APILIST.holdInvoiceList,
      parse: (response) {
        final result = json.decode(utf8.decode(response.bodyBytes));

        if (result is! List) {
          throw Exception("API response is not a list");
        }

        final list = result.map((e) => QpayInvoice.fromJson(e as Map<String, dynamic>)).toList();

        return list;
      },
    );
  }
}
