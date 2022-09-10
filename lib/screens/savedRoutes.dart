import 'package:Sweeper/screens/map/Driver_list.dart';
import 'package:Sweeper/Modal/Routes.dart';
import 'package:Sweeper/ProviderClass/DriverFriendsProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'map/showmaproute.dart';

class SavedRoutes extends StatefulWidget {
  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<SavedRoutes> {
  late String selectedDate = '', showDate = '';
  DateTime? sdateTime;
  late String dateTime;
  String? dateVal;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  GoogleMapController? mapsController;
  Map<PolylineId, Polyline> polylines = {};

  // Starting point latitude
  double _originLatitude = 26.8046765;

// Starting point longitude
  double _originLongitude = 75.8292854;
  PolylinePoints? polylinePoints;

  @override
  void initState() {

      polylinePoints = PolylinePoints();
      WidgetsBinding.instance!.addPostFrameCallback((_) => {getRoutes()});
      Provider.of<DriverFriendsProvider>(context, listen: false).loading = false;
      Provider.of<DriverFriendsProvider>(context, listen: false)
          .driverFriendsList(context);


    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Saved Routes",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: Common.displayHeight(context),
        width: Common.displayWidth(context),
        child:
        Consumer<Routes?>(
          builder: (BuildContext context, modal, Widget? child) {
            return modal!.loading
                ? modal.getRoutesData!.data!.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: modal.getRoutesData!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return
                            _routeListUi(
                              modal.getRoutesData!.data![index]);
                        })
                    : Center(
                        child: new Text(
                          'No record found',
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      )
                : Common.loadingIndicator(Colors.blue);
          },
        ),
      ),
    );
  }



  Widget _routeListUi(Datum modal) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CalendarDatePick()));
                        },
                        child: Text(
                          modal.routeName!,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )),
                  ),
                  InkWell(
                    onTap: () {


                      if (modal.originLatt != null &&
                          modal.origin_lng != null &&
                          modal.destiLatt != null &&
                          modal.desti_lng != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowMapRoutes(
                                  sourcelatt: modal.originLatt!,
                                  sourcelng: modal.origin_lng!,
                                  destlatt: modal.destiLatt!,
                                  destilng: modal.desti_lng!,
                                  type: 1,
                                  routeId: modal.id.toString(),
                                )));
                      } else {
                        Common.showSnackBar(
                            "No path created.", context, Colors.red);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.green,
                      width: 70,
                      height: 30,
                      child: Text(
                        "Activate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Common.sizeBoxWidth(10),
                  GestureDetector(
                      onTap: () {
                        Provider.of<Routes>(context, listen: false)
                            .selectedDate = '';
                        Provider.of<DriverFriendsProvider>(context,
                                listen: false)
                            .isSelectedValue = -1;
                        Provider.of<DriverFriendsProvider>(context,
                                listen: false)
                            .selectedDriverId = 0;
                        Provider.of<DriverFriendsProvider>(context,
                                listen: false)
                            .selectedDriverName = "";
                        showDriverList(context, modal.id.toString());
                      },
                      child: Icon(
                        Icons.share,
                        color: Colors.grey,
                      )),
                  Common.sizeBoxWidth(20),
                  // GestureDetector(
                  //   onTap: () {
                  //     if (modal.originLatt != null &&
                  //         modal.origin_lng != null &&
                  //         modal.destiLatt != null &&
                  //         modal.desti_lng != null)
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => ShowMapRoutes(
                  //                 sourcelatt: modal.originLatt!,
                  //                 sourcelng: modal.origin_lng!,
                  //                 destlatt: modal.destiLatt!,
                  //                 destilng: modal.desti_lng!,
                  //             type: 2,
                  //             routeId: modal.id.toString(),
                  //               )));
                  //   },
                  //   child: Icon(Icons.map_rounded),
                  // )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(8),
                height: 200,
                child: _googleMap(modal)),
          ],
        ),
      ),
    );
  }

  void getRoutes() async {
    Provider.of<Routes>(context, listen: false).loading = false;
    Provider.of<Routes>(context, listen: false).getRoutesData = null;
    await Provider.of<Routes>(context, listen: false).routeList(context);
  }

  _googleMap(Datum modal) {
    return GoogleMap(
        polylines: Set<Polyline>.of(modal.polylines!.values),
        markers: modal.markers!,
        zoomGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomControlsEnabled: false,
        rotateGesturesEnabled: false,
        trafficEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              modal.originLatt != null ? modal.originLatt! : _originLatitude,
              modal.originLatt != null ? modal.origin_lng! : _originLongitude),
          zoom: 14,
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapsController = controller;
  }

  void getPolyline(Datum modal) async {
    // String jsonResponse= json.decode(modal.routeCoordinates!);
    print(modal.routeCoordinates);
    Polyline? polyline;
    List<LatLng> polylineCoordinates = [];
    if (modal.routeCoordinates!.isNotEmpty) {
      modal.routeCoordinates!.forEach((RouteCoordinate point) {
        polylineCoordinates.add(LatLng(point.lat!, point.lng!));
      });
    } else {
      print('error');
    }
    polyline = Polyline(
        polylineId: PolylineId('poly1' '${modal.id}'),
        visible: true,
        color: Colors.blueAccent,
        points: polylineCoordinates);
    polylines[PolylineId('poly1' '${modal.id}')] = polyline;
    setState(() {});
  }

  showDriverList(BuildContext context, String routeId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045),
                              ),
                              Text(
                                "* Friends *",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.blue,
                                ),
                                // Text(
                                //   "close",
                                //   style: TextStyle(
                                //       color: Colors.blue,
                                //       fontWeight: FontWeight.w400,
                                //       fontSize:
                                //           MediaQuery.of(context).size.width * 0.045),
                                // ),
                              ),
                            ],
                          ),
                        )),
                    Common.sizeBoxHeight(10),
                    Common.divider(0.3),
                    Common.sizeBoxHeight(5),
                    Consumer<DriverFriendsProvider>(
                      builder: (context, modal, child) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 9,
                          child: modal.loading
                              ? modal.driverFriendListData.data != null &&
                                      modal.driverFriendListData.data!.length >
                                          0
                                  ? ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () {
                                            modal.selectDriver(i);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10, bottom: 10),
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.055,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  modal.driverFriendListData
                                                              .data![i].name !=
                                                          null
                                                      ? modal
                                                          .driverFriendListData
                                                          .data![i]
                                                          .name
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    modal.selectDriver(i);
                                                  },
                                                  icon: modal.isSelectedValue ==
                                                          i
                                                      ? Icon(
                                                          Icons
                                                              .radio_button_checked,
                                                          color: Colors.blue)
                                                      : Icon(
                                                          Icons
                                                              .radio_button_unchecked,
                                                          color: Colors.blue),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: modal
                                          .driverFriendListData.data!.length)
                                  : Center(
                                      child: new Text(
                                        'No Friends found',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                              : Common.loadingIndicator(Colors.blue),
                        );
                      },
                    ),
                    Common.sizeBoxHeight(10),
                    dateLay(context),
                    Common.sizeBoxHeight(10),
                    Consumer<DriverFriendsProvider>(
                      builder: (context, modal, child) {
                        return MaterialButton(
                          disabledColor: Colors.grey,
                          disabledElevation: 0.0,
                          elevation: 3.0,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Colors.blue,
                          height: MediaQuery.of(context).size.height * 0.05,
                          minWidth: MediaQuery.of(context).size.width * 0.25,
                          textColor: Theme.of(context).primaryColor,
                          onPressed: modal.isSelectedValue == -1
                              ? null
                              : () {
                                  if (Provider.of<Routes>(context,
                                              listen: false)
                                          .selectedDate !=
                                      '') {
                                    Provider.of<Routes>(context, listen: false)
                                        .shareRoute(
                                            modal.selectedDriverId.toString(),
                                            routeId,
                                            Provider.of<Routes>(context,
                                                    listen: false)
                                                .showDate,
                                            context);
                                  } else {
                                    Navigator.pop(context);
                                    Common.showSnackBar(
                                        "Please select route share date.",
                                        context,
                                        Colors.red);
                                  }
                                },
                          child: const Text(
                            'Share',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ],
                )),
          );
        });
  }

  dateLay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Provider.of<Routes>(context, listen: false).selectDate(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: const Color(0xffe2e6ea), width: 1),
                  color: const Color(0xffffffff)),
              padding: const EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              height: Common.displayHeight(context) * 0.075,
              child: Consumer<Routes>(
                builder: (context, modal, child) {
                  return ListTile(
                    title: modal.selectedDate != ''
                        ? Text(
                            modal.selectedDate != ''
                                ? modal.showDate
                                : 'Select Date',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: Common.displayWidth(context) * 0.045,
                            ))
                        : // Enter your full name
                        Text("Select Date",
                            style: TextStyle(
                                color: const Color(0xff979797),
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: Common.displayWidth(context) * 0.045),
                            textAlign: TextAlign.left),
                    trailing: Icon(
                      Icons.arrow_drop_down_sharp,
                      size: Common.displayWidth(context) * 0.1,
                      color: Colors.black38,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
