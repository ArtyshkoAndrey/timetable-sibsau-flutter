import 'package:flutter/material.dart';
import './classes/Timetable.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final Post news;
  DetailsPage({Key key, this.news}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isScrollLimitReached = true;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener((){
      final newState = _scrollController.offset <=
          (_scrollController.position.minScrollExtent + 120.0);

      if (newState != _isScrollLimitReached) {
        setState(() {
          _isScrollLimitReached = newState;
        });
      }
    });
  }

  @override
//  Widget build(BuildContext context) {
//    final topContentText = Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        SizedBox(height: 70.0),
//        Image(image: AssetImage("assets/images/logo.png"), height: 50),
////        Icon(
////          Icons.directions_car,
////          color: Colors.white,
////          size: 40.0,
////        ),
//        Container(
//          width: 90.0,
//          child: new Divider(color: Colors.green),
//        ),
//        SizedBox(height: 10.0),
//        Text(
//          widget.news.title,
//          style: TextStyle(color: Colors.white, fontSize: 24.0),
//        ),
//        SizedBox(height: 30.0),
//      ],
//    );
//
//    Widget image() {
//      if (widget.news.img != null) {
//        return Container(
//            padding: EdgeInsets.only(left: 10.0),
//            height: MediaQuery.of(context).size.height * 0.4,
//            decoration: new BoxDecoration(
//                image: DecorationImage(
//                    image: NetworkImage(
//                        'https://timetable.artyshko.ru/public/uploads${widget.news.img}'),
//                    fit: BoxFit.cover)));
//      } else {
//        return Container(
//            padding: EdgeInsets.only(left: 10.0),
//            height: MediaQuery.of(context).size.height * 0.4,
//            decoration: new BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage('assets/images/background.png'),
//                    fit: BoxFit.cover)));
//      }
//    }
//
//    final topContent = Stack(
//      children: <Widget>[
//        image(),
//        Container(
//          height: MediaQuery.of(context).size.height * 0.4,
//          padding: EdgeInsets.all(40.0),
//          width: MediaQuery.of(context).size.width,
//          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .7)),
//          child: topContentText,
//        ),
//        Positioned(
//          left: 8.0,
//          top: 60.0,
//          child: InkWell(
//            onTap: () {
//              Navigator.pop(context);
//            },
//            child: Icon(Icons.arrow_back, color: Colors.white),
//          ),
//        )
//      ],
//    );
//
//    final bottomContentText = Expanded(
//        flex: 1,
//        child: new SingleChildScrollView(
//            child: Text(
//          widget.news.body,
//          style: TextStyle(fontSize: 18.0),
//        )));
//    final bottomContent = Container(
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height * 0.6,
//      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//      child: Center(
//        child: Column(
//          children: <Widget>[bottomContentText],
//        ),
//      ),
//    );
//
//    return Scaffold(
//      body: Column(
//        children: <Widget>[topContent, bottomContent],
//      ),
//    );
//  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 260.0,
              primary: true,
              pinned: true,
              backgroundColor: Color(0xFF006CB5),
              flexibleSpace: FlexibleSpaceBar(
                title: _isScrollLimitReached
                    ? ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    widget.news.title,
                    textScaleFactor: 0.8,
                    style: TextStyle(fontSize: 16),
//                    overflow: TextOverflow.ellipsis,
                  ),
                )
                    : Text(
                  widget.news.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: Image(
                  image: AdvancedNetworkImage(
                    (widget.news.img != null) ?  'https://timetable.artyshko.ru/public/uploads${widget.news.img}' : 'https://timetable.artyshko.ru/uploads/images/7fad611613fc12bd1a3ccd1b91e9250a.jpg?_t=1567420295',
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                  ),
                  fit: BoxFit.cover,
                  frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) {
                      return Container(
                        child:child,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xCC000000),
                              const Color(0x90000000),
                              const Color(0x90000000),
                              const Color(0xCC000000)
                            ]
                          )
                        ),
                        height: 260,
                        width: double.infinity,
                      );
                    } else {
                      return Container(
                        child: CircularProgressIndicator(
                          value: null,
                          backgroundColor: Colors.white
                        ),
                        alignment: Alignment(0, 0),
                        constraints: BoxConstraints.expand(),
                      );
                    }
                  }
                ),
                collapseMode: CollapseMode.parallax,
              ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Html(
                data: widget.news.body,
                padding: EdgeInsets.all(10.0),
                backgroundColor: Colors.white70,
                defaultTextStyle: TextStyle(fontFamily: 'serif', fontSize: 16),
                linkStyle: const TextStyle(
                  color: Colors.blueAccent,
                ),
                onLinkTap: (url) {
                  launch(url);
                },
              ),
            )
          )
        ],
      ),
    );
  }
}
