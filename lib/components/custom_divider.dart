import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  final bool isHorizantol;
  const MySeparator({Key? key, this.height = 3, this.color = Colors.black, required this.isHorizantol}) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = isHorizantol ? constraints.constrainWidth() : 10;
        final boxHeight = constraints.constrainHeight();
        final dashWidth = isHorizantol ? 10.0 : 2.0;
        final dashHeight = isHorizantol ? height : 10.0;
        final dashCount = isHorizantol ? (boxWidth / (2 * dashWidth)).floor() : (boxHeight / (2 * dashHeight)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: isHorizantol ? Axis.horizontal : Axis.vertical,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: .5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
