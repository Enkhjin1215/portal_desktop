import 'package:flutter/material.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/payment_section/payment_services.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class EventWebviewScreen extends StatefulWidget {
  const EventWebviewScreen({super.key});

  @override
  State<EventWebviewScreen> createState() => _EventWebviewScreenState();
}

class _EventWebviewScreenState extends State<EventWebviewScreen> with WidgetsBindingObserver {
  // late final WebViewController _controller;
  String? document;
  String name = '';
  QpayInvoice? inv;
  EventDetail? event;
  Map<String, dynamic>? data;

  bool isQuizNight = false;
  final PaymentService _paymentService = PaymentService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      document = args['url'];
      event = args['event'];
      name = args['name'];
      inv = args['inv'];
      data = args['data'];
      if (event != null) {
        if (event!.name!.contains('Quiz')) {
          isQuizNight = true;
        }
      }

      print('document:$document');
      // init(document!);
      // init();
    }));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // _controller.clearCache();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('call check payment');
      checkPayment();
    }
  }

  checkPayment() async {
    print('check2');
    await Webservice().loadGet(Response.checkInvoice, context, parameter: inv?.id ?? '').then((response) {
      if (response['status'] == 'success') {
        if (isQuizNight) {
          _paymentService.quizNight(context: context, tableNo: data!['templates'].first['seats'].first, date: event!.startDate ?? '');
        }

        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(paymentSuccessRoute, arguments: {'event': event}, (route) => false);
      } else {
        application.showToastAlert('Төлбөр төлөгдөөгүй байна');
      }
    });
  }

  // init(String url) async {
  //   final WebViewController controller = WebViewController();
  //   controller
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(NavigationDelegate(
  //       onProgress: (int progress) async {
  //         //debugPrint("URL------------> loading:$urla");
  //       },
  //       onUrlChange: (change) {
  //         debugPrint("CHANGED URL------------> loading: ${change.url}");
  //         if (change.url!.startsWith('socialpay-payment://key=')) {
  //           launchUrl(Uri.parse(change.url!));
  //         } else if (change.url!.contains('https://portal.mn/')) {
  //           checkPayment();
  //         } else if (change.url!.contains('https://stage.portal.mn/')) {
  //           checkPayment();
  //         } else if (change.url!.contains('mn.moco.candy:')) {
  //           try {
  //             launchUrl(Uri.parse(change.url!));
  //           } catch (e) {
  //             print('exceptionssss:$e');
  //           }
  //         }
  //       },
  //     ))
  //     ..addJavaScriptChannel(
  //       'Toaster',
  //       onMessageReceived: (JavaScriptMessage message) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(message.message)),
  //         );
  //       },
  //     )
  //     ..loadRequest(Uri.parse(url));

  //   _controller = controller;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
        padding: EdgeInsets.zero,
        // appBar: tittledAppBar(context: context, tittle: ''),
        body: document == null || document == ''
            ? Column(children: [
                InkWell(
                  onTap: () {
                    NavKey.navKey.currentState!.pop();
                    // NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
                  },
                  child: SizedBox(
                    height: 40,
                    width: double.maxFinite,
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: theme.colorScheme.backColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Center(
                    child: Text(
                  'Түр хүлээнэ үү!',
                  textAlign: TextAlign.center,
                  style: TextStyles.textFt18Med.textColor(Colors.white),
                )),
                const Expanded(child: SizedBox()),
              ])
            : Column(
                children: [
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    },
                    child: SizedBox(
                      height: 40,
                      width: double.maxFinite,
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: ShapeDecoration(
                            color: theme.colorScheme.backColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
             const     Expanded(
                    child:SizedBox(),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ));
  }
}
