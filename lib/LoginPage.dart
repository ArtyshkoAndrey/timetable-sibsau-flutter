import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        final response = await http.get(
            'http://95.188.80.41/api/group/search/$query/3');
        setState(() {
          items.clear();
          items.addAll(json.decode(response.body)['groups'] as List);
          loading = false;
        });
      } catch (e) {
        print('Error Network');
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
    print(json.encode(group));
    Navigator.pushReplacementNamed(context, '/timetable');
  }

  searchList() {
    if (!loading) {
      if (searchText == '') {
        return Card(child: ListTile(title: Text('Введит название групы'), dense: true));
      }
      if (items.length > 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return new InkWell(
                onTap: (){ saveGroupAndRedirect(items[index]); },
                child: Card(
                    child: ListTile(title: Text('${items[index]['name']}'), dense: true)
                )
            );
          },
        );
      } else {
        return Card(child: ListTile(title: Text('Нет совпадений'), dense: true));
      }
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 50.0,
        )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final groupField = TextField(
      obscureText: false,
      style: style,
      controller: _controller,
      autofocus: true,
      onChanged: (value) {
        searchResults(value);
      },
      decoration: InputDecoration(
        hintText: "Группа",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    groupField
                  ],
                ),
                searchList()
              ],
            ),
          ),
        ),
      );
  }
}