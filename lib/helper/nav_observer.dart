import 'package:flutter/material.dart';

class ScreenTimeObserver extends NavigatorObserver {
  Map<String, Stopwatch> screenTimers = {};

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    String routeName = route.settings.name ?? '';
    screenTimers[routeName] = Stopwatch()..start();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    String routeName = route.settings.name ?? '';
    if (screenTimers.containsKey(routeName)) {
      screenTimers[routeName]!.stop();
      print('Screen time for $routeName: ${screenTimers[routeName]!.elapsed}');
    }
  }
}
