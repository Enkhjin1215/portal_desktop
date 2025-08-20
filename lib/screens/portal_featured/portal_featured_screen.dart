import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/screens/portal_featured/list_data.dart';
import 'package:portal/screens/portal_featured/list_item.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PortalFeaturedScreen extends StatefulWidget {
  const PortalFeaturedScreen({super.key});

  @override
  State<PortalFeaturedScreen> createState() => _PortalFeaturedScreenState();
}

class _PortalFeaturedScreenState extends State<PortalFeaturedScreen> {
  List<Event> list = [];
  EventList data = EventList();
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    list = data.getList();

    // Add listener to detect scroll changes
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Calculate which item is most visible
    if (_scrollController.hasClients && list.isNotEmpty) {
      final itemWidth = ResponsiveFlutter.of(context).wp(75) + ResponsiveFlutter.of(context).wp(4); // Width + margin
      final index = (_scrollController.offset / itemWidth).round();
      if (index != _currentIndex && index >= 0 && index < list.length) {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      body: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(120),
          color: theme.colorScheme.backgroundBlack,
          child: SingleChildScrollView(
              child: Container(
            color: theme.colorScheme.backgroundBlack,
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(120),
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Center(
                      child: GradientText(
                        'PORTAL SPECIALS',
                        style: TextStyles.textFt22Bold,
                      ),
                    ),
                    const SizedBox(
                      width: 55,
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: theme.colorScheme.whiteColor.withValues(alpha: 0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          GradientText('2025', style: TextStyles.textFt16Bold),
                          Container(
                            height: 2,
                            width: 40,
                            decoration: BoxDecoration(
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
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )
                        ],
                      ),
                      Text(
                        '2026',
                        style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                      Text(
                        '2027',
                        style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                      Text(
                        '2028',
                        style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      getTranslated(context, 'soon'),
                      style: TextStyles.textFt18Bold.textColor(theme.colorScheme.neutral200),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 400,
                      child: Stack(
                        children: [
                          Center(
                              child: SizedBox(
                            height: ResponsiveFlutter.of(context).hp(40),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(Assets.comingSoonCard),
                            ),
                          )),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: BlurryContainer(
                                  borderRadius: BorderRadius.circular(0),
                                  height: 100,
                                  width: double.maxFinite,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Ulaanbaatar, Mongolia',
                                        style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                                      ),
                                    ],
                                  )))
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 18,
                ),
                // InkWell(
                //     onTap: () {
                //       NavKey.navKey.currentState!.pushNamed(csgoRoute);
                //       // application.showToast(getTranslated(context, 'soon'));
                //     },
                //     child: Container(
                //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //       child: ZoDualBorder(
                //           duration: Duration(seconds: 3),
                //           glowOpacity: 0.4,
                //           firstBorderColor: Colors.white,
                //           secondBorderColor: Colors.orange,
                //           trackBorderColor: Colors.transparent,
                //           borderWidth: 4,
                //           borderRadius: BorderRadius.circular(12),
                //           child: ClipRRect(
                //               borderRadius: BorderRadius.circular(12),
                //               child: CachedNetworkImage(
                //                   imageUrl: 'https://cdn.akamai.steamstatic.com/apps/csgo/images/csgo_react/social/cs2.jpg',
                //                   height: 200,
                //                   width: double.maxFinite,
                //                   fit: BoxFit.fill,
                //                   errorWidget: (context, url, error) => const SizedBox.shrink()))),
                //     )),
                Text(
                  'Хамтран ажилласан эвентvvд\nHIGHTLIGHT хэсэг',
                  style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  flex: 7,
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: list.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return PortalListItem(event: list[index]);
                      }),
                ),
                const SizedBox(height: 16),
                list.isEmpty
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: list.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              // Animate to the selected item when indicator is tapped
                              final itemWidth = ResponsiveFlutter.of(context).wp(75) + ResponsiveFlutter.of(context).wp(4);
                              _scrollController.animateTo(
                                entry.key * itemWidth,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                _currentIndex = entry.key;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentIndex == entry.key ? 12 : 8, // Slightly larger for active dot
                              height: _currentIndex == entry.key ? 12 : 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == entry.key ? theme.colorScheme.whiteColor : theme.colorScheme.whiteColor.withOpacity(0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ))),
    );
  }
}
