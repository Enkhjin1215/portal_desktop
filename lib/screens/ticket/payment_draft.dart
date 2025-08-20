// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pay/pay.dart';
// import 'package:portal/components/container_transparent.dart';
// import 'package:portal/components/custom_scaffold.dart';
// import 'package:portal/components/custom_text_input.dart';
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
// import 'package:portal/provider/provider_core.dart';
// import 'package:portal/provider/theme_notifier.dart';
// import 'package:portal/router/route_path.dart';
// import 'package:portal/service/response.dart';
// import 'package:portal/service/web_service.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'payment_config.dart' as payment_configurations;

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
//   Map<String, dynamic>? data;
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
//   List<PaymentItem> paymentItems = [];
//   dynamic payResult;
//   late QpayInvoice inv;
//   TextEditingController orgRegNo = TextEditingController();
//   bool ebarimtWrong = false;
//   String ebarimtOrgName = '';

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);
//     Future.delayed(Duration.zero, (() {
//       dynamic args = ModalRoute.of(context)?.settings.arguments;
//       data = args['data'];
//       banks = qpayBanks.getBanks();
//       detail = args['event'];
//       checkAndDelete();
//       buildAppleBody();
//       setState(() {});

//       // init();
//     }));
//   }

//   checkAndDelete() async {
//     QpayInvoice? pendingInv = await checkInvoice();
//     if (pendingInv != null) {
//       deleteInvoice(pendingInv.id ?? '');
//     }
//   }

//   Future<QpayInvoice?> checkInvoice() async {
//     QpayInvoice? inv;
//     try {
//       await Webservice().loadGet(QpayInvoice.getPendingInvoice, context).then((response) {
//         inv = response;
//       });
//     } catch (e) {
//       return null;
//     }
//     return inv;
//   }

//   buildAppleBody() {
//     for (int i = 0; i < data!['templates'].length!; i++) {
//       String label = getTicketName(data!['templates'][i]['templateId']);
//       int amt = getTicketPrice(data!['templates'][i]['templateId'], data!['templates'][i]['seats']);
//       PaymentItem item = PaymentItem(amount: amt.toString(), label: label, status: PaymentItemStatus.unknown);
//       paymentItems.add(item);
//     }

//     String label = 'Total';
//     String totalAmt = totalAmtCalc().toString();
//     PaymentItem item = PaymentItem(amount: totalAmt, label: label, status: PaymentItemStatus.final_price);
//     paymentItems.add(item);
//     for (int i = 0; i < paymentItems.length; i++) {
//       print('Label: ${paymentItems[i].label}  : ${paymentItems[i].amount}');
//     }
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     orgRegNo.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       debugPrint('call check payment');
//       checkPayment(type: selectedPaymentMethod?.type ?? '');
//     }
//   }

//   Future<void> checkPayment({String type = ''}) async {
//     if (type == 'applepay') {
//       Map<String, dynamic> data = {};
//       // // var payJson = json.decode(utf8.decode(payResult));
//       // debugPrint('payResult type: ${payResult.runtimeType}\n payJson :$payResult');
//       // // debugPrint('-----------------sda----->${payResult['token']['version']}}');

//       // Map<String, dynamic> tokenPayloadData = jsonDecode(payResult['token']);
//       // Map<String, dynamic> preTokenData = jsonDecode(payResult['paymentMethod:']);
//       // Map<String, dynamic> transactionIdentifier = jsonDecode(payResult['transactionIdentifier']);

//       // debugPrint(
//       //     '1-. preTokenData : $preTokenData\n2-. transactionIdentifier : $transactionIdentifier\n3-. transactionIdentifier:$transactionIdentifier');

//       // Map<String, dynamic> tokenData = {};
//       // Map<String, dynamic> payLoadData = {};

//       // tokenData['paymentMethod'] = preTokenData;
//       // tokenData['transactionIdentifier'] = transactionIdentifier;

