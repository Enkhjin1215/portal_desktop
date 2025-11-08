import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/components/neumorphism_icon.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/response_messages.dart';
import 'package:portal/service/web_service.dart';

class LoginStepOne extends StatefulWidget {
  const LoginStepOne({super.key});

  @override
  State<LoginStepOne> createState() => _LoginStepOneState();
}

class _LoginStepOneState extends State<LoginStepOne> {
  final TextEditingController _pwdController = TextEditingController();
  @override
  void dispose() {
    // _pwdController.dispose();
    super.dispose();
  }

  _login() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['password'] = _pwdController.text;
    await Webservice().loadPost(Response.login, context, data).then((response) async {
      Provider.of<ProviderCoreModel>(context, listen: false).setPwd(_pwdController.text);

      if (response['message'] == ResponseMsg.userIsNotConfirmed) {
        _otp();
      } else {
        if (response.toString().contains("ChallengeParameters")) {
          NavKey.navKey.currentState!
              .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
        } else {
          await application.setUserType(2);
          application.setAccessToken(response['access_token']);
          application.setRefreshToken(response['refresh_token']);
          // application.setIdToken(response['idToken']);
          application.setEmail(mail);
          application.setpassword(_pwdController.text);

          // print('status:$status');

          NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
        }
      }
    });
  }

  _otp() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    await Webservice().loadPost(Response.otpResend, context, data).then((response) {
      NavKey.navKey.currentState!.pushNamed(registerStepThreeRoute);
    });
  }

  passResetOtp() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    await Webservice().loadGet(Response.forgotPassword, context, parameter: mail).then((response) {
      NavKey.navKey.currentState!.pushNamed(registerStepTwoRoute, arguments: {"from": 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool isEnglish = Provider.of<ProviderCoreModel>(context, listen: true).isEnglish;
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: customAppBar(
        context,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.backgroundColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NeumorphismIcon(
              type: 0,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              getTranslated(context, 'login'),
              style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                  text: isEnglish ? 'Your' : 'Таны и-мэйл хаяг',
                  style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
                  children: <TextSpan>[
                    TextSpan(
                      text: isEnglish ? ' email address' : ' бүртгэлтэй',
                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    TextSpan(text: isEnglish ? ' is registered.' : ' байна.', style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey))
                  ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              getTranslated(context, 'useMongolNFTpassword'),
              style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              obscureText: true,
              enable: true,
              controller: _pwdController,
              hintText: getTranslated(context, 'pwdInput'),
              inputType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                passResetOtp();
              },
              child: Text(
                getTranslated(context, 'forgotPassword'),
                style: TextStyles.textFt16Med.textColor(theme.colorScheme.hintGrey),
              ),
            ),

            // const SizedBox(
            //   height: 40,
            // )
          ])),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          width: 332,
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.zero,
          text: getTranslated(context, 'continueTxt'),
          onTap: () {
            if (!Utils.passwordValidation(_pwdController.text)) {
              application.showToastAlert(getTranslated(context, 'wrongPasswordFormat'));
            } else {
              _login();
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
