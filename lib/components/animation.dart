import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateX, translateY }

class MoveInAnimation extends StatelessWidget {
  final Widget child;

  // Duration
  final int duration; // Milliseconds
  final double? delay;

  // Position
  final bool isAxisHorizontal; // Animation horizontal, vertical
  final double? tweenStart;
  final double? tweenEnd;

  const MoveInAnimation({
    super.key,
    required this.child,
    this.duration = 500,
    this.delay,
    this.isAxisHorizontal = true,
    this.tweenStart,
    this.tweenEnd,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, 0.0.tweenTo(1.0), duration.milliseconds)
      ..add(
        isAxisHorizontal ? AniProps.translateX : AniProps.translateY,
        (tweenStart ?? -30.0).tweenTo(tweenEnd ?? 0.0),
        duration.milliseconds,
        Curves.easeOut,
      );

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (duration * (delay ?? 1)).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
          offset: Offset(
            isAxisHorizontal ? value.get(AniProps.translateX) : 0,
            isAxisHorizontal ? 0 : value.get(AniProps.translateY),
          ),
          child: child,
        ),
      ),
    );
  }
}

class FadeInAnimation extends StatelessWidget {
  final Widget child;

  // Duration
  final int duration; // Milliseconds
  final double? delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = 500,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()..add(AniProps.opacity, 0.0.tweenTo(1.0), duration.milliseconds);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (duration * (delay ?? 1)).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: child,
      ),
    );
  }
}
