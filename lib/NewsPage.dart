import 'package:flutter/material.dart';
import './DetailsPage.dart';
import './classes/Timetable.dart';
import 'package:http/http.dart' as http;
import './classes/app_config.dart';
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}
class _NewsPageState extends State<NewsPage> {
  var news = {
    'title': 'Глобальное обновление',
    'subtitle': 'Добро пожаловать в новое приложение СибГУ. Всегда актуальное расписание в кармане.',
    'content': 'Дорогие друзья! \n Я рад приветствовать вас на официальном сайте Сибирского государственного университета науки и технологий имени академика М.Ф. Решетнева! СибГУ им. М.Ф.Решетнева — первый опорный университет Восточной Сибири, осуществляющий подготовку высококвалифицированных специалистов по более чем 100 программам для авиационной и космической промышленности, машиностроения, лесной, деревообрабатывающей и химической отрасли, научных и финансовых организаций, международных и российских бизнес-структур, масс-медиа. \n СибГУ им. М.Ф.Решетнева — это целый мир возможностей, который предлагает университет сегодня. Уверен, что наш вуз станет для вас верным путеводителем в будущее \n Добро пожаловать в СибГУ им. М.Ф. Решетнева! \n Акбулатов Эдхам Шукриевич'
  };
  Future _hendlerPostFuture;

  @override
  initState() {
    super.initState();
    _hendlerPostFuture = getPost();
  }

  Future<List<Post>> getPost() async {
    var response = await http.get(uriServer + '/api/posts');
    if (response.statusCode == 200) {
      var parsed = await json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Post>((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _hendlerPostFuture,
        builder: (context, AsyncSnapshot postsSnap) {
          switch (postsSnap.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('Нет соединения с сервером', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (postsSnap.hasError) {
                return Center(
                  child: Text('Ошибка загрузки расписания', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)));
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
                                  leading: Image(image: AssetImage("assets/images/logo.png")),
                                  title: Text(post.title),
                                  subtitle: Text(post.summary),
                                ),
                                ButtonTheme.bar( // make buttons use the appropriate styles for cards
                                  child: ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('Подробнее'),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailsPage(news: post)));
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
                  }
                );
              }
              break;
            default:
              return Text("connection is just active");
            }
        }
    );
  }
}