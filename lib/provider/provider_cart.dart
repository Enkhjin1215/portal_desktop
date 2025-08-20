import 'package:flutter/material.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/models/bar_item_model.dart';

class ProviderCart extends ChangeNotifier {
  List<BarItem> barList = [];
  Bar? bar;
  List<Map<String, dynamic>> cartBody = [];

  ProviderCart(this.cartBody);

  getBar() {
    return bar;
  }

  getBarList() {
    return barList;
  }

  setBar(Bar data) {
    bar = data;
    notifyListeners();
  }

  setBarList(List<BarItem> item) {
    barList = item;
    notifyListeners();
  }

  void setCart(String eventId, List<dynamic> list, int qnt) {
    String itemID = Utils.bufferArrayToString(list);

    // Find the index of the event with the matching eventId (barId)
    int eventIndex = cartBody.indexWhere((e) => e['barId'] == eventId);

    if (eventIndex != -1) {
      // If eventId exists, update the items list
      List<Map<String, Object>> items = List<Map<String, Object>>.from(cartBody[eventIndex]['items'] as List);

      // Find the index of the item with the matching itemId
      int itemIndex = items.indexWhere((item) => item['itemId'] == itemID);

      if (itemIndex != -1) {
        // Update quantity if the item exists
        if (qnt > 0) {
          items[itemIndex]['qty'] = qnt;
        } else {
          print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!remove:$qnt');
          // Remove the item if the quantity is 0
          items.removeAt(itemIndex);
        }
      } else {
        // Add a new item if it doesn't exist and quantity is greater than 0
        if (qnt > 0) {
          items.add({'itemId': itemID, 'qty': qnt});
        }
      }

      // If no items left for this event, remove the event
      if (items.isEmpty) {
        cartBody.removeAt(eventIndex);
      } else {
        // Update the cartBody with the modified items list
        cartBody[eventIndex]['items'] = items;
      }
    } else {
      // If eventId doesn't exist, add a new entry if quantity is greater than 0
      if (qnt > 0) {
        cartBody.add({
          'barId': eventId,
          'items': [
            {'itemId': itemID, 'qty': qnt},
          ]
        });
      }
    }

    // Notify listeners to update UI
    notifyListeners();
  }

  // Get the cart
  Map<String, dynamic>? getCart(String eventId) {
    return cartBody.firstWhere((e) => e['barId'] == eventId, orElse: () => {});
  }

  int getQuant(String eventId, List<dynamic> idList) {
    String itemId = Utils.bufferArrayToString(idList);

    // Find the event with the matching eventId (barId)
    var event = cartBody.firstWhere(
      (element) => element['barId'] == eventId,
      orElse: () => <String, Object>{}, // Use Map<String, Object>
    );

    // If the event is found and it has an 'items' list
    if (event.isNotEmpty && event['items'] != null) {
      List<dynamic> items = event['items'];

      // Find the item with the matching itemId
      var item = items.firstWhere(
        (item) => item['itemId'] == itemId,
        orElse: () => <String, Object>{}, // Use Map<String, Object>
      );

      // If the item is found, return its quantity (qty)
      if (item.isNotEmpty) {
        return item['qty'] as int;
      }
    }

    return 0; // Return 0 if event or item is not found
  }
}
