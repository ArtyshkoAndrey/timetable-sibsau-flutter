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
  GoogleMapController mapController;
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
        position: LatLng(56.0118637,92.9738288),
        infoWindow: InfoWindow(
          title: 'Корпус «А»',
          snippet: 'пр. им. газеты «Красноярский рабочий», 31',
        ));
    _markers['B'] = Marker(
        markerId: MarkerId('B'),
        position: LatLng(56.015588,92.9881793),
        infoWindow: InfoWindow(
          title: 'Корпус «Б»',
          snippet: 'пр. им. газеты «Красноярский рабочий», 29',
        ));
    _markers['V'] = Marker(
        markerId: MarkerId('V'),
        position: LatLng(56.015414,92.9862323),
        infoWindow: InfoWindow(
          title: 'Корпус «В»',
          snippet: 'пр. им. газеты «Красноярский рабочий», 29 строение 94',
        ));

    _markers['G'] = Marker(
        markerId: MarkerId('G'),
        position: LatLng(55.989305, 92.880716),
        infoWindow: InfoWindow(
          title: 'Корпус «Г»',
          snippet: 'ул. Анатолия Гладкова, 6',
        ));

    _markers['D'] = Marker(
        markerId: MarkerId('D'),
        position: LatLng(56.014413, 92.975120),
        infoWindow: InfoWindow(
          title: 'Корпус «Д»',
          snippet: 'пр. им. газеты Красноярский рабочий, 56',
        ));
    _markers['E'] = Marker(
        markerId: MarkerId('E'),
        position: LatLng(56.015676, 92.979998),
        infoWindow: InfoWindow(
          title: 'Корпус «Е»',
          snippet: 'пр. им. газеты Красноярский рабочий, 48б',
        ));
    _markers['K'] = Marker(
        markerId: MarkerId('K'),
        position: LatLng(56.011439, 92.974886),
        infoWindow: InfoWindow(
          title: 'Корпус «K»',
          snippet: 'пр. им. газеты Красноярский рабочий, 31a',
        ));
    _markers['L'] = Marker(
        markerId: MarkerId('L'),
        position: LatLng(56.012797, 92.974153),
        infoWindow: InfoWindow(
          title: 'Корпус «Л»',
          snippet: 'пр. им. газеты Красноярский рабочий, 31 стр. 5',
        ));
    _markers['M'] = Marker(
        markerId: MarkerId('M'),
        position: LatLng(55.985715, 93.005734),
        infoWindow: InfoWindow(
          title: 'Корпус «M»',
          snippet: 'пр. Машиностроителей, 54',
        ));
    _markers['N'] = Marker(
        markerId: MarkerId('N'),
        position: LatLng(56.012652, 92.974302),
        infoWindow: InfoWindow(
          title: 'Корпус «Н»',
          snippet: 'пр. им. газеты Красноярский рабочий, 31 стр. 5',
        ));
    _markers['O'] = Marker(
        markerId: MarkerId('O'),
        position: LatLng(55.983323, 92.898008),
        infoWindow: InfoWindow(
          title: 'Корпус «O»',
          snippet: 'ул. 60 лет Октября, 109',
        ));
    _markers['P'] = Marker(
        markerId: MarkerId('P'),
        position: LatLng(56.012652, 92.974302),
        infoWindow: InfoWindow(
          title: 'Корпус «П»',
          snippet: '56.012125, 92.974701',
        ));
    _markers['R'] = Marker(
        markerId: MarkerId('R'),
        position: LatLng(56.042818, 93.028004),
        infoWindow: InfoWindow(
          title: 'Корпус «Р»',
          snippet: 'ул. Рейдовая, 69',
        ));
    _markers['S'] = Marker(
        markerId: MarkerId('S'),
        position: LatLng(55.999309, 92.950228),
        infoWindow: InfoWindow(
          title: 'Корпус «С»',
          snippet: 'Семафорная улица, 433/1',
        ));
    _markers['Yu'] = Marker(
        markerId: MarkerId('Yu'),
        position: LatLng(56.014901, 92.972407),
        infoWindow: InfoWindow(
          title: 'Корпус «Ю»',
          snippet: 'ул. Юности, 39',
        ));
    _markers['Kollege'] = Marker(
        markerId: MarkerId('Kollege'),
        position: LatLng(56.011748, 92.973884),
        infoWindow: InfoWindow(
          title: 'Аэрокосмический колледж',
          snippet: 'пр. им. газеты Красноярский рабочий, 31',
        ));
    _markers['School'] = Marker(
        markerId: MarkerId('School'),
        position: LatLng(56.018429, 92.977581),
        infoWindow: InfoWindow(
          title: 'Аэрокосмическая школа',
          snippet: 'Иркутская улица, 2',
        ));
    _markers['Library'] = Marker(
        markerId: MarkerId('Library'),
        position: LatLng(56.015314, 92.971482),
        infoWindow: InfoWindow(
          title: 'Научная библиотека',
          snippet: 'ул. Чайковского, 10',
        ));

    _markers['Gl'] = Marker(
        markerId: MarkerId('Gl'),
        position: LatLng(56.012192, 92.869012),
        infoWindow: InfoWindow(
          title: 'Корпус «Гл»',
          snippet: 'пр. Мира, 82',
        ));
    _markers['Cl'] = Marker(
        markerId: MarkerId('Cl'),
        position: LatLng(56.012834, 92.868987),
        infoWindow: InfoWindow(
          title: 'Корпус «Цл»',
          snippet: 'пр. Мира, 82',
        ));
    _markers['SK'] = Marker(
        markerId: MarkerId('SK'),
        position: LatLng(56.013095, 92.869007),
        infoWindow: InfoWindow(
          title: 'Корпус «СК»',
          snippet: 'пр. Мира, 82',
        ));
    _markers['YSK'] = Marker(
        markerId: MarkerId('YSK'),
        position: LatLng(56.015314, 92.971482),
        infoWindow: InfoWindow(
          title: 'Корпус «УСК»',
          snippet: 'ул. Ленина, 90',
        ));
    _markers['Al'] = Marker(
        markerId: MarkerId('Al'),
        position: LatLng(56.014707, 92.868088),
        infoWindow: InfoWindow(
          title: 'Корпус «Ал»',
          snippet: 'пр. Марковского, 57',
        ));
    _markers['Two'] = Marker(
        markerId: MarkerId('Two'),
        position: LatLng(56.013073, 92.870769),
        infoWindow: InfoWindow(
          title: 'Корпус «2»',
          snippet: 'пр. Мира, 82',
        ));
    _markers['Vl'] = Marker(
        markerId: MarkerId('Vl'),
        position: LatLng(56.014088, 92.867649),
        infoWindow: InfoWindow(
          title: 'Корпус «Вл»',
          snippet: 'пр. Марковского, 57',
        ));
    _markers['Bl'] = Marker(
        markerId: MarkerId('Bl'),
        position: LatLng(56.014074, 92.868043),
        infoWindow: InfoWindow(
          title: 'Корпус «Бл»',
          snippet: 'пр. Марковского, 57',
        ));
    _markers['Sl'] = Marker(
        markerId: MarkerId('Sl'),
        position: LatLng(56.005168, 92.843274),
        infoWindow: InfoWindow(
          title: 'Корпус «Cл»',
          snippet: 'пр. Робеспьера, 2',
        ));

    _markers['Library2'] = Marker(
        markerId: MarkerId('Library2'),
        position: LatLng(56.012636, 92.870369),
        infoWindow: InfoWindow(
          title: 'Научная библиотека',
          snippet: 'пр. Мира, 82',
        ));
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
