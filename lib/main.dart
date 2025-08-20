import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/nav_observer.dart';
import 'package:portal/language/app_localization.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_cart.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/provider_xo.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/app_router.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/popup/TicketPopup.dart';
import 'package:portal/service/firebase_notification.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GestureBinding.instance.resamplingEnabled = true;
  bool isDark = await application.getThemeType();
  final core = ProviderCoreModel();
  final List<Map<String, dynamic>> body = [];
  final cart = ProviderCart(body);
  final xo = ProviderXO([]);

  TicketPopup();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(isDark),
      ),
      ChangeNotifierProvider<ProviderCoreModel>(
        create: (_) => core,
      ),
      ChangeNotifierProvider<ProviderCart>(
        create: (_) => cart,
      ),
      ChangeNotifierProvider<ProviderXO>(
        create: (_) => xo,
      ),
    ],
    child: const MyHomePage(),
  ));
  configLoading();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyHomePageState? state = context.findAncestorStateOfType<_MyHomePageState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool sawBoarding;
  Locale _locale = const Locale('en', 'EN');
  final ScreenTimeObserver screenTimeObserver = ScreenTimeObserver();
  var theme = ValueNotifier(ThemeMode.dark);
  StreamSubscription<Uri>? _linkSubscription;
  // PushNotifManager pushNotifManager = PushNotifManager();

  @override
  void initState() {
    super.initState();
    // firebase();
    initDeepLinks();
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // firebase() async {
  //   var firebaseInit = await pushNotifManager.init();
  //   debugPrint('-------------------->MAIN:$firebaseInit -----------------------------------------------');
  // }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    if (uri.toString().contains("callback")) {
      // Handle sign-in redirect
      print("User signed in, handling callback...");
    } else if (uri.toString().contains("signout")) {
      // Handle sign-out redirect
      print("User signed out, handling signout...");
    }
  }

  void handleDeepLink(String link) {
    if (link.contains("callback")) {
      // Handle sign-in redirect
      print("User signed in, handling callback...");
    } else if (link.contains("signout")) {
      // Handle sign-out redirect
      print("User signed out, handling signout...");
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // Widget build(BuildContext context) {
  //   const appTitle = 'Flutter Speed Dial Example';
  //   return ValueListenableBuilder<ThemeMode>(
  //       valueListenable: theme,
  //       builder: (context, value, child) => MaterialApp(
  //             title: appTitle,
  //             home: MyPage(theme: theme),
  //             debugShowCheckedModeBanner: false,
  //             theme: ThemeData(
  //               brightness: Brightness.light,
  //               primaryColor: Colors.blue,
  //             ),
  //             darkTheme: ThemeData(
  //               brightness: Brightness.dark,
  //               primaryColor: Colors.lightBlue[900],
  //             ),
  //             themeMode: value,
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return DecoratedBox(
      decoration: const BoxDecoration(
          // image: DecorationImage(image: AssetImage(Assets.background), fit: BoxFit.cover),
          ),
      child: OverlaySupport(
          child: MaterialApp(
        // navigatorObservers: [screenTimeObserver],
        navigatorKey: NavKey.navKey,
        debugShowCheckedModeBanner: false,
        title: "Portal",
        theme: Provider.of<ThemeNotifier>(context, listen: true).getTheme(),
        locale: _locale,
        supportedLocales: const [
          Locale("en", "US"),
          Locale("mn", "MN"),
        ],
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppRouter.generatedRoute,
        initialRoute: onboardLogoRoute,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        builder: (BuildContext? context, Widget? child) {
          return FlutterEasyLoading(child: child);
        },
      )),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.spinningCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 45.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.white.withValues(alpha: 0.1)
    ..indicatorColor = Colors.orangeAccent
    ..textColor = Colors.transparent
    ..maskColor = Colors.transparent.withValues(alpha: 0.01)
    ..contentPadding = EdgeInsets.zero
    ..textPadding = EdgeInsets.zero
    ..userInteractions = true;

  //..customAnimation = CustomAnimation();
}
