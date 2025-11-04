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

class QpayInvoice {
  String? userId;
  dynamic? eventId;
  num? amt;
  String? invoicedesc;
  String? id;
  Qpay? qpay;
  String? createdAt;
  String? method;
  QpayInvoice({this.userId, this.eventId, this.amt, this.invoicedesc, this.id, this.qpay, this.createdAt, this.method});
  factory QpayInvoice.fromJson(Map<String, dynamic> json) {
    print('-------->${json['paymentResult']}');
    Qpay qpay = Qpay.fromJson(json['paymentResult']);
    return QpayInvoice(
        userId: json['userId'],
        eventId: json['eventId'],
        amt: json['amount'],
        invoicedesc: json['invoiceDescription'],
        id: json['_id'],
        qpay: qpay,
        createdAt: json['createdAt'],
        method: json['method']);
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

  // static Resource<QpayInvoice> get getPendingInvoice {
  //   return Resource(
  //       url: APILIST.pendingInvoice,
  //       parse: (response) {
  //         final result = json.decode(utf8.decode(response.bodyBytes));
  //         QpayInvoice detail = QpayInvoice.fromJson(result);
  //         return detail;
  //       });
  // }
}
