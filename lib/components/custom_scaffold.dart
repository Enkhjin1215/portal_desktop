import 'package:flutter/material.dart';
import 'package:portal/components/loader.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final VoidCallback? appBarOnPressedLeading;
  final Color? appBarLeadingColor;
  final Color? appBarLeadingBackgroundColor;
  final bool resizeToAvoidBottomInset;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;

  final bool loading;
  final bool? extendBodyBehindAppBar;
  final VoidCallback? onWillPop;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget body;
  final bool canPopWithSwipe;

  const CustomScaffold({
    Key? key,
    this.padding,
    this.backgroundColor,
    this.appBar,
    this.appBarOnPressedLeading,
    this.appBarLeadingColor,
    this.appBarLeadingBackgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = false,
    this.loading = false,
    this.extendBodyBehindAppBar = false,
    this.onWillPop,
    this.scaffoldKey,
    required this.body,
    this.canPopWithSwipe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themes = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    // bool isNeedSafeArea = MediaQuery.of(context).viewPadding.bottom > 20;
    double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;

    return canPopWithSwipe == true
        ? _popWithSwipeScaffold(context, themes)
        : WillPopScope(
            onWillPop: () async {
              return NavKey.navKey.currentState!.canPop() ? Future.value(true) : Future.value(false);
            },
            child: GestureDetector(
              onTap: () {
                Utils.hideKeyboard(context);
              },
              child: BlurLoadingContainer(
                loading: loading,
                child: Scaffold(
                  resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                  key: scaffoldKey,
                  extendBodyBehindAppBar: extendBodyBehindAppBar!,
                  backgroundColor: backgroundColor ?? themes.colorScheme.backgroundColor,
                  appBar: appBar ??
                      EmptyAppBar(
                        context: context,
                      ),
                  body:
                      // Stack(children: [
                      Container(
                    padding: padding ?? EdgeInsets.only(left: 24, right: 24, bottom: stdCutoutWidthDown >= 38 ? 20 : 0),
                    child: body,
                  ),
                  //   const IgnorePointer(
                  //       ignoring: true, // Prevents SnowFallAnimation from capturing touch events
                  //       child: SnowFallAnimation(
                  //         config: SnowfallConfig(
                  //           windForce: 5,
                  //           numberOfSnowflakes: 20,
                  //           speed: 1.0,
                  //           useEmoji: true,
                  //           holdSnowAtBottom: false,
                  //           customEmojis: ['❄️', '❅', '❆'],
                  //         ),
                  //       )),
                  // ]),
                  floatingActionButton: floatingActionButton,
                  floatingActionButtonLocation: floatingActionButtonLocation,
                  bottomNavigationBar: bottomNavigationBar,
                ),
              ),
            ),
          );
  }

  Widget _popWithSwipeScaffold(BuildContext context, ThemeData themes) {
    double stdCutoutWidthDown = MediaQuery.of(context).viewPadding.bottom;

    return GestureDetector(
      onTap: () {
        Utils.hideKeyboard(context);
      },
      child: BlurLoadingContainer(
        loading: loading,
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          key: scaffoldKey,
          extendBodyBehindAppBar: extendBodyBehindAppBar!,
          backgroundColor: backgroundColor ?? themes.colorScheme.whiteColor,
          appBar: appBar ??
              EmptyAppBar(
                context: context,
              ),
          body: Container(
            padding: padding ?? EdgeInsets.only(left: 24, right: 24, bottom: stdCutoutWidthDown >= 38 ? 20 : 0),
            child: body,
          ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
PreferredSize EmptyAppBar({
  required BuildContext context,
  Brightness brightness = Brightness.light,
  Color? backgroundColor,
  double elevation = 0.0,
}) {
  ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

  return PreferredSize(
      preferredSize: const Size.fromHeight(20), // here the desired height
      child: Container(color: theme.colorScheme.profileAppBar, child: SafeArea(child: SizedBox())));
}
