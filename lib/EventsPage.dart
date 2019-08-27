import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}
class _EventsPageState extends State<EventsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =  new GlobalKey<RefreshIndicatorState>();
  var events = [
    {
      'day': '30 августа',
      'data': '30',
      'content': 'Международный научно-практический семинар "Дружба - 2019" по миниволею'
    },
    {
      'day': '19 августа',
      'data': '19',
      'content': 'Тренировочные мероприятия по подготовке к Кубку Мира (финал) по подводному спорту (плавание в ластах и марафонские заплывы)'
    },
    {
      'day': '19 августа',
      'data': '19',
      'content': 'Выездной интенсив для студенческих объединений университета'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
      title: new Text("Мероприятия"),
      elevation: 0.0,
      backgroundColor: Color(0xFF006CB5)
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {print('123');},
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    child: Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new CircleAvatar(
//                              backgroundImage: new AssetImage('assets/images/logo.png'),
//                              backgroundColor: Colors.white,
                              child: Text(events[index]['data']),
                            ),
                            title: Text(events[index]['day']),
                            subtitle: Text(events[index]['content']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]);
          }
      )
    )
    );
  }
}