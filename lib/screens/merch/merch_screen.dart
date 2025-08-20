import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/merch_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class MerchScreen extends StatefulWidget {
  const MerchScreen({super.key});

  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {
  List<Merchs> merch = [];
  int userType = -1;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    userType = await application.getUserType();

    try {
      await Webservice().loadGet(Merchs.onlyMerchs, context, parameter: '?page=1&limit=20').then((response) {
        merch = response;
        setState(() {});
      });
    } catch (e) {
      merch = [];
      debugPrint('e:$e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
        padding: EdgeInsets.zero,
        // appBar: tittledAppBar(context: context, tittle: ''),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const BottomNavigation(
          currentMenu: 2,
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.blackColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                getTranslated(context, 'merchandise'),
                style: TextStyles.textFt24Bold.textColor(Colors.white),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(4),
              ),
              Expanded(
                child: Container(
                    color: Colors.transparent,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 174 / 270,
                      ),
                      itemCount: merch.length,
                      itemBuilder: (context, index) {
                        return item(merch[index], theme, index, context);
                      },
                    )),
              ),
            ])));
  }

  Widget item(Merchs item, ThemeData theme, int index, BuildContext context) {
    Attribte? color;
    color = item.attributeList?.where((e) => e.nameEn == 'color').firstOrNull;

    return InkWell(
        onTap: () async {
          print(userType);
          if (userType < 2) {
            ModalAlert().login(
              context: context,
              theme: theme,
            );
          } else {
            NavKey.navKey.currentState!.pushNamed(merchDetailRoute, arguments: {'merch': item});
          }
          // int quant = Provider.of<ProviderCart>(context, listen: false).getQuant(widget.bar!.id ?? '', item.buffer!);
          //   print('quant:$quant');
          //     ModalAlert().barItemChoose(context: context, theme: theme, item: item, barId: widget.bar!.id ?? '', quant: quant);
        },
        child: IntrinsicHeight(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
              color: theme.colorScheme.backgroundColor, border: Border.all(color: Colors.white, width: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Stack(children: [
                    CachedNetworkImage(
                      imageUrl: item.images?[0] ?? 'https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(image: NetworkImage('https://cdn.portal.mn/uploads/6da22fdb-1112-4f68-bf92-a870567b880e.jpeg'))),
                      ),
                    ),
                    color != null
                        ? Positioned(
                            bottom: 10,
                            left: (174 - (35 * double.parse(color.optionList?.length.toString() ?? '0'))) / 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                height: 35,
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: color.optionList?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            color: Utils.hexToColor(color!.optionList![index].value!),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: theme.colorScheme.fadedWhite)),
                                      );
                                    }),
                              ),
                            ))
                        : const SizedBox()
                  ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: 88,
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
                    GradientText(
                      Func.toMoneyStr(item.priceList?.first.amt ?? ''),
                      style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                    )
                    // Text(Func.toMoneyStr(item.sellPrice!), style: TextStyles.textFt15Bold.textColor(theme.colorScheme.neutral200)),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
