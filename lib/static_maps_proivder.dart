import 'package:flutter/material.dart';

class StaticMap extends StatefulWidget {
  final List locations;
  final String googleMapsApiKey;
  final int width;
  final int height;

  StaticMap(this.googleMapsApiKey, {this.width, this.height, this.locations});
  @override
  _StaticMapState createState() => new _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  static const int defaultZoomLevel = 4;
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;
  Map<String, String> defaultLocation = {
    "latitude": '37.0902',
    "longitude": '-95.7192'
  };
  String renderUrl;

  initState() {
    super.initState();

    if (widget.locations.length == 0) {
      widget.locations.add(defaultLocation);
    }
  }

  _buildUrl(List locations, int width, int height) {
    var finalUri;
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    if (widget.locations.length == 1) {
      finalUri = baseUri.replace(queryParameters: {
        'center': '${locations[0]['latitude']},${locations[0]['longitude']}',
        'zoom': defaultZoomLevel.toString(),
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        '${widget.googleMapsApiKey}': ''
      });
    } else {
      List<String> markers = new List();
      widget.locations.forEach((location) {
        var lat = location['latitude'];
        var lng = location['longitude'];
        String marker = '$lat,$lng';
        markers.add(marker);
      });
      String markersString = markers.join('|');
      finalUri = baseUri.replace(queryParameters: {
        'markers': markersString,
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        '${widget.googleMapsApiKey}': ''
      });
    }
    print(finalUri);

    setState(() {
      renderUrl = finalUri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildUrl(widget.locations, widget.width ?? defaultWidth,
        widget.height ?? defaultHeight);
    return new Container(
      child: new Image.network(renderUrl),
    );
  }
}
