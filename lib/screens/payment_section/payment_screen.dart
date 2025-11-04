import 'dart:ui';

import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter/material.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/bank_model.dart';
import 'package:portal/models/coupon_model.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/models/merch_model.dart';
import 'package:portal/models/payment_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/popup/TicketPopup.dart';
import 'package:portal/screens/payment_section/apple_pay_handler.dart';
import 'package:portal/screens/payment_section/payment_method_item.dart';
import 'package:portal/screens/payment_section/payment_services.dart';
import 'package:portal/screens/payment_section/promo_code_field.dart';
import 'package:portal/screens/payment_section/ticket_summary_item.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
  // Data from arguments
  Map<String, dynamic>? data;
  EventDetail? detail;

  // Payment related data
  final QpayBanks qpayBanks = QpayBanks();
  List<BankModel> banks = [];
  List<PaymentModel> payList = PaymentModel().getPaymentModel();
  List<PaymentModel> payMethodsList = PaymentModel().getPaymentMethods();
  PaymentModel? selectedPaymentMethod;
  QpayInvoice? invoice;

  // State variables
  int selectedVatType = -1;
  bool choosePaymentMethod = false;
  bool ebarimtWrong = false;
  String ebarimtOrgName = '';
  Promo? promoNo;
  String promoWrong = '';
  bool isQuizNight = false;

  Merch? selectedMerch;
  Merchs? merch;

  bool isCSOX = false;
  bool isSteamTopUp = false;

  bool isCash = false;
  // Controllers
  final TextEditingController orgRegNo = TextEditingController();
  final TextEditingController promoCode = TextEditingController();

  // Services
  final PaymentService _paymentService = PaymentService();

  bool isReady = false;
  dynamic ebarimtResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, () {
      _initializeData();
    });
  }

  Widget _buildCompanyRegistrationField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated(context, 'companyRegId'),
          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        // Registration input field
        CustomTextField(
          hintText: getTranslated(context, 'insertCompanyReg'),
          fillColor: Colors.transparent,
          controller: orgRegNo,
          enable: !choosePaymentMethod,
          onChanged: (p0) {
            setState(() {
              ebarimtOrgName = '';
              ebarimtWrong = false;
            });
          },
          tailingWidget: SizedBox(
            width: 86,
            child: InkWell(
                onTap: () => _checkEbarimt(),
                child: ContainerTransparent(
                  margin: const EdgeInsets.all(4),
                  bRadius: 8,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      getTranslated(context, 'check'),
                      style: TextStyles.textFt12Bold.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
                    ),
                  ),
                )),
          ),
        ),

        const SizedBox(height: 8),

        // Validation message
        if (ebarimtOrgName.isNotEmpty)
          Text(ebarimtOrgName,
              style: TextStyles.textFt14Reg.textColor(
                Colors.green,
              )),

        if (ebarimtWrong)
          Text('Буруу регистер',
              style: TextStyles.textFt14Reg.textColor(
                Colors.red.withOpacity(0.55),
              )),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _halveWidget(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Halve payment methods section
        Text(
          getTranslated(context, 'halve'),
          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        SizedBox(
            width: double.maxFinite,
            height: 110,
            child: Skeletonizer(
              enabled: payList.isEmpty,
              child: ListView.builder(
                  itemCount: payList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return PaymentMethodItem(
                      paymentMethod: payList[index],
                      onTap: () => _handlePaymentMethodSelection(payList[index]),
                      textColor: theme.colorScheme.ticketDescColor,
                      useBlackIconColor: true,
                      totalAmt: _totalAmtCalc(coupon: promoNo),
                    );
                  }),
            )),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: data!['seats'] is List
              ? ListView.builder(
                  itemCount: data!['templates'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // safely get the seats list
                    final seats = data!['templates'][index]['seats'] as List<dynamic>;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: seats.asMap().entries.map((entry) {
                        // entry.key = index, entry.value = seat
                        return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
                            child: Row(
                              children: [
                                Text(
                                  'Давхар:  ',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                Text(
                                  Utils.formatSeatCode(entry.value.toString(), 'floor'),
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Text(
                                  'Сектор:  ',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                Text(
                                  Utils.formatSeatCode(entry.value.toString(), 'sector'),
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Text(
                                  'Эгнээ:  ',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                Text(
                                  Utils.formatSeatCode(entry.value.toString(), 'row'),
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Text(
                                  'Суудал:  ',
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                                Text(
                                  Utils.formatSeatCode(entry.value.toString(), 'seat'),
                                  style: TextStyles.textFt16Bold.textColor(Colors.white),
                                ),
                              ],
                            ));
                      }).toList(),
                    );
                  },
                )
              : Text(data.toString()),
        ),
        Text(
          getTranslated(context, 'paymentMethod'),
          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        // Apple Pay button
        // if (Platform.isIOS) ApplePayButton(onTap: _handleApplePay),

        // Other payment methods grid
        SizedBox(
            width: double.maxFinite,
            height: 105,
            child: Skeletonizer(
              enabled: payMethodsList.isEmpty,
              child: ListView.builder(
                  itemCount: payMethodsList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    // Skip Apple Pay as it has its own button
                    if (payMethodsList[index].type == 'applepay') {
                      return const SizedBox();
                    }

                    return PaymentMethodItem(
                      paymentMethod: payMethodsList[index],
                      onTap: () => _handlePaymentMethodSelection(payMethodsList[index]),
                      textColor: theme.colorScheme.ticketDescColor,
                      totalAmt: _totalAmtCalc(coupon: promoNo),
                    );
                  }),
            )),
      ],
    );
  }

  Widget _buildBankSelectionGrid(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 100,
        ),
        Column(
          children: [
            Text(
              ebarimtResult != null ? 'EBARIMT ' : '',
              style: TextStyles.textFt20Bold.textColor(Colors.white),
            ),
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: QrImageView(
                  data: ebarimtResult != null ? ebarimtResult['qrData'] : invoice?.qpay?.qrText ?? '',
                  version: QrVersions.auto,
                  size: 400.0, // Size of QR image
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        ebarimtResult != null
            ? CustomButton(
                onTap: () {
                  NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
                },
                text: 'Дуусгах',
              )
            : Column(
                children: [
                  CustomButton(
                    width: 250,
                    onTap: () {
                      _checkPayment();
                    },
                    text: 'Төлбөр шалгах',
                  ),
                  InkWell(
                      onTap: () async {
                        await _deleteInvoice();
                      },
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white)),
                        child: Text(
                          'Цуцлах',
                          style: TextStyles.textFt16Med.textColor(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              )
      ],
    );
  }

  void _initializeData() {
    if (!mounted) return;

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    data = args['data'];
    if (args['event'] != null) {
      detail = args['event'];
    }
    banks = qpayBanks.getBanks();
    if (args['csox'] != null) {
      isCSOX = true;
    }
    if (args['steam'] != null) {
      isSteamTopUp = true;
    }

    if (args['promo'] != '') {
      promoCode.text = args['promo'] ?? '';
      _checkPromo();
    }
    if (args['ebarimt'] != '') {
      selectedVatType = 1;
      orgRegNo.text = args['ebarimt'];
      _checkEbarimt();
    }
    if (detail?.name?.contains('Quiz') ?? false) {
      isQuizNight = true;
    }
    if (args['selectedMerch'] != null) {
      selectedMerch = args['selectedMerch'];
      merch = args['merch'];
    }
    isReady = true;
    setState(() {});

    // _paymentService.checkAndDeletePendingInvoice(context).then((_) {
    //   if (mounted) setState(() {});
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // orgRegNo.dispose();
    // promoCode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (invoice != null) {
        _checkPayment();
      }
    }
  }

  Future<void> _checkPayment() async {
    final result = await _paymentService.checkPayment(context: context, invoiceId: invoice?.id ?? '');

    if (result) {
      application.showToast('Амжилттай');
      getEbarimt();
      // NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
    } else {
      // Payment unsuccessful
      application.showToastAlert('Төлбөр төлөгдөөгүй байна');
      if (selectedPaymentMethod?.type == 'applepay') {
        _deleteInvoice();
      }
    }
  }

  getEbarimt() async {
    Map<String, dynamic> data = {};
    await Webservice().loadPost(Response.ebarimtget, context, data, parameter: '${invoice?.id}').then((response) {
      setState(() {
        ebarimtResult = response;
      });
    });
  }

  Future<void> _createInvoice(String paymentType) async {
    // Prepare data with promo or ebarimt if needed
    Map<String, dynamic> requestData = {...data!};

    if (promoNo != null) {
      requestData['promo'] = promoCode.text.trim();
    }

    if (ebarimtOrgName.isNotEmpty) {
      requestData['ebarimtReceiver'] = orgRegNo.text;
    }

    invoice = await _paymentService.createInvoice(
        context: context, data: requestData, paymentType: paymentType, isMerch: selectedMerch != null, isCsOx: isCSOX, isSteamTopUp: isSteamTopUp);

    final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: false).getTheme();

    // Handle non-Apple Pay / non-QPay methods that need webview
    if (selectedPaymentMethod!.type == 'wire' || selectedPaymentMethod!.type == 'pos') {
      setState(() {
        isCash = true;
      });
    } else if (selectedPaymentMethod!.type == 'mcredit') {
      TicketPopup.showCustomDialog(context,
          dismissType: true,
          title: "Дараах QR-г ${selectedPaymentMethod!.name}-р \n уншуулан төлнө үү.",
          qr: '${invoice!.qpay!.qrText}',
          btnType: true,
          btnText: getTranslated(context, 'event_detail'),
          btnFunction: () {
            _checkPayment;
          },
          mTheme: theme,
          eventID: '',
          ticket: null,
          showWallet: false,
          checkInv: () async {
            _checkPayment();
          });
    } else if (selectedPaymentMethod!.type == 'digipay_m' || selectedPaymentMethod!.type == 'pocket') {
      try {
        final uri = Uri.parse(invoice?.qpay?.deepLink ?? '');
        if (await launchUrl(uri)) {
          // Success
        } else {
          application.showToastAlert('Аппликейшнээ татаж суулгана уу.');
        }
      } catch (e) {
        application.showToastAlert('Аппликейшн дэмжихгүй байна. Та суулгасан эсэхээ шалгана уу.');
      }
    } else if (selectedPaymentMethod!.type != 'qpay' && selectedPaymentMethod!.type != 'applepay') {
      NavKey.navKey.currentState!.pushNamed(eventWebViewRoute, arguments: {
        'url': selectedPaymentMethod!.type == 'qpos' ? invoice!.qpay!.deepLink! : invoice!.qpay!.link!,
        'name': selectedPaymentMethod!.name,
        "inv": invoice,
        'event': detail,
        'data': data
      });
    }
    setState(() {});
  }

  Future<void> _deleteInvoice() async {
    if (invoice != null) {
      await _paymentService.deleteInvoice(context: context, invoiceId: invoice!.id!);

      setState(() {
        invoice = null;
        choosePaymentMethod = false;
        selectedPaymentMethod = null;
      });
    }
  }

  Future<void> _handleBankPress(BankModel bank) async {
    await _paymentService.openBankApp(bankLink: bank.link!, qrText: invoice?.qpay?.qrText ?? '');
  }

  String _getTicketName(String templateId) {
    for (int i = 0; i < detail!.tickets!.length; i++) {
      if (templateId == detail!.tickets![i].id) {
        return detail!.tickets![i].name!;
      }
    }
    return '';
  }

  num _getTicketPrice(String templateId, dynamic seats, {Promo? promo}) {
    num price = 0;

    // Seat-based event
    if (seats is List<dynamic>) {
      Ticket ticket = Utils.getTicketTemplateBySeat(detail!.tickets!, seats[0]);
      int seatCount = seats.length;

      // No promo or promo for different template
      if (promo == null || (promo.templateId!.isNotEmpty && promo.templateId != templateId)) {
        return ticket.sellPrice!.amt! * seatCount;
      }

      // Percentage discount
      if (promo.discountType == 'percentage') {
        return (ticket.sellPrice!.amt! - (ticket.sellPrice!.amt! * promo.discountValue! / 100)) * seatCount;
      }

      // Fixed discount
      if (promo.discountType == 'fixed') {
        return (ticket.sellPrice!.amt! - promo.discountValue!) * seatCount;
      }
    }
    // Standing event
    else {
      for (int i = 0; i < detail!.tickets!.length; i++) {
        if (templateId == detail!.tickets![i].id) {
          int quantity = int.parse(seats.toString());

          // No promo or promo for different template
          if (promo == null || (promo.templateId!.isNotEmpty && promo.templateId != templateId)) {
            return detail!.tickets![i].sellPrice!.amt! * quantity;
          }

          // Percentage discount
          if (promo.discountType == 'percentage') {
            price = detail!.tickets![i].sellPrice!.amt! - (detail!.tickets![i].sellPrice!.amt! * promo.discountValue! / 100);
            return price * quantity;
          }

          // Fixed discount
          if (promo.discountType == 'fixed') {
            price = detail!.tickets![i].sellPrice!.amt! - promo.discountValue!;
            return price * quantity;
          }
        }
      }
    }

    return price;
  }

  num _totalAmtCalc({Promo? coupon}) {
    num amt = 0;
    print('is steam up :$isSteamTopUp');

    if (isCSOX) {
      return Utils.rollPrice(data!['qty']);
    } else if (isSteamTopUp) {
      return data!['amount'];
    } else if (selectedMerch != null) {
      //TODO
      // bar nii code
      // if (from == 0) {
      //   for (int i = 0; i < data!['items']!.length; i++) {
      //     amt += getBarItemPrice(data!['items'][i]['itemId'], data!['items'][i]['qty']);
      //   }
      // } else {
      amt = data!['cnt'] * selectedMerch!.sellPrice!.amt!;
    } else {
      for (int i = 0; i < data!['templates']!.length; i++) {
        amt += _getTicketPrice(data!['templates'][i]['templateId'], data!['templates'][i]['seats'], promo: coupon);
      }
    }
    return amt;
  }

  Future<void> _checkEbarimt() async {
    try {
      final result = await _paymentService.checkEbarimt(context: context, regNo: orgRegNo.text);

      setState(() {
        ebarimtOrgName = result;
        ebarimtWrong = false;
      });
    } catch (e) {
      setState(() {
        ebarimtOrgName = '';
        ebarimtWrong = true;
      });
    }
  }

  Future<void> _checkPromo() async {
    setState(() {
      promoWrong = '';
    });

    try {
      final result =
          await _paymentService.validatePromoCode(context: context, data: {...data!}, promoCode: promoCode.text.trim(), eventId: detail!.id ?? '');

      setState(() {
        promoNo = result;
      });
    } catch (e) {
      setState(() {
        promoNo = null;
        promoWrong = _paymentService.getPromoErrorMessage(e.toString());
      });
    }
  }

  void _clearPromo() {
    setState(() {
      promoCode.text = '';
      promoNo = null;
    });
  }

  void _changePromo() {
    setState(() {
      promoNo = null;
      promoWrong = '';
    });
  }

  List<ApplePayItemDetail> _buildApplePayItems() {
    List<ApplePayItemDetail> applelist = [];

    // Add each ticket item
    for (int i = 0; i < data!['templates'].length; i++) {
      String label = _getTicketName(data!['templates'][i]['templateId']);
      int amt = _getTicketPrice(data!['templates'][i]['templateId'], data!['templates'][i]['seats'], promo: promoNo).toInt();

      applelist.add(ApplePayItemDetail(label: label, amount: amt.toDouble()));
    }

    // Add total
    num totalAmt = _totalAmtCalc(coupon: promoNo);
    applelist.add(ApplePayItemDetail(label: 'Total', amount: totalAmt.toDouble()));

    return applelist;
  }

  Future<void> _handleApplePay() async {
    // Validate requirements first
    if (selectedVatType == -1 && (detail?.ebarimt?.isNotEmpty ?? false)) {
      application.showToastAlert('НӨАТ сонгоно уу');
      return;
    }

    if (selectedVatType == 1 && ebarimtOrgName.isEmpty) {
      application.showToastAlert('Байгууллагын регистер ээ оруулна уу.');
      return;
    }

    // Delete existing invoice if any
    if (invoice != null) {
      await _deleteInvoice();
    }

    // Set selected payment method (Apple Pay)
    setState(() {
      choosePaymentMethod = true;
      selectedPaymentMethod = payMethodsList.firstWhere((method) => method.type == 'applepay');
    });

    // Create invoice
    await _createInvoice(selectedPaymentMethod!.type!);

    // Prepare Apple Pay
    List<ApplePayItemDetail> list = _buildApplePayItems();
    final token = await application.getAccessToken();
    Future.delayed(const Duration(seconds: 3), () async {
      await ApplePayHandler.initApplePay(orderId: invoice!.id!, items: list, token: token);
      await ApplePayHandler.presentApplePay();
    });
    // Initialize and present Apple Pay
  }

  Future<void> _handlePaymentMethodSelection(PaymentModel paymentMethod) async {
    // try {
    //   Uri uri = Uri.parse('digipay://payment/25051617145582');
    //   launchUrl(uri);
    // } catch (e) {
    //   debugPrint('exception digipay:$e');
    // }
    //Validate requirements first
    if (selectedVatType == -1 && (detail?.ebarimt?.isNotEmpty ?? false)) {
      application.showToastAlert('НӨАТ сонгоно уу');
      return;
    }

    if (selectedVatType == 1 && ebarimtOrgName.isEmpty) {
      application.showToastAlert('Байгууллагын регистер ээ оруулна уу.');
      return;
    }

    if (invoice != null) {
      if (invoice?.method != paymentMethod.type) {
        print('go change method');
        setState(() {
          choosePaymentMethod = true;
          selectedPaymentMethod = paymentMethod;
        });
        changeMethod(paymentMethod.type!);
        // selectedPaymentMethod = paymentMethod;
      }
    } else {
      // Set selected payment method
      setState(() {
        choosePaymentMethod = true;
        selectedPaymentMethod = paymentMethod;
      });
      // Create new invoice
      await _createInvoice(paymentMethod.type!);
    }
  }

  changeMethod(String type) async {
    Map<String, dynamic> data = {};
    if (ebarimtOrgName.isNotEmpty) {
      data['ebarimtReceiver'] = orgRegNo.text;
    } else {
      data['ebarimtReceiver'] = '';
    }

    await Webservice().loadPost(QpayInvoice.changeMethod, context, data, parameter: '${invoice?.id}?method=$type').then((response) async {
      invoice = response;
      setState(() {});
      Future.delayed(Duration(milliseconds: 500), () async {
        final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: false).getTheme();

        // Handle non-Apple Pay / non-QPay methods that need webview

        if (selectedPaymentMethod!.type == 'mcredit') {
          TicketPopup.showCustomDialog(context,
              dismissType: true,
              title: "Дараах QR-г ${selectedPaymentMethod!.name}-р \n уншуулан төлнө үү.",
              qr: '${invoice!.qpay!.qrText}',
              btnType: true,
              btnText: getTranslated(context, 'event_detail'),
              btnFunction: () {
                _checkPayment;
              },
              mTheme: theme,
              eventID: '',
              ticket: null,
              showWallet: false,
              checkInv: () async {
                _checkPayment();
              });
        } else if (selectedPaymentMethod!.type == 'digipay_m' || selectedPaymentMethod!.type == 'pocket') {
          try {
            final uri = Uri.parse(invoice?.qpay?.deepLink ?? '');
            if (await launchUrl(uri)) {
              // Success
            } else {
              application.showToastAlert('Аппликейшнээ татаж суулгана уу.');
            }
          } catch (e) {
            application.showToastAlert('Аппликейшн дэмжихгүй байна. Та суулгасан эсэхээ шалгана уу.');
          }
        } else if (selectedPaymentMethod!.type != 'qpay' && selectedPaymentMethod!.type != 'applepay') {
          NavKey.navKey.currentState!.pushNamed(eventWebViewRoute, arguments: {
            'url': selectedPaymentMethod!.type == 'qpos' ? invoice!.qpay!.deepLink! : invoice!.qpay!.link!,
            'name': selectedPaymentMethod!.name,
            "inv": invoice,
            'event': detail,
            'data': data
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    final bool loading = Provider.of<ProviderCoreModel>(context, listen: true).getLoading();

    return CustomScaffold(
      canPopWithSwipe: true,
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: false,
      appBar: EmptyAppBar(context: context, backgroundColor: theme.colorScheme.blackColor),
      body: _buildMainContent(theme, loading),
    );
  }

  Widget _buildMainContent(ThemeData theme, bool loading) {
    if (isReady == false) {
      return _buildLoadingIndicator(theme);
    }

    return Container(
      // width: ResponsiveFlutter.of(context).wp(100),
      height: ResponsiveFlutter.of(context).hp(130),
      color: theme.colorScheme.blackColor,
      child: Stack(
        children: [
          _buildBackgroundImage(),
          _buildContentContainer(theme, loading),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: theme.colorScheme.whiteColor,
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return SizedBox(
      // width: ResponsiveFlutter.of(context).wp(100),
      height: ResponsiveFlutter.of(context).hp(130),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Image.network(
          detail?.coverImage ??
              'https://www.portal.mn/_next/image?url=https%3A%2F%2Fcdn.portal.mn%2Fspecial%2FRokitbay%2Frokitbay%20after%203.mp4_snapshot_00.15.515.jpg&w=1920&q=75',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _buildContentContainer(ThemeData theme, bool loading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: ResponsiveFlutter.of(context).hp(130),
      color: Colors.black.withOpacity(0.68),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildDragHandle(theme),
            const SizedBox(height: 20),
            _buildPaymentSummary(theme),
            const SizedBox(height: 16),
            if (loading) _buildLoadingIndicator(theme),
            if (detail?.ebarimt?.isNotEmpty ?? false) _buildVatSelection(theme),

            // Promo code field
            if (selectedMerch == null && !isCSOX)
              PromoCodeField(
                controller: promoCode,
                promoCode: promoNo,
                errorMessage: promoWrong,
                theme: theme,
                onCheckPromo: _checkPromo,
                onClearPromo: _clearPromo,
                onChangePromo: _changePromo,
              ),

            const SizedBox(height: 16),
            _buildPaymentMethodsSection(theme),

            if ((selectedPaymentMethod?.type == 'pos' || selectedPaymentMethod?.type == 'wire') && invoice != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 500,
                    onTap: () {
                      _checkPayment();
                    },
                    text: 'Төлбөр баталгаажуулах',
                  ),
                  InkWell(
                      onTap: () async {
                        await _deleteInvoice();
                      },
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white)),
                        child: Text(
                          'Цуцлах',
                          style: TextStyles.textFt16Med.textColor(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),

            if (choosePaymentMethod && selectedPaymentMethod?.type == 'qpay') _buildBankSelectionGrid(theme),

            // _halveWidget(theme),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return InkWell(
        onTap: () {
          NavKey.navKey.currentState!.pop();
        },
        child: SizedBox(
          height: 20,
          width: double.maxFinite,
          child: Center(
            child: Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(color: theme.colorScheme.ticketDescColor.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ));
  }

  Widget _buildPaymentSummary(ThemeData theme) {
    return ContainerTransparent(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            getTranslated(context, 'payAmt'),
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 12),

          // Display total amount (with or without discount)
          _buildTotalAmountDisplay(theme),

          const SizedBox(height: 12),
          Divider(
            color: theme.colorScheme.fadedWhite,
            thickness: 0.5,
          ),
          const SizedBox(height: 12),

          // Ticket list
          _buildTicketsList(theme),
        ],
      ),
    );
  }

  Widget _buildTotalAmountDisplay(ThemeData theme) {
    // Regular price

    if (isCSOX) {
      if (data!['qty'] < 5) {
        return Text(
          Func.toMoneyStr(_totalAmtCalc()),
          style: TextStyles.textFt24Bold.textColor(theme.colorScheme.whiteColor),
        );
      } else {
        return Column(
          children: [
            // Original price (strikethrough)
            Text(
              Func.toMoneyStr(data!['qty'] * 2000),
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 1.4,
                  decorationColor: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.whiteColor),
            ),
            // Discounted price
            Text(
              Func.toMoneyStr(Utils.rollPrice(data!['qty'])),
              style: TextStyles.textFt24Bold.textColor(theme.colorScheme.discountColor),
            ),
          ],
        );
      }
    }
    if (promoNo == null) {
      return Text(
        Func.toMoneyStr(_totalAmtCalc()),
        style: TextStyles.textFt24Bold.textColor(theme.colorScheme.whiteColor),
      );
    }

    // Discounted price
    return Column(
      children: [
        // Original price (strikethrough)
        Text(
          Func.toMoneyStr(_totalAmtCalc()),
          style: TextStyle(
              decoration: TextDecoration.lineThrough,
              decorationThickness: 1.4,
              decorationColor: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.whiteColor),
        ),
        // Discounted price
        Text(
          Func.toMoneyStr(_totalAmtCalc(coupon: promoNo)),
          style: TextStyles.textFt24Bold.textColor(theme.colorScheme.discountColor),
        ),
      ],
    );
  }

  Widget _buildTicketsList(ThemeData theme) {
    return selectedMerch != null
        ? Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RichText(
                text: TextSpan(
                    text: merch?.name,
                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' x ${data!['cnt']}',
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                      ),
                    ]),
              ),
              Text(
                Func.toMoneyStr(_totalAmtCalc()),
                style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
              ),
            ]),
          )
        : isCSOX
            ? Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RichText(
                    text: TextSpan(
                        text: 'Эрх',
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' x ${data!['qty']}',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                          ),
                        ]),
                  ),
                  Text(
                    Func.toMoneyStr(_totalAmtCalc()),
                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                  ),
                ]),
              )
            : isSteamTopUp
                ? Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      RichText(
                        text: TextSpan(
                            text: 'Steam цэнэглэлт',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.7)),
                            children: <TextSpan>[
                              TextSpan(
                                text: '',
                                style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                              ),
                            ]),
                      ),
                      Text(
                        Func.toMoneyStr(_totalAmtCalc()),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                      ),
                    ]),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: data!['templates'].length,
                    itemBuilder: (context, index) {
                      final templateId = data!['templates'][index]['templateId'];
                      final seats = data!['templates'][index]['seats'] is List<dynamic>
                          ? data!['templates'][index]['seats'].length
                          : data!['templates'][index]['seats'];

                      final originalPrice = _getTicketPrice(templateId, seats);
                      final discountedPrice = promoNo != null ? _getTicketPrice(templateId, seats, promo: promoNo) : null;

                      return TicketSummaryItem(
                        name: _getTicketName(templateId),
                        quantity: seats,
                        originalPrice: originalPrice,
                        discountedPrice: discountedPrice,
                        theme: theme,
                      );
                    });
  }

  Widget _buildVatSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated(context, 'chooseVat'),
          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        // Individual/Company radio buttons
        Row(
          children: [
            // Individual option
            Expanded(
              child: InkWell(
                onTap: () {
                  if (!choosePaymentMethod) {
                    setState(() {
                      selectedVatType = 0;
                    });
                  }
                },
                child: ContainerTransparent(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'individual'),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
                      ),
                      cup.CupertinoRadio(
                          activeColor: Colors.white, useCheckmarkStyle: true, value: 0, groupValue: selectedVatType, onChanged: (val) {})
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Company option
            Expanded(
              child: InkWell(
                onTap: () {
                  if (!choosePaymentMethod) {
                    setState(() {
                      selectedVatType = 1;
                    });
                  }
                },
                child: ContainerTransparent(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, 'company'),
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
                      ),
                      cup.CupertinoRadio(
                          activeColor: Colors.white, useCheckmarkStyle: true, value: 1, groupValue: selectedVatType, onChanged: (value) {}),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 16),

        // Company registration field (if company selected)
        if (selectedVatType == 1) _buildCompanyRegistrationField(theme),
      ],
    );
  }
}
