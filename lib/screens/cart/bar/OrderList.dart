import 'package:flutter/material.dart';
import 'package:portal/screens/cart/bar/OrderItem.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

import '../../../helper/responsive_flutter.dart';
import '../../../helper/text_styles.dart';
import '../../../models/order_model.dart';
import '../../../provider/theme_notifier.dart';

class OrderListUI extends StatefulWidget {
  List<BarItems>? baritems;

  OrderListUI({super.key, required this.baritems});

  @override
  State<OrderListUI> createState() => _OrderListUIState();
}

class _OrderListUIState extends State<OrderListUI> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.baritems?.length,
      itemBuilder: (context, index) {
        return OrderItem(mBarItems: widget.baritems?[index], index: index);
      },
    );
  }


}
