import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ApplePayButton extends StatelessWidget {
  final VoidCallback onTap;

  const ApplePayButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: double.maxFinite,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Buy with ',
              style: TextStyles.textFt18Bold.textColor(Colors.white),
            ),
            SvgPicture.asset(
              Assets.apple,
              color: Colors.white,
              width: 25,
              height: 25,
            ),
            Text(
              'Pay',
              style: TextStyles.textFt18Bold.textColor(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
