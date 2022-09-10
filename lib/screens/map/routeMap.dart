import 'package:flutter/material.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({Key? key}) : super(key: key);

  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image(
          image: AssetImage(
            'assets/images/mapimage.png'
          ),
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height*1,
          width: MediaQuery.of(context).size.width*1,
        ),
      ),
    );
  }
}
