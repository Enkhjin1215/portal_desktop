import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/event_model.dart';
import 'package:portal/models/wallet/wallet_history_model.dart';
import 'package:portal/models/wallet/wallet_list_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';

class CoreRequests {
  getEventList(BuildContext context, {bool dataRefresh = false, bool only = false}) async {
    if (context.mounted) {
      await Webservice().loadGet(Events.eventList, context).then((response) {
        if (context.mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setEventList(response);
        }
        if (!only) {
          debugPrint('daraagiin huseltiig duudna');
          sentFCMToken(context);
        }
      });
    }
  }

  sentFCMToken(BuildContext context) async {
    bool isSent = Provider.of<ProviderCoreModel>(context, listen: false).getIsSentFCMToken();
    String token = await application.getPushNotifToken() ?? '';
    int userType = await application.getUserType();
    if (userType < 2) {
      print('guest');
    } else {
      if (!isSent && token != '') {
        Map<String, dynamic> data = {'fcmToken': token};
        await Webservice().loadPatch(Response.sendFCMToken, context, data).then((response) {
          if (context.mounted) {
            Provider.of<ProviderCoreModel>(context, listen: false).setIsSentFCMToken(true);
          }
        });
      }
    }
  }

  getWallet(BuildContext context, {bool only = false}) async {
    await Webservice().loadGet(WalletList.getWalletList, context, parameter: '').then((response) {
      Provider.of<ProviderCoreModel>(context, listen: false).setWallet(response);
      if (!only) {
        getUserBankAccount(context);
      }
    });
  }

  Future<List<WalletHistory>> getHistory(BuildContext context, int page, int pageSize) async {
    List<WalletHistory> history = [];
    history = await Webservice().loadGet(WalletHistory.getWalletHistory, context, parameter: '?page=$page&limit=$pageSize&sort=desc');
    return history;
  }

  getUserBankAccount(BuildContext context) async {
    // try {
    await Webservice().loadGet(Account.getAccnts, context, parameter: '').then((response) {
      if (context.mounted) {
        Provider.of<ProviderCoreModel>(context, listen: false).setAccounts(response);
      }
    });
    // } catch (e) {
    //   print('EXCEPTION:$e');
    // }
  }
}
