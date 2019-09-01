import 'package:flutter/material.dart';
import './classes/Timetable.dart';

class DetailsPage extends StatefulWidget {
  final Post news;
  DetailsPage({Key key, this.news}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 70.0),
        Image(image: AssetImage("assets/images/logo.png"), height: 50),
//        Icon(
//          Icons.directions_car,
//          color: Colors.white,
//          size: 40.0,
//        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          widget.news.title,
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        SizedBox(height: 30.0),
      ],
    );

    Widget image () {
      if (widget.news.img != null) {
        return Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: new BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://timetable.artyshko.ru/public/uploads${widget.news.img}'),
                    fit: BoxFit.cover
                )
            ));
      } else {
        return Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover
                )
            ));
      }
    }

    final topContent = Stack(
      children: <Widget>[
        image(),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .7)),
          child: topContentText,
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Expanded(
      flex: 1,
      child: new SingleChildScrollView(
        child: Text(
          widget.news.body,
          style: TextStyle(fontSize: 18.0),
        )
      )
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}