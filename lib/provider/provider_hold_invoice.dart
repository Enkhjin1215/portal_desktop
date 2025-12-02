import 'package:flutter/material.dart';
import 'package:portal/models/invoice_model.dart';

class ProviderHold extends ChangeNotifier {
  List<QpayInvoice> holdInvoice = [];
  QpayInvoice? currentInvoice;
  ProviderHold();

  getHoldList() {
    return holdInvoice;
  }

  setHoldList(List<QpayInvoice> list) {
    debugPrint('set hold list : ${list.length}');
    holdInvoice = list;
    notifyListeners();
  }

  deleteInvoice(String invoiceID) {
    holdInvoice.removeWhere((e) => e.id == invoiceID);
    notifyListeners();
  }

  setCurrentInvoice(QpayInvoice inv) {
    currentInvoice = inv;
    notifyListeners();
  }

  clearCurrentInvoice() {
    currentInvoice = null;
  }

  QpayInvoice? getCurrentInvoice() {
    return currentInvoice;
  }
}
