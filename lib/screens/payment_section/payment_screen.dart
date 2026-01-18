import 'dart:ui';

import 'package:cyrtranslit/cyrtranslit.dart' as cyrtranslit;
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
import 'package:portal/provider/provider_hold_invoice.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/popup/TicketPopup.dart';
import 'package:portal/screens/payment_section/hold_invoice_screen.dart';
import 'package:portal/screens/payment_section/payment_method_item.dart';
import 'package:portal/screens/payment_section/payment_services.dart';
import 'package:portal/screens/payment_section/promo_code_field.dart';
import 'package:portal/screens/payment_section/ticket_summary_item.dart';
import 'package:portal/screens/printer/bottomsheet_printer.dart';
import 'package:portal/screens/printer/printer_service.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  Merch? selectedMerch;
  Merchs? merch;

  bool isCash = false;
  // Controllers
  final TextEditingController orgRegNo = TextEditingController();
  final TextEditingController promoCode = TextEditingController();

  // Services
  final PaymentService _paymentService = PaymentService();

  bool isReady = false;
  dynamic ebarimtResult;
  bool _isDeleting = false;

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
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ),
      ],
    );
  }

  Widget _buildBankSelectionGrid(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              ebarimtResult != null ? 'EBARIMT ' : '',
              style: TextStyles.textFt20Bold.textColor(Colors.white),
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: QrImageView(
                  data: ebarimtResult != null ? ebarimtResult['qrData'] : invoice?.qpay?.qrText ?? '',
                  version: QrVersions.auto,
                  size: 300.0, // Size of QR image
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
                      )),
                  InkWell(
                      onTap: () async {
                        final List<String> allSeats = (data!["templates"] as List).expand((template) => template["seats"] as List<String>).toList();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => UsbPrinterBottomSheet(
                            seats: allSeats,
                            eventName: cyrtranslit.cyr2Lat(detail?.name ?? '', langCode: "mn"),
                            eventDate: Func.toDateStr(detail?.startDate ?? DateTime.now().toString()),
                          ),
                        );
                        // await _deleteInvoice();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 24),
                        width: 250,
                        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white)),
                        child: Text(
                          'Хэвлэх',
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

    if (args['promo'] != '') {
      promoCode.text = args['promo'] ?? '';
      _checkPromo();
    }
    if (args['ebarimt'] != '') {
      selectedVatType = 1;
      orgRegNo.text = args['ebarimt'];
      _checkEbarimt();
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
      // if (invoice != null) {
      //   _checkPayment();
      // }
    }
  }

  Future<void> _checkPayment() async {
    final result = await _paymentService.checkPayment(context: context, invoiceId: invoice?.id ?? '');

    if (result) {
      application.showToast('Амжилттай');
      // getEbarimt();
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
    print('requestData-------->${requestData}');

    if (promoNo != null) {
      requestData['promo'] = promoCode.text.trim();
    }

    if (ebarimtOrgName.isNotEmpty) {
      requestData['ebarimtReceiver'] = orgRegNo.text;
    }

    invoice = await _paymentService.createInvoice(context: context, data: requestData, paymentType: paymentType, isMerch: selectedMerch != null);

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

  Future<void> _deleteInvoice({QpayInvoice? holdInvoice}) async {
    if (holdInvoice != null) {
      await _paymentService.deleteInvoice(context: context, invoiceId: holdInvoice.id!);
      await Provider.of<ProviderHold>(context, listen: false).clearCurrentInvoice();
      // await Provider.of<ProviderHold>(context, listen: false).deleteInvoice(holdInvoice.id!);

      // setState(() {
      invoice = null;
      choosePaymentMethod = false;
      selectedPaymentMethod = null;
      // });
    } else if (invoice != null) {
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
      if (promo == null || (promo.templateId!.isNotEmpty && !promo.templateId!.contains(templateId))) {
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
          if (promo == null || (promo.templateId!.isNotEmpty && !promo.templateId!.contains(templateId))) {
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

    if (selectedMerch != null) {
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

  Future<void> _handlePaymentMethodSelection(PaymentModel paymentMethod) async {
    if (invoice != null) {
      await _deleteInvoice();
    }
    // Set selected payment method
    setState(() {
      choosePaymentMethod = true;
      selectedPaymentMethod = paymentMethod;
    });
    // Create new invoice
    await _createInvoice(paymentMethod.type!);
  }

  changeMethod(String type) async {
    Map<String, dynamic> data = {};
    if (ebarimtOrgName.isNotEmpty) {
      data['ebarimtReceiver'] = orgRegNo.text;
    } else {
      data['ebarimtReceiver'] = '';
    }
    QpayInvoice? curInv = Provider.of<ProviderHold>(context, listen: false).getCurrentInvoice();
    print('curInv: ${curInv?.amt}');

    await Webservice()
        .loadPost(QpayInvoice.changeMethod, context, data, parameter: '${curInv == null ? invoice?.id : curInv.id}?method=$type')
        .then((response) async {
      invoice = response;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () async {
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

  Future<Map<String, dynamic>> buildBodyFromModel(QpayInvoice model) async {
    print('------------------------------->current model changed 1');

    await _deleteInvoice(holdInvoice: model);

    print('------------------------------->current model changed 2');
    final String? eventId = model.eventId;

    final List<Map<String, dynamic>> templates = [];

    if (model.templates != null) {
      for (final t in model.templates!) {
        if (t.templateId == null) continue;

        final dynamic seats = t.seats;

        templates.add({
          "templateId": t.templateId!,
          "seats": seats,
        });
      }
    }

    return {
      "templates": templates,
      "eventId": eventId,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>().getTheme();
    final loading = context.watch<ProviderCoreModel>().getLoading();

    return Selector<ProviderHold, QpayInvoice?>(
      selector: (_, provider) => provider.getCurrentInvoice(),
      builder: (context, current, child) {
        // current өөрчлөгдөх болгонд энэ builder дуудагдана
        if (current != null && !_isDeleting) {
          // UI render хийсний дараа async ажиллуулна
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _isDeleting = true; // 🚀 LOCK ON
            data = await buildBodyFromModel(current);
            _isDeleting = false; // 🔓 LOCK OFF
            if (mounted) setState(() {});
          });
        }
        return CustomScaffold(
          canPopWithSwipe: true,
          padding: EdgeInsets.zero,
          resizeToAvoidBottomInset: false,
          appBar: EmptyAppBar(
            context: context,
            backgroundColor: Colors.black,
          ),
          body: _buildMainContent(theme, loading),
        );
      },
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
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
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
                    if (selectedMerch == null)
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
                              )),
                          InkWell(
                              onTap: () async {
                                final List<String> allSeats =
                                    (data!["templates"] as List).expand((template) => template["seats"] as List<String>).toList();

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (_) => UsbPrinterBottomSheet(
                                    seats: allSeats,
                                    eventName: cyrtranslit.cyr2Lat(detail?.name ?? '', langCode: "mn"),
                                    eventDate: Func.toDateStr(detail?.startDate ?? DateTime.now().toString()),
                                  ),
                                );

                                // await printerService.printTicket(
                                //   seats: allSeats,
                                //   eventName: cyrtranslit.cyr2Lat(detail?.name ?? '', langCode: "mn"),
                                //   eventDate: Func.toDateStr(detail?.startDate ?? DateTime.now().toString()),
                                // );

                                // NavKey.navKey.currentState!.pushNamed(testPrintRoute, arguments: {
                                //   "name": cyrtranslit.cyr2Lat(detail?.name ?? '', langCode: "mn"),
                                //   "seats": allSeats,
                                //   "date": Func.toDateStr(detail?.startDate ?? DateTime.now().toString())
                                // });
                                // await _deleteInvoice();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 24),
                                width: 500,
                                padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white)),
                                child: Text(
                                  'Хэвлэх',
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
            )),
        const Expanded(
          child: HoldInvoiceScreen(),
        )
      ],
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return InkWell(
        onTap: () {
          Provider.of<ProviderHold>(context, listen: false).clearCurrentInvoice();
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



  // List<ApplePayItemDetail> _buildApplePayItems() {
  //   List<ApplePayItemDetail> applelist = [];

  //   // Add each ticket item
  //   for (int i = 0; i < data!['templates'].length; i++) {
  //     String label = _getTicketName(data!['templates'][i]['templateId']);
  //     int amt = _getTicketPrice(data!['templates'][i]['templateId'], data!['templates'][i]['seats'], promo: promoNo).toInt();

  //     applelist.add(ApplePayItemDetail(label: label, amount: amt.toDouble()));
  //   }

  //   // Add total
  //   num totalAmt = _totalAmtCalc(coupon: promoNo);
  //   applelist.add(ApplePayItemDetail(label: 'Total', amount: totalAmt.toDouble()));

  //   return applelist;
  // }

  // Future<void> _handleApplePay() async {
  //   // Validate requirements first
  //   if (selectedVatType == -1 && (detail?.ebarimt?.isNotEmpty ?? false)) {
  //     application.showToastAlert('НӨАТ сонгоно уу');
  //     return;
  //   }

  //   if (selectedVatType == 1 && ebarimtOrgName.isEmpty) {
  //     application.showToastAlert('Байгууллагын регистер ээ оруулна уу.');
  //     return;
  //   }

  //   // Delete existing invoice if any
  //   if (invoice != null) {
  //     await _deleteInvoice();
  //   }

  //   // Set selected payment method (Apple Pay)
  //   setState(() {
  //     choosePaymentMethod = true;
  //     selectedPaymentMethod = payMethodsList.firstWhere((method) => method.type == 'applepay');
  //   });

  //   // Create invoice
  //   await _createInvoice(selectedPaymentMethod!.type!);

  //   // Prepare Apple Pay
  //   List<ApplePayItemDetail> list = _buildApplePayItems();
  //   final token = await application.getAccessToken();
  //   Future.delayed(const Duration(seconds: 3), () async {
  //     await ApplePayHandler.initApplePay(orderId: invoice!.id!, items: list, token: token);
  //     await ApplePayHandler.presentApplePay();
  //   });
  //   // Initialize and present Apple Pay
  // }

