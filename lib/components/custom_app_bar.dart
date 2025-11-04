import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/language/language.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/provider_xo.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';

PreferredSizeWidget customAppBar(BuildContext context,
    {String? title, Widget? tailing, Color? color, bool isStep = false, int step = 0, bool canBack = true, int totalStep = 3}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveFlutter.of(context).hp(6)), // here the desired height

    child: Container(
      color: color ?? theme.colorScheme.backgroundColor,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !canBack
              ? const SizedBox(
                  height: 40,
                  width: 40,
                )
              : InkWell(
                  onTap: () => NavKey.navKey.currentState!.pop(),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.whiteColor,
                    ),
                  ),
                ),
          Expanded(
              child: !isStep
                  ? Center(
                      child: Text(
                        title ?? '',
                        style: TextStyles.textFt20.textColor(Colors.white),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        height: 4,
                        child: ListView.builder(
                            itemCount: totalStep,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: step - 1 == index ? theme.colorScheme.whiteColor : theme.colorScheme.colorGrey,
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                width: 40,
                                height: 4,
                              );
                            }),
                      ),
                    )),
          tailing ??
              const SizedBox(
                width: 40,
              )
        ],
      ),
    ),
  );
}

PreferredSize emptyAppBar({
  required BuildContext context,
  Brightness brightness = Brightness.dark,
  Color backgroundColor = Colors.black,
  double elevation = 0.0,
}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveFlutter.of(context).hp(6)), // here the desired height
    child: Container(
      color: theme.colorScheme.blackColor,
    ),
  );
}

PreferredSize tittledAppBar({
  required BuildContext context,
  String tittle = '',
  Brightness brightness = Brightness.dark,
  Color backgroundColor = Colors.black,
  double elevation = 0.0,
  bool backShow = false,
}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveFlutter.of(context).hp(8)), // here the desired height
    child: Container(
        color: theme.colorScheme.profileAppBar,
        child: SafeArea(
            child: Container(
          color: theme.colorScheme.profileAppBar,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Row(
            children: [
              Visibility(
                visible: backShow,
                child: InkWell(
                  onTap: () {
                    NavKey.navKey.currentState!.canPop()
                        ? NavKey.navKey.currentState!.pop()
                        : NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
                  },
                  child: SvgPicture.asset(
                    Assets.backButton,
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Center(
                child: Text(
                  tittle == '' ? '' : getTranslated(context, tittle),
                  style: TextStyles.textFt18Bold.textColor(Colors.white),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              const SizedBox(
                width: 40,
              )
            ],
          ),
        ))),
  );
}

PreferredSize walletAppBar({
  required BuildContext context,
  Brightness brightness = Brightness.dark,
  Color backgroundColor = Colors.black,
  double elevation = 0.0,
}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveFlutter.of(context).hp(8)), // here the desired height
    child: Container(
        color: theme.colorScheme.profileAppBar,
        child: SafeArea(
            child: Container(
          color: theme.colorScheme.profileAppBar,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  NavKey.navKey.currentState!.pop();
                },
                child: Container(
                  width: 35,
                  height: 35,
                  child: SvgPicture.asset(Assets.backButton),
                ),
              ),
              Text(
                getTranslated(context, 'wallet'),
                style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
              ),
              InkWell(
                onTap: () {
                  NavKey.navKey.currentState!.pushNamed(walletAddRoute);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(color: theme.colorScheme.greyText, borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ))),
  );
}

PreferredSize homeAppBar({
  required BuildContext context,
}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
  bool isEnglish = Provider.of<ProviderCoreModel>(context, listen: true).isEnglish;

  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveFlutter.of(context).hp(5.5)), // here the desired height
    child: Container(
      color: theme.colorScheme.blackColor,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 55, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(Assets.portalAppBar),
          Expanded(
            child: SizedBox(),
          ),
          Text(getTranslated(context, 'en'),
              style: TextStyles.textFt15Bold.textColor(isEnglish ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite)),
          const SizedBox(
            width: 8,
          ),
          Switch(
            value: !isEnglish,
            activeColor: theme.colorScheme.fadedWhite,
            onChanged: (bool value) {
              if (value) {
                Provider.of<ProviderCoreModel>(context, listen: false).changeLanguage(Language(2, "mn", "Mongolia", "mn"), context);
              } else {
                Provider.of<ProviderCoreModel>(context, listen: false).changeLanguage(Language(1, "us", "English", "en"), context);
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Text(getTranslated(context, 'mn'),
              style: TextStyles.textFt15Bold.textColor(!isEnglish ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite))
        ],
      ),
    ),
  );
}
