import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/notification_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;


import 'package:timezone/timezone.dart' as tz;

class SecondPage extends ConsumerStatefulWidget  {
    SecondPage();
  
   @override
  _CalenderBookScreenState createState() => _CalenderBookScreenState();

}
class _CalenderBookScreenState extends ConsumerState<SecondPage> {
     NotificationAppLaunchDetails? notificationAppLaunchDetails;
     bool _notificationsEnabled = false;
       @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
   _requestPermissions();
   // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();
  }
    void _configureSelectNotificationSubject() {
    ref.watch(notificationProvider).selectNotificationStream.stream.listen((String? payload) async {
      // await Navigator.of(context).push(MaterialPageRoute<void>(
      //   builder: (BuildContext context) => SecondPage(payload),
      // ));
    });
  }
 Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await ref.watch(notificationProvider).flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await ref.watch(notificationProvider).flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          ref.watch(notificationProvider).flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }
    Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await ref.watch(notificationProvider).flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    
     
      final  todos = ref.watch(notificationProvider);
      todos.set();
      notificationAppLaunchDetails=todos.notificationAppLaunchDetails;
      
      return 
      Scaffold(
        appBar: AppBar(),
            body: Container(height: 700, width: 400,
            
            color:Colors.yellow

            ,child:     ElevatedButton(
                      child : Text( 'Schedule notification to appear in 1 seconds ')
                      , 
                      onPressed: () async {
                        await _zonedScheduleNotification();
                      },
                    ),
            ),
         );

  }



  Future<void> _zonedScheduleNotification() async {
    await ref.watch(notificationProvider).flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

}