import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/models/ticket_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

import '../../../helper/text_styles.dart';
import '../custom_widget/QRCodeWidget.dart';

class TicketPopup {
  static final TicketPopup _instance = TicketPopup.internal();

  TicketPopup.internal();

  factory TicketPopup() => _instance;

  static BuildContext? mContext;

  static void showDivideDialog(
    BuildContext context, {
    required dismissType,
    required Function btnFunction,
    required ThemeData mTheme,
  }) {
    showDialog(
        context: context,
        barrierDismissible: dismissType,
        builder: (popContext) {
          mContext = popContext;
          return PopScope(
              canPop: true,
              onPopInvoked: (didPop) {},
              child: AlertDialog(
                  backgroundColor: mTheme.colorScheme.bottomNavigationColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                      child: Center(
                        child: Text(
                          'Тасалбар задлах',
                          textAlign: TextAlign.center,
                          style: TextStyles.textFt14Med.textColor(mTheme.colorScheme.whiteColor),
                        ),
                      ),
                    ),
                    Text(
                      'Та тасалбараа задласанаар "Хоёрдогч зах зээл" дээр зарах боломжгүй болох ба суудлын тоогоор тасалбар үүснэ.',
                      style: TextStyles.textFt14Reg.textColor(mTheme.colorScheme.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          btnFunction();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              color: mTheme.colorScheme.whiteColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: mTheme.colorScheme.greyText)),
                          child: Center(
                            child: Text(
                              'Задлах',
                              textAlign: TextAlign.center,
                              style: TextStyles.textFt14Med.textColor(mTheme.colorScheme.blackColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])));
        });
  }

  static void showCustomDialog(BuildContext context,
      {required dismissType,
      required String title,
      required String qr,
      required bool btnType,
      required String btnText,
      required Function btnFunction,
      required ThemeData mTheme,
      String? eventID,
      Tickets? ticket,
      Function? checkInv,
      bool noButton = false,
      bool showWallet = true}) {
    GlobalKey globalKey = GlobalKey();
    showDialog(
        context: context,
        barrierDismissible: dismissType,
        builder: (popContext) {
          mContext = popContext;
          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {},
            child: AlertDialog(
              backgroundColor: mTheme.colorScheme.bottomNavigationColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyles.textFt14Med.textColor(mTheme.colorScheme.whiteColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: mTheme.colorScheme.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
                        height: 200,
                        width: 200,
                        child: QRCodeWidget(
                          qrData: qr,
                        ),
                      ),
                    ),
                  ),
                  if (ticket?.seatId != '' && ticket != null)
                    Container(
                      margin: const EdgeInsets.only(top: 18, bottom: 10),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: item('Давхар', Utils.formatSeatCode(ticket.seatId!, 'floor'), mTheme),
                          ),
                          Expanded(child: item('Сектор', Utils.formatSeatCode(ticket.seatId!, 'sector'), mTheme)),
                          Expanded(child: item('Эгнээ', Utils.formatSeatCode(ticket.seatId!, 'row'), mTheme)),
                          Expanded(child: item('Суудал', Utils.formatSeatCode(ticket.seatId!, 'seat'), mTheme)),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    )
                ],
              ),
              contentPadding: EdgeInsets.zero,
              actions: <Widget>[
                if (showWallet)
                  Visibility(
                      visible: ticket == null || (ticket.isListed == false && Platform.isIOS && ticket.isUsed == false),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            btnFunction();
                          },
                          child: Container(
                            width: 200,
                            height: 40,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.appleWallet),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Add to Apple Wallet',
                                  style: TextStyles.textFt14Reg.textColor(Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                const SizedBox(height: 8),
                showWallet
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            // print('event ID:$eventID');
                            if (eventID != null) {
                              NavKey.navKey.currentState!.pushNamed(eventRoute, arguments: {'id': eventID, 'from': 1});
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: mTheme.colorScheme.whiteColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: mTheme.colorScheme.greyText)),
                            child: Center(
                              child: Text(
                                btnText ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyles.textFt14Med.textColor(mTheme.colorScheme.blackColor),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            noButton ? NavKey.navKey.currentState!.pop() : checkInv!();
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: mTheme.colorScheme.whiteColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: mTheme.colorScheme.greyText)),
                            child: Center(
                              child: Text(
                                noButton ? 'Хаах' : 'Гүйлгээг шалгах',
                                textAlign: TextAlign.center,
                                style: TextStyles.textFt14Med.textColor(mTheme.colorScheme.blackColor),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}

item(String a, String b, ThemeData theme) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white, width: 1)),
      child: Column(
        children: [
          Text(
            a,
            style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor),
          ),
          // const SizedBox(
          //   height: 2,
          // ),
          Text(
            b,
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ));
}
