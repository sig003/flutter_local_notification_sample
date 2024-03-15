import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';

class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late String uniqueChannelId;

  NotificationHelper() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initLocalNotifications();
    requestPermissionHandler();
    requestNotificationPermission();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
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

  String generateUniqueId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final charLength = 8;

    return List.generate(charLength,
            (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> showNotification() async {
    uniqueChannelId = generateUniqueId();
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      '0',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('ma'),
        vibrationPattern: Int64List.fromList([0, 1500, 500, 2000, 500, 1500]),
     enableVibration: true
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    // await flutterLocalNotificationsPlugin.show(
    //     0, 'test title', 'test body', notificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 알림 ID
      'test alarm', // 알림 제목
      'test alarm contents', // 알림 내용
      //tz.TZDateTime(tz.local, 2024, 3, 15, 16, 34), // 2024년 3월 15일 03:38에 울리도록 설정
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id', // 채널 ID
          'channel name', // 채널 이름
          channelDescription:'channel description', // 채널 설명
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}