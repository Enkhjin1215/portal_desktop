import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/language/language.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/main.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/event_image.dart';
import 'package:portal/models/event_model.dart';
import 'package:portal/models/order_model.dart';
import 'package:portal/models/wallet/wallet_list_model.dart';
import 'package:portal/screens/cart/merch/merch_list_model.dart';

import '../models/ticket_model.dart';

class ProviderCoreModel extends ChangeNotifier {
  String? email;
  String? username;
  String? password;
  bool isEnglish = false;
  List<Events> eventList = [];
  bool loading = false; //------Хүсэлт дуудах үед button-г ачааллаж байна state рүү харуулна
  TicketList? mTicketList;
  OrderList? mOrderList;
  List<String> selectedSeat = [];
  WalletList? wallet;
  List<Account> bankList = [];
  List<EventImage> images = [];
  double stdCutoutWidthDown = 0;
  bool isSendFCMToken = false;
  List<MyMerchModel> myMerchList = [];

  ProviderCoreModel({this.email, this.password, this.username, this.wallet});

  String getEmail() {
    return email ?? '';
  }

  setEmail(String mail) {
    email = mail;
    application.setEmail(mail);
    notifyListeners();
  }

  double getNotchSizel() {
    return stdCutoutWidthDown;
  }

  setNotchSizel(double size) {
    stdCutoutWidthDown = size;
    notifyListeners();
  }

  Future<String> getUsername() async {
    username = await application.getUserName();
    return username ?? '';
  }

  setUsername(String name) {
    username = name;
    application.setUserName(name);
    notifyListeners();
  }

  bool getIsSentFCMToken() {
    return isSendFCMToken;
  }

  setIsSentFCMToken(bool sent) {
    isSendFCMToken = sent;
    notifyListeners();
  }

  bool getLoading() {
    return loading;
  }

  setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  List<Events> getEventList() {
    return eventList;
  }

  List<EventModel> getAllEvents() {
    List<EventModel> list = [];
    for (int i = 0; i < eventList.length; i++) {
      list.addAll(eventList[i].events ?? []);
    }
    return list;
  }

  setEventList(List<Events> list) {
    eventList = list;
    notifyListeners();
  }

  String getPwd() {
    return password ?? '';
  }

  setPwd(String pwd) {
    password = pwd;
    notifyListeners();
  }

  List<Account> getAccounts() {
    return bankList;
  }

  setAccounts(List<Account> list) {
    bankList = list;
    notifyListeners();
  }

  List<EventImage> getImages() {
    return images;
  }

  setImages(List<EventImage> list) {
    images = list;
    notifyListeners();
  }

  List<String> getSelectedSeat() {
    return selectedSeat;
  }

  setSelectedSeat(List<String> list) {
    selectedSeat = list;
    notifyListeners();
  }

  void changeLanguage(Language language, BuildContext context) async {
    Locale _locale = await setLocale(language.languageCode);
    MyHomePage.setLocale(context, _locale);
    if (_locale.languageCode == ENGLISH) {
      isEnglish = true;
    } else {
      isEnglish = false;
    }
    notifyListeners();
  }

  setTicketList(TicketList list) {
    mTicketList = list;
    notifyListeners();
  }

  TicketList? getTicketList() {
    return mTicketList;
  }

  List<EventMetas>? getEventMetaList() {
    return mTicketList?.item?.eventMetas;
  }

  List<EventMetas>? getActiveEventList() {
    if (mTicketList?.item?.eventMetas == null) return null;
    DateTime now = DateTime.now();
    List<EventMetas> list = List.empty(growable: true);
    for (var ii in mTicketList!.item!.eventMetas!) {
      if (ii.endDate != "") {
        DateTime parsedDate = DateTime.parse(ii.endDate ?? "");
        if (parsedDate.isAfter(now)) {
          list.add(ii);
        }
      }
    }
    return list;
  }

  List<EventMetas>? getInActiveEventList() {
    if (mTicketList?.item?.eventMetas == null) return null;
    DateTime now = DateTime.now();
    List<EventMetas> list = List.empty(growable: true);
    for (var ii in mTicketList!.item!.eventMetas!) {
      if (ii.endDate != "") {
        DateTime parsedDate = DateTime.parse(ii.endDate ?? "");
        if (parsedDate.isBefore(now)) {
          list.add(ii);
        }
      }
    }
    return list;
  }

  List<Tickets>? getActiveTicketList() {
    if (mTicketList == null) return null;
    List<Tickets>? items = List.empty(growable: true);
    if (mTicketList?.item?.tickets != null) {
      for (var ii in mTicketList!.item!.tickets!) {
        if (ii.isUsed == true) {
          items.add(ii);
        }
      }
    }
    return items;
  }

  List<Tickets>? getInActiveTicketList() {
    if (mTicketList == null) return null;
    List<Tickets>? items = List.empty(growable: true);
    if (mTicketList?.item?.tickets != null) {
      for (var ii in mTicketList!.item!.tickets!) {
        if (ii.isUsed == false) {
          items.add(ii);
        }
      }
    }
    return items;
  }

  WalletList? getWallet() {
    return wallet;
  }

  setWallet(WalletList wal) {
    wallet = wal;
    notifyListeners();
  }

  setOrderList(OrderList list) {
    mOrderList = list;
    notifyListeners();
  }

  OrderList? getOrderList() {
    return mOrderList;
  }

  List<BarItems>? getOrderItems() {
    return mOrderList?.item?.baritems;
  }

  List<EventMetas>? getActiveEventsList() {
    return mTicketList?.item?.eventMetas;
  }

  setMyMerchList(List<MyMerchModel> list) {
    myMerchList = list;
    notifyListeners();
  }

  List<MyMerchModel> getMyMerchList() {
    return myMerchList;
  }

  clearUser() {
    email = '';
    username = '';
    eventList = [];
    mTicketList = null;
    mOrderList = null;
    selectedSeat = [];
    wallet = null;
    bankList = [];
    application.setUserType(1);
    application.setAccessToken('');
    application.setRefreshToken('');
    application.setIdToken('');
    loading = false;
  }
}
