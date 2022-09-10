import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:Sweeper/ProviderClass/RouteActiveInactiveProvder.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geocoder;
import 'package:Sweeper/ProviderClass/NearDriverListProv.dart';
import 'package:Sweeper/ProviderClass/GetLocation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Sweeper/screens/drawer/drawer.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class ShowMapRoutes extends StatefulWidget {
  double? sourcelatt, sourcelng, destlatt, destilng;
  int? type;
  String? routeId;

  ShowMapRoutes(
      {Key? key, this.sourcelatt, this.sourcelng, this.destlatt,
        this.destilng, this.type, this.routeId})
      : super(key: key);

  @override
  _ShowMapRoutesState createState() => _ShowMapRoutesState();
}

class _ShowMapRoutesState extends State<ShowMapRoutes> {
  String? _currentAddress;
  Location? location;
  late LocationData currentLocation;
  double? sourceLng;
  double? sourceLatt;
  GoogleMapController? mapsController;
  List<LatLng>? distancepolylineCoordinates = [];

  PolylinePoints? polylinePoints;
  bool isStart = false;
  Polyline? polyline;
  TextEditingController _textFieldController = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  String? startTime;
  String? endTime;
  List<double> speedList = [];
  double? speedVal;
  double caltotalDistance = 0.0;
  double? totalDistanceValueCal = 0.03;

