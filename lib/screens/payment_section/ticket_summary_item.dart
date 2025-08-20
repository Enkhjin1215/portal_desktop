import 'package:flutter/material.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class TicketSummaryItem extends StatelessWidget {
  final String name;
  final dynamic quantity;
  final num originalPrice;
  final num? discountedPrice;
  final ThemeData theme;

  const TicketSummaryItem({
    Key? key,
    required this.name,
    required this.quantity,
    required this.originalPrice,
    this.discountedPrice,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ticket name and price row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Ticket name and quantity
          RichText(
            text: TextSpan(
                text: '$name ',
                style: TextStyles.textFt14Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
                children: <TextSpan>[
                  TextSpan(
                    text: quantity is List<String> ? '' : 'x$quantity',
                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                  ),
                ]),
          ),

          // Ticket price
          Text(
            Func.toMoneyStr('$originalPrice'),
            style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
          ),
        ]),

        // Discount row (if applicable)
        if (discountedPrice != null && discountedPrice != originalPrice)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTranslated(context, 'promoCodeDiscount'),
                style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
              ),
              Text(
                '-${Func.toMoneyStr(originalPrice - discountedPrice!)}',
                style: TextStyles.textFt14Med.textColor(theme.colorScheme.discountColor),
              ),
            ],
          ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
