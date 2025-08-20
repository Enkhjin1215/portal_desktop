import 'package:flutter/material.dart';
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
import 'package:portal/service/response_messages.dart';
import 'package:portal/service/web_service.dart';

class RegisterStepTwo extends StatefulWidget {
  const RegisterStepTwo({super.key});

  @override
  State<RegisterStepTwo> createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo> {
  int from = 0; //0 ni register, 1 ni forget password
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();
  String username = '';
  String mail = '';

  final FocusNode _pass1Focus = FocusNode(); //Шинэ нууц үг оруулж буй үед password policy validate хэсгийг харуулахын тулд ашиглаж байгаа
  final FocusNode _pass2Focus = FocusNode(); //Давтан оруулах үед 2 нууц үг таарч байгаа эсэхийг харуулахын тулд ашиглана
  bool upperCase = false;
  bool lowerCase = false;
  bool specialChar = false;
  bool number = false;
  bool length = false;
  bool same = false;
  @override
  void initState() {
    _password1Controller.addListener(() {
      validatePassword();
    });
    _password2Controller.addListener(() {
      samePassword();
    });
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      from = args['from'] ?? from;
      if (from == 0) {
        username = args['username'];
        mail = args['email'];
      }
      setState(() {});
    }));
    super.initState();
  }

  validatePassword() {
    int least = 1; // Дор хаяж хэдэн удаа энэхүү тэмдэгт орсон байх ёстойг заасан хувьсагч
    RegExp regexUpperCase = RegExp('(?:[A-Z]){$least}');
    RegExp regexSpecialSymbol = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
        "'"
        ']');
    RegExp regexNumber = RegExp('(?:[0-9]){$least}');
    RegExp regexLowerCase = RegExp('(?:[a-z]){$least}');
    if (regexUpperCase.hasMatch(_password1Controller.text)) {
      upperCase = true;
    } else {
      upperCase = false;
    }
    if (regexNumber.hasMatch(_password1Controller.text)) {
      number = true;
    } else {
      number = false;
    }
    if (regexLowerCase.hasMatch(_password1Controller.text)) {
      lowerCase = true;
    } else {
      lowerCase = false;
    }
    if (regexSpecialSymbol.hasMatch(_password1Controller.text)) {
      specialChar = true;
    } else {
      specialChar = false;
    }
    if (_password1Controller.text.length >= 8) {
      length = true;
    } else {
      length = false;
    }
    if (_password1Controller.text == _password2Controller.text) {
      same = true;
    } else {
      same = false;
    }

    setState(() {});
  }

  samePassword() {
    if ((_password1Controller.text == _password2Controller.text) && (_password2Controller.text != '')) {
      same = true;
    } else {
      same = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    // _password1Controller.dispose();
    // _password2Controller.dispose();
    // _pass1Focus.dispose();
    // _pass2Focus.dispose();
    super.dispose();
  }

  resetPass() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['newPassword'] = _password2Controller.text;
    data['verificationCode'] = _verifyCodeController.text;
    await Webservice().loadPost(Response.passConfirm, context, data).then((response) {
      application.showToast("Амжилттай");
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
    });
  }

  _getOTP() async {
    String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
    String username = await Provider.of<ProviderCoreModel>(context, listen: false).getUsername();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = mail;
    data['username'] = username;
    data['password'] = _password2Controller.text;
    Provider.of<ProviderCoreModel>(context, listen: false).setPwd(_password2Controller.text);

    await Webservice().loadPost(Response.register, context, data).then((response) {
      if (response['message'] == ResponseMsg.userGoLogin) {
        application.showToast('Та бүртгэлтэй байна.');
        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
      } else {
        Provider.of<ProviderCoreModel>(context, listen: false).setPwd(_password2Controller.text);
        NavKey.navKey.currentState!
            .pushNamed(registerStepThreeRoute, arguments: {'password': _password2Controller.text, 'username': username, 'email': mail});
      }
    });
  }

  // Future<void> signUpUser() async {
  //   try {
  //     SignUpResult res = await Amplify.Auth.signUp(
  //       username: username,
  //       password: _password1Controller.text,
  //       options: SignUpOptions(userAttributes: {
  //         CognitoUserAttributeKey.email: mail,
  //       }),
  //     );
  //     print('res:$res');
  //     NavKey.navKey.currentState!
  //         .pushNamed(registerStepThreeRoute, arguments: {"email": mail, "username": username, "password": _password2Controller.text});

  //     // if (res.isSignUpComplete) {
  //     //   print("Sign up successful. Please verify your email.");
  //     // } else {
  //     //   print("Sign up not complete. Further steps required.");
  //     // }
  //   } on AuthException catch (e) {
  //     print("Sign up failed: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: customAppBar(context, isStep: true, step: 2),
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
              getTranslated(context, from == 1 ? 'forgotPassword' : 'register'),
              style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              getTranslated(context, 'pleaseInsertNewPassword'),
              style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              focusNode: _pass1Focus,
              enable: true,
              obscureText: true,
              controller: _password1Controller,
              hintText: getTranslated(context, 'insertNewPassword'),
              inputType: TextInputType.visiblePassword,
              onFocusChanged: (p0) {
                setState(() {});
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
                visible: _pass1Focus.hasFocus,
                child: Column(
                  children: [
                    passwordPolicyItem(upperCase, getTranslated(context, 'uppercase')),
                    passwordPolicyItem(lowerCase, getTranslated(context, 'lowercase')),
                    passwordPolicyItem(specialChar, getTranslated(context, 'specialCharacter')),
                    passwordPolicyItem(number, getTranslated(context, 'digit')),
                    passwordPolicyItem(length, getTranslated(context, 'lengthis8'))
                  ],
                )),
            CustomTextField(
              obscureText: true,
              enable: true,
              controller: _password2Controller,
              hintText: getTranslated(context, 'repeatNewPassword'),
              inputType: TextInputType.visiblePassword,
              focusNode: _pass2Focus,
            ),
            Visibility(
                visible: _pass2Focus.hasFocus,
                child: Column(
                  children: [
                    passwordPolicyItem(same, getTranslated(context, 'mustSamePassword')),
                  ],
                )),
            from == 0
                ? const SizedBox()
                : Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        getTranslated(context, 'insertVerificationCode'),
                        style: TextStyles.textFt14Reg.textColor(theme.colorScheme.colorGrey),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        obscureText: false,
                        enable: true,
                        controller: _verifyCodeController,
                        hintText: getTranslated(context, 'verifyCode'),
                        inputType: TextInputType.number,
                        // focusNode: _pass2Focus,
                      ),
                    ],
                  ),
          ])),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          width: 332,
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.zero,
          text: getTranslated(context, 'continueTxt'),
          onTap: () {
            if (same) {
              if (from == 1 && _verifyCodeController.text.length >= 4) {
                resetPass();
                // print('change password');
              } else {
                _getOTP();
                // signUpUser();
              }
              // NavKey.navKey.currentState!.pushNamed(registerStepThreeRoute);
            } else {
              application.showToastAlert(getTranslated(context, 'cantPass'));
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget passwordPolicyItem(bool condition, String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          condition ? Icons.check : Icons.close,
          color: condition ? Colors.white : Colors.grey,
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          text,
          style: TextStyles.textFt14Med.textColor(condition ? Colors.white : Colors.grey),
        )
      ],
    ),
  );
}
