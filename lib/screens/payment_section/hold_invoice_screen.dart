import 'package:flutter/material.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/invoice_model.dart';
import 'package:portal/provider/provider_hold_invoice.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/payment_section/payment_services.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class HoldInvoiceScreen extends StatefulWidget {
  const HoldInvoiceScreen({super.key});

  @override
  State<HoldInvoiceScreen> createState() => _HoldInvoiceScreenState();
}

class _HoldInvoiceScreenState extends State<HoldInvoiceScreen> {
  final PaymentService _paymentService = PaymentService();

  List<QpayInvoice> holdList = [];
  @override
  void initState() {
    holdInvoiceList();
    super.initState();
  }

  Future<void> holdInvoiceList() async {
    // holdList.clear();
    await Webservice().loadGet(QpayInvoice.getHoldList, context, parameter: '').then((response) async {
      if (context.mounted) {
        Provider.of<ProviderHold>(context, listen: false).setHoldList(response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Хүлээгдэж буй төлбөрүүд',
              style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                holdInvoiceList();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
                child: const Icon(
                  Icons.replay_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ProviderHold>(builder: (context, providerHold, child) {
                final holdList = providerHold.getHoldList();
                return ListView.builder(
                  itemCount: holdList.length,
                  itemBuilder: (context, index) {
                    final invoice = holdList[index];
                    bool isSelected = providerHold.getCurrentInvoice() != null ? invoice == providerHold.getCurrentInvoice() : false;
                    return Card(
                      color: isSelected ? Colors.green : Colors.white.withValues(alpha: 0.6),
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoice.invoicedesc ?? "No description",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text("Үнийн дүн: ${invoice.amt} MNT"),
                            const SizedBox(height: 4),
                            Text("Статус: ${invoice.qpay != null ? 'Pending' : 'Unknown'}"),
                            const SizedBox(height: 4),
                            if (invoice.createdAt != null) Text("Үүсгэсэн: ${DateTime.parse(invoice.createdAt!).toLocal()}"),
                            const SizedBox(height: 6),
                            if (invoice.templates != null)
                              Wrap(
                                spacing: 8,
                                children: invoice.templates!
                                    .map<Widget>((template) => Chip(
                                          label: Text(
                                            template.seats is List ? (template.seats as List).join(", ") : template.seats.toString(),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await _paymentService.deleteInvoice(context: context, invoiceId: invoice.id!);
                                    providerHold.deleteInvoice(invoice.id!);
                                    // holdInvoiceList();
                                  },
                                  child: Chip(
                                    backgroundColor: Colors.red,
                                    label: Text(
                                      'Цуцлах',
                                      style: TextStyles.textFt14Reg.textColor(Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    providerHold.setCurrentInvoice(invoice);
                                  },
                                  child: Chip(
                                    backgroundColor: Colors.green,
                                    label: Text(
                                      'Төлөх',
                                      style: TextStyles.textFt14Reg.textColor(Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
