import 'package:flutter/material.dart';
import './classes/Timetable.dart';
import 'package:url_launcher/url_launcher.dart';
import './classes/app_config.dart';
import './DetailsImage.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import './helpClass/flutter_html.dart';

class DetailsPage extends StatefulWidget {
  final Post news;
  DetailsPage({Key key, this.news}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isScrollLimitReached = true;
  ScrollController _scrollController;
  AppConfig _ac;

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
  Widget build(BuildContext context) {
    _ac = AppConfig(context);
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
                  constraints: BoxConstraints(maxWidth: _ac.rW(50)),
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
                padding: EdgeInsets.all(15.0),
                backgroundColor: Colors.white70,
                defaultTextStyle: TextStyle(fontFamily: 'Open-Sans', fontSize: 16),
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
