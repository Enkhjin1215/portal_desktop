import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/provider/theme_notifier.dart';

class CustomLoader extends StatelessWidget {
  final double? size;
  final bool? visible;

  const CustomLoader({Key? key, this.size, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return (visible ?? true)
        ? Center(
            child: SizedBox(
              height: size ?? MyDimens.loaderSize,
              width: size ?? MyDimens.loaderSize,
              child: CircularProgressIndicator(color: theme.colorScheme.primaryColor),
            ),
          )
        : Container();
  }
}

// ignore: non_constant_identifier_names
Widget CustomLoaderStack({
  required BuildContext context,
  required double height,
  required Widget child,
  bool visible = true,
}) {
  var widgetList = <Widget>[];

  if (visible) {
    widgetList.add(SizedBox(
      height: height,
      child: const Center(
        child: SizedBox(
          height: MyDimens.loaderSize,
          width: MyDimens.loaderSize,
          child: CircularProgressIndicator(),
        ),
      ),
    ));
  }

  widgetList.add(child);

  return Stack(children: widgetList);
}

// ignore: non_constant_identifier_names
Widget BlurLoadingContainer({
  required bool loading,
  required Widget child,
}) {
  var widgetList = <Widget>[child];

  if (loading) {
    Widget loadingContainer = Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.0,
          sigmaY: 1.0,
        ),
        child: const Center(
          child: SizedBox(
            height: MyDimens.loaderSize,
            width: MyDimens.loaderSize,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    widgetList.add(loadingContainer);
  }

  return Stack(children: widgetList);
}
