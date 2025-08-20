import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/payment_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentModel paymentMethod;
  final VoidCallback onTap;
  final Color? textColor;
  final bool useBlackIconColor;
  final num totalAmt;

  const PaymentMethodItem({
    Key? key,
    required this.paymentMethod,
    required this.onTap,
    required this.totalAmt,
    this.textColor,
    this.useBlackIconColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return ((paymentMethod.min ?? 0) <= totalAmt)
        ? InkWell(
            onTap: paymentMethod.type != 'storepay'
                ? onTap
                : () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: theme.colorScheme.bottomNavigationColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              '',
                              style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                              textAlign: TextAlign.center,
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Storepay',
                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    getTranslated(context, 'phone'),
                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: TextEditingController(),
                                    keyboardType: TextInputType.phone,
                                    style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
                                    decoration: InputDecoration(
                                      hintText: getTranslated(context, 'insertContactNumber'),
                                      hintStyle: TextStyles.textFt14Med.textColor(theme.colorScheme.hintColor),
                                      filled: true,
                                      fillColor: theme.colorScheme.inputBackground,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: theme.colorScheme.darkGrey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Container(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: theme.colorScheme.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: () async {
                                    print('pressed');
                                  },
                                  child: Text(
                                    getTranslated(context, 'continuePayment'),
                                    style: TextStyles.textFt14Bold.textColor(theme.colorScheme.blackColor),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // color: Colors.white,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: paymentMethod.isSvg!
                          ? SvgPicture.asset(
                              paymentMethod.image!,
                            )
                          : Image.asset(paymentMethod.image!),
                    )),
                const SizedBox(height: 4),
                Text(
                  paymentMethod.name ?? "",
                  style: TextStyles.textFt12Bold.textColor(textColor ?? Colors.white),
                  maxLines: 1,
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
