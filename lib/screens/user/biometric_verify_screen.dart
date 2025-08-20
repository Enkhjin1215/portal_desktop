import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class BiometricVerifyScreen extends StatefulWidget {
  const BiometricVerifyScreen({super.key});

  @override
  State<BiometricVerifyScreen> createState() => _BiometricVerifyScreenState();
}

class _BiometricVerifyScreenState extends State<BiometricVerifyScreen> {
  List<BiometricType> list = [];
  static final LocalAuthentication auth = LocalAuthentication();
  String type = '';
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    list = await auth.getAvailableBiometrics();
    if (list.isEmpty) {
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    } else {
      type = list.first.name;

      setState(() {});
    }
  }

  biometricLog() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: getTranslated(context, (type == BiometricType.fingerprint.name) == true ? 'useFingerPrint' : 'useFaceId'),
          options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException {
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    }
    if (authenticated) {
      application.setBiometricLogin(true);
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    } else {
      application.setBiometricLogin(false);
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    // init();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.inputBackground,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(
              child: SizedBox(),
            ),
            SvgPicture.asset(
              Assets.faceid,
              color: Colors.white,
              width: ResponsiveFlutter.of(context).wp(20),
              height: ResponsiveFlutter.of(context).hp(20),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              getTranslated(context, type == BiometricType.fingerprint.name ? 'useFingerPrintBody' : 'useFaceIdBody'),
              style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Center(
              child: IntrinsicHeight(
                child: CustomButton(
                  width: 332,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.zero,
                  text: getTranslated(context, 'continueTxt'),
                  onTap: () {
                    biometricLog();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
                child: CustomButton(
              textColor: theme.colorScheme.whiteColor,
              backgroundColor: theme.colorScheme.backgroundColor,
              borderColor: theme.colorScheme.whiteColor,
              width: 332,
              alignment: Alignment.bottomCenter,
              // margin: EdgeInsets.zero,
              text: getTranslated(context, 'skip'),
              onTap: () async {
                NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
              },
            )),
          ])),
    );
  }
}
