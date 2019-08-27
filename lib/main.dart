import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import './TimetablePage.dart';
import './NewsPage.dart';
import './LoginPage.dart';
import './CheckAuth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './EventsPage.dart';
import './SettingsPage.dart';
import './MapsPage.dart';

void main() {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var notified;
  SharedPreferences.getInstance().then((prefs) {
    notified = prefs.getBool('notifications');
    print(notified);
    if (notified == null) {
      prefs.setBool('notifications', true);
      _firebaseMessaging.subscribeToTopic('allDevice');
    }
  });
  runApp(new MaterialApp(
      initialRoute: '/',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/': (context) => CheckAuth(),
        '/login': (context) => LoginPage(title: 'Вход'),
        '/timetable': (context) => MyTabs()
      }
  ));
}

class MyTabs extends StatefulWidget{
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {

  TabController controller;
  Map group = {'name':'Loading'};

  @override
  void initState(){
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        group = json.decode(prefs.get('group'));
      });
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void _select(Choice choice) async {
    if (choice.title == 'Выйти') {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('group');
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
  Widget build(BuildContext context){
    return new Scaffold(
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(group['name']),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.white,
                  )
                ),
                accountEmail: new Text('СибГУ им. Решетнева'),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover
                  )
                )
              ),
              ListTile(
                title: Text("Мероприятия"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EventsPage()));
                },
              ),
              ListTile(
                title: Text("Настройки"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage()));
                },
              ),
              ListTile(
                title: Text("Карта кампуса"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MapsPage()));
                },
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text("Расписание ${group['name']}"),
          elevation: 0.0,
          backgroundColor: Color(0xFF006CB5),
          actions: <Widget> [
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
              ]
            )
          )
        ),
        body: new TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: <Widget>[
              new TimetablePage(group: group),
              new NewsPage(),
            ]
        )
    );
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