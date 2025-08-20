import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCollaborate extends StatefulWidget {
  final EventDetail eventDetail;

  const EventCollaborate({super.key, required this.eventDetail});

  @override
  State<EventCollaborate> createState() => _EventCollaborateState();
}

class _EventCollaborateState extends State<EventCollaborate> {
  bool expandable = false;
  bool expanded = false;
  String getSocialImage(String type) {
    switch (type) {
      case 'instagram':
        return Assets.instagram;
      case 'facebook':
        return Assets.facebook;
      default:
        return Assets.instagram;
    }
  }

  @override
  void initState() {
    expandable = widget.eventDetail.collaborateList!.length > 3 ? true : false;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return widget.eventDetail.collaborateList!.isEmpty
        ? const SizedBox()
        : ContainerTransparent(
            duration: const Duration(seconds: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, 'artists'),
                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                ),
                const SizedBox(
                  height: 16,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.eventDetail.collaborateList!.length >= 3 ? 3 : widget.eventDetail.collaborateList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(2)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  width: 50,
                                  height: 50,
                                  widget.eventDetail.collaborateList![index].profileImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: theme.colorScheme.darkGrey),
                                      width: 50,
                                      height: 50,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.eventDetail.collaborateList![index].role!,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      style: TextStyles.textFt12Med.textColor(theme.colorScheme.fadedWhite),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.eventDetail.collaborateList![index].username!,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: widget.eventDetail.collaborateList![index].socials!.isNotEmpty,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    height: 24,
                                    width: widget.eventDetail.collaborateList![index].socials!.length * 30,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: widget.eventDetail.collaborateList![index].socials!.length,
                                        itemBuilder: (context, ind) {
                                          return InkWell(
                                              onTap: () {
                                                Uri uri = Uri.parse(widget.eventDetail.collaborateList![index].socials![ind].link!);
                                                launchUrl(uri);
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                margin: const EdgeInsets.only(right: 6),
                                                child: InkWell(
                                                  child: SvgPicture.asset(
                                                      getSocialImage(widget.eventDetail.collaborateList![index].socials![ind].type!)),
                                                ),
                                              ));
                                        }),
                                  )),
                            ],
                          ));
                    }),
                Visibility(
                    visible: expanded,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.eventDetail.collaborateList!.length > 3
                            ? widget.eventDetail.collaborateList!.sublist(3, widget.eventDetail.collaborateList!.length).length
                            : 0,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(2)),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      width: 50,
                                      height: 50,
                                      widget.eventDetail.collaborateList!.sublist(3, widget.eventDetail.collaborateList!.length)[index].profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.eventDetail.collaborateList!.sublist(3, widget.eventDetail.collaborateList!.length)[index].role!,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: TextStyles.textFt12Med.textColor(theme.colorScheme.fadedWhite),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          widget.eventDetail.collaborateList!.sublist(3, widget.eventDetail.collaborateList!.length)[index].username!,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: widget.eventDetail.collaborateList!
                                          .sublist(3, widget.eventDetail.collaborateList!.length)[index]
                                          .socials!
                                          .isNotEmpty,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        height: 24,
                                        width: widget.eventDetail.collaborateList!
                                                .sublist(3, widget.eventDetail.collaborateList!.length)[index]
                                                .socials!
                                                .length *
                                            30,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: widget.eventDetail.collaborateList!
                                                .sublist(3, widget.eventDetail.collaborateList!.length)[index]
                                                .socials!
                                                .length,
                                            itemBuilder: (context, ind) {
                                              return InkWell(
                                                  onTap: () {
                                                    Uri uri = Uri.parse(widget.eventDetail.collaborateList!
                                                        .sublist(3, widget.eventDetail.collaborateList!.length)[index]
                                                        .socials![ind]
                                                        .link!);
                                                    launchUrl(uri);
                                                  },
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    margin: const EdgeInsets.only(right: 6),
                                                    child: InkWell(
                                                      child: SvgPicture.asset(getSocialImage(widget.eventDetail.collaborateList!
                                                          .sublist(3, widget.eventDetail.collaborateList!.length)[index]
                                                          .socials![ind]
                                                          .type!)),
                                                    ),
                                                  ));
                                            }),
                                      )),
                                ],
                              ));
                        })),
                Visibility(
                    visible: expandable,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(context, expanded ? 'minimize' : 'seeAll'),
                                style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(
                                expanded ? Icons.arrow_upward : Icons.arrow_downward,
                                color: theme.colorScheme.whiteColor,
                              )
                            ],
                          ),
                        ))),
              ],
            ));
  }
}
