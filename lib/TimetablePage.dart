import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  int _current = 0;

  @override
  Widget build(BuildContext context){
    return Stack(
        children: [
          CarouselSlider(
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0 , top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 13.0,
                          color: Colors.black.withOpacity(.2),
                          offset: Offset(6.0, 1.0),
                        )
                      ]
                    ),
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            color: Color(0xFF006CB5),
                            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text('Понедельник',
                                    style:
                                    TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold
                                    )
                                  )
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 40),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: new BorderRadius.all(Radius.circular(40.0))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      child:
                                        Text('Сегодня',
                                          style:
                                            TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                        )
                                    )
                                )
                              ]
                            )
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text('13:00',
                                        style: TextStyle(
                                          color: Colors.grey
                                        )
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Русский язык'),
                                          Text('Евсюкова М. В.',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              )
                                          )
                                        ]
                                      )
                                    )
                                  ]
                                )
                              ),
                              Divider(height: 1.0,color: Colors.grey)
                            ]
                          );
                        }
                      }
                    )
                  );
                },
              );
            }).toList(),
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            enlargeCenterPage: true,
            aspectRatio: 9/16,
            height: MediaQuery.of(context).size.height - 180,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            reverse: false,
            scrollDirection: Axis.horizontal,
          ),
          Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1,2,3,4,5].map((i) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == [1,2,3,4,5].indexOf(i) ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
                    ),
                  );
                }).toList(),
              )
          )
        ]
    );
  }
}