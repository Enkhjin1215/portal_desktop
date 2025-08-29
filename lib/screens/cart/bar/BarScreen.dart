import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/DottedLinePainter.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/order_model.dart';
import 'package:portal/models/ticket_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/order_list_requests.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

import 'EventItem.dart';

class BarScreen extends StatefulWidget {
  const BarScreen({super.key});

  @override
  State<BarScreen> createState() => _BarScreenState();
}

class _BarScreenState extends State<BarScreen> {
  OrderListRequests ticketListRequests = OrderListRequests();
  List<BarItems> barItems = [];
  List<EventMetas> eventList = [];
  List<EventMetas> mActiveEventList = [];
  List<EventMetas> mInActiveEventList = [];
  @override
  void initState() {
    ticketListRequests.getOrderList(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    eventList = Provider.of<ProviderCoreModel>(context, listen: true).getEventMetaList() ?? [];
    mActiveEventList = Provider.of<ProviderCoreModel>(context, listen: true).getActiveEventList() ?? [];
    mInActiveEventList = Provider.of<ProviderCoreModel>(context, listen: true).getInActiveEventList() ?? [];
    barItems = Provider.of<ProviderCoreModel>(context, listen: true).getOrderItems() ?? [];
    print('eventList:${eventList.length}');
    return barItems.isEmpty || eventList.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 2,
                child: ContainerTransparent(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: SvgPicture.asset(Assets.emptyTicket),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        getTranslated(context, 'noTickets'),
                        style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                )),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          )
        : SingleChildScrollView(
              child: Stack(
                children: [
                  if (mActiveEventList.isNotEmpty == true)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                                height: 10,
                                width: 10,
                                decoration:
                                    BoxDecoration(color: theme.colorScheme.backColor, borderRadius: const BorderRadius.all(Radius.circular(20)))),
                            const SizedBox(width: 10),
                            Text(
                              getTranslated(context, 'active'),
                              style: TextStyles.textFt20Bold.textColor(Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: mActiveEventList.length,
                            itemBuilder: (context, index) {
                              return _item(mActiveEventList[index], barItems);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                                height: 10,
                                width: 10,
                                decoration:
                                    BoxDecoration(color: theme.colorScheme.backColor, borderRadius: const BorderRadius.all(Radius.circular(20)))),
                            const SizedBox(width: 10),
                            Text(
                              getTranslated(context, 'inActive'),
                              style: TextStyles.textFt20Bold.textColor(Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: mInActiveEventList.length,
                            itemBuilder: (context, index) {
                              return _item(mInActiveEventList[index], barItems);
                            },
                          ),
                        ),
                      ],
                    ),
                  if (mActiveEventList.isNotEmpty == true)
                    Positioned.fill(
                      top: 40,
                      left: 5,
                      right: 1000000,
                      child: CustomPaint(
                        painter: DashedLinePainter(
                          color: theme.colorScheme.backColor,
                        ),
                      ),
                    ),
                ],
              ),
            
          );
  }

  Widget _item(EventMetas? eventMeta, List<BarItems>? baritems) {
    String mTitle = "";
    String mStartDate = "";
    String cover = "";
    if (eventMeta != null) {
      mTitle = eventMeta.name ?? "";
      String formattedDate = convertDate(eventMeta.startDate ?? "");
      mStartDate = formattedDate;
      cover = eventMeta.coverImage ?? "";
    }
    List<BarItems>? items = [];
    if (baritems?.isNotEmpty == true) {
      for (var ii in baritems!) {
        if (ii.eventId == eventMeta?.sId) {
          items.add(ii);
        }
      }
    }
    return EventItem(
      imageUrl: cover,
      badgeText: "",
      title: mTitle,
      date: mStartDate,
      baritems: items,
    );
  }
}

String convertDate(String dateString) {
  if (dateString == "") return "";
  DateTime date = DateTime.parse(dateString);
  List<String> dayNames = ['Ням', 'Даваа', 'Мягмар', 'Лхагва', 'Пүрэв', 'Баасан', 'Бямба'];
  List<String> monthNames = [
    '1-р сар',
    '2-р сар',
    '3-р сар',
    '4-р сар',
    '5-р сар',
    '6-р сар',
    '7-р сар',
    '8-р сар',
    '9-р сар',
    '10-р сар',
    '11-р сар',
    '12-р сар'
  ];
  String dayName = dayNames[date.weekday % 7];
  String monthName = monthNames[date.month - 1];
  int day = date.day;
  return '$monthName $day $dayName';
}
