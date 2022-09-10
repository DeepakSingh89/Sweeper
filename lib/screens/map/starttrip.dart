import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:Sweeper/ProviderClass/AdsProvider.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
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

import 'Driver_list.dart';


class StartTrip extends StatefulWidget {
  const StartTrip({Key? key}) : super(key: key);

  @override
  _StartTripState createState() => _StartTripState();
}

class _StartTripState extends State<StartTrip> {
  static double lat = 37.42796133580664;
  static double lng = -122.085749655962;

  String? _currentAddress;
  Location? location;
  late LocationData currentLocation;
  double? sourceLng;
  double? sourceLatt;
  double? destiLng;
  double? destiLatt;
  GoogleMapController? mapsController;
  List<LatLng>? distancePolylineCoordinates = [];
  PolylinePoints? polylinePoints;
  bool isStart = false;
  Polyline? polyline;
  TextEditingController _textFieldController = TextEditingController();
  var addressTextCtrl = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  String? startTime;
  String? endTime;
  List<double> speedList = [];
  double? speedVal;
  double caltotalDistance = 0.0;
  double? totalDistanceValueCal=0.03;


  @override
  void initState() {
    location = new Location();
    polylinePoints = PolylinePoints();
    setUppins();
    location!.onLocationChanged.listen((LocationData cLoc) {
      print('get location ${cLoc.latitude} ${cLoc.longitude}');
      if(isStart) {
        currentLocation = cLoc;
        double distance = _coordinateDistance(
            sourceLatt, sourceLng, cLoc.latitude, cLoc.longitude);
        if (distance > 0.01) {
          speedList.add(double.parse(cLoc.speed!.toStringAsFixed(2)));
          //print(cLoc.speed.toStringAsFixed(2));
          distancePolylineCoordinates?.add(
              LatLng(cLoc.latitude!,cLoc.longitude!));
          sourceLatt = cLoc.latitude;
          sourceLng = cLoc.longitude;
          if (mounted) {
            setState(() {});
          }
          updatePinOnMap();
          _getAddressFromLatLng(
              currentLocation.latitude, currentLocation.longitude);
          //_addPolyLine();
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
  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.5212402, 3.3679965),
    zoom: 16,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(6.5212402, 3.3679965),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: 
                  Provider.of<GetLocation>(context, listen: false)
                                  .locationData !=
                              null &&
                          Provider.of<GetLocation>(context, listen: false)
                                  .locationData!
                                  .latitude !=
                              null &&
                          Provider.of<GetLocation>(context, listen: false)
                                  .locationData!
                                  .longitude !=
                              null
                      ? LatLng(
                          double.parse(
                              Provider.of<GetLocation>(context, listen: false)
                                  .locationData!
                                  .latitude
                                  .toString()),
                          double.parse(
                              Provider.of<GetLocation>(context, listen: false)
                                  .locationData!
                                  .longitude
                                  .toString()))
                      : LatLng(26.89191, 75.74136),
              zoom: 16.0,
            ),
            padding: EdgeInsets.only(top: 680.0,right: 20),

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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.6,
                      child: TextFormField(
                       controller: addressTextCtrl,
                       // readOnly: true,
                        onTap: () async {
                          // await Common.openPlacePicker(context).then((value) => {
                          //   addressTextCtrl.text = value['address'],
                          //   lat = value['latt'],
                          //   lng = value['lng'],
                          // });
                          // if (lat != 0.0 && lng != 0.0) {
                          //   Provider.of<Driverlist>(context, listen: false).loading = false;
                          //   Provider.of<Driverlist>(context, listen: false).driverData =null;
                          //   await Provider.of<Driverlist>(context, listen: false).driverListForDriver(context,
                          //       lat.toString(),
                          //       lng.toString());
                          //   setState(() {});
                          // }
                        },
                        // cursorColor: Colors.black,
                       // textInputAction: TextInputAction.search,
                       //  keyboardType: TextInputType.text,
                        maxLines: 1,
                        enabled: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            hintText: 'Your Location',
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        addressTextCtrl.clear();
                      },
                      child: Align(alignment:Alignment.centerRight
                          ,child: Icon(Icons.close)),
                    )
                    // Container(
                    //   width: MediaQuery
                    //       .of(context)
                    //       .size
                    //       .width * 0.71,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: TextField(
                    //         controller: addressTextCtrl,,
                    //       cursorColor: Colors.black,
                    //       textInputAction: TextInputAction.search,
                    //       keyboardType: TextInputType.text,
                    //       maxLength:1,
                    //       decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           hintStyle: TextStyle(
                    //               fontSize: 14, fontWeight: FontWeight.bold),
                    //           hintText: 'Your Location',
                    //           suffixIcon: Icon(Icons.close)),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20.0,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _showOrderDetailPopUp(
                            context,
                            'No Sweeper!',
                            'Your area is free of any sweepers today',
                            'Dissmiss');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      if (isStart) {
                        isStart = false;
                        await totalDistanceValue();
                        Duration timediff=DateTime.now().difference(DateTime.parse(startTime!));
                        _textFieldController.clear();
                        showLocationPopup(timediff);
                      } else {
                        startTime=DateTime.now().toString();
                        isStart = true;
                        if(sourceLatt!=null && sourceLng!=null)
                        {
                          polylineCoordinates.add(LatLng(sourceLatt!, sourceLng!));
                        }
                      }

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color(0xff3FD2E6),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 28),
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage('assets/images/truck.png'),
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .05,
                              ),
                              isStart ? Text('Finish Route') : Text('Create Route'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox()
                ],
              )),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Container(
          //     height: 60,
          //     width: 60,
          //     padding: EdgeInsets.all(10.0),
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.white,
          //       heroTag: 'recenterr',
          //       onPressed: () {
          //
          //       },
          //       child: Icon(
          //         Icons.my_location,
          //         color: Colors.black,
          //       ),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //           side: BorderSide(color: Color(0xFFECEDF1))),
          //     ),
          //   ),
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async{
      //     if (isStart) {
      //       isStart = false;
      //       await totalDistanceValue();
      //       Duration timediff=DateTime.now().difference(DateTime.parse(startTime!));
      //       _textFieldController.clear();
      //       showLocationPopup(timediff);
      //     } else {
      //       startTime=DateTime.now().toString();
      //       isStart = true;
      //       if(sourceLatt!=null && sourceLng!=null)
      //       {
      //         polylineCoordinates.add(LatLng(sourceLatt!, sourceLng!));
      //       }
      //     }
      //
      //     if (mounted) {
      //       setState(() {});
      //     }
      //   },
      //   child: isStart ? Text('Finish') : Text('Start'),
      // ),
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

  void _showOrderDetailPopUp(
      BuildContext context, String title, String dis, String action) {
    // print("sent order id -- $orderId");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: 170,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        dis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          action,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ));
        });
  }


  setUppins() async {
    Uint8List? markerIcon = await Common.getBytesFromAsset('assets/images/delivery-truck.png', 100);
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
      sourceLatt = Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .latitude!;
      sourceLng = Provider.of<GetLocation>(context, listen: false)
          .locationData!
          .longitude!;

      destiLatt = Provider.of<GetLocation>(context, listen: false)
              .locationData!
              .latitude!;
      destiLng = Provider.of<GetLocation>(context, listen: false)
              .locationData!
              .longitude!;
      _markers.add(Marker(
        visible: false,
          markerId: MarkerId('sourcePin1'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position:
              // LatLng(_originLatitude,_originLongitude),
              LatLng(sourceLatt!, sourceLng!)
          // ignore: deprecated_member_use
          ));

      _markers.add(Marker(
        markerId: MarkerId('destPin1'),
        position:
            // LatLng(_destLatitude,_destLongitude),
            LatLng(destiLatt!, destiLng!),
        // ignore: deprecated_member_use
        icon:BitmapDescriptor.fromBytes(markerIcon),
      ));
      CameraPosition cPosition = CameraPosition(
        zoom: 16,
        target: LatLng(sourceLatt!, sourceLng!),
      );
      if (mapsController != null) {
        mapsController!
            .animateCamera(CameraUpdate.newCameraPosition(cPosition));
      }
      _getAddressFromLatLng(
          sourceLatt!, sourceLng!);
      if (mounted) {
        setState(() {});
      }
      // _getPolyline();
      //_getAddressFromLatLng();
      // _getAddressFromLatLng(sourceLatt,sourceLng);
    } else {
      setState(() {
        //lat = 37.42796133580664;
        // lng = -122.085749655962;
      });
      // print("Langtitude: " + lat.toString());
      // print("Longtitude: " + lng.toString());
    }
    ///update lat lang for drivers
    Provider.of<UserAuthProvider>(context, listen: false).updateLocation(
        context,
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .latitude!
            .toString(),
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .longitude!
            .toString()
    );
    // Provider.of<NearDriverListProv>(context, listen: false)
    //     .nearDriversList(currentLocation.altitude.toString(), currentLocation.longitude.toString(), context);
    // _getAddressFromLatLng();
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
    Uint8List? markerIcon = await Common.getBytesFromAsset('assets/images/delivery-truck.png', 100);
    CameraPosition cPosition = CameraPosition(
      zoom: 20,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );

    print('updated coordinates ${currentLocation.latitude!} ${currentLocation.longitude!}');
    if (mapsController!= null) {
      mapsController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    }
    if (mounted) {
      setState(() {
        var pinPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _markers.removeWhere((m) => m.markerId.value == 'destPin1');
        Marker marker = Marker(
          markerId: MarkerId('destPin1'),
          position: pinPosition,
          icon:BitmapDescriptor.fromBytes(markerIcon),
        );
        _markers.add(marker);
      });
      _getPolyline();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapsController = controller;
  }

  void _getPolyline() async {
      polylineCoordinates.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
      polyline = Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        width: 5,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[PolylineId("poly")] = polyline!;
    setState(() {});
   /* } else {
      print(result.errorMessage);
    }*/
    // _addPolyLine(polylineCoordinates);
  }

  _getAddressFromLatLng(latti, lng) async {

    try {
      List<geocoder.Placemark> p =
          await geocoder.placemarkFromCoordinates(latti, lng);
      geocoder.Placemark place = p[0];
      setState(() {

        _currentAddress =
        "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        //addressTextCtrl.text=_currentAddress!;
      });

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
              height: MediaQuery.of(context).size.height*0.3,
              child:Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Save this route',style: TextStyle(fontSize: 20.0,
                      fontWeight:FontWeight.bold),),
                  Common.sizeBoxHeight(10.0),
                  Text('Time ${timediff.inHours.toString().padLeft(2,"0")} : ${timediff.inMinutes.remainder(60).toString().padLeft(2,"0")} : '
                      '${timediff.inSeconds.remainder(60).toString().padLeft(2,"0")}'),
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
                  Common.sizeBoxHeight(30.0),
                  FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('OK'),
                    onPressed: () {
                      Common.removeFocus(context);
                      if (_textFieldController.text == '') {
                        Common.show_dialog(context, 'Please enter location name');
                      } else {
                        List<Map<String, dynamic>> dataList = [];
                        distancePolylineCoordinates!.forEach((element) {
                          Map<String, dynamic> reqData = {
                            'lat': element.latitude,
                            'lng': element.longitude,
                          };
                          dataList.add(reqData);
                        });
                        print(distancePolylineCoordinates!.length);
                        Navigator.pop(context);
                        polylines={};
                        if(mounted){
                          setState(() {
                          });
                        }
                        Provider.of<NearDriverListProv>(context, listen: false)
                            .saveUserRoute(
                            dataList, _textFieldController.text, context);
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
        if (distancePolylineCoordinates!.length != 0 &&
            distancePolylineCoordinates != null) {
          for (int i = 0; i < distancePolylineCoordinates!.length - 1; i++) {
            caltotalDistance += _coordinateDistance(
              distancePolylineCoordinates![i].latitude,
              distancePolylineCoordinates![i].longitude,
              distancePolylineCoordinates![i + 1].latitude,
              distancePolylineCoordinates![i + 1].longitude,
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
