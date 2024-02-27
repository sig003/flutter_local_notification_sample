import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late String uniqueChannelId;

  NotificationHelper() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initLocalNotifications();
    requestPermissionHandler();
  }

  Future<void> initLocalNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
    const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> requestPermissionHandler() async {
    // 알림 권한 요청
    var status = await Permission.notification.request();

    if (status.isGranted) {
      // 알림 권한이 허용된 경우
      print('Notification permission granted');
    } else {
      // 알림 권한이 거부된 경우
      print('Notification permission denied');
    }
  }

  Future<void> requestNotificationPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification() async {
    uniqueChannelId = generateUniqueId();
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      '1',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(
        0, 'test title', 'test body', notificationDetails);
  }

  String generateUniqueId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final charLength = 8;

    return List.generate(charLength,
            (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}