import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './classes/app_config.dart';
import './main.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Вход',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.white,
      ),
      home: LoginPage(title: 'Вход'),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key key, this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppConfig _ac;
  TextStyle style = TextStyle(fontSize: 20.0);
  final TextEditingController _controller = new TextEditingController();
  List items = List();
  var loading = false;
  String searchText = '';

  searchResults(String query) async {
    if (query != '') {
      setState(() {
        loading = true;
        searchText = query;
      });
      try {
        final response =
            await http.get(uriServer + 'api/group/search/$query/3');
        setState(() {
          items.clear();
          items.addAll(json.decode(response.body)['groups'] as List);
          loading = false;
        });
      } catch (e) {
        setState(() {
          items.clear();
          loading = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        searchText = query;
      });
    }
  }

  saveGroupAndRedirect(Object group) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('group', json.encode(group));
//    Navigator.pushReplacementNamed(context, '/timetable');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyTabs(),
        settings: RouteSettings(name: '/timetable'),
      ),
    );
  }

  searchList() {
    if (!loading) {
      if (searchText == '') {
        return Container(
            margin: EdgeInsets.only(bottom: _ac.rHP(23)),
            child: Card(
                child: ListTile(
                    title: Text('Введите название группы'), dense: true)));
      }
      if (items.length > 0) {
        return Container(
            height: _ac.rHP(30),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return new InkWell(
                    onTap: () {
                      saveGroupAndRedirect(items[index]);
                    },
                    child: Card(
                        child: ListTile(
                            title: Text('${items[index]['name']}'),
                            dense: true)));
              },
            ));
      } else {
        return Container(
            margin: EdgeInsets.only(bottom: _ac.rHP(23)),
            child: Card(
                child: ListTile(title: Text('Нет совпадений'), dense: true)));
      }
    } else {
      return Container(
          height: _ac.rHP(28),
          margin: EdgeInsets.only(top: _ac.rHP(2)),
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: _ac.rHP(5),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _ac = AppConfig(context);

    final groupField = Container(
//      height: 60,
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: TextField(
          style: style,
          controller: _controller,
          autofocus: true,
          onChanged: (value) {
            searchResults(value);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            hintText: "Группа",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ));

    logo(BoxConstraints _constraints) {
      if (_constraints.maxHeight > 500) {
        return SizedBox(
          height: _ac.rHP(15),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      logo(constraints),
                      SizedBox(
                        height: _ac.rHP(2),
                      ),
                      groupField
                    ],
                  ),
                  searchList()
                ],
              ),
            );
          })),
    );
  }
}
