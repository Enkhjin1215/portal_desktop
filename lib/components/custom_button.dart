import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:portal/components/custom_text.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? contentColor;
  final Color? disabledContentColor;
  final bool isBordered;
  final Color? borderColor;
  final Color? textColor;
  final BorderRadius? bRadius;
  final String? assets;

  const CustomButton({
    Key? key,
    this.onTap,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.text,
    this.fontWeight,
    this.fontSize,
    this.contentColor,
    this.disabledContentColor,
    this.isBordered = false,
    this.borderColor,
    this.textColor,
    this.bRadius,
    this.assets,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<ProviderCoreModel>(context, listen: true).getLoading();
    ThemeData theme = Provider.of<ThemeNotifier>(context).getTheme();

    // Check if the keyboard is visible
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Get safe area insets
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Calculate appropriate bottom margin for all device types
    EdgeInsets effectiveMargin;
    if (widget.margin != null) {
      // Use custom margin if provided
      effectiveMargin = widget.margin!;
    } else if (isKeyboardVisible) {
      // No margin when keyboard is visible
      effectiveMargin = EdgeInsets.zero;
    } else {
      // When keyboard is not visible:
      // - Add 18px for normal spacing
      // - Add safe area padding to handle notches and navigation bars
      effectiveMargin = EdgeInsets.only(bottom: 18 + bottomPadding);
    }

    final ButtonStyle style = ElevatedButton.styleFrom(
      shadowColor: Colors.white,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.amber,
      disabledForegroundColor: loading ? Colors.white : Colors.grey,
      elevation: 0.0,
      side: BorderSide(color: widget.borderColor ?? Colors.transparent),
      shape: RoundedRectangleBorder(borderRadius: widget.bRadius ?? BorderRadius.circular(28)),
      backgroundColor: widget.backgroundColor ??
          (loading
              ? theme.colorScheme.whiteColor
              : widget.onTap != null
                  ? theme.colorScheme.whiteColor
                  : theme.colorScheme.colorGrey),
      disabledBackgroundColor: loading ? theme.colorScheme.whiteColor : widget.disabledBackgroundColor ?? theme.colorScheme.colorGrey,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutQuart,
      alignment: widget.alignment ?? Alignment.center,
      padding: EdgeInsets.zero,
      margin: effectiveMargin,
      width: widget.width ?? 199,
      height: widget.height ?? 52,
      child: ElevatedButton(
        onPressed: loading ? null : widget.onTap,
        style: style,
        child: _buildChild(theme, loading),
      ),
    );
  }

  Widget _buildChild(ThemeData theme, bool loading) {
    if (loading) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: theme.colorScheme.loadingIcon,
          size: 30,
        ),
      );
    } else if (widget.text == null) {
      return Container();
    } else if (widget.assets == null) {
      return CustomText(
        widget.text,
        color: widget.textColor ?? (widget.onTap != null ? theme.colorScheme.blackColor : theme.colorScheme.blackColor.withOpacity(0.5)),
        alignment: Alignment.center,
        fontSize: widget.fontSize ?? 16.0,
        fontWeight: widget.fontWeight ?? FontWeight.w700,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.assets!,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 8,
          ),
          CustomText(
            widget.text,
            color: widget.textColor ?? (widget.onTap != null ? theme.colorScheme.blackColor : theme.colorScheme.blackColor.withOpacity(0.5)),
            alignment: Alignment.center,
            fontSize: widget.fontSize ?? 16.0,
            fontWeight: widget.fontWeight ?? FontWeight.w700,
            lineSpace: 0,
          )
        ],
      );
    }
  }
}
