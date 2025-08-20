import 'package:flutter/material.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/CartMenuBar.dart';
import 'package:portal/screens/cart/bar/BarScreen.dart';
import 'package:portal/screens/cart/coming_soon.dart';
import 'package:portal/screens/cart/merch/my_merch_screen.dart';
import 'package:portal/screens/cart/ticket/TicketsScreen.dart';
import 'package:provider/provider.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final PageController _pageController = PageController();

  final List<Widget> tabs = [
    const TicketsScreen(),
    const BarScreen(),
    const MyMerch(),
    const ComingSoon(
      index: 2,
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: tittledAppBar(context: context, tittle: 'myCart', backShow: true),
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.blackColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: ResponsiveFlutter.of(context).hp(4),
            ),
            CartMenuBar(
              onItemSelected: (index) {
                _pageController.jumpToPage(index);
              },
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {},
                children: tabs,
              ),
            ),
          ])),
    );
  }
}
