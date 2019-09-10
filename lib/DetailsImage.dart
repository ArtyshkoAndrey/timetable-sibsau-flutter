import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class DetailsImage extends StatefulWidget {
  final src;
  DetailsImage({Key key, this.src}) : super(key: key);

  @override
  _DetailsImageState createState() => _DetailsImageState();
}

class _DetailsImageState extends State<DetailsImage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: null,
          backgroundColor: Colors.black, //No more green
          elevation: 0.0, //Shadow gone
        ),
        body: Container(
            child: PhotoView(
          imageProvider: AdvancedNetworkImage(
            widget.src,
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 1.3,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
          transitionOnUserGestures: true,
          heroTag: widget.src,
          backgroundDecoration: BoxDecoration(color: Colors.black),
          gaplessPlayback: false,
        )));
  }
}
