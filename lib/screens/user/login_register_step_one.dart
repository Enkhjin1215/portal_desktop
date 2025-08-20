import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
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

class LogRegStepOne extends StatefulWidget {
  const LogRegStepOne({super.key});

  @override
  State<LogRegStepOne> createState() => _LogRegStepOneState();
}

class _LogRegStepOneState extends State<LogRegStepOne> {
  final TextEditingController _mailController = TextEditingController();
  int userType = 0;
  bool canBack = false;
  bool useBiometricLogin = false;
  String email = '';
  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    // _mailController.dispose();
    super.dispose();
  }

  init() async {
    userType = await application.getUserType() ?? 0;
    useBiometricLogin = await application.getBiometricLogin();
    if (useBiometricLogin) {
      email = await application.getEmail();
      _mailController.text = email;
    }
    Provider.of<ProviderCoreModel>(context, listen: false).setLoading(false);

    setState(() {});
  }

  _checkEmail() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _mailController.text;
    await Webservice().loadPost(Response.checkUser, context, data).then((response) {
      setState(() {});
      Provider.of<ProviderCoreModel>(context, listen: false).setEmail(_mailController.text);
      application.setBiometricLogin(false);
      if (response['message'] == ResponseMsg.userExist) {
        NavKey.navKey.currentState!.pushNamed(loginStepOneRoute);
      } else if (response['message'] == ResponseMsg.userNotExist) {
        NavKey.navKey.currentState!.pushNamed(registerStepOneRoute);
      }
    });
  }

  biometricLog() async {
    final LocalAuthentication auth = LocalAuthentication();
    var bioType = await auth.getAvailableBiometrics();
    String type = bioType.first.name;
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: getTranslated(context, (type == BiometricType.fingerprint.name) == true ? 'useFingerPrint' : 'useFaceId'),
          options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException {
      ////debugPrint(e);
    }
    if (authenticated) {
      login();
    } else {}
  }

  login() async {
    email = await application.getEmail();
    String password = await application.getpassword();

    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    await Webservice().loadPost(Response.login, context, data).then((response) async {
      Provider.of<ProviderCoreModel>(context, listen: false).setPwd(password);
      if (response.toString().contains("ChallengeParameters")) {
        NavKey.navKey.currentState!
            .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
      } else {
        await application.setUserType(2);
        application.setAccessToken(response['accessToken']);
        application.setRefreshToken(response['refreshToken']);
        application.setIdToken(response['idToken']);

        NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.inputBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: userType == 0,
                child: InkWell(
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
                )),
            const NeumorphismIcon(
              type: 0,
            ),
            const SizedBox(
              height: 24,
            ),
            RichText(
              text: TextSpan(
                  text: getTranslated(context, 'login'),
                  style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' / ',
                      style: TextStyles.textFt22Bold.textColor(theme.colorScheme.hintColor),
                    ),
                    TextSpan(text: getTranslated(context, 'register'), style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor))
                  ]),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              getTranslated(context, 'insertEmail'),
              style: TextStyles.textFt16Reg.textColor(theme.colorScheme.weekDayColor),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomTextField(
              enable: true,
              controller: _mailController,
              hintText: getTranslated(context, 'emailInput'),
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: IntrinsicHeight(
          child: CustomButton(
        width: 332,
        alignment: Alignment.bottomCenter,
        // margin: EdgeInsets.zero,
        text: getTranslated(context, 'continueTxt'),
        onTap: () {
          if (useBiometricLogin && email == _mailController.text) {
            biometricLog();
          } else if (!Utils.isEmail(_mailController.text)) {
            application.showToastAlert(getTranslated(context, 'wrongMailFormat'));
          } else {
            _checkEmail();
          }
        },
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
