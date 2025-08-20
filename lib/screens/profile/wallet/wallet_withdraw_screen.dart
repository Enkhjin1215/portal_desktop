import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/bank_model.dart';
import 'package:portal/models/wallet/wallet_list_model.dart';
import 'package:portal/models/wallet/wallet_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class WalletWithdraw extends StatefulWidget {
  const WalletWithdraw({super.key});

  @override
  State<WalletWithdraw> createState() => _WalletWithdrawState();
}

class _WalletWithdrawState extends State<WalletWithdraw> {
  Account? account;
  QpayBanks qpayBanks = QpayBanks();
  List<BankModel> banks = [];
  Wallet? wallet;
  int fee = 300;
  TextEditingController amtController = TextEditingController();
  double total = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      account = args['acc'];
      banks = qpayBanks.getBankList();
      WalletList? list = Provider.of<ProviderCoreModel>(context, listen: false).getWallet();
      wallet = list?.walletList?.first;
      // amtController.addListener(limtChecker);
      setState(() {});
      // init();
    }));
    super.initState();
  }

  // limtChecker() {
  //   if (amtController.text != '') {
  //     total = double.parse(amtController.text) - fee;
  //     setState(() {});
  //     if (int.parse(amtController.text) > (int.parse(wallet?.available.toString() ?? '1'))) {
  //       application.showToastAlert('Боломжит дүнгээс их байна');
  //     }
  //   }
  // }

  String getBankLogo(String type) {
    for (int i = 0; i < banks.length; i++) {
      if (banks[i].type == type) {
        return banks[i].logo!;
      }
    }
    return 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg';
  }

  // @override
  // void dispose() {
  //   amtController.dispose();
  //   super.dispose();
  // }

  withdraw(ThemeData theme) async {
    if (total <= 0) {
      application.showToastAlert('Гүйлгээний дүн бага байна');
    } else if (total > wallet!.available) {
      application.showToastAlert('Гүйлгээний дүн их байна');
    } else {
      ModalAlert().showBottomSheetDialog(
          context: context,
          theme: theme,
          title: 'Зарлагын дүн : ${Func.toMoneyStr(amtController.text)}',
          firstButtonText: getTranslated(context, 'withdrawMoney'),
          onTap: () async {
            final Map<String, dynamic> data = <String, dynamic>{};
            data['amount'] = int.parse(amtController.text);
            data['bankId'] = account!.id;
            await Webservice().loadPost(Response.withdrawMoney, context, data).then((response) async {
              application.showToast('Амжилттай');
              NavKey.navKey.currentState!.pushNamedAndRemoveUntil(profileRoute, (route) => false);
            });
          },
          secondButtonText: getTranslated(context, 'cancel'));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    Provider.of<ProviderCoreModel>(context, listen: false).getWallet;

    return CustomScaffold(
      padding: EdgeInsets.zero,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.walletBackground), fit: BoxFit.fill)),
          child: account == null
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
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  InkWell(
                    onTap: () {
                      print('pop');
                      NavKey.navKey.currentState!.pop();
                    },
                    child: SizedBox(
                      height: 40,
                      width: double.maxFinite,
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: ShapeDecoration(
                            color: theme.colorScheme.backColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      getTranslated(context, 'withdraw'),
                      style: TextStyles.textFt15Bold.textColor(theme.colorScheme.hintColor),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ContainerTransparent(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          account?.accntName ?? '',
                          style: TextStyles.textFt12Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                      ),
                      Text(
                        account?.accntNumber?.toString() ?? '',
                        style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          width: 25,
                          height: 25,
                          getBankLogo(account!.bankType!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(width: 25, height: 25, 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg');
                          },
                        ),
                      ),
                    ],
                  )),
                  ContainerTransparent(
                      opacity: 0.05,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Text(
                        getTranslated(context, 'withdrawCaution'),
                        textAlign: TextAlign.justify,
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.7)),
                      )),
                  Text(
                    getTranslated(context, 'withdrawAmt'),
                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                      borderColor: theme.colorScheme.fadedWhite,
                      enable: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: amtController,
                      hintText: getTranslated(context, 'withdrawAmt'),
                      inputType: TextInputType.number,
                      fillColor: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
                      onChanged: (p0) {
                        if (p0 != '') {
                          total = double.parse(p0) - fee;
                        } else {
                          total = 0;
                        }
                        setState(() {});
                      },
                      tailingWidget: Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 24,
                        width: 24,
                        child: Center(
                          child: Text(
                            'MNT',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'balance'),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                      ),
                      Text(
                        Func.toMoneyStr(wallet?.available ?? '0'),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  Divider(
                    color: theme.colorScheme.darkGrey,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'bankTransactionFee'),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                      ),
                      Text(
                        Func.toMoneyStr(fee),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ])),
      floatingActionButton: IntrinsicHeight(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, 'amtToTheBank'),
                      style: TextStyles.textFt16Med.textColor(theme.colorScheme.weekDayColor),
                    ),
                    Text(
                      Func.toMoneyStr(total),
                      style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomButton(
                  width: double.maxFinite,
                  backgroundColor: theme.colorScheme.whiteColor,
                  textColor: theme.colorScheme.blackColor,
                  text: getTranslated(context, 'continueTxt'),
                  onTap: () {
                    withdraw(theme);
                  },
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
