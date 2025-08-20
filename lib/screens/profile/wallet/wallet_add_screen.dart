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
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/bank_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/core_requests.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class WalletAddScreen extends StatefulWidget {
  const WalletAddScreen({super.key});

  @override
  State<WalletAddScreen> createState() => _WalletAddScreenState();
}

class _WalletAddScreenState extends State<WalletAddScreen> {
  QpayBanks qpayBanks = QpayBanks();
  List<BankModel> banks = [];
  BankModel? selectedBank;
  TextEditingController bankAcntNumberController = TextEditingController();
  TextEditingController bankHolderNameController = TextEditingController();
  CoreRequests coreRequests = CoreRequests();

  @override
  void initState() {
    banks = qpayBanks.getBankList();
    setState(() {});
    super.initState();
  }

  @override
  dispose() {
    // bankAcntNumberController.dispose();
    // bankHolderNameController.dispose();
    super.dispose();
  }

  saveBank() async {
    if (bankAcntNumberController.text.length <= 8) {
      application.showToastAlert('Дансны дугаар буруу байна');
    } else if (bankHolderNameController.text.length <= 2) {
      application.showToastAlert('Дансны эзэмшигчийн нэр буруу байна');
    } else if (selectedBank == null) {
      application.showToastAlert('Банк сонгоно уу');
    } else {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['bankType'] = selectedBank!.type;
      data['accountNumber'] = bankAcntNumberController.text;
      data['accountName'] = bankHolderNameController.text;
      try {
        await Webservice().loadPost(Account.bankAdd, context, data).then((response) async {
          Account account = response;
          if (account.accntName != '') {
            NavKey.navKey.currentState!.pushNamed(walletVerifyRoute, arguments: {'acc': account});
          }
        });
      } catch (e) {
        debugPrint('e:$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
      canPopWithSwipe: true,
      appBar: customAppBar(context, isStep: true, step: 1, totalStep: 2),
      padding: EdgeInsets.zero,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.walletBackground), fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                getTranslated(context, 'BankAdd'),
                style: TextStyles.textFt15Bold.textColor(theme.colorScheme.hintColor),
              ),
            ),
            ContainerTransparent(
                opacity: 0.05,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Text(
                  getTranslated(context, 'bankAddCaution'),
                  textAlign: TextAlign.center,
                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.7)),
                )),
            Utils.requiredText(getTranslated(context, 'chooseBank'), TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor)),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                ModalAlert().bankList(
                  context: context,
                  theme: theme,
                  list: banks,
                  onSelectAcc: (BankModel bank) {
                    setState(() {
                      selectedBank = bank;
                      bankAcntNumberController.text = '';
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(color: theme.colorScheme.fadedWhite),
                    borderRadius: BorderRadius.circular(12)),
                width: double.maxFinite,
                child: selectedBank == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, 'chooseBank'),
                            style: TextStyles.textFt14Reg.textColor(theme.colorScheme.hintColor),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              width: 25,
                              height: 25,
                              selectedBank!.logo!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Text(
                              selectedBank!.name ?? '',
                              style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                            ),
                          )
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Utils.requiredText(getTranslated(context, 'accountNumber'), TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor)),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              borderColor: theme.colorScheme.fadedWhite,
              enable: true,
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: bankAcntNumberController,
              hintText: getTranslated(context, 'accountNumber'),
              inputType: TextInputType.text,
              fillColor: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
            ),
            const SizedBox(
              height: 16,
            ),
            Utils.requiredText(getTranslated(context, 'accountHolderName'), TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor)),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              borderColor: theme.colorScheme.fadedWhite,
              enable: true,
              controller: bankHolderNameController,
              hintText: getTranslated(context, 'accountHolderName'),
              inputType: TextInputType.name,
              fillColor: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
            ),
          ],
        ),
      ),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          // margin: EdgeInsets.zero,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          onTap: () async {
            saveBank();
          },

          text: getTranslated(context, 'BankAdd'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
