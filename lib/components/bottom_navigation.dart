import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_sheet.dart';
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
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomNavigation extends StatefulWidget {
  final int currentMenu;

  const BottomNavigation({Key? key, required this.currentMenu}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with TickerProviderStateMixin {
  var isDialOpen = ValueNotifier<bool>(false);

  int userType = -1;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    userType = await application.getUserType();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      height: ResponsiveFlutter.of(context).hp(5),
      padding: EdgeInsets.only(top: 12, bottom: stdCutoutWidthDown * 1.2),
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.colorScheme.fadedWhite, width: 0.3)),
          color: theme.colorScheme.softBlack.withValues(alpha: 0.7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: _bottomNavItem(0, Assets.home1Active, Assets.home1InActive, theme, (() async {
              if (widget.currentMenu != 0) {
                NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
              }

              setState(() {});
            }), getTranslated(context, 'event')),
          ),
          Expanded(
            child: _bottomNavItem(1, Assets.home2Active, Assets.home2InActive, theme, (() async {
              if (widget.currentMenu != 1) {
                NavKey.navKey.currentState?.pushNamedAndRemoveUntil(marketRoute, (route) => false);
              }
            }), getTranslated(context, 'market')),
          ),

          GestureDetector(
              onTap: () {
                if (widget.currentMenu != 4) {
                  NavKey.navKey.currentState!.pushNamedAndRemoveUntil(portalMainRoute, (route) => false);
                }
              },
              child: Container(
                  height: ResponsiveFlutter.of(context).hp(7),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(2), // Border width

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2AD0CA),
                        Color(0xFFE1F664),
                        Color(0xFFEFB0FE),
                        Color(0xFFABB3FC),
                        Color(0xFF5DF7A4),
                        Color(0xFF58C4F6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF333333), border: Border.all(color: Colors.white, width: 0.2)),
                    child: SvgPicture.asset(widget.currentMenu == 4 ? Assets.homeActive : Assets.homeInactive),
                  ))),

          Expanded(
            child: _bottomNavItem(2, Assets.home3Active, Assets.home3InActive, theme, (() async {
              if (widget.currentMenu != 2) {
                NavKey.navKey.currentState!.pushNamedAndRemoveUntil(merchMainRoute, (route) => false);
              }
            }), getTranslated(context, 'merch')),
          ),
          // Expanded(
          //     child: userType < 2
          //         ? _bottomNavItem(3, Assets.profileActive, theme, (() async {
          //             if (widget.currentMenu != 3) {
          //               if (userType < 2) {
          //                 ModalAlert().login(
          //                   context: context,
          //                   theme: theme,
          //                 );
          //               } else {
          //                 NavKey.navKey.currentState!.pushNamedAndRemoveUntil(profileRoute, (route) => false);
          //               }
          //             }
          //           }), Assets.profile, getTranslated(context, 'profile'))
          //         : Container(
          //             margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).hp(0.5)),
          //             child: SpeedDial(
          //               animationDuration: Duration(milliseconds: 500),
          //               icon: Icons.account_circle_sharp,
          //               activeIcon: Icons.account_circle_rounded,
          //               iconTheme: IconThemeData(color: theme.colorScheme.greyText, size: 40),

          //               spacing: 3,
          //               mini: false,
          //               openCloseDial: isDialOpen,
          //               childPadding: const EdgeInsets.all(4),
          //               spaceBetweenChildren: 4,

          //               buttonSize: const Size(56, 40), // it's the SpeedDial size which defaults to 56 itself
          //               // iconTheme: IconThemeData(size: 22),
          //               childrenButtonSize: const Size(56, 56),
          //               visible: true,
          //               direction: SpeedDialDirection.up,
          //               switchLabelPosition: false,

          //               closeManually: false,

          //               /// If false, backgroundOverlay will not be rendered.
          //               renderOverlay: true,
          //               overlayColor: Colors.black,
          //               overlayOpacity: 0,
          //               onOpen: () => debugPrint('OPENING DIAL'),
          //               onClose: () => debugPrint('DIAL CLOSED'),
          //               useRotationAnimation: true,
          //               tooltip: 'Quick Action',
          //               heroTag: 'speed-dial-hero-tag',
          //               // foregroundColor: Colors.black,
          //               backgroundColor: theme.colorScheme.softBlack.withValues(alpha:0.7),
          //               // activeForegroundColor: Colors.red,
          //               // activeBackgroundColor: Colors.blue,
          //               elevation: 0.0,
          //               animationCurve: Curves.elasticInOut,
          //               isOpenOnStart: false,
          //               shape: const StadiumBorder(),
          //               // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //               children: [
          //                 SpeedDialChild(
          //                   child: const Icon(Icons.logout_outlined),
          //                   backgroundColor: theme.colorScheme.hintGrey,
          //                   foregroundColor: Colors.red,
          //                   label: getTranslated(context, 'logout'),
          //                   onTap: () async {
          //                     await Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
          //                     NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
          //                   },
          //                   onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          //                 ),
          //                 SpeedDialChild(
          //                   child: const Icon(Icons.wallet_rounded),
          //                   backgroundColor: theme.colorScheme.hintGrey,
          //                   foregroundColor: Colors.black,
          //                   label: getTranslated(context, 'wallet'),
          //                   onTap: () {
          //                     NavKey.navKey.currentState!.pushNamed(walletRoute);
          //                   },
          //                 ),
          //                 SpeedDialChild(
          //                   // labelBackgroundColor: theme.colorScheme.fadedWhite.withValues(alpha:0.001),
          //                   // labelStyle: TextStyles.textFt12.textColor(theme.colorScheme.whiteColor),
          //                   child: const Icon(Icons.language_rounded),
          //                   backgroundColor: theme.colorScheme.hintGrey,
          //                   foregroundColor: Colors.black,
          //                   label: getTranslated(context, 'language'),
          //                   visible: true,
          //                   onTap: () {
          //                     Provider.of<ProviderCoreModel>(context, listen: false).isEnglish
          //                         ? Provider.of<ProviderCoreModel>(context, listen: false)
          //                             .changeLanguage(Language(2, "mn", "Mongolia", "mn"), context)
          //                         : Provider.of<ProviderCoreModel>(context, listen: false)
          //                             .changeLanguage(Language(1, "us", "English", "en"), context);
          //                   },
          //                   onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
          //                 ),
          //               ],
          //             ))
          Expanded(
            child: _bottomNavItem(3, Assets.home4Active, Assets.home4InActive, theme, (() async {
              if (widget.currentMenu != 3) {
                if (userType < 2) {
                  ModalAlert().login(
                    context: context,
                    theme: theme,
                  );
                } else {
                  NavKey.navKey.currentState!.pushNamedAndRemoveUntil(profileRoute, (route) => false);
                }
              }
            }), getTranslated(context, 'profile')),
          ),
        ],
      ),
    );
  }

  _bottomNavItem(
    int index,
    String activeAsset,
    String inactiveAsset,
    ThemeData? theme,
    Function()? onTap,
    String text,
  ) {
    return ZoomTapAnimation(
      end: 0.8,
      onTap: onTap!,
      beginDuration: const Duration(milliseconds: 50),
      endDuration: const Duration(milliseconds: 150),
      child: SizedBox(
        // margin: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(2), vertical: ResponsiveFlutter.of(context).hp(0)),
        // width: ResponsiveFlutter.of(context).wp(10),
        height: ResponsiveFlutter.of(context).hp(7),
        child: Column(
          children: [
            Expanded(
                child: SvgPicture.asset(
              widget.currentMenu == index ? activeAsset : inactiveAsset,
            )),
            Text(text,
                style:
                    TextStyles.textFt12Bold.textColor(widget.currentMenu == index ? theme!.colorScheme.whiteColor : Colors.white.withOpacity(0.5))),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
