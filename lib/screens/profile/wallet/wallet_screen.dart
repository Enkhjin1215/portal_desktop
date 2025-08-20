import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/wallet/wallet_history_model.dart';
import 'package:portal/models/wallet/wallet_list_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/core_requests.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletList? walletList;
  CoreRequests coreRequests = CoreRequests();
  List<WalletHistory> historyList = [];
  static const _pageSize = 20;
  List<Account> banks = [];
  final PagingController<int, WalletHistory> _pagingController = PagingController(firstPageKey: 1);
  @override
  void initState() {
    init();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  init() async {
    await coreRequests.getWallet(context);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await coreRequests.getHistory(context, pageKey, _pageSize);
      print('newItems:$newItems');
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  String statusName(String type) {
    switch (type) {
      case 'transfer':
        return getTranslated(context, 'transfer');
      case 'withdraw':
        return getTranslated(context, 'withdraw');
      case 'transfer_fee':
        return getTranslated(context, 'transferFee');
      case 'refund':
        return getTranslated(context, 'refund');
      default:
        return type;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'transfer':
        return Colors.red;
      case 'withdraw':
        return Colors.red;
      case 'transfer_fee':
        return Colors.red;
      case 'refund':
        return Colors.green;

      default:
        return Colors.white;
    }
  }

  Future<bool> checkBank() async {
    bool available = true;
    await Webservice().loadGet(Response.checkBank, context, parameter: '').then((response) {
      available = response['active'] ?? false;
    });
    return available;
  }

  withdraw(ThemeData theme) async {
    if (!await checkBank()) {
      application.showToastAlert('Одоогоор зарлага хийх боломжгүй байна.');
      return;
    }

    await coreRequests.getUserBankAccount(context);
    banks = Provider.of<ProviderCoreModel>(context, listen: false).getAccounts();
    if (banks.isEmpty) {
      application.showToastAlert('Эхлээд банкны дансаа холбоно уу');
      return;
    }

    ModalAlert().bankListShow(
      context: context,
      theme: theme,
      list: banks,
      onDeleteAccount: deleteBank,
    );
  }

  deleteBank(Account acc) async {
    await Webservice().loadDelete(Response.deleteAcnt, context, parameter: '/${acc.id}').then((response) {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    walletList = Provider.of<ProviderCoreModel>(context, listen: true).getWallet();
    return CustomScaffold(
        padding: EdgeInsets.zero,
        appBar: walletAppBar(context: context),
        resizeToAvoidBottomInset: false,
        canPopWithSwipe: true,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.profileBackground,
            child: walletList == null
                ? Center(
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: theme.colorScheme.whiteColor,
                      ),
                    ),
                  )
                : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      width: double.maxFinite,
                      height: 250,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(Assets.walletVisa),
                        fit: BoxFit.fill,
                      )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'balance'), style: TextStyles.textFt16Reg.textColor(theme.colorScheme.whiteColor)),
                              Text(
                                Func.toMoneyStr(walletList!.walletList!.first.available),
                                style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                              )
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                child: Image.asset(Assets.portalAppBar, height: 35),
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: CustomButton(
                              text: getTranslated(context, 'withdraw'),
                              onTap: () {
                                withdraw(theme);
                              },
                              margin: EdgeInsets.zero,
                              height: 40,
                              width: double.maxFinite,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).hp(2),
                    ),
                    Expanded(
                        child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.profileAppBar,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ResponsiveFlutter.of(context).hp(1),
                            ),
                            Text(
                              getTranslated(context, 'transaction_history'),
                              style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                            ),
                            SizedBox(
                              height: ResponsiveFlutter.of(context).hp(1),
                            ),
                            Expanded(
                                child: PagedListView<int, WalletHistory>(
                              pagingController: _pagingController,
                              builderDelegate: PagedChildBuilderDelegate<WalletHistory>(
                                noItemsFoundIndicatorBuilder: (context) {
                                  return Center(
                                    child: Text(
                                      'Гүйлгээний түүх хоосон байна!',
                                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(statusName(item.type ?? ''), style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor)),
                                          Text(Func.toDateTimeStr(item.createdAt ?? ''),
                                              style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor)),
                                        ],
                                      ),
                                      Text(Func.toMoneyStr(item.amt), style: TextStyles.textFt14Bold.textColor(getColor(item.type ?? '')))
                                    ],
                                  );
                                },
                              ),
                            ))
                          ],
                        ),
                      ),
                    ))
                  ])));
  }
}
