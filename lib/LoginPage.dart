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
  bool showChoose = true;
  bool showGroup = false;
  bool showTeacher = false;
  String labelTextInInput = 'Группа';
  String labelTextInText = 'Введите название группы';

  searchResults(String query) async {
    if (query != '') {
      setState(() {
        loading = true;
        searchText = query;
      });
      try {
        if (showGroup) {
          print(333);
          final response =
          await http.get(uriServer + 'api/group/search/$query/3');
          setState(() {
            items.clear();
            items.addAll(json.decode(response.body)['groups'] as List);
            loading = false;
          });
        } else if (showTeacher) {
          print(123);
          final response =
          await http.get(uriServer + 'api/teacher/search/$query/3');
          setState(() {
            items.clear();
            items.addAll(json.decode(response.body)['teacher'] as List);
            loading = false;
          });
        }
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
    if (showGroup) {
      prefs.remove('teacher');
      prefs.setString('group', json.encode(group));
    } else if (showTeacher) {
      prefs.remove('group');
      prefs.setString('teacher', json.encode(group));
    }
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
                    title: Text(labelTextInText), dense: true)));
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
                            title: showGroup ? Text('${items[index]['name']}') : showTeacher ? Text('${items[index]['full_name']}') : Text(''),
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
      margin: EdgeInsets.only(top: 20),
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
            hintText: labelTextInInput,
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
      body: Stack(children: <Widget>[showGroup ? Center( child:Container(
          alignment: Alignment(0.0, 0.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
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
            }))) :
        showChoose ? Container(
          height: _ac.rH(100),
          width: _ac.rW(100),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:  new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        OutlineButton(
                          highlightedBorderColor: Colors.white,
                          borderSide: BorderSide(color: Colors.white),
                          shape: StadiumBorder(),
                          color: Colors.transparent,
                          textColor: Colors.white,
                          child: new Text(
                            'Студент',
                          ),
                          onPressed: () {
                            setState(() {
                              showGroup = true;
                              showChoose = false;
                              showTeacher = false;
                              labelTextInInput = 'Группа';
                              labelTextInText = 'Введите название группы';
                            });
                          }
                        ),
                        OutlineButton(
                          highlightedBorderColor: Colors.white,
                          borderSide: BorderSide(color: Colors.white),
                          shape: StadiumBorder(),
                          color: Colors.transparent,
                          textColor: Colors.white,
                          child: new Text(
                            'Преподаватель',
                          ),
                          onPressed: () {
                            setState(() {
                              showGroup = false;
                              showChoose = false;
                              showTeacher = true;
                              labelTextInInput = 'ФИО';
                              labelTextInText = 'Введите ФИО преподавателя';
                            });
                          }
                        ),
                      ]
                  )
              );
            })
        ) :
        showTeacher ? Center( child: Container(
          alignment: Alignment(0.0, 0.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
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
                }))) : Container(),
        SizedBox(
          width: _ac.rW(100),
          height: 60,
          child: new AppBar(
            elevation: 0.0,
            title: null,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (showTeacher || showGroup) {
                    return IconButton(icon: Icon(Icons.arrow_back),
                      onPressed: () {
                      print(123);
                        setState(() {
                          showTeacher = false;
                          showGroup = false;
                          showChoose = true;
                        });
                      },
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    );
                  } else {
                    return new Container();
                  }
                }
            ),
          ),
        )
    ]));
  }
}
