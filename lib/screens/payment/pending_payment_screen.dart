// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:portal/components/container_transparent.dart';
// import 'package:portal/components/custom_scaffold.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/helper/constant.dart';
// import 'package:portal/helper/func.dart';
// import 'package:portal/helper/responsive_flutter.dart';
// import 'package:portal/helper/text_styles.dart';
// import 'package:portal/helper/utils.dart';
// import 'package:portal/language/language_constant.dart';
// import 'package:portal/models/bank_model.dart';
// import 'package:portal/models/event_detail_model.dart';
// import 'package:portal/models/invoice_model.dart';
// import 'package:portal/models/payment_model.dart';
// import 'package:portal/provider/theme_notifier.dart';
// import 'package:provider/provider.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PendingPayment extends StatefulWidget {
//   const PendingPayment({super.key});

//   @override
//   State<PendingPayment> createState() => _PendingPaymentState();
// }

// class _PendingPaymentState extends State<PendingPayment> with WidgetsBindingObserver {
//   QpayBanks qpayBanks = QpayBanks();
//   List<BankModel> banks = [];
//   List<PaymentModel> payList = PaymentModel().getPaymentModel();
//   List<PaymentModel> payMethodsList = PaymentModel().getPaymentMethods();
//   PaymentModel? selectedPaymentMethod;
//   double _dragDistance = 0.0;
//   QpayInvoice? invoice;
//   EventDetail? detail;
//   int selectedVatType = -1;
//   bool choosePaymentMethod = false;
//   int totalAmt = 0;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);
//     Future.delayed(Duration.zero, (() {
//       dynamic args = ModalRoute.of(context)?.settings.arguments;
//       invoice = args['invoice'];
//       banks = qpayBanks.getBanks();
//       detail = args['event'];
//       setState(() {});

//       // init();
//     }));
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       print('call check payment');
//       checkPayment();
//     }
//   }

//   Future<void> checkPayment() async {}

//   // deleteInvoice() async {

//   // }

//   bankPress(BankModel bank) async {
//     Uri uri = Uri.parse(bank.link! + invoice!.qpay!.qrText!);
//     try {
//       await launchUrl(uri);
//     } catch (e) {
//       application.showToastAlert('Аппликейшнээ татаж суулгана уу.');
//     }
//   }

//   getTicketName(String templateId) {
//     String seatType = '';
//     for (int i = 0; i < detail!.tickets!.length; i++) {
//       if (templateId == detail!.tickets![i].id) {
//         seatType = detail!.tickets![i].name!;
//         break;
//       }
//     }
//     return seatType;
//   }

//   int getTicketPrice(String templateId, dynamic seats) {
//     int price = 0;
//     if (seats.runtimeType == List<String>) {
//       Ticket ticket = Utils.getTicketTemplateBySeat(detail!.tickets!, seats[0]);
//       return ticket.sellPrice!.amt! * int.parse(seats.length.toString());
//     } else {
//       for (int i = 0; i < detail!.tickets!.length; i++) {
//         if (templateId == detail!.tickets![i].id) {
//           price = detail!.tickets![i].sellPrice!.amt!;
//           price = price * int.parse(seats.toString());
//           break;
//         }
//       }
//     }

//     return price;
//   }

//   String totalAmtCalc() {
//     int amt = 0;
//     amt = int.parse(invoice?.amt.toString() ?? '');
//     return Func.toMoneyStr(amt);
//   }

//   // checkTicketPaymentMethods(){
//   //   widget.detail
//   // }

//   String getBankStoreUrl(String bankName) {
//     // ignore: unrelated_type_equality_checks
//     bool isAndroid = Platform.isAndroid;

