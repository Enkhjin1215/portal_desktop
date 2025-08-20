import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/portal_featured/list_data.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  Event? event;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      event = args['event'];
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
        padding: EdgeInsets.zero,
        appBar: tittledAppBar(context: context, tittle: 'highlight', backShow: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.blackColor,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: event == null
                ? Center(
                    child: Text(
                      'Loading',
                      style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                      height: ResponsiveFlutter.of(context).hp(4),
                    ),
                    Text(
                      event!.name,
                      style: TextStyles.textFt24Bold.textColor(theme.colorScheme.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Portal.mn',
                          style: TextStyles.textFt18Reg.textColor(theme.colorScheme.whiteColor),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          DateFormat('MMMM d, y').format(event!.date),
                          style: TextStyles.textFt18Reg.textColor(theme.colorScheme.greyText),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CachedNetworkImage(
                      imageUrl: event!.coverImage,
                      height: 200,
                      width: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      event!.description,
                      style: TextStyles.textFt16Reg.textColor(theme.colorScheme.whiteColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: event!.gallery.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: CachedNetworkImage(
                                imageUrl: event!.gallery[index],
                                height: 200,
                                width: double.maxFinite,
                                errorWidget: (context, url, error) => const SizedBox.shrink()),
                          );
                        })
                  ]))));
  }
}
