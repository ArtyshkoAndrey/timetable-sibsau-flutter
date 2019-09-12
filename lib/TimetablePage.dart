import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;
import 'package:flutter/foundation.dart';
import 'package:timetable/classes/Timetable.dart';
import 'package:timetable/classes/app_config.dart';


class TimetablePage extends StatefulWidget {
  final Map group;
  TimetablePage({Key key, this.group}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with SingleTickerProviderStateMixin {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  int _current = 0;
  Future _future;
  AppConfig _ac;
  TabController _tabController;
  DateTime date;
  int dayOfYear;
  int numW;
  List ctrl = [];
  bool flagsAutoScroll = false;

  @override
  initState() {
    ctrl.add(PageController());
    ctrl.add(PageController());
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    _future = getLessons();
    date = DateTime.now();
    dayOfYear = int.parse(DateFormat("D").format(date));
    numW = ((dayOfYear - date.weekday + 10) / 7).floor() % 2;
    if (numW == 0) {
      _tabController.animateTo(0);
      numW = 1;
    } else {
      _tabController.animateTo(1);
      numW = 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        flagsAutoScroll = false;
      });
    }
  }

  Future<List> getLessons({refresh = false}) async {
    final SharedPreferences prefs = await pref;
    if (widget.group['id'] == null) {
      await Future.delayed(Duration(seconds: 1));
    }
    if (widget.group['id'] != null) {
      if (!refresh) {
        try {
          var parsed =
              await json.decode(prefs.getString('timetable'))['timetable'];
          var list = List();
          list.add(parsed[0]); // Массив дней 1 недели
          list.add(parsed[1]);
          list[0] = await list[0].map<Day>((day) => Day.fromJson(day)).toList();
          list[1] = await list[1].map<Day>((day) => Day.fromJson(day)).toList();
          return list;
        } catch (e) {
          try {
            var response;
            if (widget.group['name'] != null) {
              response = await http.get(uriServer + '/api/group/${widget.group['id']}');
            } else {
              response = await http.get(uriServer + '/api/teacher/${widget.group['id']}');
            }
            if (response.statusCode == 200) {
              var parsed = await json.decode(response.body)['timetable'];
              await prefs.setString('timetable', response.body);
              var list = List();
              list.add(parsed[0]); // Массив дней 1 недели
              list.add(parsed[1]);
              list[0] =
                  await list[0].map<Day>((day) => Day.fromJson(day)).toList();
              list[1] =
                  await list[1].map<Day>((day) => Day.fromJson(day)).toList();
              return list;
            }
          } catch (e) {
            throw Exception('Failed to load post');
          }
        }
      } else {
        try {
          var response;
          if (widget.group['name'] != null) {
            response = await http.get(uriServer + '/api/group/${widget.group['id']}');
          } else {
            response = await http.get(uriServer + '/api/teacher/${widget.group['id']}');
          }
          if (response.statusCode == 200) {
            var parsed = await json.decode(response.body)['timetable'];
            await prefs.setString('timetable', response.body);
            var list = List();
            list.add(parsed[0]); // Массив дней 1 недели
            list.add(parsed[1]);
            list[0] =
                await list[0].map<Day>((day) => Day.fromJson(day)).toList();
            list[1] =
                await list[1].map<Day>((day) => Day.fromJson(day)).toList();
            return list;
          }
        } catch (e) {
          var parsed =
              await json.decode(prefs.getString('timetable'))['timetable'];
          var list = List();
          list.add(parsed[0]); // Массив дней 1 недели
          list.add(parsed[1]);
          list[0] = await list[0].map<Day>((day) => Day.fromJson(day)).toList();
          list[1] = await list[1].map<Day>((day) => Day.fromJson(day)).toList();
          return list;
        }
      }
      throw Exception('Failed to load post');
    } else {
      throw Exception('Failed to load post');
    }
  }

