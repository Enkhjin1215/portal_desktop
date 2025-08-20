import 'package:flutter/material.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ProfileDelete extends StatefulWidget {
  const ProfileDelete({super.key});

  @override
  State<ProfileDelete> createState() => _ProfileDeleteState();
}

class _ProfileDeleteState extends State<ProfileDelete> {
  delete() async {
    await Webservice()
        .loadGet(
      Response.checkAccount,
      context,
    )
        .then((response) async {
      deleteFinal();
    });
  }

  deleteFinal() async {
    await Webservice()
        .loadDelete(
      Response.deleteAccount,
      context,
    )
        .then((response) async {
      await Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
      NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
    });
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      canPopWithSwipe: true,
      padding: EdgeInsets.zero,
      appBar: tittledAppBar(context: context, tittle: 'deleteAccount', backShow: true),
      resizeToAvoidBottomInset: false,
      body: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.profileBackground,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(5),
              ),
              Text(
                getTranslated(context, 'delete_this_account'),
                style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(3),
              ),
              Text(
                getTranslated(context, 'delete_caution'),
                style: TextStyles.textFt16Bold.textColor(theme.colorScheme.greyText),
              ),
            ],
          )),
      floatingActionButton: IntrinsicHeight(
          child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black;
                    }
                    return Colors.white;
                  }),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 1.0, color: isChecked ? Colors.black : Colors.white),
                  ),
                  checkColor: Colors.black,
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                  }),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  getTranslated(context, 'delete_check'),
                  style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                ),
              )
            ],
          ),
          SizedBox(
            height: ResponsiveFlutter.of(context).hp(2),
          ),
          InkWell(
              onTap: !isChecked
                  ? null
                  : () {
                      delete();
                      // NavKey.navKey.currentState!.pushNamed(profileDeleteRoute);
                    },
              child: Container(
                // height: 60,
                width: double.maxFinite,
                margin: EdgeInsets.only(bottom: 30, right: ResponsiveFlutter.of(context).wp(4), left: ResponsiveFlutter.of(context).wp(4)),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveFlutter.of(context).hp(1.8),
                ),
                decoration: BoxDecoration(
                    color: Colors.transparent, border: Border.all(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(16)),
                child: Text(
                  getTranslated(context, 'delete'),
                  style: TextStyles.textFt15Bold.textColor(Colors.red),
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
