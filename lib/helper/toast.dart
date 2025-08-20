import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final bool isAlert;
  final bool isConn;

  const CustomToast({
    Key? key,
    this.message = '',
    this.isAlert = false,
    this.isConn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      child: GestureDetector(
          onTapDown: (va) {
            OverlaySupportEntry.of(context)?.dismiss();
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(8),
              ),
              Container(
                width: 327,
                // height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    color: isAlert ? theme.colorScheme.toastWarningColor : theme.colorScheme.toastGreenColor,
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(
                    //   isAlert ? Icons.warning : Icons.check_circle,
                    //   color: theme.colorScheme.whiteColor,
                    // ),
                    Expanded(
                      child: Text(
                        message,
                        // maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                      ),
                    )
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