  @override
  void initState() {
    // TODO: implement initState
    location = new Location();
    polylinePoints = PolylinePoints();
    setUppins();
    location!.onLocationChanged.listen((LocationData cLoc) {
      print('get location ${cLoc.latitude} ${cLoc.longitude}');
      if (isStart)
      {
        double distance = _coordinateDistance(
            sourceLatt, sourceLng, cLoc.latitude, cLoc.longitude);
        if (distance > 0.01) {
          speedList.add(double.parse(cLoc.speed!.toStringAsFixed(2)));
          distancepolylineCoordinates
              ?.add(LatLng(cLoc.latitude!, cLoc.longitude!));
          sourceLatt = cLoc.latitude;
          sourceLng = cLoc.longitude;
          currentLocation = cLoc;
          if (mounted) {
            setState(() {});
          }
          _getAddressFromLatLng(
              currentLocation.latitude, currentLocation.longitude);
          updatePinOnMap();

        } else {
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerManually(),
      body: Stack(
        children: [
          GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            indoorViewEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: _markers,
            onMapCreated: _onMapCreated,
            mapToolbarEnabled: true,
            minMaxZoomPreference: MinMaxZoomPreference(10.0, 22.0),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.sourcelatt != null ? widget.sourcelatt! : 0.0,
                  widget.sourcelng != null ? widget.sourcelng! : 0.0),
              zoom: 11.0,
            ),
            padding: EdgeInsets.only(top: 580.0 ,right: 20),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    InkWell(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: Icon(Icons.menu)),
                    SizedBox(width: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.68,
                      child: TextField(
                        decoration: InputDecoration(
                            hintMaxLines: 2,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            hintText: _currentAddress == ''
                                ? 'Your Location'
                                : _currentAddress,
                            suffixIcon: Icon(Icons.close)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           if (isStart) {
            if(widget.type == 1){
              Provider.of<RouteActiveInActiveProvider>(context,listen: false)
          .routeInActive(widget.routeId.toString(), context);
              isStart = false;
            }else{
              isStart = false;
              await totalDistanceValue();
              Duration timediff=DateTime.now().difference(DateTime.parse(startTime!));
              polylineCoordinates=[];
              distancepolylineCoordinates=[];
              showLocationPopup(timediff);
            }
          } else {
            if(widget.type == 1){
              Provider.of<RouteActiveInActiveProvider>(context,listen: false)
                  .routeActive(widget.routeId.toString(), context);
              isStart = true;
            }else{
              startTime=DateTime.now().toString();
              isStart = true;
            }
          }
          if (mounted) {
            setState(() {});
          }
        },
        child: isStart ? Text('Finish') : Text('Start'),
      ),
    );
  }

  customDiloge() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What do you want to remember?'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  setUppins() async {
    // Uint8List? markerIcon = await Common.getBytesFromAsset('assets/images/delivery-truck.png', 100);
    await Provider.of<GetLocation>(context, listen: false)
        .showlocation(context);
    if (Provider.of<GetLocation>(context, listen: false).locationData != null &&
        Provider.of<GetLocation>(context, listen: false)
                .locationData!
                .latitude !=
            null &&
        Provider.of<GetLocation>(context, listen: false)
                .locationData!
                .longitude !=
            null) {
      _markers.add(Marker(
          markerId: MarkerId('sourcePin1'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(widget.sourcelatt!, widget.sourcelng!)));
      _markers.add(Marker(
        markerId: MarkerId('destPin1'),
        position: LatLng(widget.destlatt!, widget.destilng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

      CameraPosition cPosition = CameraPosition(
        zoom: 16,
        target: LatLng(widget.sourcelatt!, widget.sourcelng!),
      );
      if (mapsController != null) {
        mapsController!
            .animateCamera(CameraUpdate.newCameraPosition(cPosition));
      }
      _getAddressFromLatLng(
          widget.sourcelatt!, widget.sourcelng!);
      if (mounted) {
        setState(() {});
      }
    } else {
      setState(() {});
    }
    _getPolyline();
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void updatePinOnMap() async {
    Uint8List? markerIcon =
        await Common.getBytesFromAsset('assets/images/delivery-truck.png', 100);
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );

    print(
        'updated coordinates ${currentLocation.latitude!} ${currentLocation.longitude!}');
    if (mapsController != null) {
      mapsController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    }
    if (mounted) {
      setState(() {
        var pinPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _markers.removeWhere((m) => m.markerId.value == 'destPin1');
        Marker marker = Marker(
          markerId: MarkerId('destPin1'),
          position: pinPosition,
          icon: BitmapDescriptor.fromBytes(markerIcon),
        );
        _markers.add(marker);
      });
      _updatePolyline();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapsController = controller;
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    Polyline? polyline;
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
      'AIzaSyDfYy9JovU1we00qR3PZQt3dx_imneouds',
      PointLatLng(widget.sourcelatt!, widget.sourcelng!),
      PointLatLng(widget.destlatt!, widget.destilng!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    // Defining an ID
    polyline = Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 2,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[PolylineId("poly")] = polyline;
    setState(() {});
    /* } else {
      print(result.errorMessage);
    }*/
  }

  void _updatePolyline() async {
    List<LatLng> polylineCoordinates = [];
    Polyline? polyline;
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
      'AIzaSyDfYy9JovU1we00qR3PZQt3dx_imneouds',
      PointLatLng(widget.sourcelatt!, widget.sourcelng!),
      PointLatLng(currentLocation.latitude!, currentLocation.longitude!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    // Defining an ID
    polyline = Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 2,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[PolylineId("poly")] = polyline;
    setState(() {});
    /* } else {
      print(result.errorMessage);
    }*/
  }

  _getAddressFromLatLng(latti, lng) async {
    try {
      List<geocoder.Placemark> p =
          await geocoder.placemarkFromCoordinates(latti, lng);
      geocoder.Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
      print(_currentAddress.toString());
    } catch (e) {
      print(e);
    }
  }

  showLocationPopup(Duration timediff) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Save this route',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Common.sizeBoxHeight(10.0),
                  Text(
                      'Time ${timediff.inHours.toString().padLeft(2, "0")} : ${timediff.inMinutes.remainder(60).toString().padLeft(2, "0")} : '
                      '${timediff.inSeconds.remainder(60).toString().padLeft(2, "0")}'),
                  Common.sizeBoxHeight(5.0),
                  Text('Distance ${totalDistanceValueCal} Miles'),
                  Common.sizeBoxHeight(10.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Location name"),
                  ),
                  Common.sizeBoxHeight(50.0),
                  FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('OK'),
                    onPressed: () {
                      Common.removeFocus(context);
                      if (_textFieldController.text == '') {
                        Common.show_dialog(
                            context, 'Please enter location name');
                      } else {
                        setState(() {
                          List<Map<String, dynamic>> dataList = [];
                          distancepolylineCoordinates!.forEach((element) {
                            Map<String, dynamic> reqData = {
                              'lat': element.latitude,
                              'lng': element.longitude,
                            };
                            dataList.add(reqData);
                          });
                          Navigator.pop(context);
                          polylines = {};
                          if (mounted) {
                            setState(() {});
                          }
                          Provider.of<NearDriverListProv>(context, listen: false)
                              .saveUserRoute(dataList, _textFieldController.text, context).then((value) =>
                          {
                            Navigator.of(context).pop()
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  //calculate total distance traveled
  Future<void> totalDistanceValue() async {
    //speed calcluate
    double val = 0.0;
    speedList.forEach((item) {
      val = val + item;
    });
    if (speedList.length > 0) {
      int totalLength = speedList.length;
      double speedaVal = val.toInt() / totalLength;
      speedVal = double.parse(speedaVal.toStringAsFixed(2));
      //data.speedVal = speedVal;
    } else {
      speedVal = 0.0;
    }

    //distance calcualte
    if (mounted) {
      setState(() {
        caltotalDistance = 0.0;
        if (distancepolylineCoordinates!.length != 0 &&
            distancepolylineCoordinates != null) {
          for (int i = 0; i < distancepolylineCoordinates!.length - 1; i++) {
            caltotalDistance += _coordinateDistance(
              distancepolylineCoordinates![i].latitude,
              distancepolylineCoordinates![i].longitude,
              distancepolylineCoordinates![i + 1].latitude,
              distancepolylineCoordinates![i + 1].longitude,
            );
          }
          double newVal = double.parse(caltotalDistance.toStringAsFixed(4));
          double val = newVal * 0.62137;
          String value = val.toStringAsFixed(2);
          totalDistanceValueCal = double.parse(value);
          //data.totaldisval = totalDistanceValueCal;
        }
      });

      //timke calclate
      double disMeter = totalDistanceValueCal! * 1609.34;
      if (disMeter == 0.0 || speedVal == 0.0) {
        //data.time = 0;
      } else {
        double time = disMeter / speedVal!;

        //data.time = time.toInt();
      }
      print('Total distance $totalDistanceValueCal');
      // print('Time value ${data!.time}');
      print('Speed value ${speedVal}');
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mapsController!.dispose();
    super.dispose();
  }
}
