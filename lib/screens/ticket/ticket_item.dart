import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class TicketItem extends StatefulWidget {
  final Ticket ticket;
  final int index;
  final Function(bool, int) onPress;
  final bool? chooseSeat;
  final int min;
  final int max;
  final EventDetail detail;
  final Function tapSeat;

  const TicketItem({
    super.key,
    required this.ticket,
    required this.detail,
    required this.index,
    required this.onPress,
    this.chooseSeat = false,
    required this.tapSeat,
    this.min = 0,
    this.max = 0,
  });

  @override
  State<TicketItem> createState() => _TicketItemState();
}

class _TicketItemState extends State<TicketItem> with TickerProviderStateMixin {
  int count = 0;
  late Timer _timer;
  late DateTime startDate;
  late DateTime endDate;
  late bool isAfter;
  DateTime now = DateTime.now();
  late AnimationController _shakeAnimationController;
  late Animation<double> _doubleAnim;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    startDate = DateTime.parse(widget.ticket.startDate!).toLocal();
    endDate = DateTime.parse(widget.ticket.endDate!).toLocal();
    isAfter = now.isAfter(startDate);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _doubleAnim = Tween(begin: 0.0, end: 10.0).animate(_shakeAnimationController);

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _shakeAnimationController.dispose();

    super.dispose();
  }

  void shake(String message) {
    application.showToastAlert(getTranslated(context, message));
    _shakeAnimationController.forward(from: 50).then((value) {
      _shakeAnimationController.reverse();
    });
  }

  String calculateDiscount(var actualPrice, var sellPrice) {
    num aPrice = num.parse(actualPrice.toString());
    num sPrice = num.parse(sellPrice.toString());
    String result = '';

    result = ((1 - sPrice / aPrice) * 100).toStringAsFixed(2);
    result = '$result% OFF';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    bool isOver = now.isAfter(endDate);
    // print('endDate:${endDate}');

    return AnimatedBuilder(
        animation: _doubleAnim,
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(_doubleAnim.value, 0),
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.2)),
                child: widget.chooseSeat!
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, 'withSeat'),
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${Func.toMoneyStr(widget.min)} - ${Func.toMoneyStr(widget.max)}',
                            style: TextStyles.textFt18Bold.textColor(theme.colorScheme.neutral200),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Divider(
                            color: theme.colorScheme.fadedWhite,
                            thickness: 0.5,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 56,
                            width: double.maxFinite,
                            child: TabBarView(
                              controller: _tabController,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                ticketBody(context, theme, isOver, isAfter, endDate, startDate, widget.ticket, isSeat: true),
                                SizedBox(
                                  height: 56,
                                  width: double.maxFinite,
                                  child: Text(
                                    widget.ticket.desc ?? '',
                                    style: TextStyles.textFt18Reg.textColor(theme.colorScheme.whiteColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomButton(
                            margin: EdgeInsets.zero,
                            bRadius: BorderRadius.circular(14),
                            width: double.maxFinite,
                            text: getTranslated(context, 'chooseSeat'),
                            textColor: Colors.white,
                            backgroundColor: Colors.white.withValues(alpha: 0.08),
                            onTap: () {
                              if (isOver) {
                                shake('closed');
                              } else {
                                print('click2');
                                widget.tapSeat();
                              }
                            },
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.ticket.name!,
                                    style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  if (widget.ticket.actualPrice != null)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            Func.toMoneyComma(widget.ticket.actualPrice!.amt!),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              decorationThickness: 1.4,
                                              decorationColor: Colors.white,
                                              fontSize: 16,
                                              color: theme.colorScheme.whiteColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.discountColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            calculateDiscount(widget.ticket.actualPrice?.amt ?? 0, widget.ticket.sellPrice?.amt ?? 0),
                                            style: TextStyles.textFt14Bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  Text(
                                    Func.toMoneyComma(widget.ticket.sellPrice!.amt!),
                                    style: TextStyles.textFt20Bold.textColor(
                                        widget.ticket.actualPrice != null ? theme.colorScheme.discountColor : theme.colorScheme.whiteColor),
                                  )
                                ],
                              )),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
                                    border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.5),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (widget.ticket.avl! <= 0) {
                                          shake('soldOut');
                                        } else if (isOver) {
                                          shake('closed');
                                        } else if (count > 0) {
                                          count--;
                                          widget.onPress(false, count);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: theme.colorScheme.whiteColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(60)),
                                        child: SvgPicture.asset(Assets.minus),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      '$count',
                                      style: TextStyles.textFt18Med.textColor(theme.colorScheme.whiteColor),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (widget.ticket.avl! <= 0) {
                                          shake('soldOut');
                                        } else if (isOver) {
                                          shake('closed');
                                        } else if (count >= 10) {
                                          shake('maxQnt');
                                        } else {
                                          count++;
                                          widget.onPress(true, count);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: theme.colorScheme.whiteColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(60)),
                                        child: SvgPicture.asset(Assets.add),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Divider(
                            color: theme.colorScheme.fadedWhite,
                            thickness: 0.5,
                          ),
                          SizedBox(
                            height: 56,
                            width: double.maxFinite,
                            child: TabBarView(
                              controller: _tabController,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                ticketBody(context, theme, isOver, isAfter, endDate, startDate, widget.ticket),
                                SizedBox(
                                  height: 56,
                                  width: double.maxFinite,
                                  child: Text(
                                    widget.ticket.desc ?? '',
                                    style: TextStyles.textFt18Reg.textColor(theme.colorScheme.whiteColor),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
              ));
        });
  }
}

Widget ticketBody(BuildContext context, ThemeData theme, bool isOver, bool isAfter, DateTime endDate, DateTime startDate, Ticket ticket,
    {bool isSeat = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(
        height: 12,
      ),
      Row(
        children: [
          Text(
            getTranslated(context, 'left'),
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          SvgPicture.asset(Assets.miniTicket),
          const SizedBox(
            width: 8,
          ),
          RichText(
            text: TextSpan(text: '${ticket.avl}', style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor), children: <TextSpan>[]),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isOver
                ? 'Хаагдсан огноо'
                : isAfter
                    ? getTranslated(context, 'tillClose')
                    : getTranslated(context, 'tillOpen'),
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
          ),
          Text(
            isOver ? '${endDate.year}.${endDate.month}.${endDate.day}' : timer(endDate, startDate, isAfter, isOver, context),
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
          ),
        ],
      )
    ],
  );
}

String timer(DateTime endDate, DateTime startDate, bool after, bool isOver, BuildContext context) {
  DateTime now = DateTime.now();
  Duration difference = after ? endDate.difference(now) : now.difference(startDate);
  int days = difference.inDays; // Difference in days
  int hours = difference.inHours % 24; // Difference in hours (excluding days)
  int minutes = difference.inMinutes % 60; // Difference in minutes (excluding hours)
  int seconds = difference.inSeconds % 60; // Difference in seconds (excluding minutes)

  if (isOver) {
    return '0 ${getTranslated(context, 'day')} 0 ${getTranslated(context, 'hour')} 00:00';
  } else {
    return '$days ${getTranslated(context, 'day')} $hours ${getTranslated(context, 'hour')} $minutes:$seconds';
  }
}
