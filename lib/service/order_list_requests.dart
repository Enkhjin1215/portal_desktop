import 'package:flutter/material.dart';
import 'package:portal/models/order_model.dart';
import 'package:provider/provider.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/service/web_service.dart';

class OrderListRequests {
  getOrderList(BuildContext context, {bool dataRefresh = false, bool only = false}) async {
    if (context.mounted) {
      await Webservice().loadGet(OrderList.orderList, context).then((response) {
        if (context.mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setOrderList(response);
        }
      });
    }
  }
}
