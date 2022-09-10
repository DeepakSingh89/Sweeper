import 'dart:io';
import 'package:Sweeper/util/Common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Sweeper/Modal/NearDriverPoJo.dart';
import 'package:Sweeper/util/marker_generator.dart';
import 'package:flutter/cupertino.dart';

class MapDriverMarkerProv extends ChangeNotifier{

  Set<Marker> markers = Set<Marker>();
  String isLoad = '1';

  Future<void> add(BuildContext context, List<Datum>? data, Size size) async {
    data!.forEach((discoverData) async {
      MarkerGenerator(
        Stack(
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/truck.png"), fit: BoxFit.cover)),
            ),
            Positioned(
                bottom: 90,
                right: 60,
                child: Container(
                    width: 180.0,
                    height: 180.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/truck.png")))))
          ],
        ),
            (bitmaps) {
          if (discoverData.lat != null && discoverData.lng != null) {
            markers.add(Marker(
              icon: BitmapDescriptor.fromBytes(bitmaps),
              markerId: MarkerId(discoverData.id.toString()),
              position: LatLng(double.parse(discoverData.lat.toString()),
                  double.parse(discoverData.lng.toString())),
              onTap: () {
              },
            ));
            if (isLoad == '1') {
              Common.hideLoading(context);
              isLoad = '2';
            }

            notifyListeners();
          }
        },
      ).generate(context);
      notifyListeners();
    });
  }


}