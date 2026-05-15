import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  // create instance of firebase messeaging
  final messaging = FirebaseMessaging.instance;

  /// firebase local notification is use to show the notification on foreground like snackBar.
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  void initializeLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializeSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  void notificationNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    // check permission authorized or not
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted  permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user grnaated provision notification');
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('user denied permission');
    }
  }

// this is use to get notification token.
  Future<String> getNotificationToken() async {
    String? token = await messaging.getToken();
    if (token?.isEmpty == true) {
      messaging.onTokenRefresh.listen((event) {
        token = event;
        print('token refresh:$event');
      });
    }
    print('token:$token');
    return token ?? '';
  }

// for show foreground messages in app.
  void foreGroundMessagesShow() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(kDebugMode) {
        print('title:${message.data}');
        print('body:${message.data}');
      }
      showNotification(message);
    });
  }

  // show the notifications
  Future<void> showNotification(RemoteMessage message) async {
    final chanel = AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(),
        'High Importance Notification',
    importance: Importance.max,);
    final androidNotificationDetails = AndroidNotificationDetails(
        chanel.id, chanel.name,
        priority: Priority.high, importance: Importance.high);
    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentSound: true,
      presentBadge: true,
    );
    final notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    Future.delayed(Duration.zero,() {
      flutterLocalNotificationPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails);
    },);
  }
}
