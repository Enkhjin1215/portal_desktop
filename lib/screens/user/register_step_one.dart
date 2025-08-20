import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal/helper/utils.dart';
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
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';

class RegisterStepOne extends StatefulWidget {
  const RegisterStepOne({super.key});

  @override
  State<RegisterStepOne> createState() => _RegisterStepOneState();
}

class _RegisterStepOneState extends State<RegisterStepOne> {
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> isUsernameOrEmailAvailable(String username, String email) async {
  //   print('STEP 1: $username \t email:$email');
  //   try {
  //     await Amplify.Auth.signIn(username: username, password: 'dummyPassword');
  //     print("Username already exists.");
  //     return false;
  //   } on UserNotFoundException {
  //     try {
  //       await Amplify.Auth.signIn(username: email, password: 'dummyPassword');
  //       print("Email already exists.");
  //       return false;
  //     } on UserNotFoundException {
  //       return true; // Both username and email are available
  //     } on AuthException catch (e) {
  //       print("Email availability check failed: $e");
  //       return true;
  //     }
  //   } on AuthException catch (e) {
  //     print("Username availability check failed: ${e.message}");
  //     if (e.message == 'Incorrect username or password.') {
  //       return false;
  //     }
  //     return true;
  //   }
  // }

  // checkUnique() async {
  //   try {
  //     bool isAvailable = await isUsernameOrEmailAvailable(_userNameController.text, _mailController.text);
  //     if (!isAvailable) {
  //       application.showToastAlert("Username or email already taken.");
  //       return;
  //     } else {
  //       NavKey.navKey.currentState!
  //           .pushNamed(registerStepTwoRoute, arguments: {"from": 0, "email": _mailController.text, "username": _userNameController.text});
  //     }
  //   } on AuthException catch (e) {
  //     debugPrint("Sign up failed: $e");
  //   }
  // }

  _checkUserName() async {
    String raw = Utils.simpleObfuscate(_userNameController.text.trim());

    String encoded = Uri.encodeComponent(raw);

    await Webservice().loadGet(Response.checkUserName, context, parameter: '/$encoded').then((response) {
      if (response['data'] != null) {
        String result = Utils.simpleDeobfuscate(response['data']);

        print('result:$result');
        if (result.contains('"status":false')) {
          Provider.of<ProviderCoreModel>(context, listen: false).setUsername(_userNameController.text);
          String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();

          NavKey.navKey.currentState!
              .pushNamed(registerStepTwoRoute, arguments: {"from": 0, "username": _userNameController.text.trim(), "email": mail});
        } else {
          application.showToastAlert(getTranslated(context, 'usernameNotUnique'));
        }
      } else {
        application.showToastAlert(getTranslated(context, 'usernameNotUnique'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: customAppBar(context, isStep: true, step: 1),
      resizeToAvoidBottomInset: false,
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
              getTranslated(context, 'register'),
              style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(text: 'Та', style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey), children: <TextSpan>[
                TextSpan(
                  text: ' MongolNFT',
                  style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                ),
                TextSpan(text: '-д бүртгэлгүй байна.', style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey))
              ]),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            // Text(
            //   getTranslated(context, 'insertNewUserName'),
            //   style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
            // ),
            // const SizedBox(
            //   height: 16,
            // ),
            // CustomTextField(
            //   enable: true,
            //   controller: _mailController,
            //   hintText: getTranslated(context, 'emailInput'),
            //   inputType: TextInputType.emailAddress,
            // ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              enable: true,
              controller: _userNameController,
              hintText: getTranslated(context, 'inserUserName'),
              inputType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ])),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          width: 332,
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.zero,
          text: getTranslated(context, 'continueTxt'),
          onTap: () {
            if (_userNameController.text.isEmpty) {
              application.showToastAlert(getTranslated(context, 'emptyWarning'));
            } else {
              // checkUnique();
              _checkUserName();
              // NavKey.navKey.currentState!.pushNamed(registerStepTwoRoute);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
