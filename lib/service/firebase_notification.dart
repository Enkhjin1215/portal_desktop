// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:portal/helper/application.dart';
// import 'package:portal/helper/constant.dart';

// // PushNotifManager pushNotifManager = PushNotifManager();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'my_channel', // id
//   'My Channel', // title
//   importance: Importance.high,
// );

// class PushNotifManager {
//   late FirebaseApp firebaseApp;
//   FlutterLocalNotificationsPlugin? localNotif;
//   AndroidNotificationChannel? notifChannel; // Local notification
//   Future<String> init() async {
//     //debugPrint('---------------------------------FIREBASE STARTED____________________________________________________');

//     ///
//     /// Firebase app
//     ///
//     firebaseApp = await Firebase.initializeApp();
//     await FirebaseMessaging.instance.setAutoInitEnabled(true);
//     FlutterLocalNotificationsPlugin fltNotification;
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     ///
//     /// Firebase messaging
//     ///
//     // debugPrint('------------------------------------->${await permission.status}');
//     NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }

//     // var token = await messaging.getToken();
//     // //debugPrint('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$token}');

//     if (Platform.isIOS) {
//       messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
//       messaging.getInitialMessage();
//       // print("------>${await messaging.getAPNSToken()}");
//     }

//     ///
//     /// Notification permission
//     ///

//     ////debugPrint('User granted permission: ${settings.authorizationStatus}');

//     ///
//     /// Push notification token
//     ///
//     //debugPrint('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
//     String fcmToken = '';
//     if (Platform.isAndroid) {
//       fcmToken = await messaging.getToken() ?? '';
//     } else {
//       // var sda = await messaging.;
//       // print('${sda.toString()}');
//       fcmToken = await messaging.getAPNSToken() ?? '';
//     }
//     debugPrint("Push notif token 1: $fcmToken");

//     if (fcmToken != '') {
//       debugPrint("Push notif token: $fcmToken");
//       Application().setPushNotifToken(fcmToken);
//     }
//     FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
//       Application().setPushNotifToken(fcmToken);
//     }).onError((err) {
//       debugPrint("fcm token: $fcmToken");
//     });

//     //debugPrint('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^2');

//     ///
//     /// Local notification
//     ///
//     if (Platform.isAndroid) {
//       var initSettings = const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));

//       localNotif = FlutterLocalNotificationsPlugin();
//       await localNotif?.initialize(initSettings);
//     }

//     ///
//     /// Background message handler
//     ///
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessageOpenedApp.listen((event) async {
//       RemoteNotification? notification = event.notification;

//       debugPrint("background notification: ${event.data}");
//       String jwtToken = await application.getAccessToken();
//       ////debugPrint("jwt token:${jwtToken}");

//       if (event.data.isNotEmpty && jwtToken.isNotEmpty) {
//         Map<String, dynamic> body = event.data;

//         // if (body['lnDetail'] != null) {
//         //   String route = body['lnDetail'];
//         //   NavKey.navKey.currentState?.pushNamed(loanDetailRoute, arguments: {
//         //     'acntNo': route,
//         //     'isFromNotif': true,
//         //   });
//         // } else if (body['lnClosed'] != null) {
//         //   String route = body['lnClosed'];
//         //   NavKey.navKey.currentState?.pushNamed(loanHistoryDetail, arguments: {
//         //     'isFromNotif': true,
//         //     'acntNo': route,
//         //   });
//         // } else if (body['cntr'] == 'success') {
//         //   NavKey.navKey.currentState?.pushNamed(loanGetRoute, arguments: {
//         //     'isFromNotif': true,
//         //   });
//         // }
//       }
//     });

//     ///
//     /// Foreground message handler
//     ///
//     ///
//     var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initSetting = InitializationSettings(android: androiInit);

//     fltNotification = FlutterLocalNotificationsPlugin();
//     // fltNotification.initialize(initSetting);

//     var androidDetails = const AndroidNotificationDetails('1', 'channelName');
//     var generalNotificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       AppleNotification? apple = message.notification?.apple;
//       if (notification != null && android != null) {
//         fltNotification.show(notification.hashCode, notification.title, notification.body, generalNotificationDetails);
//         dynamic body = message.data;

//         ////debugPrint("notif body: \n ${body}");
//         ////debugPrint("notif body: \n ${body}");

//         application.showNotification(
//           notification.title!,
//           notification.body!,
//           body,
//         );
//       }
//     });
//     return 'Done';
//   }
// }

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('background message: $message');
//   await Firebase.initializeApp();
//   Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
//     debugPrint('onDidReceiveLocalNotification');
//   }
//   // var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//   // final initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//   // final initializationSettingsMacOS = MacOSInitializationSettings();

//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//   // final initializationSettings =
//   //     InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onSelectNotification: onSelectNotification,
//   // );
//   ////debugPrint(' Handling background message ${message.notification?.title}');
// }

// Future<void> onSelectNotification(String? payload) async {
//   ////debugPrint('onSelectNotification');
// }
