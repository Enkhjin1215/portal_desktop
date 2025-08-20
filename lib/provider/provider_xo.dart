import 'package:flutter/material.dart';
import 'package:portal/models/counter_event.dart';

class ProviderXO extends ChangeNotifier {
  List<CounterEvent> xoList = [];
  List<dynamic> notifList = [];
  ProviderXO(this.xoList);
  getXOList() {
    return xoList;
  }

  setXOList(List<CounterEvent> data) {
    xoList = data;
    notifyListeners();
  }

  getNotif() {
    return notifList;
  }

  setNotifList(List<dynamic> data) {
    notifList = data;
    notifyListeners();
  }

  bool getUnreadNotif() {
    bool haveUnreadNotif = false;
    List<dynamic> unread = [];
    if (notifList.isEmpty) {
      return false;
    } else {
      unread = notifList.where((e) => e['isRead'] == false).toList();
    }
    haveUnreadNotif = unread.isEmpty ? false : true;
    return haveUnreadNotif;
  }
}
