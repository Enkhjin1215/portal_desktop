import 'package:flutter/material.dart';

class ContainerTransparent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? bRadius;
  final EdgeInsetsGeometry? margin;
  final Duration? duration;
  final double opacity;
  final double? width;
  const ContainerTransparent(
      {super.key, required this.child, this.padding, this.bRadius, this.margin, this.duration, this.opacity = 0.1, this.width});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? Duration.zero,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        width: width ?? double.maxFinite,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: opacity), borderRadius: BorderRadius.circular(bRadius ?? 24)),
        child: child,
      ),
    );
  }
}
