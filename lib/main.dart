import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:timetable/TimetablePage.dart';
import 'package:timetable/NewsPage.dart';
import 'package:timetable/LoginPage.dart';
import 'package:timetable/CheckAuth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timetable/EventsPage.dart';
import 'package:timetable/SettingsPage.dart';
import 'package:timetable/MapsPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

void main() {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var notified;
  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  _requestPermission(PermissionGroup.location);
  SharedPreferences.getInstance().then((prefs) {
    notified = prefs.getBool('notifications');
    if (notified == null) {
      prefs.setBool('notifications', true);
      _firebaseMessaging.subscribeToTopic('allDevice');
    }
  });
  runApp(new MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/': (context) => CheckAuth(),
        '/login': (context) => LoginPage(title: 'Вход'),
        '/timetable': (context) => MyTabs()
      }));
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  TabController controller;
  Map group = {'name': 'Loading'};
  String _projectVersion = '';
  @override
  void initState() {
    super.initState();
    initPlatformState();
    controller = new TabController(vsync: this, length: 2);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        if (prefs.get('group') != null)
          group = json.decode(prefs.get('group'));
        else group = json.decode(prefs.get('teacher'));
      });
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }
    setState(() {
      _projectVersion = projectVersion;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _select(Choice choice) async {
    if (choice.title == 'Выйти') {
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove('group');
      await prefs.remove('timetable');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckAuth(),
          settings: RouteSettings(name: '/'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: group['name'] != null ? new Text(group['name']) : new Text(group['full_name']),
                  currentAccountPicture: new GestureDetector(
                      child: new CircleAvatar(
                    backgroundImage: new AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.white,
                  )),
                  accountEmail: new Text('СибГУ им. Решетнева'),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage('assets/images/bg.png'),
                          fit: BoxFit.cover))),
              ListTile(
                title: Text("Мероприятия"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new EventsPage()));
                },
              ),
              ListTile(
                title: Text("Карта корпусов"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new MapsPage()));
                },
              ),
              ListTile(
                title: Text("Настройки"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SettingsPage()));
                },
              ),
              ListTile(
                title: Text("Версия приложения $_projectVersion")
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          title: group['name'] != null ? new Text("Расписание ${group['name']}") : new Text("${group['full_name']}"),
          elevation: 0.0,
          backgroundColor: Color(0xFF006CB5),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        bottomNavigationBar: new SizedBox(
            width: MediaQuery.of(context).size.width,
            child: new Material(
                color: Colors.white,
                child: new TabBar(
                    controller: controller,
                    indicatorColor: Color(0xFF006CB5),
                    labelColor: Color(0xFF006CB5),
                    unselectedLabelColor: Colors.lightBlue[100],
                    labelPadding: EdgeInsets.zero,
                    tabs: <Tab>[
                      new Tab(icon: new Icon(Icons.date_range)),
                      new Tab(icon: new Icon(Mdi.newspaper))
                    ]))),
        body: new TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: <Widget>[
              new TimetablePage(group: group),
              new NewsPage(),
            ]));
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Выйти', icon: Mdi.exitToApp)
];
