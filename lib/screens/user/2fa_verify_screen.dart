import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/neumorphism_icon.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class TwoFAVerifyScreen extends StatefulWidget {
  const TwoFAVerifyScreen({super.key});

  @override
  State<TwoFAVerifyScreen> createState() => _TwoFAVerifyScreenState();
}

class _TwoFAVerifyScreenState extends State<TwoFAVerifyScreen> {
  bool isLenght = false;
  TextEditingController otpController = TextEditingController();
  String session = '';
  String username = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      username = args['name'];
      session = args['session'];
      setState(() {});
    }));
  }

  validatePinLenght(String val) {
    if (val.length == 6) {
      isLenght = true;
    } else {
      isLenght = false;
    }
    setState(() {});
  }

  login() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['session'] = session;
    data['userCode'] = otpController.text;
    await Webservice().loadPost(Response.loginMFA, context, data).then((response) async {
      if (response.toString().contains("ChallengeParameters")) {
        NavKey.navKey.currentState!
            .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
      } else {
        await application.setUserType(2);
        application.setAccessToken(response['access_token']);
        application.setRefreshToken(response['refresh_token']);
        // application.setIdToken(response['idToken']);

        // var status = await Permission.notification.status;
        // if (status == PermissionStatus.granted) {
        NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
        // } else {
        //   NavKey.navKey.currentState!.pushNamed(notifPermissionRoute);
        // }
      }
    });
  }

  // void _confirmSignIn() async {
  //   String totpCode = otpController.text.trim();

  //   try {
  //     SignInResult result = await Amplify.Auth.confirmSignIn(
  //       confirmationValue: totpCode,
  //     );

  //     if (result.isSignedIn) {
  //       print("TOTP verification successful!");

  //       // Fetch tokens after successful sign-in
  //       CognitoAuthSession session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
  //       print("Access Token: ${session.userPoolTokensResult.value.accessToken.raw}");

  //       await application.setUserType(2);

  //       print("Access Token 2: ${session.userPoolTokensResult.value.idToken.raw}");
  //       print("Access Token 3: ${session.userPoolTokensResult.value.refreshToken}");
  //       application.setAccessToken(session.userPoolTokensResult.value.accessToken.raw);
  //       application.setRefreshToken(session.userPoolTokensResult.value.refreshToken);
  //       application.setIdToken(session.userPoolTokensResult.value.idToken.raw);

  //       NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
  //     } else {
  //       print("TOTP verification failed. Next step: ${result.nextStep.signInStep}");
  //     }
  //   } catch (e) {
  //     print("Error confirming TOTP: $e");
  //   }
  // }

  final PinTheme _pinDecoration = PinTheme(
    textStyle: TextStyles.textFt24Med.textColor(Colors.white),
    height: 54,
    width: 52,
    // margin: EdgeInsets.symmetric(horizontal: 50),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
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
              getTranslated(context, '2FAVerify'),
              style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                  text: 'MongolNFT хаягт холбосон ',
                  style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'authenticator апп',
                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    TextSpan(text: '-c гаргаж өгсөн', style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey)),
                    TextSpan(
                      text: ' 6 оронтой кодыг',
                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    TextSpan(text: ' оруулна уу.', style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey)),
                  ]),
            ),

            const SizedBox(
              height: 16,
            ),
            _pinInput(),

            const SizedBox(
              height: 16,
            ),

            // const SizedBox(
            //   height: 40,
            // )
          ])),
      floatingActionButton: IntrinsicHeight(
        child: Visibility(
          visible: isLenght,
          child: CustomButton(
            width: 332,
            alignment: Alignment.bottomCenter,
            // margin: EdgeInsets.zero,
            text: getTranslated(context, 'continueTxt'),
            onTap: () {
              // _confirmSignIn();
              login();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _pinInput() {
    ThemeData themes = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Pinput(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      length: 6,
      enabled: true,
      readOnly: false,
      keyboardType: TextInputType.number,
      useNativeKeyboard: true,
      onCompleted: (value) {
        // otpController.text = value;
      },
      controller: otpController,
      onChanged: (value) {
        validatePinLenght(value);
      },
      defaultPinTheme: _pinDecoration.copyWith(
          decoration: BoxDecoration(
            color: themes.colorScheme.hintColor,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4)),
      focusedPinTheme: _pinDecoration.copyWith(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: themes.colorScheme.hintColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: themes.colorScheme.blackColor.withValues(alpha: 0.1),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
