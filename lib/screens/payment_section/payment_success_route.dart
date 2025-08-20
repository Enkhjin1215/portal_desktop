import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class SuccessRoute extends StatefulWidget {
  const SuccessRoute({super.key});

  @override
  State<SuccessRoute> createState() => _SuccessRouteState();
}

class _SuccessRouteState extends State<SuccessRoute> {
  final confettiController = ConfettiController();
  String orderID = '';
  EventDetail? detail;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      detail = args['event'];
      orderID = args['invoice_id'] ?? '';
      setState(() {});
      if (orderID != '') {
        check(orderID);
      }
    }));
    confettiController.play();
  }

  check(String id) async {
    await Webservice().loadGet(Response.checkInvoice, context, parameter: orderID).then((response) {});
  }

  @override
  dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return PopScope(
        child: Container(
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.blackColor,
            child: detail == null
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
                          detail?.coverImage ?? 'https://cdn.cody.mn/img/276960/1920x0xwebp/DBR_9534.jpg?h=4ef1aa3a49ec22862e90935a08f476f976e741b4',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: ResponsiveFlutter.of(context).hp(100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Text(
                            'Таны худалдан авалт амжилттай 🎉',
                            textAlign: TextAlign.center,
                            style: TextStyles.textFt28Med.textColor(Colors.lightGreenAccent),
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          CustomButton(
                            onTap: () {
                              NavKey.navKey.currentState!.pushNamedAndRemoveUntil(eventTabtRoute, (route) => false);
                            },
                            width: double.maxFinite,
                            text: getTranslated(context, 'continueTxt'),
                          )
                        ],
                      ),
                    ),
                    ConfettiWidget(
                      numberOfParticles: 16,
                      maximumSize: const Size(35, 20),
                      shouldLoop: true,
                      confettiController: confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                    )
                  ])));
  }
}
