// import 'dart:io';

// import 'package:app_settings/app_settings.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/service/firebase_notification.dart';
// import 'package:provider/provider.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';
// import 'package:portal/components/custom_button.dart';
// import 'package:portal/components/custom_scaffold.dart';
// import 'package:portal/components/neumorphism_icon.dart';
// import 'package:portal/helper/assets.dart';
// import 'package:portal/helper/constant.dart';
// import 'package:portal/helper/responsive_flutter.dart';
// import 'package:portal/helper/text_styles.dart';
// import 'package:portal/language/language_constant.dart';
// import 'package:portal/provider/theme_notifier.dart';
// import 'package:portal/router/route_path.dart';

// class NotifPermission extends StatefulWidget {
//   const NotifPermission({super.key});

//   @override
//   State<NotifPermission> createState() => _NotifPermissionState();
// }

// class _NotifPermissionState extends State<NotifPermission> with TickerProviderStateMixin {
//   late AnimationController _backgroundController;
//   late Animation<Offset> _backgroundAnimation;

//   late AnimationController _itemController;
//   late Animation<Offset> _itemAnimation;

//   late AnimationController _item2Controller;
//   late Animation<Offset> _item2Animation;

//   late AnimationController _item3Controller;
//   late Animation<Offset> _item3Animation;

//   late AnimationController _textController;
//   late Animation<double> _textAnimation;
//   int userType = 0;
//   PushNotifManager pushNotifManager = PushNotifManager();

//   @override
//   void initState() {
//     super.initState();
//     init();
//     _backgroundController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _backgroundAnimation = Tween<Offset>(
//       begin: const Offset(0.0, -1.0), // Offscreen top
//       end: const Offset(0.0, 0.0), // Center middle
//     ).animate(CurvedAnimation(
//       parent: _backgroundController,
//       curve: Curves.easeInOut,
//     ));
//     _backgroundController.forward();
//     _itemController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _itemAnimation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0), // Offscreen right
//       end: const Offset(0.0, 0.0), // Center middle
//     ).animate(CurvedAnimation(
//       parent: _itemController,
//       curve: Curves.easeInOut,
//     ));
//     _itemController.forward();

//     _item2Controller = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//     _item2Animation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0), // Offscreen right
//       end: const Offset(0.0, 0.0), // Center middle
//     ).animate(CurvedAnimation(
//       parent: _item2Controller,
//       curve: Curves.easeInOut,
//     ));
//     _item2Controller.forward();

//     _item3Controller = AnimationController(
//       duration: const Duration(milliseconds: 2500),
//       vsync: this,
//     );
//     _item3Animation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0), // Offscreen right
//       end: const Offset(0.0, 0.0), // Center middle
//     ).animate(CurvedAnimation(
//       parent: _item3Controller,
//       curve: Curves.easeInOut,
//     ));
//     _item3Controller.forward();
//     _textController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _textAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_textController);
//     _textController.forward();
//   }

