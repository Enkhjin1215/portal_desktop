// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pinput/pinput.dart';
// import 'package:portal/components/custom_app_bar.dart';
// import 'package:portal/components/custom_button.dart';
// import 'package:portal/components/custom_scaffold.dart';
// import 'package:portal/components/custom_text_input.dart';
// import 'package:portal/components/neumorphism_icon.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/helper/constant.dart';
// import 'package:portal/helper/responsive_flutter.dart';
// import 'package:portal/helper/text_styles.dart';
// import 'package:portal/helper/utils.dart';
// import 'package:portal/language/language_constant.dart';
// import 'package:portal/provider/theme_notifier.dart';
// import 'package:portal/screens/user/register_step_two.dart';
// import 'package:provider/provider.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';

// class ForgotPass extends StatefulWidget {
//   const ForgotPass({super.key});

//   @override
//   State<ForgotPass> createState() => _ForgotPassState();
// }

// class _ForgotPassState extends State<ForgotPass> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _password2Controller = TextEditingController();
//   final FocusNode _pass2Focus = FocusNode(); //Давтан оруулах үед 2 нууц үг таарч байгаа эсэхийг харуулахын тулд ашиглана

//   int step = 0;
//   bool isLenght = false;
//   TextEditingController otpController = TextEditingController();
//   bool upperCase = false;
//   bool lowerCase = false;
//   bool specialChar = false;
//   bool number = false;
//   bool length = false;
//   @override
//   void initState() {
//     super.initState();
//     _password2Controller.addListener(() {
//       validatePassword();
//     });
//   }

//   validatePassword() {
//     int least = 1; // Дор хаяж хэдэн удаа энэхүү тэмдэгт орсон байх ёстойг заасан хувьсагч
//     RegExp regexUpperCase = RegExp('(?:[A-Z]){$least}');
//     RegExp regexSpecialSymbol = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
//         "'"
//         ']');
//     RegExp regexNumber = RegExp('(?:[0-9]){$least}');
//     RegExp regexLowerCase = RegExp('(?:[a-z]){$least}');
//     if (regexUpperCase.hasMatch(_password2Controller.text)) {
//       upperCase = true;
//     } else {
//       upperCase = false;
//     }
//     if (regexNumber.hasMatch(_password2Controller.text)) {
//       number = true;
//     } else {
//       number = false;
//     }
//     if (regexLowerCase.hasMatch(_password2Controller.text)) {
//       lowerCase = true;
//     } else {
//       lowerCase = false;
//     }
//     if (regexSpecialSymbol.hasMatch(_password2Controller.text)) {
//       specialChar = true;
//     } else {
//       specialChar = false;
//     }
//     if (_password2Controller.text.length >= 12) {
//       length = true;
//     } else {
//       length = false;
//     }

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     // _pwdController.dispose();
//     super.dispose();
//   }

//   // _login() async {
//   //   String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
//   //   final Map<String, dynamic> data = <String, dynamic>{};
//   //   data['email'] = mail;
//   //   data['password'] = _pwdController.text;
//   //   await Webservice().loadPost(Response.login, context, data).then((response) async {
//   //     Provider.of<ProviderCoreModel>(context, listen: false).setPwd(_pwdController.text);

//   //     if (response['message'] == ResponseMsg.userIsNotConfirmed) {
//   //       _otp();
//   //     } else {
//   //       if (response.toString().contains("ChallengeParameters")) {
//   //         NavKey.navKey.currentState!
//   //             .pushNamed(twoFaRoute, arguments: {'name': response['ChallengeParameters']['USER_ID_FOR_SRP'], 'session': response['Session']});
//   //       } else {
//   //         await application.setUserType(2);
//   //         application.setAccessToken(response['accessToken']);
//   //         application.setRefreshToken(response['refreshToken']);
//   //         application.setIdToken(response['idToken']);
//   //         application.setEmail(mail);
//   //         application.setpassword(_pwdController.text);

//   //         var status = await Permission.notification.status;
//   //         if (status == PermissionStatus.granted) {
//   //           NavKey.navKey.currentState?.pushNamedAndRemoveUntil(biometricVerifyRoute, (route) => false);
//   //         } else {
//   //           NavKey.navKey.currentState!.pushNamed(notifPermissionRoute);
//   //         }
//   //       }
//   //     }
//   //   });
//   // }

//   // _otp() async {
//   //   String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
//   //   final Map<String, dynamic> data = <String, dynamic>{};
//   //   data['email'] = mail;
//   //   await Webservice().loadPost(Response.otpResend, context, data).then((response) {
//   //     NavKey.navKey.currentState!.pushNamed(registerStepThreeRoute);
//   //   });
//   // }

//   // passResetOtp() async {
//   //   String mail = Provider.of<ProviderCoreModel>(context, listen: false).getEmail();
//   //   await Webservice().loadGet(Response.forgotPassword, context, parameter: mail).then((response) {
//   //     NavKey.navKey.currentState!.pushNamed(registerStepTwoRoute, arguments: {"from": 1});
//   //   });
//   // }
//   final PinTheme _pinDecoration = PinTheme(
//     textStyle: TextStyles.textFt24Med.textColor(Colors.white),
//     height: 54,
//     width: 52,
//     // margin: EdgeInsets.symmetric(horizontal: 50),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(4),
//     ),
//   );
//   validatePinLenght(String val) {
//     if (val.length == 6) {
//       isLenght = true;
//     } else {
//       isLenght = false;
//     }
//     setState(() {});
//   }

