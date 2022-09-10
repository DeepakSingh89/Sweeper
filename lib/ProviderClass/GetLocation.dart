import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetLocation with ChangeNotifier {
  Location location = new Location();
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LatLng _center = const LatLng(40.7127753, -74.0059728);

  Future<void> showlocation(BuildContext context) async {
    ///bool geolocationStatus = await Geolocator().isLocationServiceEnabled();
    try {
      bool geolocationStatus1 = await location.serviceEnabled();
      if (Theme.of(context).platform == TargetPlatform.android) {
        if (geolocationStatus1) {
          if (await location.hasPermission() == PermissionStatus.granted) {
            var data = await location.getLocation();
            locationData = data;
            _center = new LatLng(locationData!.latitude!.toDouble(),
                locationData!.longitude!.toDouble());
            notifyListeners();
          } else {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              if (_permissionGranted == PermissionStatus.deniedForever) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Give Location Permission!'),
                  duration: Duration(minutes: 2),
                  action: SnackBarAction(
                      label: 'Open setting',
                      onPressed: () => AppSettings.openAppSettings()),
                ));
              } else {
                show_locationdialog(context,
                    'You have to enable location permisson to show all the near by Restaurants');
              }
            } else {
              var data = await location.getLocation();
              locationData = data;
              _center = new LatLng(locationData!.latitude!.toDouble(),
                  locationData!.longitude!.toDouble());
              notifyListeners();
            }
          }
        } else {
          if (!await location.requestService()) {
            show_locationdialog(context,
                'You have to enable location service to show all the near by Restaurants');
          } else {
            showlocation(context);
          }
        }
      } else {
        if (!await location.serviceEnabled()) {
          //AppSettings.openLocationSettings();
          locationPemissionDialog(context,
              'You have to enable location service to show all the near by Restaurants');
        } else {
          _permissionGranted = await location.hasPermission();

          if (_permissionGranted != PermissionStatus.granted) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Give Location Permission!'),
                  duration: Duration(minutes: 2),
                  action: SnackBarAction(
                      label: 'Open setting',
                      onPressed: () => AppSettings.openAppSettings()),
                ),
              );
            } else {
              var data = await location.getLocation();
              locationData = data;
              _center = new LatLng(locationData!.latitude!.toDouble(),
                  locationData!.longitude!.toDouble());
              notifyListeners();
            }
          } else {
            var data = await location.getLocation();
            locationData = data;
            _center = new LatLng(locationData!.latitude!.toDouble(),
                locationData!.longitude!.toDouble());
            notifyListeners();
          }
        }
      }
    } catch (exception) {
      print('exception is $exception');
    }
  }

  show_locationdialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
//                    exit(0);
                    Navigator.of(context).pop();
                    showlocation(context);
                  },
                ),
              )
            ],
          );
        });
  }

  locationPemissionDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
//                    exit(0);
                    Navigator.of(context).pop();
                    AppSettings.openLocationSettings();
                  },
                ),
              )
            ],
          );
        });
  }


}
