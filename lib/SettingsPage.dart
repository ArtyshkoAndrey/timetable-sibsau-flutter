import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Settings/DevelopPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool notification = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var notified = prefs.getBool('notifications');
      if (notified == null) {
        prefs.setBool('notifications', true);
        notified = true;
        _firebaseMessaging.subscribeToTopic('allDevice');
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
            title: new Text("Настройки"),
            elevation: 0.0,
            backgroundColor: Color(0xFF006CB5)
        ),
        body: ListView(children: <Widget>[
          new SwitchListTile(
            value: notification,
            title: Text('Уведомления'),
            subtitle: Text('Расписания, обновления и тд.'),
            onChanged: (value) {
              if (value) {
                _firebaseMessaging.subscribeToTopic('allDevice');
              } else {
                _firebaseMessaging.unsubscribeFromTopic('allDevice');
              }
              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool('notifications', value);
                setState(() {
                  notification = value;
                });
              });
            },
          ),
          ListTile(
            title: Text('Для разработчика'),
            subtitle: Text('Настройки разработчика'),
            onTap: (){Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DevelopPage()));},
          )
        ]),
    );
  }
}