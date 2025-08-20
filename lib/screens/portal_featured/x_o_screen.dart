import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/portal_featured/cs_go_loot_screen.dart';
import 'package:portal/screens/portal_featured/poll_screen.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class XOScreen extends StatefulWidget {
  const XOScreen({Key? key}) : super(key: key);

  @override
  State<XOScreen> createState() => _XOScreenState();
}

class _XOScreenState extends State<XOScreen> with SingleTickerProviderStateMixin {
  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    print('current index: ${_currentIndex}');
    return SafeArea(
        child: Container(
      color: theme.colorScheme.backgroundColor,
      width: ResponsiveFlutter.of(context).wp(100),
      height: ResponsiveFlutter.of(context).hp(110),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    NavKey.navKey.currentState!.pop();
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
              Column(
                children: [
                  Text(
                    'X',
                    style: TextStyles.textFt22Bold.textColor(_currentIndex == 0 ? Colors.white : Colors.grey),
                  ),
                  if (_currentIndex == 0)
                    Container(
                        width: 18,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2AD0CA),
                                Color(0xFFE1F664),
                                Color(0xFFEFB0FE),
                                Color(0xFFABB3FC),
                                Color(0xFF5DF7A4),
                                Color(0xFF58C4F6),
                              ],
                              stops: [0, 0.2, 0.5, 0.7, 0.9, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )))
                ],
              ),
              Text(
                ' | ',
                style: TextStyles.textFt22Bold.textColor(Colors.grey),
              ),
              Column(
                children: [
                  Text(
                    'O',
                    style: TextStyles.textFt24Bold.textColor(_currentIndex == 1 ? Colors.white : Colors.grey),
                  ),
                  if (_currentIndex == 1)
                    Container(
                        width: 18,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2AD0CA),
                                Color(0xFFE1F664),
                                Color(0xFFEFB0FE),
                                Color(0xFFABB3FC),
                                Color(0xFF5DF7A4),
                                Color(0xFF58C4F6),
                              ],
                              stops: [0, 0.2, 0.5, 0.7, 0.9, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )))
                ],
              ),
              const Expanded(
                child: SizedBox(),
              ),
              const SizedBox(
                width: 55,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
              children: const [CSGOLootScreen(), PollScreen()],
            ),
          )
        ],
      ),
    ));
  }
}
