import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/coupon_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PromoCodeField extends StatelessWidget {
  final TextEditingController controller;
  final Promo? promoCode;
  final String errorMessage;
  final ThemeData theme;
  final Function() onCheckPromo;
  final Function() onClearPromo;
  final Function() onChangePromo;

  const PromoCodeField(
      {Key? key,
      required this.controller,
      required this.promoCode,
      required this.errorMessage,
      required this.theme,
      required this.onCheckPromo,
      required this.onClearPromo,
      required this.onChangePromo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated(context, 'insertPromo'),
          style: TextStyles.textFt16Med.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        // Promo code input field
        CustomTextField(
          textColor: promoCode != null ? Colors.black : Colors.white,
          hintText: getTranslated(context, 'promocode'),
          fillColor: promoCode == null ? Colors.transparent.withOpacity(0.1) : theme.colorScheme.discountColor.withOpacity(0.99),
          borderColor: promoCode == null ? Colors.white.withOpacity(0.3) : theme.colorScheme.discountColor,
          controller: controller,
          onChanged: (p0) {
            onChangePromo();
          },
          enable: true,
          tailingWidget: SizedBox(
            width: 86,
            child: InkWell(
              onTap: () {
                if (promoCode == null) {
                  onCheckPromo();
                } else {
                  onClearPromo();
                }
              },
              child: promoCode != null
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          Assets.exit,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ContainerTransparent(
                      margin: const EdgeInsets.all(4),
                      bRadius: 8,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          getTranslated(context, 'enter'),
                          style: TextStyles.textFt12Bold.textColor(theme.colorScheme.ticketDescColor.withOpacity(0.7)),
                        ),
                      ),
                    ),
            ),
          ),
        ),

        // Error message
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: TextStyles.textFt14Reg.textColor(Colors.red),
            ),
          ),
      ],
    );
  }
}
