import 'dart:io';
import 'package:Sweeper/Network/Api_Urls.dart';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';


class Common{


  static Future<dynamic> openPlacePicker(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
        offset: 0,
        radius: 1000,
        types: [],
        strictbounds: false,
        region: "ar",
        context: context,
        apiKey: ApiUrls.kGoogleApiKey,
        mode: Mode.fullscreen,
        language: "en",
        components: [
          new Component(Component.country, "uk"),
          new Component(Component.country, "us"),
          new Component(Component.country, "ind")
        ]);
    if (p != null) {
      GoogleMapsPlaces _places = new GoogleMapsPlaces(
          apiKey: ApiUrls.kGoogleApiKey); //Same API_KEY as above
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId.toString());
      Map<String, dynamic> data;
      data = {
        'latt': detail.result.geometry!.location.lat,
        'lng': detail.result.geometry!.location.lng,
        'address': p.description,
      };
      return data;
    }
  }

  // Snack Bar
  static showSnackBar(
      String message, BuildContext context, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Widget divider(double size) {
    return Divider(
      thickness: size,
      color: Colors.grey,
    );
  }

  //Show loading dialog
  static showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.blue),
                          strokeWidth: 2.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text(
                            'Please Wait...',
                            style:
                            new TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        )
//                      : SizedBox(),
                      ]),
                ),
              )),
        );
      },
    );
  }

  //Hide loading dialog
  static hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  //Show Dialog Popup
  static Future<void> show_dialog(BuildContext context, String? message) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message!),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )
              : AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message!),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }


  //Show Dialog Popup
  static Future<void> viewDialog(BuildContext context, String message) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )
              : AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  //Loading indicator
  static Widget loadingIndicator(Color color) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Container(
                height: 30.0,
                width: 30.0,
                child: Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color,
                  ),
                ),
              )),
        ]);
  }


  static removeFocus(BuildContext context) {
    late  FocusScopeNode currentFocus = FocusScope.of(context);
    //hasPrimaryFocus is necessary to prevent Flutter from
    // throwing an exception when trying to un focus the node at the top of the tree
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
  //Size box for width
  static Widget sizeBoxWidth(double width) {
    return SizedBox(
      width: width,
    );
  }

  static Widget sizeBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Size displaySize(BuildContext context) {
    //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    // debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  static double displayWidth(BuildContext context) {
    //debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }
  static showSnakBarwithkey(
      String message, GlobalKey<ScaffoldState> _key, Color backgroundColor) {
//    _key.currentState.hideCurrentSnackBar();
    _key.currentState!.showSnackBar(new SnackBar(
      backgroundColor: backgroundColor,
      content: new Text(message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          )),
      duration: Duration(seconds: 2),
    ));
  }


  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


}