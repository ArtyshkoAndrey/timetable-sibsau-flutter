import 'package:flutter/material.dart';
import './DetailsPage.dart';
import './classes/Timetable.dart';
import 'package:http/http.dart' as http;
import './classes/app_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future _hendlerPostFuture;
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  bool internet = true;

  @override
  initState() {
    super.initState();
    _hendlerPostFuture = getPost();
  }

  Future<List<Post>> getPost() async {
    final SharedPreferences prefs = await pref;
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
      setState(() {
        internet = false;
      });
      var parsed =
          json.decode(prefs.getString('news')).cast<Map<String, dynamic>>();
      return parsed.map<Post>((value) => Post.fromJson(value)).toList();
    }
    throw Exception('Failed to load post');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _hendlerPostFuture,
        builder: (context, AsyncSnapshot postsSnap) {
          switch (postsSnap.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: Text('Нет соединения с сервером',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0)));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (postsSnap.hasError) {
                return Center(
                    child: Text('Ошибка загрузки расписания',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0)));
              } else {
                return ListView.builder(
                    itemCount: postsSnap.data.length,
                    itemBuilder: (context, index) {
                      Post post = postsSnap.data[index];
                      return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Image(
                                        image: AdvancedNetworkImage(
                                            'http://s.gravatar.com/avatar/f31e533e6ab7a1edff0fa46e5c3b089d.png',
                                            useDiskCache: true),
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(post.title),
                                      subtitle: Text(post.summary),
                                    ),
                                    ButtonTheme.bar(
                                      // make buttons use the appropriate styles for cards
                                      child: ButtonBar(
                                        children: <Widget>[
                                          FlatButton(
                                            child: const Text('Подробнее'),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsPage(
                                                              news: post)));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]);
                    });
              }
              break;
            default:
              return Text("connection is just active");
          }
        });
  }
}
