import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/ticket/ticket_item.dart';
import 'package:portal/screens/ticket/ticket_pending_invoice_service.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class EventTicketScreen extends StatefulWidget {
  const EventTicketScreen({super.key});

  @override
  State<EventTicketScreen> createState() => _EventTicketScreenState();
}

class _EventTicketScreenState extends State<EventTicketScreen> with SingleTickerProviderStateMixin {
  EventDetail? detail;
  int count = 0;
  List<Map<String, dynamic>> body = [];
  late DateTime startDate;
  bool chooseSeatVisible = false;
  List<Ticket> ticketList = [];
  bool isReady = false; //suudal bga esehiig shalgaad bwal ticket list-nd insert hiij ogdog tul delgets zurahdaa ene flagiig ashiglana
  int min = 1000000000; //suudaltai event iin min dun
  int max = 0; //suudaltai event iin max dun
  double _dragDistance = 0.0;

  int from = 0;
  late TicketPendingInvoiceService _pendingInvoiceService;

  @override
  void initState() {
    body = [];
    ticketList = [];
    setState(() {});
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      detail = args['detail'];
      startDate = DateTime.parse(detail!.startDate!).toLocal();
      ticketList = detail!.tickets!;
      _pendingInvoiceService = TicketPendingInvoiceService();

      Provider.of<ProviderCoreModel>(context, listen: false).setSelectedSeat([]);
      isChooseSeatVisible();
    }));

    super.initState();
  }

  @override
  void dispose() {
    body = [];
    ticketList = [];
    super.dispose();
  }

  createInvoice() async {
    print('data:$body');

    final Map<String, dynamic> data = <String, dynamic>{};
    data['templates'] = body;
    data['eventId'] = detail!.id;
    NavKey.navKey.currentState!.pushNamed(paymentRoute, arguments: {'data': data, 'event': detail, 'promo': '', 'ebarimt': ''});
  }

  totalCal(List<Map<String, dynamic>> body) {
    print('body:$body');
    num amount = 0;
    for (int j = 0; j < body.length; j++) {
      for (int i = 0; i < ticketList.length; i++) {
        if (ticketList[i].id == body[j]['templateId']) {
          if (body[j]['seats'].runtimeType == String) {
          } else {
            amount = amount + ticketList[i].sellPrice!.amt! * body[j]['seats'];
          }
        }
      }
    }
    // print('amount:$amount');
    return amount;
  }

  isChooseSeatVisible() {
    for (int i = 0; i < ticketList.length; i++) {
      if (ticketList[i].isSeat!) {
        if (min > ticketList[i].sellPrice!.amt!) {
          min = ticketList[i].sellPrice!.amt!;
          print('index:$i - ${ticketList[i].sellPrice!.amt!} - ${ticketList[i].id}');
        }
        if (max < ticketList[i].sellPrice!.amt!) {
          max = ticketList[i].sellPrice!.amt!;
        }

        chooseSeatVisible = true;

        // Ticket ticket = Ticket(acceptablePaymentMethod: [], seats: []);
      }
    }

    if (chooseSeatVisible) {
      // Filter tickets where isSeat is true
      List<Ticket> seatTickets = ticketList.where((el) => el.isSeat == true).toList();

      if (seatTickets.isNotEmpty) {
        // Find earliest startDate
        DateTime earliestStartDate = DateTime.parse(seatTickets.first.startDate!);
        String earliestStartDateString = seatTickets.first.startDate!;

        // Find latest endDate
        DateTime latestEndDate = DateTime.parse(seatTickets.first.endDate!);
        String latestEndDateString = seatTickets.first.endDate!;

        // Loop through all seat tickets to find earliest start and latest end
        for (var ticket in seatTickets) {
          if (ticket.startDate != null) {
            DateTime currentStartDate = DateTime.parse(ticket.startDate!);
            if (currentStartDate.isBefore(earliestStartDate)) {
              earliestStartDate = currentStartDate;
              earliestStartDateString = ticket.startDate!;
            }
          }

          if (ticket.endDate != null) {
            DateTime currentEndDate = DateTime.parse(ticket.endDate!);
            if (currentEndDate.isAfter(latestEndDate)) {
              latestEndDate = currentEndDate;
              latestEndDateString = ticket.endDate!;
            }
          }
        }

        print('Earliest startDate: $earliestStartDateString, Latest endDate: $latestEndDateString');

        // Find the ticket with the appropriate price (using the first seat ticket's price for now)
        // You might want to adjust this logic based on your requirements
        Ticket referencePriceTicket = seatTickets.first;

        // Create new ticket with earliest start date and latest end date
        Ticket lastTicket = Ticket(
            acceptablePaymentMethod: [],
            sellPrice: referencePriceTicket.sellPrice,
            isSeat: true,
            startDate: earliestStartDateString,
            endDate: latestEndDateString,
            seats: []);

        ticketList.insert(ticketList.length, lastTicket);
      }
    }

    isReady = true;
    setState(() {});
  }

  Future<QpayInvoice?> checkInvoice() async {
    QpayInvoice? inv;
    try {
      await Webservice().loadGet(QpayInvoice.getPendingInvoice, context).then((response) {
        inv = response;
      });
    } catch (e) {
      return null;
    }
    return inv;
  }

  deleteInvoice(String id) async {
    await Webservice().loadDelete(Response.deleteInvoice, context, parameter: id).then((response) {
      NavKey.navKey.currentState!.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool isEnglish = Provider.of<ProviderCoreModel>(context, listen: true).isEnglish;

    return CustomScaffold(
      canPopWithSwipe: true,
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: false,
      appBar: EmptyAppBar(context: context),
      body: Container(
        // width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.mattBlack,
        child: detail == null && !isReady
            ? Center(
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: theme.colorScheme.whiteColor,
                  ),
                ),
              )
            : Stack(children: [
                SizedBox(
                  width: ResponsiveFlutter.of(context).wp(100),
                  height: ResponsiveFlutter.of(context).hp(100),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                    child: Image.network(
                      detail!.coverImage!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: theme.colorScheme.backgroundBlack.withValues(alpha: 0.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              NavKey.navKey.currentState!.pop();
                            },
                            child: SizedBox(
                              height: 40,
                              width: double.maxFinite,
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.ticketDescColor.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            )),
                        ContainerTransparent(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    detail!.coverImage!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    detail!.name ?? '',
                                    style: TextStyles.textFt18Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              color: theme.colorScheme.fadedWhite,
                              thickness: 0.5,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(children: [
                              Icon(
                                Icons.timer,
                                color: theme.colorScheme.ticketDescColor.withValues(alpha: 0.7),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  '${startDate.month}-р сар ${startDate.day}, ${Utils.weekDay(startDate.weekday, isEnglish)} ● ${DateFormat('HH:mm').format(startDate)}',
                                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                                ),
                              )
                            ]),
                            Row(children: [
                              Icon(
                                Icons.location_pin,
                                color: theme.colorScheme.ticketDescColor.withValues(alpha: 0.7),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  '${detail!.location!.name}',
                                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                                ),
                              )
                            ]),
                          ],
                        )),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          getTranslated(context, 'chooseTicket'),
                          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ticketList.length,
                                itemBuilder: ((context, index) {
                                  Map<String, dynamic> item = {};
                                  return index + 1 == ticketList.length && ticketList[index].isSeat!
                                      ? TicketItem(
                                          ticket: ticketList[index],
                                          index: index,
                                          onPress: (p0, p1) {},
                                          chooseSeat: true,
                                          min: min,
                                          max: max,
                                          detail: detail!,
                                          tapSeat: () {
                                            NavKey.navKey.currentState!.pushNamed(eventChooseSeatRoute, arguments: {'detail': detail, 'body2': body});
                                          },
                                        )
                                      : ticketList[index].isSeat!
                                          ? const SizedBox()
                                          : TicketItem(
                                              tapSeat: () {},
                                              detail: detail!,
                                              ticket: ticketList[index],
                                              index: index,
                                              onPress: (bool isAdd, int count) {
                                                Map<String, dynamic> searchValue = {
                                                  'templateId': ticketList[index].id,
                                                  'seats': isAdd ? count - 1 : count + 1
                                                };
                                                String searchValueString = searchValue.toString();
                                                List<String> bodyStrings = body.map((e) => e.toString()).toList();
                                                int indexOf = bodyStrings.indexOf(searchValueString);
                                                if (indexOf != -1) {
                                                  if (count <= 0) {
                                                    body.removeAt(indexOf);
                                                  } else {
                                                    item['templateId'] = ticketList[index].id;
                                                    item['seats'] = count;
                                                    body[indexOf] = item;
                                                  }
                                                  print('index of :$indexOf \t item:$item');
                                                  setState(() {});
                                                } else {
                                                  item['templateId'] = ticketList[index].id;
                                                  item['seats'] = count;
                                                  body.add(item);
                                                  setState(() {});
                                                }
                                              });
                                }))),
                        const SizedBox(
                          height: 80,
                        )
                        // Visibility(visible: chooseSeatVisible, child: const Text('test we')),
                      ],
                    ))
              ]),
      ),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          backgroundColor: theme.colorScheme.whiteColor,
          textColor: theme.colorScheme.blackColor,
          text: '${getTranslated(context, 'buy')} /${Func.toMoneyStr(totalCal(body))}/',
          onTap: body.isEmpty
              ? null
              : () async {
                  bool hasPendingInvoice = await _pendingInvoiceService.handlePendingInvoice(
                    context: context,
                    theme: theme,
                    currentEventDetail: detail,
                  );

                  if (!hasPendingInvoice) {
                    createInvoice();
                  }
                },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
