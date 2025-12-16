import 'package:flutter/material.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/components/neumorphism_icon.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/response_messages.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class LogRegStepOne extends StatefulWidget {
  const LogRegStepOne({super.key});

  @override
  State<LogRegStepOne> createState() => _LogRegStepOneState();
}

class _LogRegStepOneState extends State<LogRegStepOne> {
  final TextEditingController _mailController = TextEditingController(text: "renchinochir.u@gmail.com");
  final TextEditingController _pwdController = TextEditingController(text: "Test@123@123");
  // final TextEditingController _mailController = TextEditingController(text: "discodisco@mailinator.com");
  // final TextEditingController _pwdController = TextEditingController(text: "DrC5(ACM");
  // final TextEditingController _mailController = TextEditingController(text: "");
  // final TextEditingController _pwdController = TextEditingController(text: "");

  int userType = 0;
  bool canBack = false;
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

  login() async {
    // email = await application.getEmail();
    // String password = await application.getpassword();

    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _mailController.text;
    data['password'] = _pwdController.text;
    await Webservice().loadPost(Response.login, context, data).then((response) async {
      // Provider.of<ProviderCoreModel>(context, listen: false).setPwd(password);
      if (response.toString().contains("ChallengeParameters")) {
        NavKey.navKey.currentState!
            .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
      } else {
        await application.setUserType(2);
        application.setAccessToken(response['access_token']);
        application.setRefreshToken(response['refresh_token']);
        // application.setIdToken(response['idToken']);

        NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context).getTheme();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.inputBackground,
      body: Container(
          // width: ResponsiveFlutter.of(context).wp(150),
          // height: ResponsiveFlutter.of(context).hp(100),
          decoration: const BoxDecoration(color: Colors.red, image: DecorationImage(image: AssetImage(Assets.onboardBackground), fit: BoxFit.fill)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700, // Desktop-д тохирсон өргөн
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Desktop бол drag-line хэрэггүй тул хассан
                      const SizedBox(height: 20),

                      const NeumorphismIcon(type: 0),
                      const SizedBox(height: 32),

                      Text(
                        getTranslated(context, 'login'),
                        style: TextStyles.textFt30.textColor(theme.colorScheme.whiteColor),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        getTranslated(context, 'insertEmail'),
                        style: TextStyles.textFt18Reg.textColor(theme.colorScheme.whiteColor),
                      ),
                      const SizedBox(height: 32),

                      CustomTextField(
                        enable: true,
                        controller: _mailController,
                        hintText: getTranslated(context, 'emailInput'),
                        inputType: TextInputType.emailAddress,
                        fillColor: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        obscureText: true,
                        enable: true,
                        controller: _pwdController,
                        hintText: getTranslated(context, 'pwdInput'),
                        inputType: TextInputType.visiblePassword,
                        fillColor: Colors.white.withValues(alpha: 0.5),
                      ),

                      const SizedBox(height: 40),

                      // Desktop-д илүү тохиромжтой Login Button
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: CustomButton(
                          text: getTranslated(context, 'login'),
                          onTap: () {
                            if (_mailController.text.isNotEmpty && _pwdController.text.isNotEmpty) {
                              login();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
