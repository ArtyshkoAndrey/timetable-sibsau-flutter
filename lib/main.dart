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

void main() {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging
      .subscribeToTopic('allDevice');
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
    pr1();
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

  void pr1 () {
    print(123);
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Расписание ${group['name']}"),
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