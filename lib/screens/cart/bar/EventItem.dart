import 'package:flutter/material.dart';
import 'package:portal/screens/cart/bar/OrderList.dart';
import 'package:portal/screens/cart/ticket/ticketShape/GradientBadge.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import '../../../components/custom_divider.dart';
import '../../../helper/responsive_flutter.dart';
import '../../../helper/text_styles.dart';
import '../../../models/order_model.dart';
import '../../../provider/theme_notifier.dart';

class EventItem extends StatelessWidget {
  final String imageUrl;
  final String badgeText;
  final String title;
  final String date;
  List<BarItems>? baritems;

  EventItem({super.key, required this.imageUrl, required this.badgeText, required this.title, required this.date, required this.baritems});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    print('imageURL:$imageUrl');
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 20, left: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.backColor,
            width: .5,
          ),
          left: BorderSide(
            color: theme.colorScheme.backColor,
            width: .5,
          ),
          right: BorderSide(
            color: theme.colorScheme.backColor,
            width: .5,
          ),
          bottom: BorderSide(
            color: theme.colorScheme.backColor,
            width: .5,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              (imageUrl != "")
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(height: 80, width: 80, color: Colors.blue),
              const SizedBox(width: 20),
              Container(
                width: ResponsiveFlutter.of(context).wp(46),
                margin: const EdgeInsets.only(right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientBadge(
                      text: badgeText,
                    ),
                    Text(
                      title,
                      style: TextStyles.textFt20Bold.textColor(Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.textFt18Med.textColor(Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
              margin: const EdgeInsets.only(top: 25, left: 10, right: 10),
              child: MySeparator(color: theme.colorScheme.backColor, isHorizantol: true)),
          const SizedBox(height: 20),
          if (baritems?.isNotEmpty == true) OrderListUI(baritems: baritems)
        ],
      ),
    );
  }
}
