import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

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
              child: InkWell(
            onTap: () {
              NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
            },
            child: Center(
              child: Text(
                getTranslated(context, 'event'),
                style: TextStyles.textFt16Bold.textColor(Colors.white),
              ),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () {
              NavKey.navKey.currentState?.pushNamedAndRemoveUntil(purchaseRoute, (route) => false);
            },
            child: Center(
              child: Text(
                'Борлуулалт',
                style: TextStyles.textFt16Bold.textColor(Colors.white),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
