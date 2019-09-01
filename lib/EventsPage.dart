import 'package:flutter/material.dart';
import './classes/Timetable.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './classes/app_config.dart';
import 'dart:convert';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController _postsController;
  int counter = 0;
  @override
  void initState() {
    _postsController = new StreamController();
    loadPosts();
    super.initState();
  }

  Future getEvent() async {
    var response = await http.get(uriServer + '/api/events');
    if (response.statusCode == 200) {
      var parsed =
          await json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Event>((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Null> _handleRefresh() async {
    getEvent().then((res) async {
      _postsController.add(res);
      if (counter != res.length) {
        showSnack();
      }
      return null;
    });
  }

  loadPosts() async {
    getEvent().then((res) async {
      setState(() {
        counter = res.length;
      });
      _postsController.add(res);
      return res;
    });
  }

  showSnack() {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Добавлены новые мероприятия'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
            title: new Text("Мероприятия"),
            elevation: 0.0,
            backgroundColor: Color(0xFF006CB5)),
        body: StreamBuilder(
            stream: _postsController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: new CircleAvatar(
                                            child: Text(snapshot.data[index].numDay.toString()),
                                          ),
                                          title: Text(snapshot.data[index].date),
                                          subtitle: Text(snapshot.data[index].title),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                        }));
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error);
              }
              return null;
            }));
  }
}
