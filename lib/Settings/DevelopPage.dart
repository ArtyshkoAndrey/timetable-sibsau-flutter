import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevelopPage extends StatefulWidget {
  @override
  _DevelopPageState createState() => _DevelopPageState();
}

class _DevelopPageState extends State<DevelopPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool notification = false;

  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var notified = prefs.getBool('notificationsDevelopTest');
      if (notified == null) {
        prefs.setBool('notificationsDevelopTest', true);
        notified = true;
        _firebaseMessaging.subscribeToTopic('notificationsDevelopTest');
        setState(() {
          notification = notified;
        });
      } else {
        setState(() {
          notification = notified;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text("Для разработчика"),
          elevation: 0.0,
          backgroundColor: Color(0xFF006CB5)),
      body: ListView(children: <Widget>[
        new SwitchListTile(
          value: notification,
          title: Text('Тестовые уведомления'),
          subtitle: Text('Расписания, обновления и тд.'),
          onChanged: (value) {
            if (value) {
              _firebaseMessaging.subscribeToTopic('notificationsDevelopTest');
            } else {
              _firebaseMessaging
                  .unsubscribeFromTopic('notificationsDevelopTest');
            }
            SharedPreferences.getInstance().then((prefs) {
              prefs.setBool('notifications', value);
              setState(() {
                notification = value;
              });
            });
          },
        ),
      ]),
    );
  }
}
