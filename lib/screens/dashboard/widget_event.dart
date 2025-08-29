import 'package:flutter/material.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:zo_animated_border/widget/zo_track_border.dart';

import '../../helper/responsive_flutter.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<EventModel> list = Provider.of<ProviderCoreModel>(context, listen: true).getEventList();
    return  GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2, crossAxisSpacing: 20),
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _item(list[index], index);
          },
        );
  }

  String emoji(String tag) {
    switch (tag) {
      case 'Trending':
        return '⚡️';
      case 'Hot':
        return '🔥';
      case 'SalesEndSoon':
        return '☄️';
      case 'AlmostFull':
        return '😱';
      default:
        return '';
    }
  }

  Widget _item(EventModel item, int index) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return GestureDetector(
        onTap: () {
          NavKey.navKey.currentState!.pushNamed(eventRoute, arguments: {'id': item.id, 'from': 0});
        },
        child: Container(
            decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.hintColor, width: 0.5), borderRadius: BorderRadius.circular(8)),
            // color: Colors.pink,
            height: ResponsiveFlutter.of(context).hp(18),
            margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(4)),
            width: double.maxFinite,
            child: ZoMonoCromeBorder(
                trackBorderColor: (item.tags == null || item.tags!.isEmpty) ? Colors.grey : Colors.red,
                cornerRadius: 8.0,
                borderStyle: ZoMonoCromeBorderStyle.mirror,
                borderWidth: 2.5,
                child: Stack(
                  // alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          // child: Stack(
                          //   children: [
                          Image.network(
                        '${item.coverImage}',
                        width: double.maxFinite,
                        height: ResponsiveFlutter.of(context).hp(15),
                        fit: BoxFit.fill,
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: ImageFiltered(
                      //       imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      //       child: ShaderMask(
                      //         shaderCallback: (rect) {
                      //           return LinearGradient(
                      //               begin: Alignment.topCenter,
                      //               end: Alignment.bottomCenter,
                      //               colors: [Colors.black, Colors.white.withValues(alpha:0.1)],
                      //               stops: const [0.7, 0.75]).createShader(rect);
                      //         },
                      //         blendMode: BlendMode.dstOut,
                      //         child: Image.network('${item.coverImage}',
                      //             fit: BoxFit.cover, alignment: Alignment.bottomCenter),
                      //       )),
                      // )
                      // ],
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.only(top: 10),
                          height: 180,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.2),
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.9),
                                Colors.black.withValues(alpha: 0.99),
                                Colors.black.withValues(alpha: 0.99),
                                Colors.black,
                                Colors.black
                              ], stops: const [
                                0.5,
                                0.55,
                                0.6,
                                0.75,
                                0.8,
                                0.85,
                                0.9,
                                1.0
                              ]),
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.tags?.isNotEmpty ?? false)
                                SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                      itemCount: item.tags!.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                            margin: const EdgeInsets.only(left: 16, bottom: 2),
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                                            child: Row(
                                              children: [
                                                GradientText(
                                                  getTranslated(context, '${item.tags![index]}'),
                                                  style: TextStyles.textFt10Bold,
                                                ),
                                                Text(' ${emoji(item.tags![index])}', style: TextStyles.textFt10Bold)
                                              ],
                                            ));
                                      }),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  item.name?.toUpperCase() ?? '',
                                  style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15),
                              //   child: Row(children: [
                              //     Icon(
                              //       Icons.location_pin,
                              //       color: theme.colorScheme.fadedWhite,
                              //     ),
                              //     const SizedBox(
                              //       width: 4,
                              //     ),
                              //     Expanded(
                              //       child: Text(item.location!.name!.capitalize(),
                              //           overflow: TextOverflow.clip,
                              //           maxLines: 1,
                              //           style: TextStyles.textFt14Reg.textColor(theme.colorScheme.fadedWhite)),
                              //     )
                              //   ]),
                              // ),
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}
