import 'package:flutter/material.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/helper/text_styles.dart';

class EventSecondMarketScreen extends StatefulWidget {
  const EventSecondMarketScreen({super.key});

  @override
  State<EventSecondMarketScreen> createState() => _EventSecondMarketScreenState();
}

class _EventSecondMarketScreenState extends State<EventSecondMarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Second market',
          style: TextStyles.textFt22Bold.textColor(Colors.white),
        ),
      ),
    );
  }
}
