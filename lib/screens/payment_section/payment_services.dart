import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/models/coupon_model.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  // Check and delete any pending invoices
  // Future<void> checkAndDeletePendingInvoice(BuildContext context) async {
  //   QpayInvoice? pendingInv = await checkInvoice(context);
  //   if (pendingInv != null) {
  //     await deleteInvoice(context: context, invoiceId: pendingInv.id ?? '');
  //   }
  // }

  // Check for pending invoices
  // Future<QpayInvoice?> checkInvoice(BuildContext context) async {
  //   try {
  //     QpayInvoice? inv;
  //     await Webservice().loadGet(QpayInvoice.getPendingInvoice, context).then((response) {
  //       inv = response;
  //     });
  //     return inv;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Check payment status
  Future<bool> checkPayment({required BuildContext context, required String invoiceId}) async {
    try {
      Map<String, dynamic> body = {};
      body['invoiceId'] = invoiceId;
      final response = await Webservice().loadPost(Response.checkInvoice, context, body);

      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  // Create invoice
  Future<QpayInvoice> createInvoice(
      {required BuildContext context,
      required Map<String, dynamic> data,
      required String paymentType,
      bool isMerch = false,
      bool isCsOx = false,
      bool isSteamTopUp = false}) async {
    late QpayInvoice invoice;

    await Webservice()
        .loadPost(QpayInvoice.getQpay, context, data,
            parameter: isMerch
                ? '/merch?method=$paymentType'
                : isCsOx
                    ? '/cs?method=$paymentType'
                    : isSteamTopUp
                        ? '/steam?method=$paymentType'
                        : '?method=$paymentType')
        .then((response) {
      invoice = response;
    });

    return invoice;
  }

  // Delete invoice
  Future<void> deleteInvoice({required BuildContext context, required String invoiceId}) async {
    try {
      await Webservice().loadDelete(Response.deleteInvoice, context, parameter: invoiceId, alertShow: false);
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }

  Future<void> quizNight({required BuildContext context, required String tableNo, required String date}) async {
    String name = await application.getQuizName();
    String phone = await application.getQuizNumber();
    Map<String, dynamic> body = {};
    body['table_no'] = tableNo;
    body['date'] = date;
    body['team_name'] = name;
    body['phone_number'] = phone;
    try {
      await Webservice().loadPost(
        Response.quizNight,
        context,
        body,
      );
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }

  // Open bank app
  Future<void> openBankApp({required String bankLink, required String qrText}) async {
    Uri uri = Uri.parse(bankLink + qrText);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('bank app cant open : $e');
      application.showToastAlert('Аппликейшнээ татаж суулгана уу.');
    }
  }

  // Check ebarimt organization
  Future<String> checkEbarimt({required BuildContext context, required String regNo}) async {
    final response = await Webservice().loadGet(Response.checkEbarimtOrg, context, parameter: regNo);

    return response['name'] as String;
  }

  // Validate promo code
  Future<Promo?> validatePromoCode(
      {required BuildContext context, required Map<String, dynamic> data, required String promoCode, required String eventId}) async {
    Map<String, dynamic> body = {...data};
    body['code'] = promoCode;

    final response = await Webservice().loadPost(Promo.checkPromo, context, body);

    // Check if the promo is valid for this event
    if ((response?.eventId == '' && response?.templateId == '') || response?.eventId == eventId) {
      return response;
    }

    throw Exception('eventMismatch');
  }

  // Get user-friendly error message for promo code failures
  String getPromoErrorMessage(String errorString) {
    if (errorString.contains('alreadyUsedPromo')) {
      return 'Ашигласан Promo code байна.';
    } else if (errorString.contains('promoNotFound')) {
      return 'Хүчингүй Promo code байна.';
    } else if (errorString.contains('promoExpired')) {
      return 'Promo code хугацаа хэтэрсэн байна.';
    } else if (errorString.contains('usageLimitReached')) {
      return 'Promo code лимит хэтэрсэн байна.';
    } else if (errorString.contains('eventMismatch')) {
      return 'Өөр эвентийн Promo code байна.';
    } else if (errorString.contains('ticketMismatch')) {
      return 'Өөр тасалбарын Promo code байна.';
    } else if (errorString.contains('unusablePromo')) {
      return 'Promo code хөнгөлөлт хэтэрсэн байна.';
    }

    return 'Promo code алдаа гарлаа.';
  }
}
