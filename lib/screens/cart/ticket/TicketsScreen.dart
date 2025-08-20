import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/models/ticket_model.dart';
import 'package:portal/screens/cart/ticket/ticket_filter.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/ticket_list_requests.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/text_styles.dart';
import '../../../language/language_constant.dart';
import '../../../provider/provider_core.dart';
import '../../../provider/theme_notifier.dart';
import '../popup/TicketPopup.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int selectedFilter = 0; // 0: All, 1: Active, 2: Used, 3: Listed
  TicketListRequests ticketListRequests = TicketListRequests();

  @override
  void initState() {
    if (mounted) {
      ticketListRequests.getTicketList(context);
    }
    super.initState();
  }

  String imageUrl(String eventId, List<EventMetas>? eventMetas, {int type = 0}) {
    //type =  0 imageURL,
    //type = 1 ticketName

    String data = type == 0 ? 'https://cdn.cody.mn/img/276960/1920x0xwebp/DBR_9534.jpg?h=4ef1aa3a49ec22862e90935a08f476f976e741b4' : '';
    if (eventMetas != null) {
      for (var event in eventMetas) {
        if (event.sId == eventId) {
          if (type == 0) {
            data = event.coverImageV ?? data;
          } else if (type == 1) {
            data = event.name ?? "";
          }

          return data;
        }
      }
      return data;
    } else {
      return data;
    }
  }

  dynamic getStatus(Tickets tick, int type) {
    if (tick.isUsed == true) {
      if (type == 0) {
        return Colors.grey;
      } else {
        return 'USED';
      }
    } else if (tick.isListed == true) {
      if (type == 0) {
        return Colors.brown;
      } else {
        return 'LISTED';
      }
    } else {
      if (type == 0) {
        return Colors.green;
      } else {
        return 'ACTIVE';
      }
    }
  }

  // Filter tickets based on selected filter
  List<Tickets> filterTickets(List<Tickets> tickets) {
    if (selectedFilter == 0) {
      // All tickets
      return tickets;
    } else if (selectedFilter == 1) {
      // Active tickets
      return tickets.where((ticket) => !ticket.isUsed! && !ticket.isListed!).toList();
    } else if (selectedFilter == 2) {
      // Used tickets
      return tickets.where((ticket) => ticket.isUsed!).toList();
    } else {
      // Listed tickets
      return tickets.where((ticket) => ticket.isListed!).toList();
    }
  }

  void onFilterChanged(int filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  addToWallet(Tickets ticket) async {
    Map<String, dynamic> data = {};
    await Webservice().loadPost(Response.getWalletUri, context, data, parameter: '${ticket.id}/pass').then((response) {
      Uri uri = Uri.parse(response['url']);
      launchUrl(uri);
    });
  }

  ticketDivide(Tickets ticket) async {
    await Webservice().loadGet(Response.ticketDivide, context, parameter: '${ticket.id}').then((response) async {
      ticketListRequests.getTicketList(context);
      application.showToast('Амжилттай!');
      NavKey.navKey.currentState!.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool loading = Provider.of<ProviderCoreModel>(context, listen: true).getLoading();

    TicketList? ticketModel = Provider.of<ProviderCoreModel>(context, listen: true).getTicketList();

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
    if (ticketModel == null || ticketModel.item!.tickets!.isEmpty) {
      return Column(
        children: [
          const SizedBox(
            height: 40,
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

    // Filter tickets based on selection
    final filteredTickets = filterTickets(ticketModel.item!.tickets!);

    // Empty filtered state
    if (filteredTickets.isEmpty) {
      return Column(
        children: [
          // Filter chips
          TicketFilter(
            selectedFilter: selectedFilter,
            onFilterChanged: onFilterChanged,
          ),
          const SizedBox(height: 20),
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
                  Text(
                    selectedFilter == 1
                        ? getTranslated(context, 'noActiveTickets')
                        : selectedFilter == 2
                            ? getTranslated(context, 'noUsedTickets')
                            : getTranslated(context, 'noListedTickets'),
                    style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      getTranslated(context, 'noTickets'),
                      style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox())
        ],
      );
    }

    // Tickets grid view with filter
    return Column(
      children: [
        // Filter chips
        TicketFilter(
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged,
        ),

        // Tickets grid
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 156 / 232,
              ),
              itemCount: filteredTickets.length,
              itemBuilder: (context, index) {
                Tickets ticket = filteredTickets[index];
                return InkWell(
                    onTap: () {
                      if (ticket.templateId?.seatCnt != null && ticket.isDivided! == false) {
                        TicketPopup.showDivideDialog(context, dismissType: true, btnFunction: () {
                          ticketDivide(ticket);
                        }, mTheme: theme);
                      } else {
                        TicketPopup.showCustomDialog(context,
                            dismissType: true,
                            title: "Дараах QR-г та эвентийн \nшалгагчид үзүүлэн нэвтэрнэ үү.",
                            qr: 'ticket__${ticket.qrText}',
                            btnType: true,
                            btnText: getTranslated(context, 'event_detail'), btnFunction: () {
                          addToWallet(ticket);
                        }, mTheme: theme, eventID: ticket.eventId!, ticket: ticket);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: theme.colorScheme.backgroundColor, borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(2), vertical: ResponsiveFlutter.of(context).hp(2)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl(ticket.eventId!, ticketModel.item?.eventMetas, type: 0),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        margin: const EdgeInsets.only(right: 8, top: 8),
                                        decoration: BoxDecoration(color: getStatus(ticket, 0), borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          getStatus(ticket, 1),
                                          style: TextStyles.textFt10.textColor(Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: theme.colorScheme.backgroundColor,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ticket.templateId?.name ?? 'null',
                                  style: TextStyles.textFt16Bold.textColor(theme.colorScheme.neutral200),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "@${ticketModel.item?.username ?? 'null'}",
                                      style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.5)),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Visibility(
                                        visible: ticket.type == 'vip',
                                        child: Tooltip(
                                          message: 'VIP',
                                          child: Icon(
                                            Icons.table_bar,
                                            color: Colors.white.withValues(alpha: 0.7),
                                          ),
                                        )),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                                const SizedBox(height: 8)
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              }),
        ),
      ],
    );
  }

  // Future<void> _downloadQRImage(String qr) async {
  //   try {
  //     if (await _requestPermission(Permission.storage)) {
  //       final qrValidationResult = QrValidator.validate(
  //         data: qr,
  //         version: QrVersions.auto,
  //         errorCorrectionLevel: QrErrorCorrectLevel.L,
  //       );

  //       if (qrValidationResult.status == QrValidationStatus.valid) {
  //         final qrCode = qrValidationResult.qrCode;
  //         final painter = QrPainter.withQr(
  //           qr: qrCode!,
  //           color: const Color(0xFF000000),
  //           emptyColor: const Color(0xFFFFFFFF),
  //           gapless: false,
  //         );

  //         final picData = await painter.toImageData(2048);
  //         final directory = await getTemporaryDirectory();
  //         final filePath = '${directory.path}/qr_code.png';
  //         final file = File(filePath);

  //         await file.writeAsBytes(picData!.buffer.asUint8List());

  //         final galleryPath = await _getGalleryPath();
  //         final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //         final newFilePath = '$galleryPath/QR_Code_$timestamp.png';
  //         final newFile = await file.copy(newFilePath);

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('QR Code saved to gallery!')),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Invalid QR Code data.')),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Storage permission is required to save QR Code.')),
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred while saving the QR Code.')),
  //     );
  //   }
  // }

  // Future<bool> _requestPermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     return result == PermissionStatus.granted;
  //   }
  // }

  // Future<String> _getGalleryPath() async {
  //   final directory = await getExternalStorageDirectory();
  //   final galleryPath = '${directory!.path}/DCIM/Camera';
  //   final galleryDir = Directory(galleryPath);
  //   if (!await galleryDir.exists()) {
  //     await galleryDir.create(recursive: true);
  //   }
  //   return galleryPath;
  // }
}
