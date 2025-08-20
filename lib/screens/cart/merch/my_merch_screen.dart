import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/merch/claim_certificate.dart';
import 'package:portal/screens/cart/merch/merch_list_model.dart';
import 'package:portal/screens/cart/popup/TicketPopup.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/service/ticket_list_requests.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class MyMerch extends StatefulWidget {
  const MyMerch({super.key});

  @override
  State<MyMerch> createState() => _MyMerchState();
}

class _MyMerchState extends State<MyMerch> {
  TicketListRequests ticketListRequests = TicketListRequests();
  bool isSelected = true;
  List<String> mongolz = [
    '6808d084058e2ab44fa292ad',
    '6808d862058e2ab44fa2936f',
    '6808d976058e2ab44fa293a7',
    '808da3d058e2ab44fa293c3',
    '6808dac6058e2ab44fa293da',
    '6808db7a058e2ab44fa293f6',
    '6846a8a58eb20ef783656b91',
    '685cc2fd4da2e0313c938ab0'
  ];
  @override
  void initState() {
    if (mounted) {
      ticketListRequests.getMerchList(context);
    }
    print('test');
    super.initState();
  }

  bool showCertificate(String id) {
    return mongolz.contains(id) && isSelected;
  }

  void _showMyDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => ClaimCertificate(
        merchId: id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool loading = Provider.of<ProviderCoreModel>(context, listen: true).getLoading();

    List<MyMerchModel>? list = Provider.of<ProviderCoreModel>(context, listen: true).getMyMerchList();

    // No tickets or loading state
    if (loading) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(5)),
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: theme.colorScheme.whiteColor,
          ),
        ),
      );
    }

    // Empty state
    if (list.isEmpty) {
      return Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = true;
                    ticketListRequests.getMerchList(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getTranslated(context, 'active'),
                    style: TextStyles.textFt14Med.textColor(
                      isSelected ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = false;
                    ticketListRequests.getUsedMerch(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: !isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: !isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getTranslated(context, 'used'),
                    style: TextStyles.textFt14Med.textColor(
                      !isSelected ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: ContainerTransparent(
                child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Center(
                    child: SvgPicture.asset(Assets.emptyTicket),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    getTranslated(context, 'noTickets'),
                    style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            )),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          )
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = true;
                  ticketListRequests.getMerchList(context);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite,
                    width: 1,
                  ),
                ),
                child: Text(
                  getTranslated(context, 'active'),
                  style: TextStyles.textFt14Med.textColor(
                    isSelected ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = false;
                  ticketListRequests.getUsedMerch(context);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: !isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: !isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite,
                    width: 1,
                  ),
                ),
                child: Text(
                  getTranslated(context, 'used'),
                  style: TextStyles.textFt14Med.textColor(
                    !isSelected ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 156 / 290,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                MyMerchModel merch = list[index];
                return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.colorScheme.blackColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 0.2)),
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(2), vertical: ResponsiveFlutter.of(context).hp(2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    merch.templateId.imageUrl.firstOrNull ??
                                        'https://cdn.cody.mn/img/276960/1920x0xwebp/DBR_9534.jpg?h=4ef1aa3a49ec22862e90935a08f476f976e741b4',
                                  ),
                                  fit: BoxFit.fill),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  merch.name,
                                  style: TextStyles.textFt16Bold.textColor(theme.colorScheme.neutral200),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                    height: 25,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: merch.merchItemId.attrs.length,
                                      itemBuilder: (context, index) {
                                        final entry = merch.merchItemId.attrs.entries.toList()[index];
                                        final value = entry.value;
                                        return Container(
                                          height: 40,
                                          margin: const EdgeInsets.only(right: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white, width: 0.2),
                                          ),
                                          child: Text(
                                            '$value',
                                            style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.8)),
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                              child: InkWell(
                            onTap: () {
                              TicketPopup.showCustomDialog(context,
                                  dismissType: true,
                                  title: "Дараах QR-г та эвентийн \nшалгагчид үзүүлэн мерч-ээ авна уу.",
                                  qr: 'merchant__${merch.qrText}',
                                  btnType: true,
                                  btnText: getTranslated(context, 'event_detail'),
                                  btnFunction: () {},
                                  mTheme: theme,
                                  eventID: null,
                                  ticket: null,
                                  noButton: true,
                                  showWallet: false);
                            },
                            child: Container(
                              height: 28,
                              width: 130,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6BE3D7),
                                    Color(0xFFEEA2F5),
                                    Color(0xFFF6CAB3),
                                  ],
                                  stops: [0, 0.5, 1],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'CLAIM',
                                  style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(
                            height: 8,
                          ),
                          showCertificate(merch.id)
                              ? InkWell(
                                  onTap: () {
                                    _showMyDialog(context, merch.id);
                                  },
                                  child: Center(
                                      child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 28,
                                    width: 130,
                                    child: Center(
                                      child: GradientText(
                                        getTranslated(context, 'getCert'),
                                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.blackColor),
                                      ),
                                    ),
                                  )))
                              : SizedBox()
                        ],
                      ),
                    ));
              }),
        ),
      ],
    );
  }
}
