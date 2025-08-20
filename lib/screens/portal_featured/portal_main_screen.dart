import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/counter_event.dart';
import 'package:portal/provider/provider_xo.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:zo_animated_border/widget/zo_breathing_border.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

class PortalMainScreen extends StatefulWidget {
  const PortalMainScreen({super.key});

  @override
  State<PortalMainScreen> createState() => _PortalMainScreenState();
}

class _PortalMainScreenState extends State<PortalMainScreen> {
  bool isLoading = true;
  List<CounterEvent> list = [];
  int userType = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    userType = await application.getUserType();

    await Webservice().loadGet(CounterEvent.getTournaments, context, parameter: '').then((response) {
      Provider.of<ProviderXO>(context, listen: false).setXOList(response);
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    list = Provider.of<ProviderXO>(context, listen: true).getXOList();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      body: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(120),
          color: theme.colorScheme.backgroundBlack,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                  color: theme.colorScheme.backgroundBlack,
                  width: ResponsiveFlutter.of(context).wp(100),
                  height: ResponsiveFlutter.of(context).hp(120),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      GradientText(
                        'PORTAL SPECIALS',
                        style: TextStyles.textFt22Bold,
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Зөвхөн portal дээр гаргаж буй тоглолт эвент болон урамшуулалт хөтөлбөрүүд',
                        style: TextStyles.textFt14Reg.textColor(Colors.grey),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2), // Border width
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
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black, // Your content background
                              borderRadius: BorderRadius.circular(14), // Slightly smaller radius
                            ),
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(Assets.magic),
                                  ),
                                  GradientText(
                                    'Roll & Poll',
                                    style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                ],
                              ),
                            )),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return ZoAnimatedGradientBorder(
                                glowOpacity: 0.1,
                                borderRadius: 16,
                                gradientColor: const [
                                  Color(0xFF6BE3D7),
                                  Colors.yellow,
                                  Colors.amber,
                                ],
                                duration: const Duration(seconds: 4),
                                child: InkWell(
                                    onTap: () {
                                      if (userType < 2) {
                                        ModalAlert().login(
                                          context: context,
                                          theme: theme,
                                        );
                                      } else if (list[index].id != null || list[index].id != '') {
                                        NavKey.navKey.currentState!.pushNamed(csgoRoute, arguments: {'id': list[index].id});
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                                      width: ResponsiveFlutter.of(context).wp(100),
                                      height: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage(list[index].image ?? ''), fit: BoxFit.cover),
                                          border: Border.all(color: Colors.white, width: 0.3),
                                          borderRadius: BorderRadius.circular(16)),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.black.withValues(alpha: 0.6),
                                                Colors.black.withValues(alpha: 0.7),
                                                Colors.black.withValues(alpha: 0.9),
                                                Colors.black.withValues(alpha: 1),
                                              ],
                                              stops: [0, 0.2, 0.5, 0.7, 0.9, 1],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                list[index].name ?? '',
                                                style: TextStyles.textFt18Reg.textColor(Colors.white),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'endDate'),
                                                    style: TextStyles.textFt14Reg.textColor(Colors.white),
                                                  ),
                                                  Text(
                                                    Func.toDateStr(list[index].endDate ?? ''),
                                                    style: TextStyles.textFt14Reg.textColor(Colors.white),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              )
                                            ],
                                          )),
                                    )));
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      ZoAnimatedGradientBorder(
                          glowOpacity: 0.1,
                          borderRadius: 16,
                          gradientColor: const [
                            Color(0xFF6BE3D7),
                            Colors.pinkAccent,
                            Colors.purple,
                          ],
                          duration: const Duration(seconds: 4),
                          child: InkWell(
                              onTap: () {
                                // NavKey.navKey.currentState!.pushNamed(steamMainRoute);
                                application.showToast(getTranslated(context, 'soon'));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                width: ResponsiveFlutter.of(context).wp(100),
                                height: 200,
                                decoration: BoxDecoration(
                                    image:
                                        const DecorationImage(image: NetworkImage('https://cdn.portal.mn/uploads/steam-5x2.jpg'), fit: BoxFit.cover),
                                    border: Border.all(color: Colors.white, width: 0.3),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Steam цэнэглэлт',
                                      style: TextStyles.textFt18Reg.textColor(Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated(context, 'soon'),
                                          style: TextStyles.textFt14Reg.textColor(Colors.white),
                                        ),
                                        Text(
                                          '',
                                          style: TextStyles.textFt14Reg.textColor(Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )))

                      // InkWell(
                      //     onTap: () {
                      //       NavKey.navKey.currentState!.pushNamed(csgoRoute);
                      //       // application.showToast(getTranslated(context, 'soon'));
                      //     },
                      //     child: Container(
                      //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      //       child: ZoDualBorder(
                      //           duration: const Duration(seconds: 3),
                      //           glowOpacity: 0.4,
                      //           firstBorderColor: Colors.white,
                      //           secondBorderColor: Colors.orange,
                      //           trackBorderColor: Colors.transparent,
                      //           borderWidth: 2,
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
                      // const SizedBox(
                      //   height: 18,
                      // ),

                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     NavKey.navKey.currentState!.pushNamed(portalRoute);
                      //   },
                      //   child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 16),
                      //       child: ZoMonoCromeBorder(
                      //           trackBorderColor: Colors.purple,
                      //           cornerRadius: 16.0,
                      //           borderStyle: ZoMonoCromeBorderStyle.repeated,
                      //           borderWidth: 3.5,
                      //           child: SizedBox(
                      //             height: 200,
                      //             width: double.maxFinite,
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(16),
                      //               child: Image.asset(
                      //                 Assets.comingSoonCard,
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //           ))),
                      // ),
                      // const Expanded(
                      //   child: SizedBox(),
                      // ),
                    ],
                  ),
                ))),
      bottomNavigationBar: const BottomNavigation(currentMenu: 4),
    );
  }
}
