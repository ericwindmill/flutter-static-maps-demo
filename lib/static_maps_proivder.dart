import 'package:flutter/material.dart';

class StaticMap extends StatefulWidget {
  final List locations;
  final String googleMapsApiKey;
  final int width;
  final int height;
  final int zoom;

  StaticMap(this.googleMapsApiKey,
      {this.width, this.height, this.locations, this.zoom});
  @override
  _StaticMapState createState() => new _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;
  Map<String, String> defaultLocation = {
    "latitude": '37.0902',
    "longitude": '-95.7192'
  };
  String renderUrl;

  _buildUrl(List locations, int width, int height) {
    var finalUri;
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    print(widget.locations.length);

    if (widget.locations.length == 1) {
      finalUri = baseUri.replace(queryParameters: {
        'center': '${locations[0]['latitude']},${locations[0]['longitude']}',
        'zoom': widget.zoom.toString(),
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
    if (widget.locations.length == 0) {
      widget.locations.add(defaultLocation);
    }
    _buildUrl(widget.locations, widget.width ?? defaultWidth,
        widget.height ?? defaultHeight);
    return new Container(
         child:  new Image.network(renderUrl),
    );
  }
}