//       // payLoadData['data'] = tokenPayloadData["data"];
//       // payLoadData['signature'] = tokenPayloadData["signature"];
//       // payLoadData['header'] = tokenPayloadData["header"];
//       // payLoadData['version'] = tokenPayloadData["version"];
//       // tokenData['paymentData'] = payLoadData;
//       // data['token'] = tokenData;
//       // data['order_id'] = invoice?.id;
//       // // } catch (e) {
//       // //   print('EXCEP    :$e');
//       // // }
//       // Map<String, dynamic> payData = {};

//       // payData['paymentData'] = data;
//       // print('--------->$payData');
//       try {
//         // Parse the JSON string into a Map

//         // Extract necessary fields from the JSON
//         Map<String, dynamic> paymentMethod = payResult['paymentMethod'];
//         String transactionIdentifier = payResult['transactionIdentifier'];
//         Map<String, dynamic> token = jsonDecode(payResult['token']);

//         // Construct the desired structure
//         Map<String, dynamic> paymentData = {
//           "token": {
//             "paymentMethod": {
//               "type": paymentMethod["type"].toString(),
//               "network": paymentMethod["network"],
//               "displayName": paymentMethod["displayName"],
//             },
//             "transactionIdentifier": transactionIdentifier,
//             "paymentData": {
//               "data": token["data"],
//               "signature": token["signature"],
//               "header": {
//                 "publicKeyHash": token["header"]["publicKeyHash"],
//                 "ephemeralPublicKey": token["header"]["ephemeralPublicKey"],
//                 "transactionId": token["header"]["transactionId"],
//               },
//               "version": token["version"],
//             },
//           }
//         };
//         // "order_id": invoice?.id,
//         // };
//         data = paymentData;
//         // Print the constructed JSON for verification
//         // print("Formatted payment data: ${jsonEncode(paymentData)}");
//       } catch (e) {
//         print("Error parsing payment result: $e");
//       }
//       if (data.isNotEmpty && invoice?.id != null) {
//         await Webservice()
//             .loadPost(
//           Response.checkApplePay,
//           context,
//           data,
//           parameter: invoice!.id!,
//         )
//             .then((response) {
//           if (response['success'] == true) {
//             NavKey.navKey.currentState!.pushNamedAndRemoveUntil(
//                 paymentSuccessRoute,
//                 arguments: {
//                   'event': detail,
//                   'invoice_id': response['orderId'],
//                 },
//                 (route) => false);
//           } else {
//             deleteInvoice(invoice?.id ?? '');

//             application.showToastAlert('Төлбөр төлөгдөөгүй байна');
//           }
//         });
//       }
//     } else {
//       await Webservice().loadGet(Response.checkInvoice, context, parameter: invoice?.id ?? '').then((response) {
//         if (response['status'] == 'success') {
//           NavKey.navKey.currentState!.pushNamedAndRemoveUntil(paymentSuccessRoute, arguments: {'event': detail}, (route) => false);
//         } else {
//           application.showToastAlert('Төлбөр төлөгдөөгүй байна');
//         }
//       });
//     }
//   }

//   Future<QpayInvoice>? createInvoice(String type) async {
//     if (ebarimtOrgName != '') {
//       data!['ebarimtReceiver'] = orgRegNo.text;
//     }
//     await Webservice().loadPost(QpayInvoice.getQpay, context, data, parameter: '?method=$type').then((response) {
//       inv = response;
//       if (selectedPaymentMethod!.type != 'qpay' && selectedPaymentMethod!.type != 'applepay') {
//         NavKey.navKey.currentState!
//             .pushNamed(eventWebViewRoute, arguments: {'url': inv.qpay!.link!, 'name': selectedPaymentMethod!.name, "inv": inv, 'event': detail});
//       }
//     });
//     return inv;
//   }

