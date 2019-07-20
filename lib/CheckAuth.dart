import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData () async {
    var prefs = await SharedPreferences.getInstance();
    var group = prefs.get('group');
    if (group == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/timetable');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitThreeBounce(color: Color(0xFF006CB5), size: 50)
    );
  }
}