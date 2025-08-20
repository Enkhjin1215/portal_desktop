import 'package:flutter/material.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/portal_featured/list_data.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PortalListItem extends StatelessWidget {
  final Event event;
  const PortalListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    final width = ResponsiveFlutter.of(context).wp(80);

    return InkWell(
        onTap: () {
          NavKey.navKey.currentState!.pushNamed(portalFeaturedDetail, arguments: {'event': event});
        },
        child: Container(
          width: width,
          height: 400,
          margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).wp(4)),
          decoration: BoxDecoration(
            color: theme.colorScheme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.greyText.withOpacity(0.3), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top text section with padding
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: TextStyles.textFt20Bold.textColor(theme.colorScheme.whiteColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      event.description,
                      style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor.withOpacity(0.65)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Image section with left padding
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Image.network(
                    event.coverImage2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
