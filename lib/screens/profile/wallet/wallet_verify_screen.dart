import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class WalletVerify extends StatefulWidget {
  const WalletVerify({super.key});

  @override
  State<WalletVerify> createState() => _WalletVerifyState();
}

class _WalletVerifyState extends State<WalletVerify> {
  TextEditingController bankCodeController = TextEditingController();
  late Account account;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      account = args['acc'];
      setState(() {});
      // init();
    }));
  }

  @override
  void dispose() {
    bankCodeController.dispose();
    super.dispose();
  }

  verifyBank() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userCode'] = bankCodeController.text;
    data['accountNumber'] = account.accntNumber;
    await Webservice().loadPost(Response.verifyAcnt, context, data).then((response) async {
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(profileRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
      canPopWithSwipe: true,
      appBar: customAppBar(context, isStep: true, step: 2, totalStep: 2),
      padding: EdgeInsets.zero,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.walletBackground), fit: BoxFit.fill)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                getTranslated(context, 'accountVerify'),
                style: TextStyles.textFt15Bold.textColor(theme.colorScheme.hintColor),
              ),
            ),
            ContainerTransparent(
                opacity: 0.05,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Text(
                  getTranslated(context, 'walletVerify'),
                  textAlign: TextAlign.center,
                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.7)),
                )),
            Utils.requiredText(getTranslated(context, 'verifyCode'), TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor)),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              borderColor: theme.colorScheme.fadedWhite,
              enable: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: bankCodeController,
              hintText: getTranslated(context, 'verifyCode'),
              inputType: TextInputType.number,
              fillColor: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
              maxLength: 6,
            ),
          ])),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          // margin: EdgeInsets.zero,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          onTap: () async {
            verifyBank();
          },

          text: getTranslated(context, 'accountVerify'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
