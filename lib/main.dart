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
        primarySwatch: Colors.blue,
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


  Future<Null> findLocation() async {
    Map<String, double> location;

    try {
      location = await _location.getLocation;

      setState(() {
        this.locations = [location];
      });
    } catch (exception) {}
  }

  void handleSubmit() {
    String lat;
    String lng;
    lat = _latController.text;
    lng = _lngController.text;

    setState(() {
      locations.add({
        "latitude": lat,
        "longitude": lng
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new StaticMap(googleMapsApi, locations: locations),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 25.0),
            child: new Column(
              children: <Widget>[
                new Text('Press the button to find your location'),
                new RaisedButton(
                  onPressed: () => findLocation(),
                  child: new Text('Get My Locations'),
                  color: Theme.of(context).primaryColor,
                ),
                new RaisedButton(
                  onPressed: () => print('reset'),
                  child: new Text('Reset Map'),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 25.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: _latController,
                  decoration: const InputDecoration(
                    labelText: 'latitude',
                  )
                ),
                new TextField(
                    controller: _lngController,
                    decoration: const InputDecoration(
                      labelText: 'longitude',
                    )
                ),
                new RaisedButton(onPressed:() => handleSubmit()),
              ],
            )
          )
        ],
      )),
    );
  }
}
