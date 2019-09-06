import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  final Map<String, Marker> _markers = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(56.012796, 92.869015),
    zoom: 16,
  );

  static final CameraPosition _kLeft =
      CameraPosition(target: LatLng(56.012796, 92.869015), zoom: 16);

  static final CameraPosition _kRight =
      CameraPosition(target: LatLng(56.012153, 92.974597), zoom: 16);

  @override
  void initState() {
    _markers['A'] = Marker(
        markerId: MarkerId('A'),
        position: LatLng(56.0127544, 92.9736427),
        infoWindow: InfoWindow(
          title: 'Корпус «А»',
          snippet: 'пр. им. газеты «Красноярский рабочий», 31',
        ));
    _markers['V'] = Marker(
        markerId: MarkerId('V'),
        position: LatLng(56.0154511, 92.9861462),
        infoWindow: InfoWindow(
          title: 'Корпус «В»',
          snippet: 'пр. им. газеты «Красноярский рабочий», 29',
        ));
    _markers['L'] = Marker(
        markerId: MarkerId('L'),
        position: LatLng(56.012970, 92.973901),
        infoWindow: InfoWindow(
          title: 'Корпус «Л»',
          snippet: 'пр. им. газеты Красноярский рабочий, 31',
        ));
    _markers['L'] = Marker(
        markerId: MarkerId('L'),
        position: LatLng(56.0123588, 92.8676686),
        infoWindow: InfoWindow(
          title: 'Корпус «Гл»',
          snippet: 'пр. Мира, 82',
        ));
    _markers['Bl'] = Marker(
        markerId: MarkerId('Bl'),
        position: LatLng(56.0147639, 92.867594),
        infoWindow: InfoWindow(
          title: 'Корпус «Бл»',
          snippet: 'ул. Марковского, 57',
        ));
    _markers['Yu'] = Marker(
        markerId: MarkerId('Yu'),
        position: LatLng(56.0174608, 92.9802543),
        infoWindow: InfoWindow(
          title: 'Корпус «Ю»',
          snippet: 'ул. Юности, 18а',
        ));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Карта кампуса', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white, //No more green
        elevation: 0.0, //Shadow gone
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            mapType: _currentMapType,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers.values.toSet(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: FloatingActionButton(
              onPressed: _onMapTypeButtonPressed,
              child: Icon(Icons.map),
              heroTag: null,
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Container(
            child: FloatingActionButton.extended(
              onPressed: _goToTheLeft,
              label: Text('Корпусы на левом'),
              heroTag: null,
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Container(
            child: FloatingActionButton.extended(
              onPressed: _goToTheRight,
              label: Text('Корпусы на правом'),
              heroTag: null,
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLeft() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLeft));
  }

  Future<void> _goToTheRight() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kRight));
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
