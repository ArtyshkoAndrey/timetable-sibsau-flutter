import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './DetailsPage.dart';
import './classes/Timetable.dart';
import 'package:http/http.dart' as http;
import './classes/app_config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController _postsController;
  int counter = 0;

  @override
  initState() {
    super.initState();
    _postsController = new StreamController();
    loadPosts(refresh: true);
  }

  Future<List<Post>> getPost({refresh = false}) async {
    final SharedPreferences prefs = await pref;
    if (refresh) {
      try {
        var parsed =
            json.decode(prefs.getString('news')).cast<Map<String, dynamic>>();
        return parsed.map<Post>((value) => Post.fromJson(value)).toList();
      } catch (e) {
        var response = await http.get(uriServer + '/api/posts');
        if (response.statusCode == 200) {
          var parsed =
              await json.decode(response.body).cast<Map<String, dynamic>>();
          var posts = parsed.map<Post>((json) => Post.fromJson(json)).toList();
          await prefs.setString('news', response.body);
          return posts;
        }
      }
    }
    try {
      var response = await http.get(uriServer + '/api/posts');
      if (response.statusCode == 200) {
        var parsed =
            await json.decode(response.body).cast<Map<String, dynamic>>();
        var posts = parsed.map<Post>((json) => Post.fromJson(json)).toList();
        await prefs.setString('news', response.body);
        return posts;
      }
    } catch (e) {
      var parsed =
          json.decode(prefs.getString('news')).cast<Map<String, dynamic>>();
      return parsed.map<Post>((value) => Post.fromJson(value)).toList();
    }
    throw Exception('Failed to load post');
  }

  Future<Null> _handleRefresh() async {
    getPost().then((res) async {
      _postsController.add(res);
      if (counter != res.length) {
        showSnack();
        setState(() {
          counter = res.length;
        });
      }
      return null;
    });
  }

  loadPosts({refresh = false}) async {
    getPost(refresh: refresh).then((res) async {
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
        content: Text('Добавлены новые новости'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
                          Post post = snapshot.data[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 1.0,
                                    child: InkWell(
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Image(image: AdvancedNetworkImage(
                                                    post.avatar,
                                                    useDiskCache: true), fit: BoxFit.cover,),
                                              title: Text(post.title),
                                              subtitle: Text(post.summary),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  child: Text(post.userName,
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                      )),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                        '${DateFormat('dd.MM.yyyy').format(post.date)}',
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                        )),
                                                    Padding(
                                                      child: Icon(
                                                        Icons.today,
                                                        color: Colors.black45,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 20),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new DetailsPage(
                                                            news: post)));
                                      },
                                    ),
                                  )
                                ]),
                          );
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
