import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Map<String, dynamic>> data = [
    {
      'title': 'Монголын хамгийн анхны',
      'text': 'Энтертайнмент салбарын бүхий л тасалбараа нэг дороос',
    },
    {
      'title': 'Хамгийн хялбар',
      'text': 'Энтертайнмент салбарын бүхий л тасалбараа нэг дороос',
    },
    {
      'title': 'Бусдаас өөр',
      'text': 'Энтертайнмент салбарын бүхий л тасалбараа нэг дороос',
    }
  ];
  Widget _indicator(bool isActive) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.greyText : theme.colorScheme.greyText.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // border: Border.all(
        //   color: const Color(0xFF24ABF8),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
      width: ResponsiveFlutter.of(context).wp(100),
      height: ResponsiveFlutter.of(context).hp(100),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Assets.onboardBackground,
              ),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 120,
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                item(data[0], theme),
                item(data[1], theme),
                item(data[2], theme),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButton(
            width: 332,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.zero,
            text: '${getTranslated(context, 'login')}/${getTranslated(context, 'register')}',
            onTap: () async {
              await application.setUserType(0);

              NavKey.navKey.currentState!.pushNamed(onboardLogJoinedRoute);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          // CustomButton(
          //   textColor: theme.colorScheme.whiteColor,
          //   backgroundColor: theme.colorScheme.backgroundColor,
          //   width: 332,
          //   alignment: Alignment.bottomCenter,
          //   // margin: EdgeInsets.zero,
          //   text: getTranslated(context, 'skip'),
          //   onTap: () async {
          //     await application.setUserType(1);
          //     NavKey.navKey.currentState!.pushNamed(onboardHomeJoinedRoute);
          //   },
          // ),
        ],
      ),
    );
  }
}

Widget item(Map<String, dynamic> data, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        data['title'],
        style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
      ),
      const SizedBox(
        height: 12,
      ),
      Text(data['text'], style: TextStyles.textFt15Reg.textColor(theme.colorScheme.greyText), textAlign: TextAlign.center),
      const SizedBox(
        height: 16,
      )
    ],
  );
}
