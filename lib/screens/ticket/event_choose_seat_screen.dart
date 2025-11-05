import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/api_list.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_inappwebview_windows/flutter_inappwebview_windows.dart';


class EventChooseSeatScreen extends StatefulWidget {
  const EventChooseSeatScreen({super.key});

  @override
  State<EventChooseSeatScreen> createState() => _EventChooseSeatScreenState();
}

class _EventChooseSeatScreenState extends State<EventChooseSeatScreen> with SingleTickerProviderStateMixin {
  bool isReady = false;
  late EventDetail detail;
  final GlobalKey webViewKey = GlobalKey();

  List<String> selectedSeats = [];
  List<Map<String, dynamic>> body = [];
  List<Map<String, dynamic>> rawBody = [];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isOpen = false;
  bool isQuizNight = false;
  int prog = 0;
  TextEditingController teamNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  WebViewEnvironment? webViewEnvironment;
    InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() async {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      detail = args['detail'];
      rawBody = [];
      rawBody = args['body2'];
      if (detail.name!.contains('Quiz')) {
        isQuizNight = true;
      }

      teamNameController.text = await application.getQuizName();
      contactNumberController.text = await application.getQuizNumber();
      setState(() {});
      Provider.of<ProviderCoreModel>(context, listen: false).setSelectedSeat([]);
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
        'Failed to find an installed WebView2 runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'custom_path'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
      // init(detail.id!);
      // init();
    }));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    setState(() {
      isReady = true;
    });
  }

  @override
  void dispose() {
    body = [];
    rawBody = [];


    _animationController.dispose();
    teamNameController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  // init(String url) async {
  //   final WebViewController controller = WebViewController();
  //   controller
  //     ..enableZoom(true)
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) async {
  //           print('progress:$progress');
  //           if (progress != 100) {
  //             setState(() {
  //               isReady = false;
  //               prog = progress;
  //             });
  //           } else {
  //             setState(() {
  //               isReady = true;
  //             });
  //           }
  //         },
  //         onUrlChange: (change) {
  //           debugPrint("CHANGED URL------------> loading:${change.url}");
  //           if (change.url!.length >= 65) {
  //             Uri uri = Uri.parse(change.url!);
  //             String? seatsParam = uri.queryParameters['seats'];

  //             // Split the seats string into a List<String>
  //             List<String> seats = seatsParam != null && seatsParam.isNotEmpty ? seatsParam.split(',') : [];
  //             debugPrint('seats:$seats');
  //             Provider.of<ProviderCoreModel>(context, listen: false).setSelectedSeat(seats);
  //           }
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse('${APILIST.eventChooseSeat}$url'));

  //   _controller = controller;
  // }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  buildBody() {
    print('------------------------->${rawBody}');
    // body = rawBody;

    for (int j = 0; j < selectedSeats.length; j++) {
      Ticket ticket = Utils.getTicketTemplateBySeat(detail.tickets!, selectedSeats[j]);
      Map<String, dynamic> item = {};
      item['templateId'] = ticket.id;
      item['seats'] = selectedSeats[j];
      body.add(item);
    }
    Map<String, dynamic> groupedMap = {};

    for (var item in body) {
      String templateId = item["templateId"];
      var seat = item["seats"];

      if (groupedMap.containsKey(templateId)) {
        if (groupedMap[templateId] is List) {
          if (groupedMap[templateId].contains(seat)) {
          } else {
            groupedMap[templateId].add(seat);
          }
        } else {
          groupedMap[templateId] = [groupedMap[templateId], seat];
        }
      } else {
        groupedMap[templateId] = seat is String ? [seat] : seat;
      }
    }

    List<Map<String, dynamic>> result = [];
    groupedMap.forEach((key, value) {
      result.add({"templateId": key, "seats": value});
    });
    final Map<String, dynamic> data = <String, dynamic>{};
    data['templates'] = result;
    data['eventId'] = detail.id;
    print('data:$data');
    NavKey.navKey.currentState!.pushNamed(paymentRoute, arguments: {'data': data, 'event': detail, 'promo': '', 'ebarimt': ''});
  }

  Widget _buildBulletPoint(String? color, String? text) {
    return color == null
        ? const SizedBox()
        : SizedBox(
            height: 20,
            width: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Utils.hexToColor(color),
                      borderRadius: BorderRadius.circular(60),
                    )),
                const Text(' - ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(Func.toMoneyStr(text ?? ''))),
              ],
            ),
          );
  }

  totalCal(List<String> seats) {
    num amt = 0;
    for (int i = 0; i < seats.length; i++) {
      amt += Utils.getTicketTemplateBySeat(detail.tickets!, seats[i]).sellPrice!.amt!;
    }
    return amt.toString();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    selectedSeats = Provider.of<ProviderCoreModel>(context, listen: true).getSelectedSeat();
    return CustomScaffold(
        appBar: EmptyAppBar(context: context),
        padding: EdgeInsets.zero,
        body: Container(
            height: ResponsiveFlutter.of(context).hp(100),
            // width: ResponsiveFlutter.of(context).wp(100),
            color: theme.colorScheme.backgroundColor,
            child: !isReady
                ? Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: theme.colorScheme.whiteColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '$prog/100',
                      style: TextStyles.textFt16Bold.textColor(Colors.white),
                    )
                  ]))
                : Stack(
                   
              children: [
                InAppWebView(
                  key: webViewKey,
                  webViewEnvironment: webViewEnvironment,
                  initialUrlRequest:
                      URLRequest(url: WebUri.uri(Uri.parse('${APILIST.eventChooseSeat}${detail.id}'))),
      
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                 
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                                if (url.toString().length >= 65) {
              Uri uri = Uri.parse(url.toString());
              String? seatsParam = uri.queryParameters['seats'];

              // Split the seats string into a List<String>
              List<String> seats = seatsParam != null && seatsParam.isNotEmpty ? seatsParam.split(',') : [];
              debugPrint('seats:$seats');
              Provider.of<ProviderCoreModel>(context, listen: false).setSelectedSeat(seats);
            }
                  },
             
             
      
        
            
                ),
               
              
            
                      Container(
                          margin: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).hp(2), horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  NavKey.navKey.currentState!.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(60)),
                                  child: SvgPicture.asset(
                                    Assets.backButton,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: _toggleDropdown,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(60)),
                                    child: SvgPicture.asset(
                                      Assets.tabDetail,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.15, // Aligned with the trigger
                        right: 0,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                              width: 200,
                              height: (detail.tickets!.length * 20 + 80) > 400 ? 400 : (detail.tickets!.length * 20 + 80),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.weekDayColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(-2, 0),
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated(context, 'ticket'),
                                          style: TextStyles.textFt18Bold,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: _toggleDropdown,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: detail.tickets!.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return _buildBulletPoint(detail.tickets?[index].color, detail.tickets?[index].sellPrice?.amt.toString());
                                        })
                                  ],
                                ),
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 140,
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  ModalAlert().showBottomSheet(
                                      context: context, theme: theme, child: tickets(theme), height: selectedSeats.length * 90 + 150, isSeat: true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.bgDark,
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(color: theme.colorScheme.darkGrey, width: 0.5)),
                                  child: IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_upward_sharp, color: Color(0xFFd79d58)),
                                        Text(
                                          '${selectedSeats.length}ш',
                                          style: TextStyles.textFt16Bold.textColor(const Color(0xFFd79d58)),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomButton(
                                margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                                width: double.maxFinite,
                                onTap: () {
                                  if (isQuizNight) {
                                    if (selectedSeats.isEmpty) {
                                      application.showToastAlert('Та ширээгээ сонгоно уу');
                                    } else if (selectedSeats.length >= 2) {
                                      application.showToastAlert('Нэгээс илүү ширээ сонгож болохгүй');
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: theme.colorScheme.bottomNavigationColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            title: Text(
                                              detail.name ?? '',
                                              style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'teamName'),
                                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  TextField(
                                                    controller: teamNameController,
                                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                                    decoration: InputDecoration(
                                                      hintText: getTranslated(context, 'insertTeamName'),
                                                      hintStyle: TextStyles.textFt14Med.textColor(theme.colorScheme.hintColor),
                                                      filled: true,
                                                      fillColor: theme.colorScheme.inputBackground,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    getTranslated(context, 'contactNumber'),
                                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  TextField(
                                                    controller: contactNumberController,
                                                    keyboardType: TextInputType.phone,
                                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                                    decoration: InputDecoration(
                                                      hintText: getTranslated(context, 'insertContactNumber'),
                                                      hintStyle: TextStyles.textFt14Med.textColor(theme.colorScheme.hintColor),
                                                      filled: true,
                                                      fillColor: theme.colorScheme.inputBackground,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Container(
                                                width: double.infinity,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: theme.colorScheme.whiteColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                  ),
                                                  onPressed: () async {
                                                    if (teamNameController.text.isEmpty) {
                                                      application.showToastAlert(getTranslated(context, 'needName'));
                                                      return;
                                                    }

                                                    if (contactNumberController.text.isEmpty) {
                                                      application.showToastAlert(getTranslated(context, 'needNumber'));
                                                      return;
                                                    }
                                                    await application.setQuizName(teamNameController.text);
                                                    await application.setQuizNumber(contactNumberController.text);

                                                    body = [];
                                                    buildBody();
                                                  },
                                                  child: Text(
                                                    getTranslated(context, 'continuePayment'),
                                                    style: TextStyles.textFt14Bold.textColor(theme.colorScheme.blackColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else if (selectedSeats.isNotEmpty) {
                                    body = [];
                                    buildBody();
                                  }
                                },
                                text: '${getTranslated(context, 'buy')} /${Func.toMoneyStr(totalCal(selectedSeats))}/',
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )));
  }

  Widget tickets(ThemeData theme) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: selectedSeats.length,
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.only(bottom: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: theme.colorScheme.mattBlack,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.whiteColor.withValues(alpha: 0.4), width: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIP',
                    style: TextStyles.textFt14Bold.textColor(theme.colorScheme.fadedWhite),
                  ),
                  Text(
                    Func.toMoneyComma(Utils.getTicketTemplateBySeat(detail.tickets!, selectedSeats[index]).sellPrice!.amt!),
                    style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      item('Давхар', Utils.formatSeatCode(selectedSeats[index], 'floor'), theme),
                      item('Сектор', Utils.formatSeatCode(selectedSeats[index], 'sector'), theme),
                      item('Эгнээ', Utils.formatSeatCode(selectedSeats[index], 'row'), theme),
                      item('Суудал', Utils.formatSeatCode(selectedSeats[index], 'seat'), theme),
                    ],
                  )
                ],
              ));
        });
  }

  item(String a, String b, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(color: theme.colorScheme.greyText.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Column(
        children: [
          Text(a, style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor)),
          const SizedBox(
            height: 1,
          ),
          Text(b, style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor))
        ],
      )

          // RichText(
          //   text: TextSpan(text: '$a: ', style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor), children: <TextSpan>[
          //     TextSpan(
          //       text: b,
          //       style: TextStyles.textFt12Bold.textColor(theme.colorScheme.whiteColor),
          //     ),
          //   ]),
          // ),
          ),
    );
  }
}
