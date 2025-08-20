import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double width;
  final Color color;

  const DottedDivider({
    Key? key,
    this.width = 1.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;

        return Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            (maxHeight ~/ (width * 2)).clamp(1, double.infinity).toInt(),
            (index) => Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
