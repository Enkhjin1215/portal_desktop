import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';

class EventSponsor extends StatefulWidget {
  final EventDetail eventDetail;

  const EventSponsor({super.key, required this.eventDetail});

  @override
  State<EventSponsor> createState() => _EventSponsorState();
}

class _EventSponsorState extends State<EventSponsor> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return widget.eventDetail.sponsoreList!.isEmpty
        ? const SizedBox()
        : AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: ContainerTransparent(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, 'collaboretedOrgs'),
                  style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                ),
                const SizedBox(
                  height: 16,
                ),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: widget.eventDetail.sponsoreList!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              width: 72,
                              height: 72,
                              widget.eventDetail.sponsoreList![index].profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.eventDetail.sponsoreList![index].role!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor),
                          )
                        ],
                      );
                    })
              ],
            )));
  }
}
