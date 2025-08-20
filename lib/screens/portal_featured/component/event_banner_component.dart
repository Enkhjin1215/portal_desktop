import 'package:flutter/material.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/portal_featured/component/cs-event-model.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class EventBannerComponent extends StatelessWidget {
  final CSGOCase csgoCase;
  const EventBannerComponent({Key? key, required this.csgoCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(csgoCase.bannerImageUrl!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern or image would go here
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${csgoCase.name}',
                  style: TextStyles.textFt18Bold.textColor(Colors.white),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Text(
                  getTranslated(context, 'endDate'),
                  style: TextStyles.textFt14Reg.textColor(Colors.white),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Func.toDateStr(csgoCase.endDate ?? ''),
                      style: TextStyles.textFt12Bold.textColor(Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CS:GO logo or icon (positioned on the right)
        ],
      ),
    );
  }
}
