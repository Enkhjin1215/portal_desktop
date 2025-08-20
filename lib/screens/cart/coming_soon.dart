import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ComingSoon extends StatefulWidget {
  final int index;
  const ComingSoon({super.key, required this.index});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

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
}
