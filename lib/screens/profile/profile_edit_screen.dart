import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String email = '';
  String username = 'null';
  String token = '';
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    email = await application.getEmail();
    token = await application.getAccessToken() ?? '';
    Map<String, dynamic> data = JwtDecoder.decode(token);
    username = data['username'] ?? '';
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      canPopWithSwipe: true,
      padding: EdgeInsets.zero,
      appBar: tittledAppBar(context: context, tittle: 'account_settings', backShow: true),
      resizeToAvoidBottomInset: false,
      body: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.profileBackground,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(5),
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).hp(3), horizontal: ResponsiveFlutter.of(context).wp(3)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          getTranslated(context, 'username'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          username,
                          textAlign: TextAlign.end,
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.75)),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getTranslated(context, 'email'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.75)),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getTranslated(context, 'phone'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            '---- ----',
                            style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor.withValues(alpha: 0.75)),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
      floatingActionButton: InkWell(
          onTap: () {
            NavKey.navKey.currentState!.pushNamed(profileDeleteRoute);
          },
          child: Container(
            // height: 60,
            width: double.maxFinite,
            margin: EdgeInsets.only(bottom: 30, right: ResponsiveFlutter.of(context).wp(4), left: ResponsiveFlutter.of(context).wp(4)),
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveFlutter.of(context).hp(1.8),
            ),
            decoration:
                BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(16)),
            child: Text(
              getTranslated(context, 'deleteAccount'),
              style: TextStyles.textFt15Bold.textColor(Colors.red),
              textAlign: TextAlign.center,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
