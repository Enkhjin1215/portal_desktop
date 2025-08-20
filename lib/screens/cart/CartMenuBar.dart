import 'package:flutter/material.dart';
import 'package:portal/language/language_constant.dart';
import 'package:provider/provider.dart';

import '../../helper/responsive_flutter.dart';
import '../../provider/theme_notifier.dart';

class CartMenuBar extends StatefulWidget {
  final Function(int) onItemSelected;

  CartMenuBar({required this.onItemSelected});

  @override
  _CartMenuBarState createState() => _CartMenuBarState();
}

class _CartMenuBarState extends State<CartMenuBar> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> options = [
    {'icon': Icons.confirmation_num, 'label': 'ticket'},
    {'icon': Icons.local_bar, 'label': 'bar'},
    {'icon': Icons.auto_awesome, 'label': 'merch'},
    {'icon': Icons.store, 'label': 'market'},
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(options.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onItemSelected(index);
          },
          child: Container(
            height: (ResponsiveFlutter.of(context).wp(100) - 100) / 4,
            width: (ResponsiveFlutter.of(context).wp(100) - 60) / 4,
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: selectedIndex == index ? theme.colorScheme.whiteColor : theme.colorScheme.backColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: selectedIndex == index
                  ? [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  options[index]['icon'],
                  color: selectedIndex == index ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  getTranslated(context, '${options[index]['label']}'),
                  style: TextStyle(
                    fontFamily: 'Zona Pro',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: selectedIndex == index ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
