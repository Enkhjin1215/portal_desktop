import 'package:flutter/material.dart';

import '../../../../components/custom_divider.dart';

class DashLine extends StatefulWidget {
  Color borderColor;

  DashLine({super.key, required this.borderColor});

  @override
  State<DashLine> createState() => _DashLineState();
}

class _DashLineState extends State<DashLine> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: 30,
              width: 15,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                border: Border(
                  left: BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: 30,
                width: 15,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                  border: Border(
                    right: BorderSide(
                      color: widget.borderColor,
                      width: 0.5,
                    ),
                    top: BorderSide(
                      color: widget.borderColor,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: widget.borderColor,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: MySeparator(color: widget.borderColor, isHorizantol: true)),
        Positioned(
          right: 0,
          child: Stack(
            children: [
              Container(
                height: 30,
                width: 15,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  height: 30,
                  width: 15,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: widget.borderColor,
                        width: 0.5,
                      ),
                      top: BorderSide(
                        color: widget.borderColor,
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: widget.borderColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