//   deleteInvoice(String id) async {
//     if (invoice != null) {
//       try {
//         await Webservice().loadDelete(Response.deleteInvoice, context, parameter: id, alertShow: false).then((response) {
//           invoice == null;
//           choosePaymentMethod = false;
//           selectedPaymentMethod = null;
//           debugPrint('deleted');
//           setState(() {});
//         });
//       } catch (e) {
//         debugPrint('e');
//       }
//     }
//   }

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

//   num totalAmtCalc() {
//     int amt = 0;
//     for (int i = 0; i < data!['templates']!.length; i++) {
//       amt += getTicketPrice(data!['templates'][i]['templateId'], data!['templates'][i]['seats']);
//     }
//     return amt;
//   }

//   // checkTicketPaymentMethods(){
//   //   widget.detail
//   // }
//   checkEbarimt() async {
//     try {
//       await Webservice().loadGet(Response.checkEbarimtOrg, context, parameter: orgRegNo.text).then((response) {
//         ebarimtOrgName = response['name'];
//         ebarimtWrong = false;
//         setState(() {});
//       });
//     } catch (e) {
//       setState(() {
//         ebarimtOrgName = '';
//         ebarimtWrong = true;
//       });
//     }
//   }

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

//   final Pay _payClient = Pay({
//     PayProvider.google_pay: payment_configurations.defaultGooglePayConfig,
//     PayProvider.apple_pay: payment_configurations.defaultApplePayConfig,
//   });

//   Future<bool> checkApplePay(dynamic data) async {
//     Map<String, dynamic> data = {};
//     try {
//       // Parse the JSON string into a Map

//       // Extract necessary fields from the JSON
//       Map<String, dynamic> paymentMethod = payResult['paymentMethod'];
//       String transactionIdentifier = payResult['transactionIdentifier'];
//       Map<String, dynamic> token = jsonDecode(payResult['token']);

//       // Construct the desired structure
//       Map<String, dynamic> paymentData = {
//         "token": {
//           "paymentMethod": {
//             "type": paymentMethod["type"].toString(),
//             "network": paymentMethod["network"],
//             "displayName": paymentMethod["displayName"],
//           },
//           "transactionIdentifier": transactionIdentifier,
//           "paymentData": {
//             "data": token["data"],
//             "signature": token["signature"],
//             "header": {
//               "publicKeyHash": token["header"]["publicKeyHash"],
//               "ephemeralPublicKey": token["header"]["ephemeralPublicKey"],
//               "transactionId": token["header"]["transactionId"],
//             },
//             "version": token["version"],
//           },
//         }
//       };
//       // "order_id": invoice?.id,
//       // };
//       data = paymentData;
//       // Print the constructed JSON for verification
//       // print("Formatted payment data: ${jsonEncode(paymentData)}");
//     } catch (e) {
//       print("Error parsing payment result: $e");
//       return false;
//     }
//     if (data.isNotEmpty && invoice?.id != null) {
//       await Webservice()
//           .loadPost(
//         Response.checkApplePay,
//         context,
//         data,
//         parameter: invoice!.id!,
//       )
//           .then((response) {
//         if (response['success'] == true) {
//           return true;
//         } else {
//           deleteInvoice(invoice?.id ?? '');

//           application.showToastAlert('Төлбөр төлөгдөөгүй байна');
//           return false;
//         }
//       });
//     }
//     return false;
//   }

//   void onApplePayResult(paymentResult) async {
//     debugPrint("za ymartai ch datagaa awlaa  ${paymentResult.toString()}");

//     payResult = paymentResult;
//     showDialog(
//       barrierColor: Colors.red,
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//     try {
//       // Send token to your backend for verification
//       bool isSuccess = await checkApplePay(payResult);
//       print('issuccess:$isSuccess');

//       Navigator.pop(context); // Close loading dialog

