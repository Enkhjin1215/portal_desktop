import 'package:flutter/material.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class CountdownTimerComponent extends StatelessWidget {
  final Duration remainingTime;
  final bool? isError;

  const CountdownTimerComponent({
    Key? key,
    required this.remainingTime,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
        width: 186,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.white.withOpacity(0.3),
          //     spreadRadius: 1,
          //     blurRadius: 8,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Text(
          'Roll',
          style: TextStyles.textFt16Bold.textColor(Colors.black),
          textAlign: TextAlign.center,
        ));
  }
}
