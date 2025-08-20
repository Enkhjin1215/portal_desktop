import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool enable;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? hintText;
  final TextInputType? inputType;
  final FocusNode? focusNode;
  final bool obscureText;
  final Color? fillColor;
  final Function(bool)? onFocusChanged;
  final Widget? tailingWidget;
  final Color? borderColor;
  final Function(String)? onChanged;
  final VoidCallback? onDone;

  final Color? textColor;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.enable = true,
      this.inputFormatters,
      this.maxLength,
      this.hintText,
      this.inputType,
      this.focusNode,
      this.obscureText = false,
      this.onFocusChanged,
      this.fillColor,
      this.tailingWidget,
      this.borderColor,
      this.onChanged,
      this.onDone,
      this.textColor});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode? _focusNode;

  bool _isObscure = false;

  late TextEditingController _controller;
  @override
  void initState() {
    _isObscure = widget.obscureText;

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller;
    _focusNode!.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_focusNode!.hasFocus);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return TextFormField(
      onEditingComplete: widget.onDone,
      obscureText: _isObscure,
      focusNode: widget.focusNode,
      enabled: widget.enable,
      controller: widget.controller,
      keyboardType: widget.inputType ?? TextInputType.emailAddress,
      inputFormatters: widget.inputFormatters,
      cursorColor: Colors.white,
      onChanged: widget.onChanged,
      style: TextStyles.textFt14Reg.textColor(widget.textColor ?? Colors.white),
      obscuringCharacter: '●',
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 20,
        ),
        fillColor: widget.fillColor ?? theme.colorScheme.softBlack,
        filled: true,
        hintStyle: TextStyles.textFt14Reg.textColor(theme.colorScheme.hintColor),
        hintText: widget.hintText,
        counterText: '',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.borderColor ?? theme.colorScheme.inputBackground)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.borderColor ?? theme.colorScheme.inputBackground)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.colorGrey)),
        suffixIcon: widget.obscureText
            ? Container(
                height: 24,
                width: 24,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    _isObscure = !_isObscure;
                    setState(() {});
                  },
                  child: SvgPicture.asset(
                    !_isObscure ? Assets.eyesOn : Assets.eyesOff,
                    height: 24,
                    width: 24,
                    color: theme.colorScheme.whiteColor,
                  ),
                ),
              )
            : widget.tailingWidget ??
                const SizedBox(
                  width: 24,
                  height: 24,
                ),
      ),
      maxLength: widget.maxLength ?? 60,
    );
  }
}
