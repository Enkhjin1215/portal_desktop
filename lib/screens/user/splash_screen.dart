import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
// import 'package:rive/rive.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;
  bool buttonShow = false;
  @override
  void initState() {
    checkAppVersion();
    _textController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_textController);
    _textController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      buttonShow = true;
      setState(() {});
    });
    super.initState();
  }

  checkAppVersion() async {
    String version = '1.0.0';

    // Апп-н хувилбар шалгаж байгаа хэсэг
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    print('app version:$version');
    String os = Platform.isIOS ? 'IOS' : 'android';

    await Webservice().loadGet(Response.checkUpdate, context, parameter: '$version?os=$os').then((response) {
      //debugPrint('response:$response');
      if (response['uptodate'] == true) {
        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(needUpdateRoute, (route) => false);
      } else {
        //debugPrint('Updated');
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.backgroundColor,
        child: Stack(
          children: [
            // const Center(
            //   child: RiveAnimation.asset(
            //     Assets.galaxyRiv,
            //     fit: BoxFit.fitHeight,
            //   ),
            // ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).hp(25)),
                  child: FadeTransition(
                      opacity: _textAnimation,
                      child: Text(
                        'PORTAL',
                        style: TextStyles.textFt40Bold.textColor(theme.colorScheme.whiteColor).italic,
                      ))),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: buttonShow,
                    child: CustomButton(
                      width: 332,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(8)),
                      onTap: () {
                        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
                      },
                      // margin: EdgeInsets.zero,
                      text: getTranslated(context, 'continueTxt'),
                    )))
          ],
        ));
  }
}
