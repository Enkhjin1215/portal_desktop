import 'dart:convert';

import 'package:portal/models/account_model.dart';
import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Response {
  int? errorCode;
  String? message;

  Response({this.errorCode, this.message});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      errorCode: int.parse(json['status'].toString()),
      message: json['msg'],
    );
  }

  static Resource<dynamic> get checkUser {
    return Resource(
        url: APILIST.authcheckMail,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkPromo {
    return Resource(
        url: APILIST.promoCheck,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get login {
    return Resource(
        url: APILIST.authLogin,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get loginMFA {
    return Resource(
        url: APILIST.loginTwoFA,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkUserName {
    return Resource(
        url: APILIST.authCheckUsername,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkBank {
    return Resource(
        url: APILIST.bankCheck,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkUpdate {
    return Resource(
        url: APILIST.checkVersion,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get forgotPassword {
    return Resource(
        url: APILIST.forgotPass,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkInvoice {
    return Resource(
        url: APILIST.checkInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkApplePay {
    return Resource(
        url: APILIST.checkAppleInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get register {
    return Resource(
        url: APILIST.authRegister,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get passConfirm {
    return Resource(
        url: APILIST.forgotPassConfirm,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get otpResend {
    return Resource(
        url: APILIST.authOtpResend,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get otpCheck {
    return Resource(
        url: APILIST.authOtpCheck,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get deleteAcnt {
    return Resource(
        url: APILIST.userbankAccount,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get deleteInvoice {
    return Resource(
        url: APILIST.deleteInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get verifyAcnt {
    return Resource(
        url: APILIST.userbankVerifyAccnt,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get withdrawMoney {
    return Resource(
        url: APILIST.userbankWithdraw,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkAccount {
    return Resource(
        url: APILIST.deleteCheckAccount,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get deleteAccount {
    return Resource(
        url: APILIST.deleteAcc,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get checkEbarimtOrg {
    return Resource(
        url: APILIST.ebarimtCheck,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get ticketDivide {
    return Resource(
        url: APILIST.ticketDivide,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get getWalletUri {
    return Resource(
        url: APILIST.appleWallet,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get quizNight {
    return Resource(
        url: APILIST.quizNight,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get sendFCMToken {
    return Resource(
        url: APILIST.fcmToken,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get getNotifList {
    return Resource(
        url: APILIST.notifList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get setNotifRead {
    return Resource(
        url: APILIST.notifRead,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get csgoGetMe {
    return Resource(
        url: APILIST.csox,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get changeMethod {
    return Resource(
        url: APILIST.changeInvoice,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get csgoClaimDaily {
    return Resource(
        url: APILIST.csoxClaimDaily,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get steamExchangeRate {
    return Resource(
        url: APILIST.steamExchangeRate,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get steamTradeUrl {
    return Resource(
        url: APILIST.steamTradeUrl,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }

  static Resource<dynamic> get merchCert {
    return Resource(
        url: APILIST.merchCertSend,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          return result;
        });
  }
  // static Resource<dynamic> get userBankAccount {
  //   return Resource(
  //       url: APILIST.userbankAccount,
  //       parse: (response) {
  //         final result = json.decode(utf8.decode(response.bodyBytes));
  //         List<dynamic> list = [];
  //         result.map((data) => print('--->$data'));
  //         list = result.map((data) => Account.fromJson(data)).toList();
  //         return list;
  //       });
  // }
}
