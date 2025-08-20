import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/neumorphism_icon.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';

class RegisterStepThree extends StatefulWidget {
  const RegisterStepThree({super.key});

  @override
  State<RegisterStepThree> createState() => _RegisterStepThreeState();
}

class _RegisterStepThreeState extends State<RegisterStepThree> {
  String mail = '';
  String username = '';
  String password = '';
  bool isLenght = false;
  TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    // mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      password = args['password'];
      username = args['username'];
      mail = args['email'];

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

  // Future<void> verifyEmailWithTOTP() async {
  //   print('mail:$mail \t otp:${otpController.text} username:$username');
  //   try {
  //     SignUpResult res = await Amplify.Auth.confirmSignUp(
  //       username: username,
  //       confirmationCode: otpController.text,
  //     );
  //     print('result from register step three:$res');
  //     NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
  //   } on ExpiredCodeException {
  //     application.showToastAlert('Хугацаа дууссан байна. Нэг удаагийн код дахин илгээлээ');
  //     print("Verification code expired. Requesting a new one...");
  //     await resendVerificationCode(mail);
  //   } on AuthException catch (e) {
  //     print("Email verification failed: $e");
  //   }
  // }

  // Future<void> resendVerificationCode(String email) async {
  //   try {
  //     await Amplify.Auth.resendSignUpCode(username: email);
  //     print("A new verification code has been sent to your email.");
  //   } on AuthException catch (e) {
  //     print("Failed to resend verification code: ${e.message}");
  //   }
  // }

  _check() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    String password = Provider.of<ProviderCoreModel>(context, listen: false).getPwd();
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = mail;
    data['password'] = password;
    data['challenge'] = otpController.text;

    await Webservice().loadPost(Response.otpCheck, context, data).then((response) {
      application.showToast('Амжилттай!');
      _login();

      // if (response['message'] == ResponseMsg.userGoLogin) {
      //   application.showToast('Та бүртгэлтэй байна.');
      //   NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
      // } else {
      //   NavKey.navKey.currentState!.pushNamed(registerStepThreeRoute);
      // }
    });
  }

  _login() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    String password = Provider.of<ProviderCoreModel>(context, listen: false).getPwd();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['password'] = password;
    await Webservice().loadPost(Response.login, context, data).then((response) async {
      if (response.toString().contains("ChallengeParameters")) {
        NavKey.navKey.currentState!
            .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
      } else {
        await application.setUserType(2);
        application.setAccessToken(response['accessToken']);
        application.setRefreshToken(response['refreshToken']);
        application.setIdToken(response['idToken']);
        application.setEmail(mail);
        application.setpassword(password);

        NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
      }
    });
  }

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: customAppBar(context, isStep: true, step: 3),
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.backgroundColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NeumorphismIcon(
              type: 3,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              getTranslated(context, 'mailConfirm'),
              style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(text: mail, style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor), children: <TextSpan>[
                TextSpan(
                  text: ' мэйл хаягт ирсэн',
                  style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
                ),
                TextSpan(text: '\n6 оронтой кодыг', style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor)),
                TextSpan(
                  text: ' оруулна уу.',
                  style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
                ),
              ]),
            ),
            const SizedBox(
              height: 24,
            ),
            _pinInput(),
            const SizedBox(
              height: 40,
            )
          ])),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          width: 332,
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.zero,
          text: getTranslated(context, 'continueTxt'),
          onTap: () {
            if (otpController.text.length != 6) {
              application.showToastAlert(getTranslated(context, 'pleaseCompleteField'));
            } else {
              _check();
              // verifyEmailWithTOTP();
            }
          },
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
