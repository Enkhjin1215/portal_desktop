// event_route.dart
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/bar_item_model.dart';
import 'package:portal/models/event_children_model.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/provider_cart.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/screens/events/event_bar_screen.dart';
import 'package:portal/screens/events/event_detail_screen.dart';
import 'package:portal/screens/events/event_merch_screen.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class EventRoute extends StatefulWidget {
  const EventRoute({super.key});

  @override
  State<EventRoute> createState() => _EventRouteState();
}

class _EventRouteState extends State<EventRoute> with SingleTickerProviderStateMixin {
  String id = '';
  bool _isLoading = true;
  Color appBarColor = Colors.transparent;
  EventDetail? detail;
  List<EventChildren> childrenList = [];
  EventChildren? selectedChild;
  PageController _controller = PageController();
  int _currentIndex = 0;

  int userType = -1;
  int from = 1;
  // late TicketPendingInvoiceService _pendingInvoiceService;

  @override
  void initState() {
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      _controller = PageController(initialPage: 0);
      id = args['id'];
      from = args['from'];
      print('from:$from');

      if (from == 0) {
        // _pendingInvoiceService = TicketPendingInvoiceService();

        init();
        getDetail(id);
      } else {
        getDetail(id, noNeed: true);
      }
    }));
    super.initState();
  }

  init() async {
    userType = await application.getUserType();
  }

  @override
  void dispose() {
    // _pendingInvoiceService.dispose();
    super.dispose();
  }

  getDetail(String eventId, {bool noNeed = false}) async {
    await Webservice().loadGet(EventDetail.eventDetail, context, parameter: eventId).then((response) {
      detail = response;
      if (!noNeed) {
        checkChild();
      } else {
        _updatePalette();
      }
    });
  }

  checkChild() async {
    await Webservice().loadGet(EventChildren.eventList, context, parameter: '${detail!.id}/children').then((response) async {
      childrenList = response;
      if (childrenList.isNotEmpty) {
        await getDetail(childrenList.first.id!, noNeed: true);
      }
    });
    await _updatePalette();
  }

  // Map<String, dynamic> simplifyPendingInvoice(PendingInvoiceModel? model) {
  //   if (model == null) {
  //     return {};
  //   }
  //   final List<Map<String, dynamic>> simplifiedTemplates = model.templates?.map((template) {
  //         return {
  //           'templateId': template.templateId?.id,
  //           'seats': template.seats,
  //         };
  //       }).toList() ??
  //       [];

  //   return {
  //     'templates': simplifiedTemplates,
  //     'eventId': model.eventId?.id,
  //   };
  // }

  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(detail!.coverImage!));
    appBarColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
    _isLoading = false;
    setState(() {});
  }

  deleteInvoice(String id, {bool doPop = true}) async {
    await Webservice().loadDelete(Response.deleteInvoice, context, parameter: id).then((response) {
      if (doPop) {
        NavKey.navKey.currentState!.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    List<BarItem> barList = Provider.of<ProviderCart>(context, listen: true).getBarList();
    Bar? bar = Provider.of<ProviderCart>(context, listen: true).getBar();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: false,
      body: _isLoading
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
          :
          // Main content with scrolling
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: double.infinity,
              color: Colors.green.withValues(alpha: 0.05),
              child: Row(
                children: [
                  // Fixed header section
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          // Back button / drag handle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    NavKey.navKey.currentState!.pop();
                                  },
                                  child: const ContainerTransparent(
                                      padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                                      width: 48,
                                      bRadius: 60,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.white,
                                      ))),
                              const Expanded(child: SizedBox()),
                            ],
                          ),

                          // Event image and title
                          const SizedBox(height: 20),

                          if (from == 0) tabBar(theme),
                          const SizedBox(height: 20),
                          Text(
                            detail!.name!,
                            style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
                          ),
                          const SizedBox(height: 20),
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                              width: 400,
                              height: 400,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(detail?.featurePhoto ?? ""),
                              )),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     color: Colors.blue,
                  //   ),
                  // )

                  Expanded(
                    child: PageView(
                      controller: _controller,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        EventDetailScreen(
                          detail: detail!,
                          childrenList: childrenList,
                          onTap: (value) {
                            selectedChild = value;
                            setState(() {});
                          },
                        ),
                        EventBarScreen(
                          detail: detail!,
                        ),
                        EventMerchScreen(
                          eventDetail: detail,
                        )
                      ],
                      onPageChanged: (index) {
                        _currentIndex = index;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Visibility(
        visible: from == 1
            ? false
            : _currentIndex == 0
                ? childrenList.isEmpty || (childrenList.isNotEmpty && selectedChild != null)
                : _currentIndex == 1
                    ? true
                    : false,
        child: CustomButton(
          width: 500,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          onTap: () async {
            print('userType from route:$userType');
            if (userType < 2) {
              ModalAlert().login(
                context: context,
                theme: theme,
              );
            } else {
              //to do pending invoice oo chirne;

              if (_currentIndex == 0) {
                if ((childrenList.isNotEmpty && selectedChild != null)) {
                  await getDetail(selectedChild!.id!, noNeed: true);
                }
                NavKey.navKey.currentState?.pushNamed(eventTicketRoute, arguments: {"detail": detail});
              } else if (_currentIndex == 1) {
                Map<String, dynamic> body = {};
                if (barList.isEmpty) {
                } else {
                  body = Provider.of<ProviderCart>(context, listen: false).getCart(bar!.id!) ?? {};
                }
                if (body.isNotEmpty) {
                  NavKey.navKey.currentState?.pushNamed(paymentCartRoute, arguments: {"detail": detail, 'data': body, 'from': 0, 'bar': bar});
                }
              } else {
                print('sss');
              }
            }
          },
          text: getTranslated(context, _currentIndex == 0 ? 'buyTicket' : 'buy'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget tabBar(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _tabButtonItem(index: 0, text: 'ticket', theme: theme),
        ),
        Expanded(
          child: _tabButtonItem(index: 1, text: 'bar', theme: theme),
        ),
        Expanded(
          child: _tabButtonItem(index: 2, text: 'merch', theme: theme),
        ),
        Expanded(
          child: _tabButtonItem(index: 3, text: 'market', theme: theme),
        )
      ],
    );
  }

  Widget _tabButtonItem({required int index, required String text, required ThemeData theme}) {
    return InkWell(
      onTap: () {
        if (index == _currentIndex) {
        } else {
          _controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _currentIndex == index ? theme.colorScheme.whiteColor.withValues(alpha: 0.2) : Colors.transparent.withOpacity(0.1),
        ),
        child: _currentIndex == index
            ? Center(
                child: GradientText(
                getTranslated(context, text),
                style: TextStyles.textFt12Bold,
              ))
            : Text(
                getTranslated(context, text),
                style: TextStyles.textFt12Bold.textColor(_currentIndex == index ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
