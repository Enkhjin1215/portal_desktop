import 'package:flutter/material.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';

class MyNftScreen extends StatefulWidget {
  const MyNftScreen({super.key});

  @override
  State<MyNftScreen> createState() => _MyNftScreenState();
}

class _MyNftScreenState extends State<MyNftScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
        canPopWithSwipe: true,
        padding: EdgeInsets.zero,
        appBar: tittledAppBar(context: context, tittle: 'myNFTs', backShow: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.profileBackground,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(5),
              ),
              Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).hp(3), horizontal: ResponsiveFlutter.of(context).wp(3)),
                  child: Column(
                    children: [],
                  ))
            ])));
  }
}
