import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal/helper/assets.dart';

class NeumorphismIcon extends StatelessWidget {
  final int type;
  const NeumorphismIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: SvgPicture.asset(
        type == 0
            ? Assets.login
            : type == 1
                ? Assets.email
                : Assets.register,
        width: 50,
        height: 50,
      ),
    );
  }
}
