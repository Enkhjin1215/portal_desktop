import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/merch_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class EventMerchScreen extends StatefulWidget {
  final EventDetail? eventDetail;
  const EventMerchScreen({super.key, this.eventDetail});

  @override
  State<EventMerchScreen> createState() => _EventMerchScreenState();
}

class _EventMerchScreenState extends State<EventMerchScreen> {
  int userType = -1;
  List<Merchs> merch = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    userType = await application.getUserType();
    getMerch(widget.eventDetail?.id ?? '');
  }

  getMerch(String eventId) async {
    try {
      await Webservice().loadGet(Merchs.getMerch, context, parameter: eventId).then((response) {
        merch = response;
        setState(() {});
      });
    } catch (e) {
      merch = [];
      debugPrint('e:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return merch.isEmpty
        ? Column(
            children: [
              IntrinsicHeight(
                child: ContainerTransparent(
                    child: Column(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 12,
                      child: Center(
                        child: SvgPicture.asset(Assets.emptyTicket),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        getTranslated(context, 'noMerch'),
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
                child: SizedBox(),
              )
            ],
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                    color: Colors.transparent,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 174 / 222,
                      ),
                      itemCount: merch.length,
                      itemBuilder: (context, index) {
                        return item(merch[index], theme, index, context);
                      },
                    )),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          );
  }

  Widget item(Merchs item, ThemeData theme, int index, BuildContext context) {
    return InkWell(
        onTap: () async {
          print(userType);
          if (userType < 2) {
            ModalAlert().login(
              context: context,
              theme: theme,
            );
          } else {
            NavKey.navKey.currentState!.pushNamed(merchDetailRoute, arguments: {'event': widget.eventDetail, 'merch': item});
          }
          // int quant = Provider.of<ProviderCart>(context, listen: false).getQuant(widget.bar!.id ?? '', item.buffer!);
          //   print('quant:$quant');
          //     ModalAlert().barItemChoose(context: context, theme: theme, item: item, barId: widget.bar!.id ?? '', quant: quant);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          height: 222,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                    elevation: 2,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: item.images?[0] ?? 'https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(image: NetworkImage('https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg'))),
                      ),
                    )
                    //  Image.network(
                    //   item.image ?? 'https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg',
                    //   fit: BoxFit.fill,
                    //   height: 170,
                    //   width: ResponsiveFlutter.of(context).wp(100),
                    // ),
                    ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: BlurryContainer(
                      elevation: 2,
                      blur: 2,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                      padding: EdgeInsets.zero,
                      width: double.maxFinite,
                      height: 88,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        height: 88,
                        color: Colors.transparent.withValues(alpha: 0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.type!,
                              style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200),
                              maxLines: 1,
                            ),
                            Text(
                              item.name ?? '',
                              style: TextStyles.textFt12Bold.textColor(theme.colorScheme.fadedWhite.withValues(alpha: 0.9)),
                            ),
                            Text(
                              Func.toMoneyStr(item.priceList?.first.amt ?? ''),
                              style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                            )
                            // Text(Func.toMoneyStr(item.sellPrice!), style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200)),
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }
}