//       if (isSuccess) {
//         print("Payment successful!");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful!")));
//       } else {
//         print("Payment failed!");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed!")));
//       }
//     } catch (e) {
//       Navigator.pop(context); // Close loading dialog
//       print("Error found: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed!")));
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     bool loading = Provider.of<ProviderCoreModel>(context, listen: true).getLoading();

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
//                                 // debugPrint('drag distance:$_dragDistance');
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
//                                           Func.toMoneyStr(totalAmtCalc()),
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
//                                         ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: data!['templates'].length,
//                                             itemBuilder: (context, index) {
//                                               return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                                                 RichText(
//                                                   text: TextSpan(
//                                                       text: '${getTicketName(data!['templates'][index]['templateId'])} ',
//                                                       style:
//                                                           TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                                       children: <TextSpan>[
//                                                         TextSpan(
//                                                           text: data!['templates'][index]['seats'].runtimeType == (List<String>)
//                                                               ? ''
//                                                               : 'x${data!['templates'][index]['seats']}',
//                                                           style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
//                                                         ),
//                                                       ]),
//                                                 ),
//                                                 Text(
//                                                   Func.toMoneyStr(
//                                                       '${getTicketPrice(data!['templates'][index]['templateId'], data!['templates'][index]['seats'])}'),
//                                                   style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
//                                                 ),
//                                               ]);
//                                             })
//                                       ],
//                                     )),
//                                 const SizedBox(
//                                   height: 16,
//                                 ),
//                                 Visibility(
//                                     visible: loading,
//                                     child: const Center(
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                       ),
//                                     )),
//                                 Visibility(
//                                     visible: detail?.ebarimt?.isNotEmpty ?? false,
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           getTranslated(context, 'chooseVat'),
//                                           style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   if (choosePaymentMethod) {
//                                                   } else {
//                                                     selectedVatType = 0;
//                                                     setState(() {});
//                                                   }
//                                                 },
//                                                 child: ContainerTransparent(
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         getTranslated(context, 'individual'),
//                                                         style: TextStyles.textFt14Med
//                                                             .textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                                       ),
//                                                       CupertinoRadio(
//                                                           activeColor: Colors.white,
//                                                           useCheckmarkStyle: true,
//                                                           value: 0,
//                                                           groupValue: selectedVatType,
//                                                           onChanged: (val) {})
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 16,
//                                             ),
//                                             Expanded(
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   if (choosePaymentMethod) {
//                                                   } else {
//                                                     selectedVatType = 1;
//                                                     setState(() {});
//                                                   }
//                                                 },
//                                                 child: ContainerTransparent(
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         getTranslated(context, 'company'),
//                                                         style: TextStyles.textFt14Med
//                                                             .textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                                       ),
//                                                       CupertinoRadio(
//                                                           activeColor: Colors.white,
//                                                           useCheckmarkStyle: true,
//                                                           value: 1,
//                                                           groupValue: selectedVatType,
//                                                           onChanged: (value) {}),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         Visibility(
//                                             visible: selectedVatType == 1,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   getTranslated(context, 'companyRegId'),
//                                                   style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 16,
//                                                 ),
//                                                 CustomTextField(
//                                                   hintText: getTranslated(context, 'insertCompanyReg'),
//                                                   fillColor: Colors.transparent.withValues(alpha: 0.1),
//                                                   controller: orgRegNo,
//                                                   enable: !choosePaymentMethod,
//                                                   tailingWidget: SizedBox(
//                                                     width: 86,
//                                                     child: InkWell(
//                                                         onTap: () {
//                                                           checkEbarimt();
//                                                           // debugPrint('check');
//                                                         },
//                                                         child: ContainerTransparent(
//                                                           margin: const EdgeInsets.all(4),
//                                                           bRadius: 8,
//                                                           padding: const EdgeInsets.all(8),
//                                                           child: Center(
//                                                             child: Text(
//                                                               getTranslated(context, 'check'),
//                                                               style: TextStyles.textFt12Bold
//                                                                   .textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                                             ),
//                                                           ),
//                                                         )),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 8,
//                                                 ),
//                                                 if (ebarimtOrgName != '')
//                                                   Text(ebarimtOrgName,
//                                                       style: TextStyles.textFt14Reg.textColor(
//                                                         Colors.green.withValues(alpha: 0.55),
//                                                       )),
//                                                 if (ebarimtWrong)
//                                                   Text('Буруу регистер',
//                                                       style: TextStyles.textFt14Reg.textColor(
//                                                         Colors.red.withValues(alpha: 0.55),
//                                                       )),
//                                                 const SizedBox(
//                                                   height: 8,
//                                                 ),
//                                               ],
//                                             )),
//                                       ],
//                                     )),
//                                 Visibility(
//                                     visible: !choosePaymentMethod || (detail?.ebarimt?.isEmpty ?? true),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           getTranslated(context, 'paymentMethod'),
//                                           style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         ApplePayButton(
//                                           paymentConfiguration: payment_configurations.defaultApplePayConfig,
//                                           paymentItems: paymentItems,
//                                           style: ApplePayButtonStyle.black,
//                                           type: ApplePayButtonType.buy,
//                                           width: double.maxFinite,
//                                           height: ResponsiveFlutter.of(context).hp(6),
//                                           margin: const EdgeInsets.only(bottom: 16.0),
//                                           onPaymentResult: onApplePayResult,
//                                           loadingIndicator: const Center(
//                                             child: CircularProgressIndicator(),
//                                           ),
//                                           onPressed: () async {
//                                             debugPrint('Apple Pay button pressed');

//                                             if (paymentItems.isEmpty) {
//                                               debugPrint('Error: No payment items available.');
//                                               return;
//                                             }

//                                             final bool isApplePayAvailable = await _payClient.userCanPay(PayProvider.apple_pay);
//                                             if (!isApplePayAvailable) {
//                                               debugPrint('Error: Apple Pay is not available on this device.');
//                                               return;
//                                             }
//                                             if (invoice != null) {
//                                               await deleteInvoice(invoice!.id!);
//                                             }
//                                             choosePaymentMethod = true;
//                                             selectedPaymentMethod = payMethodsList[2];

//                                             Future.delayed(Duration.zero, () async {
//                                               invoice = await createInvoice(payMethodsList[2].type!);
//                                             });
//                                             setState(() {});
//                                             debugPrint('Starting Apple Pay flow...');
//                                           },
//                                           onError: (error) {
//                                             debugPrint('on error start...');
//                                             if (invoice != null) {
//                                               deleteInvoice(invoice!.id ?? '');
//                                             }
//                                           },
//                                         ),
//                                         SizedBox(
//                                             width: double.maxFinite,
//                                             height: 105,
//                                             child: Skeletonizer(
//                                               enabled: payList.isEmpty ? true : false,
//                                               child: ListView.builder(
//                                                   itemCount: payMethodsList.length,
//                                                   shrinkWrap: true,
//                                                   scrollDirection: Axis.horizontal,
//                                                   itemBuilder: (context, index) {
//                                                     return payMethodsList[index].type == 'applepay'
//                                                         ? const SizedBox()
//                                                         : InkWell(
//                                                             onTap: () async {
//                                                               if (selectedVatType == -1 && (detail?.ebarimt?.isNotEmpty ?? false)) {
//                                                                 application.showToastAlert('НӨАТ сонгоно уу');
//                                                               } else {
//                                                                 if (invoice != null) {
//                                                                   await deleteInvoice(invoice!.id!);
//                                                                 }
//                                                                 choosePaymentMethod = true;
//                                                                 selectedPaymentMethod = payMethodsList[index];
//                                                                 Future.delayed(Duration.zero, () async {
//                                                                   invoice = await createInvoice(payMethodsList[index].type!);
//                                                                 });
//                                                                 setState(() {});
//                                                               }
//                                                             },
//                                                             child: Column(
//                                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                                               children: [
//                                                                 Container(
//                                                                     // padding: const EdgeInsets.all(4),
//                                                                     decoration:
//                                                                         BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
//                                                                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                                                                     width: 80,
//                                                                     height: 80,
//                                                                     child: payList[index].isSvg!
//                                                                         ? SvgPicture.asset(
//                                                                             payMethodsList[index].image!,
//                                                                           )
//                                                                         : Image.asset(payMethodsList[index].image!)),
//                                                                 const SizedBox(
//                                                                   height: 8,
//                                                                 ),
//                                                                 Text(
//                                                                   payMethodsList[index].name ?? "",
//                                                                   style: TextStyles.textFt12Bold.textColor(theme.colorScheme.ticketDescColor),
//                                                                   maxLines: 1,
//                                                                 )
//                                                               ],
//                                                             ));
//                                                   }),
//                                             )),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         Text(
//                                           getTranslated(context, 'halve'),
//                                           style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         SizedBox(
//                                             width: double.maxFinite,
//                                             height: 105,
//                                             child: Skeletonizer(
//                                               enabled: payList.isEmpty ? true : false,
//                                               child: ListView.builder(
//                                                   itemCount: payList.length,
//                                                   shrinkWrap: true,
//                                                   scrollDirection: Axis.horizontal,
//                                                   itemBuilder: (context, index) {
//                                                     return InkWell(
//                                                         onTap: () async {
//                                                           if (selectedVatType == -1 && (detail?.ebarimt?.isNotEmpty ?? false)) {
//                                                             application.showToastAlert('НӨАТ сонгоно уу');
//                                                           } else {
//                                                             if (invoice != null) {
//                                                               deleteInvoice(invoice!.id!);
//                                                             }
//                                                             choosePaymentMethod = true;
//                                                             selectedPaymentMethod = payList[index];
//                                                             Future.delayed(Duration.zero, () async {
//                                                               invoice = await createInvoice(payList[index].type!);
//                                                             });

//                                                             setState(() {});
//                                                           }
//                                                         },
//                                                         child: Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                                           children: [
//                                                             Container(
//                                                                 // padding: const EdgeInsets.all(4),
//                                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
//                                                                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                                                                 width: 80,
//                                                                 height: 80,
//                                                                 child: payList[index].isSvg!
//                                                                     ? SvgPicture.asset(
//                                                                         payList[index].image!,
//                                                                         color: Colors.black,
//                                                                         // color: theme.colorScheme.hipay,
//                                                                       )
//                                                                     : Image.asset(payList[index].image!)),
//                                                             const SizedBox(
//                                                               height: 8,
//                                                             ),
//                                                             Text(
//                                                               payList[index].name ?? "",
//                                                               style: TextStyles.textFt12Bold.textColor(theme.colorScheme.ticketDescColor),
//                                                               maxLines: 1,
//                                                             )
//                                                           ],
//                                                         ));
//                                                   }),
//                                             )),
//                                       ],
//                                     )),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Visibility(
//                                     visible: choosePaymentMethod && selectedPaymentMethod?.type == 'qpay',
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           getTranslated(context, 'bankApp'),
//                                           style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
//                                         ),
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         GridView.builder(
//                                             physics: const ClampingScrollPhysics(),
//                                             padding: EdgeInsets.zero,
//                                             shrinkWrap: true,
//                                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 4,
//                                               childAspectRatio: 1 / 1.3,
//                                             ),
//                                             itemCount: banks.length,
//                                             itemBuilder: (context, index) {
//                                               return InkWell(
//                                                 onTap: () {
//                                                   bankPress(banks[index]);
//                                                 },
//                                                 child: Column(
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius: BorderRadius.circular(16),
//                                                       child: Image.network(
//                                                         width: 80,
//                                                         height: 80,
//                                                         banks[index].logo!,
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 4,
//                                                     ),
//                                                     Text(
//                                                       banks[index].name!,
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor),
//                                                       maxLines: 1,
//                                                     )
//                                                   ],
//                                                 ),
//                                               );
//                                             })
//                                       ],
//                                     ))
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
