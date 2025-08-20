import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';

class OnboardLogoScreen extends StatefulWidget {
  const OnboardLogoScreen({super.key});

  @override
  State<OnboardLogoScreen> createState() => _OnboardLogoScreenState();
}

class _OnboardLogoScreenState extends State<OnboardLogoScreen> with TickerProviderStateMixin {
  late AnimationController _easecontroller;
  late Animation<double> _easeanimation;
  @override
  void initState() {
    super.initState();

    _easecontroller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _easeanimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _easecontroller, curve: Curves.easeIn),
    );
    _easecontroller.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      init();

      // checkAppVersion();
    });
  }

  checkAppVersion() async {
    double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;
    Provider.of<ProviderCoreModel>(context, listen: false).setNotchSizel(stdCutoutWidthDown);
    String version = '1.0.0';

    // Апп-н хувилбар шалгаж байгаа хэсэг
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    print('app version:$version');
    String os = Platform.isIOS ? 'ios' : 'android';

    await Webservice().loadGet(Response.checkUpdate, context, parameter: '$version?os=$os').then((response) {
      debugPrint('response:${response['uptodate']} ${response['uptodate'].runtimeType}');
      // init();

      if (response['uptodate'] == false) {
        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(needUpdateRoute, (route) => false);
      } else {
        Future.delayed(Duration.zero, () {
          init();
        });
        //debugPrint('Updated');
      }
    });
  }

  init() async {
    // NavKey.navKey.currentState!.pushNamedAndRemoveUntil(onboardRoute, (route) => false);

    String accessToken = await application.getAccessToken();
    String idToken = await application.getIdToken();
    String refreshToken = await application.getRefreshToken();

    if (accessToken != '' && idToken != '' && refreshToken != '') {
      application.setUserType(2);
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    } else {
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(onboardRoute, (route) => false);
    }
  }

  @override
  void dispose() {
    _easecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.blackColor,
        child: AnimatedBuilder(
          animation: _easeanimation,
          builder: (context, child) {
            return Transform.scale(scale: _easeanimation.value, child: Center(child: Image.asset(Assets.portalDoor)));
          },
        )

        //  AnimatedBuilder(
        //   animation: _animation,
        //   builder: (context, child) {
        //     return Transform.scale(
        //       scale: _animation.value,
        //       child: SvgPicture.asset(
        //         Assets.portalLogo, // Update this path to your SVG file
        //         width: 80.0,
        //         height: 80.0,
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
