import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal/provider/theme_notifier.dart';

enum CustomTextStyle {
  Caption, // 12.0
  Normal, // 14.0
  Medium, // 16.0
  Large, // 18.0
  Headline6, // 20.0
  Headline5, // 24.0
}

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  /// Main
  final String? text;
  final CustomTextStyle style;

  /// Box constraint arguments
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Alignment? alignment;

  /// Text arguments
  final Color? color;
  final Color? bgColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? softWrap;
  final int? maxLines;
  final double? lineSpace;
  TextAlign? textAlign;
  final TextOverflow? overflow;
  // final String? fontFamily;
  final FontStyle fontStyle;
  final bool underlined;
  final Color? underlineColor;
  final BoxBorder? border;
  CustomText(
    this.text, {
    super.key,
    this.style = CustomTextStyle.Normal,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.alignment,
    this.color,
    this.bgColor,
    this.fontSize = 13,
    this.fontWeight,
    this.softWrap,
    this.maxLines,
    this.lineSpace,
    this.textAlign,
    this.overflow,
    this.fontStyle = FontStyle.normal,
    // this.fontFamily = FontAsset.SFProRounded,
    this.underlined = false,
    this.underlineColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    if (alignment == Alignment.center) textAlign = TextAlign.center;

    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment ?? Alignment.centerLeft,
      decoration: BoxDecoration(
        border: border,
      ),
      child: Text(
        text ?? '',
        softWrap: softWrap ?? true,
        maxLines: maxLines ?? 1,
        textAlign: textAlign ?? TextAlign.start,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          letterSpacing: 0,
          color: color ?? _color(theme),
          fontSize: fontSize ?? _fontSize(),
          fontWeight: fontWeight ?? _fontWeight(),
          height: lineSpace,
          backgroundColor: bgColor,
          fontStyle: fontStyle,
          fontFamily: 'Zona Pro',
          decoration: underlined ? TextDecoration.underline : null,
          decorationColor: underlineColor ?? _underlineColor(theme),
          decorationThickness: 1,
        ),
      ),
    );
  }

  double _fontSize() {
    return 16;
  }

  Color? _color(ThemeData theme) {
    switch (style) {
      default:
        return theme.colorScheme.blackColor;
    }
  }

  Color? _underlineColor(ThemeData theme) {
    switch (style) {
      default:
        return theme.colorScheme.blackColor;
    }
  }

  FontWeight _fontWeight() {
    switch (style) {
      default:
        return fontWeight ?? FontWeight.normal;
    }
  }
}
