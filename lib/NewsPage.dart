import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 3.0,
        child: new GestureDetector(
          child: new Container(
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.png",
                  alignment: Alignment.center,
                  width: 120.0,
                  height: 120.0,
                ),
                new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Business Headlines",
                    style: TextStyle(
                        fontSize: 20.0, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            var id = 1;
          },
        )
    );
  }
}