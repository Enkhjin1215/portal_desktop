import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/merch_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MerchDetail extends StatefulWidget {
  const MerchDetail({super.key});

  @override
  State<MerchDetail> createState() => _MerchDetailState();
}

class _MerchDetailState extends State<MerchDetail> {
  EventDetail? detail;
  Merchs? merch;
  bool _isLoading = true;
  Attribte? size;
  Attribte? color;
  Attribte? typeList;

  String selectedColor = '';
  String selectedSize = '';
  String selectedType = '';

  int quant = 0;
  Merch? selectedMerch;
  int selectedIndex = 0;
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      detail = args['event'];
      merch = args['merch'];
      init();

      setState(() {});
    }));
  }

  init() {
    if (merch == null) {
      _isLoading = false;
      setState(() {});

      return;
    }
    size = merch?.attributeList?.where((e) => e.nameEn!.toLowerCase() == 'size').firstOrNull;
    color = merch?.attributeList?.where((e) => e.nameEn!.toLowerCase() == 'color').firstOrNull;
    typeList = merch?.attributeList?.where((e) => e.nameEn!.toLowerCase() == 'type').firstOrNull;
    if (size != null) {
      selectedSize = size!.optionList!.first.value!;
    }
    if (color != null) {
      selectedColor = color!.optionList!.first.value!;
    }
    if (typeList != null) {
      selectedType = typeList!.optionList!.first.value!;
    }
    if (detail == null) {
      getMerchDetail();
    } else {
      _isLoading = false;
      setState(() {});
    }
  }

  getMerchDetail() async {
    try {
      await Webservice().loadGet(Merchs.singleMerch, context, parameter: '/${merch?.id}').then((response) {
        merch = response;
        selectedMerch = merch?.itemList?.firstOrNull;
        print('selected merch:${selectedMerch!.avail}');
        _isLoading = false;
        _controller.document = Document.fromJson(merch!.description);
        _controller.readOnly = true;

        setState(() {});
      });
    } catch (e) {
      debugPrint('e:$e');
    }
  }

  TextStyle getStyle(var attribute) {
    Attribute attr = attribute as Attribute;
    if (attr.key == 'color') {
      if (attr.value.toString().contains('#')) {
        Color color = Utils.hexToColor(attr.value.toString());
        return TextStyle(color: color);
      } else {
        return TextStyle(color: Utils.parseNamedColor(attr.value.toString()));
      }
    }

    return TextStyle(color: Colors.white);
  }

  Merch? selectedMerchFinder(String? color, String? size, String? type) {
    selectedMerch = merch?.itemList?.where((item) {
      final attrs = item.attrs;
      final activeFilters = {
        if (size != null && size.isNotEmpty) 'size': size,
        if (type != null && type.isNotEmpty) 'type': type,
        if (color != null && color.isNotEmpty) 'color': color,
      };

      if (activeFilters.isEmpty) return true;

      for (final entry in activeFilters.entries) {
        final attrValue = attrs[entry.key];
        if (attrValue == null || attrValue != entry.value) {
          return false;
        }
      }

      return true;
    }).firstOrNull;

    quant == selectedMerch?.avail;

    setState(() {});
    return selectedMerch;
  }

  String getSelectedMerch() {
    if (selectedMerch == null) {
      return '0';
    } else {
      int left = selectedMerch!.avail! - selectedMerch!.onHold!;
      if (left.isNegative) {
        return '0';
      } else {
        return '$left';
      }
    }
  }

  String getTotalPrice() {
    if (selectedMerch == null) {
      return '';
    } else if (quant == 0) {
      return '';
    } else {
      return '/${Func.toMoneyStr(quant * (merch?.priceList?.first.amt ?? 0))}/';
    }
  }

  createBody() {
    Map<String, dynamic> data = {};
    if (selectedMerch == null) {
      return;
    } else if (quant == 0) {
      return;
    } else {
      data['eventId'] = detail!.id;
      data['itemId'] = selectedMerch!.id;
      data['cnt'] = quant;
      NavKey.navKey.currentState
          ?.pushNamed(paymentCartRoute, arguments: {"detail": detail, 'data': data, 'from': 1, 'name': merch?.name ?? '', 'merch': selectedMerch});
    }
  }

  createZadgaiMerchBody() async {
    Map<String, dynamic> data = {};

    if (selectedMerch == null) {
      return;
    } else if (quant == 0) {
      return;
    } else {
      data['eventId'] = merch?.eventId['_id'];
      data['itemId'] = selectedMerch!.id;
      data['cnt'] = quant;
      data['lang'] = Provider.of<ProviderCoreModel>(context, listen: false).isEnglish ? 'en' : 'mn';
      EventDetail dumpDetail = await getEvent(merch?.eventId['_id']);

      Future.delayed(const Duration(seconds: 1), () {
        NavKey.navKey.currentState!.pushNamed(paymentRoute,
            arguments: {'data': data, 'event': dumpDetail, 'promo': '', 'ebarimt': '', 'selectedMerch': selectedMerch, 'merch': merch});
      });
    }
  }

  FutureOr<EventDetail> getEvent(String eventId) async {
    late EventDetail event;
    await Webservice().loadGet(EventDetail.eventDetail, context, parameter: eventId).then((response) {
      event = response;
    });
    return event;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.whiteColor,
                ),
              ),
            )
          : Container(
              width: ResponsiveFlutter.of(context).wp(100),
              height: ResponsiveFlutter.of(context).hp(120),
              decoration: detail == null
                  ? const BoxDecoration(
                      color: Colors.black,
                    )
                  : BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(detail!.coverImage!, scale: 1),
                          fit: BoxFit.fitHeight,
                          colorFilter: const ColorFilter.linearToSrgbGamma())),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.backgroundBlack.withValues(alpha: 0.6),
                  ),
                  child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              NavKey.navKey.currentState!.pop();
                            },
                            child: SvgPicture.asset(
                              Assets.backButton,
                              width: 48,
                              height: 48,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: theme.colorScheme.greyText,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.fadedWhite)),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        merch?.type ?? '',
                        style: TextStyles.textFt10Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      merch?.name ?? '',
                      style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GradientText(
                      Func.toMoneyStr(merch?.priceList?.first.amt ?? ''),
                      style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main Image
                        Container(
                          width: ResponsiveFlutter.of(context).wp(60),
                          height: ResponsiveFlutter.of(context).hp(35),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InteractiveViewer(
                                child: Image.network(
                              merch!.images![selectedIndex],
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Thumbnails
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(merch?.images?.length ?? 0, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedIndex == index ? Colors.white : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    merch!.images![index],
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (size != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            size?.name ?? '',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).wp(100),
                            height: 40,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: size!.optionList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    focusColor: Colors.transparent,
                                    onTap: () {
                                      selectedSize = size!.optionList![index].value!;
                                      selectedMerchFinder(selectedColor, selectedSize, selectedType);

                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 60,
                                      margin: const EdgeInsets.only(right: 8),
                                      // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: size!.optionList![index].value == selectedSize
                                              ? theme.colorScheme.whiteColor
                                              : theme.colorScheme.backgroundBlack,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: theme.colorScheme.fadedWhite)),
                                      child: Center(
                                        child: Text(
                                          size!.optionList![index].value ?? '',
                                          style: TextStyles.textFt14Bold.textColor(size!.optionList![index].value == selectedSize
                                              ? theme.colorScheme.blackColor
                                              : theme.colorScheme.whiteColor),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    if (color != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            color?.name ?? '',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).wp(100),
                            height: 30,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: color!.optionList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedColor = color!.optionList![index].value!;
                                      if (selectedSize != '') {
                                        selectedMerchFinder(selectedColor, selectedSize, selectedType);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 24,
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: selectedColor == color!.optionList![index].value
                                          ? const EdgeInsets.symmetric(vertical: 4, horizontal: 4)
                                          : EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                          color: theme.colorScheme.whiteColor,
                                          borderRadius: BorderRadius.circular(60),
                                          border: Border.all(color: theme.colorScheme.fadedWhite)),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        color: Utils.hexToColor(color!.optionList![index].value!),
                                        borderRadius: BorderRadius.circular(60),
                                      )),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    if (typeList != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            typeList?.name ?? '',
                            style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).wp(100),
                            height: 40,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: typeList!.optionList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    focusColor: Colors.transparent,
                                    onTap: () {
                                      selectedType = typeList!.optionList![index].value!;
                                      if (selectedType != '') {
                                        selectedMerchFinder(selectedColor, selectedSize, selectedType);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      // width: 60,
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: typeList!.optionList![index].value == selectedType
                                              ? theme.colorScheme.whiteColor
                                              : theme.colorScheme.backgroundBlack,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: theme.colorScheme.fadedWhite)),
                                      child: Center(
                                        child: typeList!.optionList![index].value == selectedType
                                            ? GradientText(
                                                typeList!.optionList![index].value ?? '',
                                                style: TextStyles.textFt14Bold,
                                              )
                                            : Text(
                                                typeList!.optionList![index].value ?? '',
                                                style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                                              ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (size != null)
                              Row(
                                children: [
                                  Text(
                                    "$selectedSize - ",
                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withValues(alpha: 0.6)),
                                  ),
                                  if (selectedColor != '')
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: Utils.hexToColor(selectedColor)),
                                    ),
                                  if (selectedType != '')
                                    GradientText(
                                      selectedType,
                                      style: TextStyles.textFt14Reg,
                                    ),
                                ],
                              ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '${getSelectedMerch()} ширхэг үлдсэн',
                              style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: theme.colorScheme.whiteColor.withValues(alpha: 0.1),
                                border: Border.all(color: theme.colorScheme.fadedWhite, width: 0.5),
                                borderRadius: BorderRadius.circular(24)),
                            child: Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: () {
                                    if (selectedMerch != null) {
                                      if (quant > 0) {
                                        quant--;
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.whiteColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(60)),
                                    child: SvgPicture.asset(Assets.minus),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '$quant',
                                  style: TextStyles.textFt18Med.textColor(theme.colorScheme.whiteColor),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: () {
                                    if (selectedMerch != null) {
                                      print('------------1');
                                      if (quant < int.parse(getSelectedMerch())) {
                                        quant++;
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.whiteColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(60)),
                                    child: SvgPicture.asset(Assets.add),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      getTranslated(context, 'event_detail'),
                      style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          border: const Border(left: BorderSide(color: Colors.white, width: 0.3)),
                          borderRadius: BorderRadius.circular(12)),
                      child: IgnorePointer(
                          ignoring: true,
                          child: QuillEditor.basic(
                            controller: _controller,
                            configurations: QuillEditorConfigurations(
                              scrollPhysics: NeverScrollableScrollPhysics(),
                              scrollable: false,
                              customStyleBuilder: getStyle,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ])))),
      floatingActionButton: IntrinsicHeight(
        child: CustomButton(
          // margin: EdgeInsets.zero,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          onTap: () async {
            detail == null ? createZadgaiMerchBody() : createBody();
          },
          text: '${getTranslated(context, 'buy')} ${getTotalPrice()}',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
