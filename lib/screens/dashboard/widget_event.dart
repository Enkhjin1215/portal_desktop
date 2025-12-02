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
    return GridView.builder(
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
          // NavKey.navKey.currentState!.pushNamed(testPrintRoute, arguments: {
          //   "name": cyrtranslit.cyr2Lat('Comeback is Real', langCode: "mn"),
          //   // "seats": allSeats,
          //   "seats": ["F1-SA2-R7-s4", "F1-SC1-R8-s6"],
          //   "date": Func.toDateStr(DateTime.now().toString())
          // });
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
                child: Container(
                    height: 330,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(item.coverImage!), fit: BoxFit.fill)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                    child: Center(
                                      child: Text(
                                        DateTime.parse(item.startDate ?? DateTime.now().toString()).month.toString() +
                                            getTranslated(context, 'month'),
                                        style: TextStyles.textFt14Reg.textColor(Colors.white),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      DateTime.parse(item.startDate ?? DateTime.now().toString()).day.toString(),
                                      style: TextStyles.textFt18Bold,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.only(top: 10),
                          // height: 100,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.01),
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
                              Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(
                                      child: Text(
                                    item.name?.toUpperCase() ?? '',
                                    style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                  )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveFlutter.of(context).wp(2), vertical: ResponsiveFlutter.of(context).hp(0.5)),
                                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.orange.withValues(alpha: 0.05), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))
                                      ], borderRadius: BorderRadius.circular(12), color: theme.colorScheme.whiteColor.withValues(alpha: 0.2)),
                                      child: GradientText(getTranslated(context, 'buy'), style: TextStyles.textFt18Reg)),
                                  const SizedBox(width: 20),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ))
                      ],
                    )))));
  }
}