  getYesterday(Day i, numWeek) {
    if (date.weekday == i.index && numW != numWeek) {
      return Container(
          margin: EdgeInsets.only(right: 40),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: new BorderRadius.all(Radius.circular(40.0))),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                'Сегодня',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              )));
    } else {
      return Container(
          margin: EdgeInsets.only(right: 40),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              )));
    }
  }

  lessonCol(Lesson l) {
    bool notNull(Object o) => o != null;
    if (l.nextLesson == null) {
      return Column(children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: _ac.rWP(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(l.time.start,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                          Text('   ',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough)),
                          Text(l.time.end, style: TextStyle(color: Colors.grey))
                        ],
                      )),
                  Container(
                      width: _ac.rWP(70),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            l.subgroup != null
                                ? Text(l.subgroup,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ))
                                : null,
                            Flexible(
                                child: new Container(
                                    child: Text(l.name + ' (' + l.type + ')',
                                        style: TextStyle(fontSize: 16.0)))),
                            Text(l.teacher,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Text(l.audience,
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ].where(notNull).toList()))
                ])),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 1.0, color: Colors.grey))
      ]);
    } else if (l.nextLesson != null) {
      Lesson l2 = l.nextLesson;
      return Column(children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: _ac.rWP(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(l.time.start,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14)),
                          Text('   ',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough)),
                          Text(l.time.end, style: TextStyle(color: Colors.grey))
                        ],
                      )),
                  Container(
                      width: _ac.rWP(70),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(l.subgroup,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Flexible(
                                child: new Container(
                                    child: Text(l.name + ' (' + l.type + ')',
                                        style: TextStyle(fontSize: 16.0)))),
                            Text(l.teacher,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Text(l.audience,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                            ),
                            Text(l2.subgroup,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Flexible(
                                child: new Container(
                                    child: Text(l2.name + ' (' + l2.type + ')',
                                        style: TextStyle(fontSize: 16.0)))),
                            Text(l2.teacher,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Text(l2.audience,
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ]))
                ])),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 1.0, color: Colors.grey))
      ]);
    }
  }

  Widget build(BuildContext context) {
    _ac = AppConfig(context);
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              flagsAutoScroll = false;
              _current = 0;
              _future = getLessons(refresh: true);
            });
          },
          child: Icon(Icons.refresh),
          backgroundColor: Colors.blue,
        ),
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Color(0xFF006CB5),
            height: 50.0,
            child: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: '1 неделя'),
                Tab(text: '2 неделя'),
                Tab(text: 'Экзамены'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            week(context, 0),
            week(context, 1),
            Center(
                child: Text('Экзаменов на данный момент нет',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.0))),
          ],
        ),
      ),
    );
  }

  intPage(days, numWeek) {
    int intPage = 0;
    days.asMap().forEach((index, day) {
      if (date.weekday == day.index && numW != numWeek) {
        _current = index;
        intPage = index;
      }
    });
    return intPage;
  }

  // Изменить в классе дня индекс и имя дня недели. В Future изменить сборку под переделанный класс
  Widget week(BuildContext context, int numWeek) {
    return Stack(
      children: [
        FutureBuilder<List>(
            future: _future,
            builder: (context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                      child: Text('Нет соединения с сервером',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0)));
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Ошибка загрузки расписания',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)));
                  } else {
                    List<Day> days = snapshot.data[numWeek];
                    if (days.length == 0) {
                      return Center(
                          child: Text('Нет лент...',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0)));
                    }
                    try {
                      return Stack(children: [
                        PageView.builder(
                            onPageChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            controller: ctrl[numWeek],
                            itemCount: days.length,
                            itemBuilder: (context, int currentIdx) {
                              Day day = days[currentIdx];
                              if (flagsAutoScroll == false) {
                                if (intPage(days, numWeek) != 0) {
                                  flagsAutoScroll = true;
                                  ctrl[numWeek].animateToPage(
                                      intPage(days, numWeek),
                                      duration: new Duration(milliseconds: 500),
                                      curve: Curves.linear);
                                }
                              }
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 20,
                                      bottom: 30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 13.0,
                                          color: Colors.black.withOpacity(.2),
                                          offset: Offset(6.0, 1.0),
                                        )
                                      ]),
                                  child: ListView.builder(
                                      itemCount: day.lessons.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF006CB5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7, horizontal: 5),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20),
                                                        child: Text(day.name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    getYesterday(day, numWeek)
                                                  ]));
                                        } else {
                                          return lessonCol(
                                              day.lessons[index - 1]);
                                        }
                                      }));
                            }),
                        Positioned(
                            bottom: 5,
                            left: 0.0,
                            right: 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: snapshot.data[numWeek].map<Widget>((i) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current ==
                                              snapshot.data[numWeek].indexOf(i)
                                          ? Color.fromRGBO(0, 108, 181, 0.9)
                                          : Color.fromRGBO(0, 108, 181, 0.4)),
                                );
                              }).toList(),
                            ))
                      ]);
                    } catch (e) {
                      return Center(child: Text('Ошибка'));
                    }
                  }
                  break;
                default:
                  return Text("connection is just active");
              }
            })
      ],
    );
  }
}
