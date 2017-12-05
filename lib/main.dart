import 'dart:async';

import 'package:flutter/material.dart';
import 'package:static_maps_example/static_maps_proivder.dart';
import 'package:location/location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Static Maps',
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.lightBlueAccent,
      ),
      home: new MyHomePage(title: 'Static Maps Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location _location = new Location();
  List locations = [];
  String googleMapsApi = 'AIzaSyCzxj6UFfx8uvDaaE9OSSPkjJXdou3jD9I';
  TextEditingController _latController = new TextEditingController();
  TextEditingController _lngController = new TextEditingController();
  int zoom = 4;

  Future<Null> findUserLocation() async {
    Map<String, double> location;
    try {
      location = await _location.getLocation;
      setState(() {
        this.locations = [location];
      });
    } catch (exception) {}
  }

  void handleSubmitNewMarker() {
    String lat;
    String lng;
    lat = _latController.text;
    lng = _lngController.text;

    setState(() {
      locations.add({"latitude": lat, "longitude": lng});
    });
    _lngController.clear();
    _latController.clear();
  }

  void increaseZoom() {
    setState(() {
      zoom = zoom + 1;
    });
  }

  void decreaseZoom() {
    setState(() {
      zoom = zoom - 1;
    });
  }

  void resetMap() {
    setState(() {
      locations = [];
      zoom = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(locations.length);
    var isActiveColor =
        (locations.length <= 1) ? Theme.of(context).primaryColor : Colors.grey;

    Widget body = new Container(
      child: new Column(
        children: <Widget>[
          // Map Section w/ +/- buttons
          new Stack(
            children: <Widget>[
              new StaticMap(googleMapsApi, locations: locations, zoom: zoom),
              new Positioned(
                top: 130.0,
                right: 10.0,
                child: new FloatingActionButton(
                  onPressed: (locations.length <= 1) ? increaseZoom : null,
                  backgroundColor: isActiveColor,
                  child: new Icon(
                    const IconData(0xe145, fontFamily: 'MaterialIcons'),
                  ),
                ),
              ),
              new Positioned(
                top: 190.0,
                right: 10.0,
                child: new FloatingActionButton(
                  onPressed: (locations.length <= 1) ? decreaseZoom : null,
                  backgroundColor: isActiveColor,
                  child: new Icon(
                    const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                  ),
                ),
              ),
            ],
          ),
          // Get Location & Reset Button Section
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  onPressed: findUserLocation,
                  child: new Text('Get My Current Location'),
                  color: Theme.of(context).primaryColor,
                ),
                new RaisedButton(
                  onPressed: resetMap,
                  child: new Text('Reset Map'),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          // Marker Placement Input Section
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                    controller: _latController,
                    decoration: const InputDecoration(
                      labelText: 'latitude',
                    )),
                new TextField(
                    controller: _lngController,
                    decoration: const InputDecoration(
                      labelText: 'longitude',
                    )),
                new Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: new RaisedButton(
                    onPressed: handleSubmitNewMarker,
                    child: new Text('Place Marker'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: body,
    );
  }
}