//   // Future<void> resetPassword(String username) async {
//   //   try {
//   //     await Amplify.Auth.resetPassword(username: username);
//   //     debugPrint("Password reset code sent to email. :$username");
//   //     setState(() {
//   //       step = 1;
//   //     });
//   //   } on UserNotFoundException {
//   //     debugPrint("User not found. Please check your email.");
//   //   } on LimitExceededException {
//   //     debugPrint("Too many requests. Try again later.");
//   //   } on AuthException catch (e) {
//   //     debugPrint("Error requesting password reset: ${e.message}");
//   //   }
//   // }

//   // Future<void> confirmNewPassword(String username, String confirmationCode, String newPassword) async {
//   //   try {
//   //     await Amplify.Auth.confirmResetPassword(
//   //       username: username,
//   //       newPassword: newPassword,
//   //       confirmationCode: confirmationCode,
//   //     );
//   //     debugPrint("Password reset successful! You can now log in.");
//   //     application.showToast('Амжилттай, та одоо нэвтэрнэ үү');
//   //     NavKey.navKey.currentState!.pop();
//   //   } on CodeMismatchException {
//   //     debugPrint("Invalid confirmation code. Please check and try again.");
//   //   } on ExpiredCodeException {
//   //     debugPrint("Code expired. Request a new password reset.");
//   //   } on AuthException catch (e) {
//   //     debugPrint("Password reset failed: ${e.message}");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     return CustomScaffold(
//         padding: EdgeInsets.zero,
//         appBar: customAppBar(
//           context,
//         ),
//         resizeToAvoidBottomInset: false,
//         body: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             width: ResponsiveFlutter.of(context).wp(100),
//             height: ResponsiveFlutter.of(context).hp(100),
//             color: theme.colorScheme.backgroundColor,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const NeumorphismIcon(),
//               const SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 getTranslated(context, 'forgotPassword'),
//                 style: TextStyles.textFt24Med.textColor(theme.colorScheme.whiteColor),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),

//               Text(getTranslated(context, 'inserUserName'), style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey)),
//               const SizedBox(
//                 height: 16,
//               ),

//               CustomTextField(
//                 enable: true,
//                 controller: _usernameController,
//                 hintText: getTranslated(context, 'inserUserName'),
//                 inputType: TextInputType.name,
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Visibility(
//                   visible: step == 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         getTranslated(context, 'verifyCode'),
//                         style: TextStyles.textFt16Reg.textColor(theme.colorScheme.colorGrey),
//                       ),
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       _pinInput(),
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Visibility(
//                           visible: _pass2Focus.hasFocus,
//                           child: Column(
//                             children: [
//                               passwordPolicyItem(upperCase, getTranslated(context, 'uppercase')),
//                               passwordPolicyItem(lowerCase, getTranslated(context, 'lowercase')),
//                               passwordPolicyItem(specialChar, getTranslated(context, 'specialCharacter')),
//                               passwordPolicyItem(number, getTranslated(context, 'digit')),
//                               passwordPolicyItem(length, getTranslated(context, 'lengthis8'))
//                             ],
//                           )),
//                       CustomTextField(
//                         obscureText: true,
//                         enable: true,
//                         controller: _password2Controller,
//                         hintText: getTranslated(context, 'insertNewPassword'),
//                         inputType: TextInputType.visiblePassword,
//                         focusNode: _pass2Focus,
//                       ),
//                     ],
//                   )),
//               const Expanded(
//                 child: SizedBox(),
//               ),

//               CustomButton(
//                 width: 332,
//                 alignment: Alignment.bottomCenter,
//                 // margin: EdgeInsets.zero,
//                 text: getTranslated(context, step == 0 ? 'continueTxt' : 'confirm'),
//                 onTap: () {
//                   if (step == 0 && _usernameController.text.isNotEmpty) {
//                     resetPassword(_usernameController.text.trim());
//                   } else if (step == 1 && isLenght && Utils.passwordValidation(_password2Controller.text.trim())) {
//                     confirmNewPassword(_usernameController.text.trim(), otpController.text.trim(), _password2Controller.text.trim());
//                   }
//                 },
//               ),

//               // const SizedBox(
//               //   height: 40,
//               // )
//             ])));
//   }

//   Widget _pinInput() {
//     ThemeData themes = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

//     return Pinput(
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       length: 6,
//       enabled: true,
//       readOnly: false,
//       keyboardType: TextInputType.number,
//       useNativeKeyboard: true,
//       onCompleted: (value) {
//         // otpController.text = value;
//       },
//       controller: otpController,
//       onChanged: (value) {
//         validatePinLenght(value);
//       },
//       defaultPinTheme: _pinDecoration.copyWith(
//           decoration: BoxDecoration(
//             color: themes.colorScheme.hintColor,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.symmetric(horizontal: 4)),
//       focusedPinTheme: _pinDecoration.copyWith(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: themes.colorScheme.hintColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: themes.colorScheme.blackColor.withValues(alpha: 0.1),
//               spreadRadius: 5,
//               blurRadius: 20,
//               offset: const Offset(0, 1), // changes position of shadow
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