//     switch (bankName) {
//       case 'Khan bank':
//         return isAndroid ? androidKhanBank : iosKHANBank;
//       case 'State bank':
//         return isAndroid ? androidSTATEBank : iosSTATEBank;
//       case 'Xac bank':
//         return isAndroid ? androidKHASBank : iosKHASBank;
//       case 'Trade and Development bank':
//         return isAndroid ? androidTDBBank : iosTDB;
//       case 'Most money':
//         return isAndroid ? androidMostMoney : iosMostMoney;
//       case 'National investment bank':
//         return isAndroid ? androidNIBank : iosNIBank;
//       case 'Chinggis khaan bank':
//         return isAndroid ? androidCKBank : iosCKBank;
//       case 'Capitron bank':
//         return isAndroid ? androidCAPITRONBank : iosCAPITRONBank;
//       case 'Bogd bank':
//         return isAndroid ? androidBOGDBank : iosBOGDBank;
//       case 'qPay wallet':
//         return isAndroid ? androidQpayWallet : iosQpayWallet;
//       default:
//         return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     return CustomScaffold(
//       canPopWithSwipe: true,
//       padding: EdgeInsets.zero,
//       resizeToAvoidBottomInset: false,
//       appBar: EmptyAppBar(context: context, backgroundColor: theme.colorScheme.blackColor),
//       body: Container(
//           width: ResponsiveFlutter.of(context).wp(100),
//           height: ResponsiveFlutter.of(context).hp(100),
//           color: theme.colorScheme.blackColor,
//           child: detail == null
//               ? Center(
//                   child: SizedBox(
//                     height: 16,
//                     width: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                       color: theme.colorScheme.whiteColor,
//                     ),
//                   ),
//                 )
//               : Stack(children: [
//                   SizedBox(
//                     width: ResponsiveFlutter.of(context).wp(100),
//                     height: ResponsiveFlutter.of(context).hp(100),
//                     child: ImageFiltered(
//                       imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
//                       child: Image.network(
//                         detail?.coverImage ?? 'https://cdn.cody.mn/img/276960/1920x0xwebp/DBR_9534.jpg?h=4ef1aa3a49ec22862e90935a08f476f976e741b4',
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                   ),
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       height: ResponsiveFlutter.of(context).hp(100),
//                       color: Colors.black.withValues(alpha: 0.68),
//                       child: SingleChildScrollView(
//                           child: GestureDetector(
//                               onVerticalDragUpdate: (details) {
//                                 setState(() {
//                                   _dragDistance += details.delta.dy;
//                                 });
//                                 print('drag distance:$_dragDistance');
//                               },
//                               onVerticalDragEnd: (details) {
//                                 if (_dragDistance > 100) {
//                                   NavKey.navKey.currentState!.pop();
//                                 }
//                                 _dragDistance = 0.0;
//                               },
//                               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Center(
//                                   child: InkWell(
//                                     onTap: () {
//                                       NavKey.navKey.currentState!.pop();
//                                     },
//                                     child: Container(
//                                       width: 40,
//                                       height: 4,
//                                       decoration: BoxDecoration(
//                                           color: theme.colorScheme.ticketDescColor.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 ContainerTransparent(
//                                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           getTranslated(context, 'payAmt'),
//                                           style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         Text(
//                                           totalAmtCalc(),
//                                           style: TextStyles.textFt24Bold.textColor(theme.colorScheme.whiteColor),
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         Divider(
//                                           color: theme.colorScheme.fadedWhite,
//                                           thickness: 0.5,
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               '${invoice?.invoicedesc}',
//                                               style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
//                                             ),
//                                             Text(
//                                               Func.toMoneyStr('${invoice?.amt}'),
//                                               style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                       ],
//                                     )),
//                                 const SizedBox(
//                                   height: 16,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       getTranslated(context, 'bankApp'),
//                                       style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     GridView.builder(
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         padding: EdgeInsets.zero,
//                                         shrinkWrap: true,
//                                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 4,
//                                           childAspectRatio: 1 / 1.3,
//                                         ),
//                                         itemCount: banks.length,
//                                         itemBuilder: (context, index) {
//                                           return InkWell(
//                                             onTap: () {
//                                               bankPress(banks[index]);
//                                             },
//                                             child: Column(
//                                               children: [
//                                                 ClipRRect(
//                                                   borderRadius: BorderRadius.circular(16),
//                                                   child: Image.network(
//                                                     width: 80,
//                                                     height: 80,
//                                                     banks[index].logo!,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 4,
//                                                 ),
//                                                 Text(
//                                                   banks[index].name!,
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor),
//                                                   maxLines: 1,
//                                                 )
//                                               ],
//                                             ),
//                                           );
//                                         })
//                                   ],
//                                 )
//                               ]))))
//                 ])),
//       // floatingActionButton: IntrinsicHeight(
//       //   child: CustomButton(
//       //     backgroundColor: theme.colorScheme.backgroundColor,
//       //     textColor: theme.colorScheme.whiteColor,
//       //     width: double.maxFinite,
//       //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
//       //     onTap: () {
//       //       NavKey.navKey.currentState?.pop();
//       //     },
//       //     text: getTranslated(context, 'back'),
//       //   ),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
