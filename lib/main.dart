import 'package:flutter/material.dart';
import 'notification_helper.dart';

void main() {
  runApp(MaterialApp(home:FlutterLocalNotifications()));
}

class FlutterLocalNotifications extends StatefulWidget {
  const FlutterLocalNotifications({Key? key}) : super(key: key);

  @override
  State<FlutterLocalNotifications> createState() => _FlutterLocalNotificationsState();
}

class _FlutterLocalNotificationsState extends State<FlutterLocalNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notifications Sample'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showNotification();
          },
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}