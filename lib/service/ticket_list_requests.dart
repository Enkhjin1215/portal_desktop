import 'package:flutter/material.dart';
import 'package:portal/screens/cart/merch/merch_list_model.dart';
import 'package:provider/provider.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/service/web_service.dart';

import '../models/ticket_model.dart';

class TicketListRequests {
  getTicketList(BuildContext context, {bool dataRefresh = false, bool only = false}) async {
    if (context.mounted) {
      await Webservice().loadGet(TicketList.ticketList, context).then((response) {
        if (context.mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setTicketList(response);
        }
      });
    }
  }

  getMerchList(BuildContext context, {bool dataRefresh = false, bool only = false}) async {
    if (context.mounted) {
      await Webservice().loadGet(MyMerchModel.getMyMerchModels, context, parameter: '?isUsed=false').then((response) {
        if (context.mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setMyMerchList(response);
        }
      });
    }
  }

  getUsedMerch(BuildContext context, {bool dataRefresh = false, bool only = false}) async {
    if (context.mounted) {
      await Webservice().loadGet(MyMerchModel.getMyMerchModels, context, parameter: '?isUsed=true').then((response) {
        if (context.mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setMyMerchList(response);
        }
      });
    }
  }
}
