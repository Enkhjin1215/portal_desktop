import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedUpdateScreen extends StatefulWidget {
  const NeedUpdateScreen({Key? key}) : super(key: key);

  @override
  State<NeedUpdateScreen> createState() => _NeedUpdateScreenState();
}

class _NeedUpdateScreenState extends State<NeedUpdateScreen> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        // widget is resumed

        // payTabbarKey!.currentState.checkInvoice();
        //debugPrint('resumed');
        Future.delayed(Duration.zero, () {
          checkAppVersion();
        });

        // qpayKey.currentState!.checkIsPayed();

        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        //debugPrint('inactive');
        break;
      case AppLifecycleState.paused:
        // widget is paused
        //debugPrint('paused');
        break;
      case AppLifecycleState.detached:
        // widget is detached
        //debugPrint('detached');
        break;
      default:
        break;
    }
  }

  checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    //debugPrint('app version:$version');

    String os = Platform.isIOS ? 'ios' : 'android';

    await Webservice().loadGet(Response.checkUpdate, context, parameter: '$version?os=$os').then((response) {
      //debugPrint('response:$response');
      if (response['uptodate'] == true) {
        application.showToast('Амжилттай шинэчлэгдлээ!');
        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(onboardRoute, (route) => false);
      } else {
        //debugPrint('Updated');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(color: theme.colorScheme.backgroundColor, image: const DecorationImage(image: AssetImage(Assets.updateBackground))),
      child: Column(
        children: [
          const Expanded(flex: 5, child: SizedBox()),
          Center(
            child: SvgPicture.asset(
              Assets.portalLogoWithBackgroundSvg,
              // width: ,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            getTranslated(context, 'update'),
            style: TextStyles.textFt20Bold.textColor(theme.colorScheme.whiteColor),
          ),
          const SizedBox(
            height: 14,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: Text(
              getTranslated(context, 'pleaseUpdateApp'),
              style: TextStyles.textFt16Reg.textHeight(1.6).textColor(theme.colorScheme.whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          CustomButton(
            text: getTranslated(context, 'doUpdate'),
            width: 306,
            onTap: () {
              if (Platform.isIOS) {
                // Replace 'your_app_id' with your app's ID on the App Store
                launchUrl(Uri.parse('https://apps.apple.com/mn/app/portal-mn/id6736892114'), mode: LaunchMode.externalApplication);
              } else {
                // Replace 'your_package_name' with your app's package name on the Play Store
                launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=portal.mn.ticket'), mode: LaunchMode.externalApplication);
              }
            },
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