//   init() async {
//     userType = await application.getUserType();
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _backgroundController.dispose();
//     _item2Controller.dispose();
//     _item3Controller.dispose();
//     _itemController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     return CustomScaffold(
//         padding: EdgeInsets.zero,
//         // appBar: customAppBar(context),
//         resizeToAvoidBottomInset: false,
//         body: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             width: ResponsiveFlutter.of(context).wp(100),
//             height: ResponsiveFlutter.of(context).hp(100),
//             color: theme.colorScheme.backgroundColor,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               SizedBox(
//                 height: ResponsiveFlutter.of(context).hp(6),
//               ),
//               const NeumorphismIcon(
//                 type: 0,
//               ),
//               SizedBox(
//                 height: ResponsiveFlutter.of(context).hp(4),
//               ),
//               FadeTransition(
//                   opacity: _textAnimation,
//                   child: Text(
//                     getTranslated(context, 'turnOnNotification'),
//                     style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
//                   )),
//               const SizedBox(
//                 height: 8,
//               ),
//               FadeTransition(
//                   opacity: _textAnimation,
//                   child: Text(
//                     getTranslated(context, 'getAllEventInfo'),
//                     style: TextStyles.textFt16Reg.textColor(theme.colorScheme.greyText),
//                   )),
//               const SizedBox(
//                 height: 16,
//               ),
//               Stack(
//                 children: [
//                   SlideTransition(
//                       position: _backgroundAnimation,
//                       child: Center(
//                         child: Image.asset(
//                           Assets.phoneBackground,
//                           // color: Colors.purple,
//                         ),
//                       )),
//                   Column(
//                     children: [
//                       SlideTransition(
//                           position: _itemAnimation,
//                           child: Container(
//                             margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
//                             height: ResponsiveFlutter.of(context).hp(7),
//                             width: double.maxFinite,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 image: const DecorationImage(image: AssetImage(Assets.notification), fit: BoxFit.fitWidth)),
//                           )),
//                       SlideTransition(
//                         position: _item2Animation,
//                         child: Container(
//                           margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//                           height: ResponsiveFlutter.of(context).hp(7),
//                           width: double.maxFinite,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               image: const DecorationImage(image: AssetImage(Assets.notification2), fit: BoxFit.fitWidth)),
//                         ),
//                       ),
//                       SlideTransition(
//                           position: _item3Animation,
//                           child: Container(
//                             margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//                             height: ResponsiveFlutter.of(context).hp(7),
//                             width: double.maxFinite,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               image: const DecorationImage(image: AssetImage(Assets.notification2), fit: BoxFit.fitWidth),
//                             ),
//                           ))
//                     ],
//                   )
//                 ],
//               ),
//               const Expanded(
//                 child: SizedBox(),
//               ),
//               Center(
//                 child: CustomButton(
//                   width: 332,
//                   alignment: Alignment.bottomCenter,
//                   margin: EdgeInsets.zero,
//                   text: getTranslated(context, 'turnOnNotification'),
//                   onTap: () async {
//                     if (Platform.isIOS) {
//                       NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();

//                       if (settings.authorizationStatus == AuthorizationStatus.denied) {
//                         // Request permission through Firebase
//                         settings = await FirebaseMessaging.instance.requestPermission(
//                           alert: true,
//                           badge: true,
//                           sound: true,
//                         );
//                       }

//                       if (settings.authorizationStatus == AuthorizationStatus.authorized ||
//                           settings.authorizationStatus == AuthorizationStatus.provisional) {
//                         // Permission granted, navigate to next screen
//                         if (userType == 2) {
//                           NavKey.navKey.currentState?.pushNamedAndRemoveUntil(biometricVerifyRoute, (route) => false);
//                         } else {
//                           NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
//                         }
//                       } else {
//                         // Permission denied, open app settings
//                         AppSettings.openAppSettings(type: AppSettingsType.notification);
//                       }
//                     } else {
//                       // For Android, use permission_handler
//                       var res = await Permission.notification.status;
//                       if (res.isDenied || res.isPermanentlyDenied) {
//                         var newRes = await Permission.notification.request();
//                         if (newRes.isGranted) {
//                           // Navigate to next screen
//                           if (userType == 2) {
//                             NavKey.navKey.currentState?.pushNamedAndRemoveUntil(biometricVerifyRoute, (route) => false);
//                           } else {
//                             NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
//                           }
//                         } else {
//                           AppSettings.openAppSettings(type: AppSettingsType.notification);
//                         }
//                       } else if (res.isGranted) {
//                         // Already granted, navigate
//                         if (userType == 2) {
//                           NavKey.navKey.currentState?.pushNamedAndRemoveUntil(biometricVerifyRoute, (route) => false);
//                         } else {
//                           NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
//                         }
//                       }
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Center(
//                   child: CustomButton(
//                 textColor: theme.colorScheme.whiteColor,
//                 backgroundColor: theme.colorScheme.backgroundColor,
//                 borderColor: Colors.white,
//                 width: 332,
//                 alignment: Alignment.bottomCenter,
//                 // margin: EdgeInsets.zero,
//                 text: getTranslated(context, 'skip'),
//                 onTap: () {
//                   if (_item3Controller.isCompleted) {
//                     if (userType == 2) {
//                       NavKey.navKey.currentState?.pushNamedAndRemoveUntil(biometricVerifyRoute, (route) => false);
//                     } else {
//                       NavKey.navKey.currentState?.pushNamedAndRemoveUntil(homeRoute, (route) => false);
//                     }
//                   }
//                 },
//               )),
//             ])));
//   }
// }
