import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/bar_item_model.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/provider_cart.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class EventBarScreen extends StatefulWidget {
  final EventDetail detail;

  const EventBarScreen({super.key, required this.detail});

  @override
  State<EventBarScreen> createState() => _EventBarScreenState();
}

class _EventBarScreenState extends State<EventBarScreen> {
  @override
  void initState() {
    init(widget.detail.id ?? '');
    super.initState();
  }

  init(String eventId) async {
    try {
      await Webservice().loadGet(Bar.getBar, context, parameter: eventId).then((response) {
        if (context.mounted) {
          Provider.of<ProviderCart>(context, listen: false).setBar(response);
          Provider.of<ProviderCart>(context, listen: false).setBarList(response.barList ?? []);
        }
      });
    } catch (e) {
      debugPrint('excep:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    List<BarItem> barList = Provider.of<ProviderCart>(context, listen: true).getBarList();
    Bar? bar = Provider.of<ProviderCart>(context, listen: true).getBar();
    return bar == null || barList.isEmpty
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
                      getTranslated(context, 'noBar'),
                      style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ))),
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
                      itemCount: barList.length,
                      itemBuilder: (context, index) {
                        return item(barList[index], theme, index, context, bar);
                      },
                    )),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          );
  }

  Widget item(BarItem item, ThemeData theme, int index, BuildContext context, Bar bar) {
    return InkWell(
        onTap: () async {
          int quant = Provider.of<ProviderCart>(context, listen: false).getQuant(bar.id ?? '', item.buffer!);
          print('quant:$quant');
          ModalAlert().barItemChoose(context: context, theme: theme, item: item, barId: bar.id ?? '', quant: quant);
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
                      imageUrl: item.image ?? 'https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg',
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
                              item.name!,
                              style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200),
                              maxLines: 1,
                            ),
                            Text(
                              item.itemType ?? '',
                              style: TextStyles.textFt12.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.5)),
                            ),
                            Text(Func.toMoneyStr(item.sellPrice!), style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200)),
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }
}
