import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
        bottomNavigationBar: const BottomNavigation(currentMenu: 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(Assets.emptyTicket),
            ),
            Text(
              getTranslated(context, 'soon'),
              style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
