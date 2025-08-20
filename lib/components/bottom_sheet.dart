import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_text.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/account_model.dart';
import 'package:portal/models/bank_model.dart';
import 'package:portal/models/bar_item_model.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/models/pending_invoice_model.dart';
import 'package:portal/provider/provider_cart.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalAlert {
  void showBottomSheetDialog({
    required BuildContext context,
    required ThemeData theme,
    double? height,
    Function()? onTap,
    Function()? onSecondTap,
    String? title,
    String? firstButtonText,
    String? secondButtonText,
    Color? firstButtonBgColor,
    Color? firstTextColor,
    Color? secondTextColor,
    Color? secondButtonBgColor,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.softBlack,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  InkWell(
                    onTap: (() {
                      NavKey.navKey.currentState!.pop();
                    }),
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(color: theme.colorScheme.whiteColor, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title ?? '',
                    style: TextStyles.textFt20Medium.textColor(theme.colorScheme.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    margin: EdgeInsets.zero,
                    text: firstButtonText ?? '',
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: secondButtonBgColor ?? theme.colorScheme.whiteColor,
                    textColor: secondTextColor ?? theme.colorScheme.blackColor,
                    onTap: () {
                      onTap!();
                    },
                  ),
                  const SizedBox(height: 8),
                  // CustomButton(
                  //   text: secondButtonText ?? '',
                  //   height: 48,
                  //   width: MediaQuery.of(context).size.width,
                  //   backgroundColor: firstButtonBgColor ?? theme.colorScheme.hintColor.withValues(alpha:0.2),
                  //   textColor: firstTextColor ?? theme.colorScheme.whiteColor,
                  //   borderColor: secondTextColor ?? theme.colorScheme.blackColor,
                  //   onTap: () {
                  //     // //debugPrint('onsecondtap:$onSecondTap');
                  //     onSecondTap == null ? NavKey.navKey.currentState!.pop() : onSecondTap();
                  //   },
                  // ),
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      decoration: BoxDecoration(
                          color: firstButtonBgColor ?? theme.colorScheme.hintColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(28)),
                      child: CustomText(
                        secondButtonText ?? '',
                        color: theme.colorScheme.whiteColor.withValues(alpha: 0.8),
                        alignment: Alignment.center,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        lineSpace: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ));
      },
    );
  }

  void barItemChoose({required BuildContext context, required ThemeData theme, required BarItem item, required String barId, required int quant}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setBottomSheetState) {
            return Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 100),
              child: BlurryContainer(
                padding: const EdgeInsets.all(20),
                elevation: 2,
                blur: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        NavKey.navKey.currentState!.pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(60)),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Icon(
                          Icons.close,
                          color: theme.colorScheme.whiteColor,
                        ),
                      ),
                    ),
                    Expanded(
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
                                  offset: const Offset(0, 1), // changes position of shadow
                                ),
                              ],
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  item.image!,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                children: [
                                  Text(
                                    item.name ?? 'null',
                                    style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Text(
                                    Func.toMoneyStr(quant * item.sellPrice!),
                                    style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (quant <= 0) {
                                            return;
                                          } else {
                                            quant--;
                                            Provider.of<ProviderCart>(context, listen: false).setCart(barId, item.buffer ?? [], quant);
                                          }
                                          setBottomSheetState(() {});
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
                                        '$quant',
                                        style: TextStyles.textFt18Med.textColor(theme.colorScheme.whiteColor),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (quant >= 10) {
                                            return;
                                          } else {
                                            quant++;
                                            Provider.of<ProviderCart>(context, listen: false).setCart(barId, item.buffer ?? [], quant);
                                          }
                                          setBottomSheetState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: theme.colorScheme.whiteColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(60)),
                                          child: SvgPicture.asset(Assets.add),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void showBottomSheet({required BuildContext context, required ThemeData theme, required Widget child, required double height, isSeat = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return isSeat
            ? Container(
                height: height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 100),
                child: BlurryContainer(
                  padding: const EdgeInsets.all(20),
                  elevation: 2,
                  blur: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          NavKey.navKey.currentState!.pop();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(60)),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Icon(
                            Icons.close,
                            color: theme.colorScheme.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: child,
                      )
                    ],
                  ),
                ),
              )
            : Container(
                height: height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.backgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (() {
                          NavKey.navKey.currentState!.pop();
                        }),
                        child: Container(
                          width: 46,
                          height: 4,
                          decoration: BoxDecoration(color: theme.colorScheme.fadedWhite, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),

                      const SizedBox(height: 20),
                      child
                      // child
                    ],
                  ),
                ));
      },
    );
  }

  void login({required BuildContext context, required ThemeData theme}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;

          return Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: stdCutoutWidthDown >= 38 ? 40 : 0),
            child: BlurryContainer(
              padding: const EdgeInsets.all(20),
              elevation: 2,
              blur: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(60)),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.whiteColor,
                      ),
                    ),
                  ),
                  Expanded(
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
                                  offset: const Offset(0, 1), // changes position of shadow
                                ),
                              ],
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.2)),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Text(
                                getTranslated(context, 'needLogin'),
                                style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                              )),
                              const SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    application.setUserType(1);
                                    NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 50),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.whiteColor.withValues(alpha: 0.3),
                                        border: Border.all(color: theme.colorScheme.hintColor, width: 0.5),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text(
                                        getTranslated(context, 'login'),
                                        style: TextStyles.textFt12Bold.textColor(theme.colorScheme.whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )))
                ],
              ),
            ),
          );
        });
  }

  void bankListShow({
    required BuildContext context,
    required ThemeData theme,
    required List<Account> list,
    required Function(Account account) onDeleteAccount, // callback to trigger deletion
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;
        print("bottom margin:$stdCutoutWidthDown");
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            return Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: stdCutoutWidthDown >= 38 ? 40 : 0),
              child: BlurryContainer(
                padding: const EdgeInsets.all(20),
                elevation: 2,
                blur: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        NavKey.navKey.currentState!.pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Icon(
                          Icons.close,
                          color: theme.colorScheme.whiteColor,
                        ),
                      ),
                    ),
                    Expanded(
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
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.2),
                        ),
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final account = list[index];
                            return Dismissible(
                              key: Key(account.accntNumber.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red.withValues(alpha: 0.45)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                await onDeleteAccount(account);

                                // Fade-out animation can be managed by removing the item from the list
                                setBottomSheetState(() {
                                  list.removeAt(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Account ${account.accntNumber} deleted'),
                                ));
                              },
                              child: InkWell(
                                onTap: () {
                                  NavKey.navKey.currentState!.pushNamed(walletWithdrawRoute, arguments: {'acc': account});
                                },
                                child: ContainerTransparent(
                                  opacity: 0.2,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        account.bankType ?? '',
                                        style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                                      ),
                                      Text(
                                        '${account.accntNumber ?? ''}',
                                        style: TextStyles.textFt15Reg.textColor(theme.colorScheme.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void bankList({
    required BuildContext context,
    required ThemeData theme,
    required List<BankModel> list,
    required Function(BankModel account) onSelectAcc, // callback to trigger deletion
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            return Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 40),
              child: BlurryContainer(
                padding: const EdgeInsets.all(20),
                elevation: 2,
                blur: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        NavKey.navKey.currentState!.pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Icon(
                          Icons.close,
                          color: theme.colorScheme.whiteColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.transparent.withValues(alpha: 0.25),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.2),
                        ),
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final account = list[index];
                            return ContainerTransparent(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                opacity: 0.2,
                                child: InkWell(
                                  onTap: () async {
                                    await onSelectAcc(account);
                                    NavKey.navKey.currentState!.pop();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          width: 30,
                                          height: 30,
                                          account.logo!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          account.name ?? '',
                                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // void quizNighName({
  //   required BuildContext context,
  //   required ThemeData theme,
  // }) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;

  //         return Container(
  //             width: MediaQuery.of(context).size.width,
  //             padding: EdgeInsets.fromLTRB(32, 8, 32, stdCutoutWidthDown * 1.2),
  //             // margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(1)),
  //             decoration: BoxDecoration(
  //               color: theme.colorScheme.softBlack,
  //               borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(16.0),
  //                   topRight: Radius.circular(16.0),
  //                   bottomLeft: Radius.circular(16.0),
  //                   bottomRight: Radius.circular(16.0)),
  //             ),
  //             child: Column(mainAxisSize: MainAxisSize.min, children: [
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //               CustomTextField(controller: TextEditingController()),
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //               CustomTextField(controller: TextEditingController()),
  //             ]));
  //       });
  // }

  void pendingInvoice(
      {required BuildContext context,
      required ThemeData theme,
      double? height,
      Function()? onTap,
      Function()? onSecondTap,
      String? title,
      String? firstButtonText,
      String? secondButtonText,
      Color? firstButtonBgColor,
      Color? firstTextColor,
      Color? secondTextColor,
      Color? secondButtonBgColor,
      PendingInvoiceModel? invoice,
      StreamController<Duration>? timeController,
      DateTime? endTime,
      Function? whenComplete}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;

        return StreamBuilder<Duration>(
          stream: timeController?.stream,
          initialData: endTime?.difference(DateTime.now()),
          builder: (context, snapshot) {
            final remainingTime = snapshot.data ?? Duration.zero;
            final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
            final seconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(32, 8, 32, stdCutoutWidthDown * 1.2),
              // margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(1)),
              decoration: BoxDecoration(
                color: theme.colorScheme.softBlack,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated(
                        context,
                        'pendingOrder',
                      ),
                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (invoice?.eventId?.coverImageV != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            invoice!.eventId!.coverImageV!,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          invoice!.eventId!.name ?? '',
                          style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'orderCancel'),
                        style: TextStyles.textFt14Med.textColor(const Color(0xFFd79d58)),
                      ),
                      Container(
                        width: 70,
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFd79d58), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "$minutes:$seconds",
                          style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: invoice.templates?.length,
                      itemBuilder: (context, index) {
                        bool isSeat = invoice.templates?[index].seats is String;

                        return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black.withValues(alpha: 0.3)),
                            child: Row(
                              children: [
                                Text(
                                  invoice.templates?[index].templateId?.name ?? '',
                                  style: TextStyles.textFt15Reg.textColor(theme.colorScheme.greyText),
                                ),
                                Text(
                                  " x${isSeat ? invoice.templates![index].seats.length : invoice.templates?[index].seats}",
                                  style: TextStyles.textFt15Reg.textColor(theme.colorScheme.whiteColor),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                isSeat
                                    ? Text(
                                        " ${Func.toMoneyStr(invoice.templates![index].sellPrice!.amount! * invoice.templates![index].seats!.length!)}",
                                        style: TextStyles.textFt15Reg.textColor(theme.colorScheme.whiteColor),
                                      )
                                    : Text(
                                        " ${Func.toMoneyStr(invoice.templates![index].sellPrice!.amount! * invoice.templates![index].seats)}",
                                        style: TextStyles.textFt15Reg.textColor(theme.colorScheme.whiteColor),
                                      ),
                              ],
                            ));
                      }),
                  Divider(
                    color: theme.colorScheme.greyText,
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).hp(1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'total'),
                        style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                      Text(
                        Func.toMoneyStr(invoice.amount ?? '0'),
                        style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).hp(1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          margin: EdgeInsets.zero,
                          text: firstButtonText ?? '',
                          height: 48,
                          width: MediaQuery.of(context).size.width,
                          backgroundColor: secondButtonBgColor ?? theme.colorScheme.whiteColor,
                          textColor: secondTextColor ?? theme.colorScheme.blackColor,
                          onTap: () {
                            onTap!();
                          },
                        ),
                      ),
                      SizedBox(width: ResponsiveFlutter.of(context).wp(5)),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onSecondTap!();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            decoration: BoxDecoration(
                                color: firstButtonBgColor ?? theme.colorScheme.hintColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(28)),
                            child: CustomText(
                              secondButtonText ?? '',
                              color: theme.colorScheme.whiteColor.withValues(alpha: 0.8),
                              alignment: Alignment.center,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              lineSpace: 0,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  claimItem(
    BuildContext context,
    ThemeData theme,
    Future<bool> Function(String val) onTap,
    bool isSaved,
    TextEditingController controller,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          int count = 1;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: theme.colorScheme.blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: isSaved
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(
                            'Хүсэлтийг хүлээж авлаа',
                            style: TextStyles.textFt18Bold,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Item Trade Ban ',
                                style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'гарахаар таны Steam хаяг руу ',
                                    style: TextStyles.textFt14Reg.textColor(theme.colorScheme.ticketDescColor),
                                  ),
                                  TextSpan(
                                    text: ' Trade offer',
                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  TextSpan(
                                    text: ' очих болно.',
                                    style: TextStyles.textFt14Reg.textColor(theme.colorScheme.ticketDescColor),
                                  )
                                ]),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Санамж',
                            style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Steam дээр Trade Ban нь 7 хүртэлх хоног хүлээгдэж гардгийг анхаарна уу. Энэ хугацаанд аливаа алдаа гаргахаас сэргийлж Trade URL-аа өөрчлөхгүй байхыг хүсье.',
                            style: TextStyles.textFt14Reg.textColor(theme.colorScheme.ticketDescColor),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: CustomButton(
                              text: 'Ойлголоо',
                              width: 188,
                              margin: EdgeInsets.zero,
                              onTap: () {
                                NavKey.navKey.currentState!.pop();
                              },
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GradientText(
                            'Steam Trade URL',
                            style: TextStyles.textFt18Bold,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse('https://steamcommunity.com/id/me/tradeoffers/privacy#trade_offer_access_url'));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('How to get it',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_outward_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          // Text(
                          //   'Steam trade URL-ээ доор оруулна уу',
                          //   style: TextStyles.textFt12MoneyReg.textColor(Colors.white),
                          // ),
                          // const SizedBox(
                          //   height: 12,
                          // ),
                          CustomTextField(
                            maxLength: 500,
                            controller: controller,
                            hintText: 'Steam Trade URL оруулах',
                            inputType: TextInputType.number,
                            fillColor: Colors.white.withOpacity(0.1),
                            borderColor: Colors.white.withOpacity(0.3),
                            textColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: CustomButton(
                              height: 35,
                              text: 'Хадгалах',
                              width: 188,
                              margin: EdgeInsets.zero,
                              onTap: () async {
                                if (controller.text.trim().isNotEmpty) {
                                  bool isWork = await onTap(controller.text.trim());
                                  print('------------>isWork :$isWork');
                                  if (isWork) {
                                    setState(() {
                                      isSaved = true;
                                    });
                                  }
                                } else {
                                  application.showToastAlert('Trade Url аа оруулна уу');
                                }
                              },
                            ),
                          )
                        ],
                      ));
          });
        });
  }

  showRollChanceBuy(
    BuildContext context,
    Duration remainingTime,
    ThemeData theme,
    Function onTap,
    StreamController<Duration>? timeController,
    bool showSuccessMessage,
    Function buy,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        int count = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.colorScheme.blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    'Эрх авах',
                    style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      if (showSuccessMessage) {
                        setState(
                          () {
                            showSuccessMessage = false;
                          },
                        );
                      } else {
                        NavKey.navKey.currentState!.pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(25),
                      ),
                      child: Icon(showSuccessMessage ? Icons.arrow_back : Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              content: showSuccessMessage
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Func.toMoneyComma(Utils.rollPrice(count)),
                              style: TextStyles.textFt20Bold.textColor(Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
                                  border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.5),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: () {
                                      if (count > 0) {
                                        setState(() {
                                          count--;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: theme.colorScheme.whiteColor.withValues(alpha: 0.1), shape: BoxShape.circle),
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
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: () {
                                      setState(() {
                                        count++;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: theme.colorScheme.whiteColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                                      child: SvgPicture.asset(Assets.add),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, 'discountValue'),
                              style: TextStyles.textFt14Bold.textColor(Colors.white),
                            ),
                            Text(
                              Utils.rollPriceDiscountPercentage(count),
                              style: TextStyles.textFt14Bold.textColor(theme.colorScheme.discountColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, 'discountAmt'),
                              style: TextStyles.textFt14Bold.textColor(Colors.white),
                            ),
                            Text(
                              Func.toMoneyComma(Utils.rollPriceDiscountAmt(count)),
                              style: TextStyles.textFt14Bold.textColor(theme.colorScheme.discountColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, 'totalAmt'),
                              style: TextStyles.textFt18Bold.textColor(Colors.white),
                            ),
                            Text(
                              Func.toMoneyComma(Utils.rollPrice(count)),
                              style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            if (count > 0) {
                              buy(count);
                            }
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'buy'),
                                style: TextStyles.textFt14Med,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : StreamBuilder<Duration>(
                      stream: timeController?.stream,
                      initialData: remainingTime,
                      builder: (context, snapshot) {
                        final remainingTime = snapshot.data ?? Duration.zero;
                        final hours = remainingTime.inHours.toString().padLeft(2, '0');
                        final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
                        final seconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

                        return IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181818),
                                  border: Border.all(color: Colors.grey, width: 0.4),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: (remainingTime.inSeconds <= 0)
                                          ? InkWell(
                                              onTap: () {
                                                onTap();
                                              },
                                              child: const GradientText(
                                                '+ 1 Үнэгүй эрх авах',
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  decorationThickness: 0.4,
                                                ),
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GradientText(
                                                  'Дараагийн үнэгүй эрх хүртэл',
                                                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                                ),
                                                const SizedBox(height: 4),
                                                GradientText(
                                                  '$hours цаг $minutes мин $seconds сек',
                                                  style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Эрх худалдан авах',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _butItem(theme, Func.toMoneyComma(2000), '1 эрх', Colors.white)),
                                  Expanded(child: _butItem(theme, '10% OFF', '5+ эрх', theme.colorScheme.discountColor)),
                                  Expanded(child: _butItem(theme, '15% OFF', '10+ эрх', theme.colorScheme.discountColor)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  /// Trigger the toggle here
                                  setState(() {
                                    showSuccessMessage = true;
                                  });
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      getTranslated(context, 'buy'),
                                      style: TextStyles.textFt14Med,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Даалгавар биелүүлээд эрх авах',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _dialogItem(theme, 'Тасалбар худалдан авах', 'тасалбар'),
                              const SizedBox(height: 8),
                              _dialogItem(theme, 'Мерч худалдан авах', 'мерч'),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Widget _butItem(ThemeData theme, String text, String text2, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withValues(alpha: 0.1)), color: const Color(0xFF181818)),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyles.textFt14Bold.textColor(color),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            text2,
            style: TextStyles.textFt14Bold.textColor(color),
          )
        ],
      ),
    );
  }
}

Widget _dialogItem(ThemeData theme, String text, String type) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration:
          BoxDecoration(color: Color(0xFF181818), border: Border.all(color: Colors.grey, width: 0.4), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '1 $type = 1 эрх',
                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                ),
              ],
            ),
          ),
        ],
      ));
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
