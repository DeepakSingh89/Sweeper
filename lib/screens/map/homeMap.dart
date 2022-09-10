import 'package:Sweeper/ProviderClass/AdsProvider.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/map/Driver_list.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:provider/provider.dart';
import 'package:Sweeper/ProviderClass/GetLocation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Sweeper/screens/drawer/drawer.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double lat = 37.42796133580664;
  static double lng = -122.085749655962;
  GoogleMapController? mapsController;
  late double mapBottomPadding  ;
  void _onMapCreated(GoogleMapController controller) {
    mapsController = controller;
    // setState(() {
    //   mapBottomPadding=280 ;
    //
    //
    // });
  }
  var addressTextCtrl = TextEditingController();

  @override
  void initState() {
    getDriverList();
    // getCurrentLocation();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerManually(),
      body: Consumer<Driverlist>(
        builder: (context, modal, child){
          return modal.loading
              ? Stack(
            children: [
              GoogleMap(

                markers: Set<Marker>.of(modal
                    .markers.values),
                polylines: Set<Polyline>.of(modal
                    .mapPolylines
                    .values),
                indoorViewEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                padding: EdgeInsets.only(top: 580.0),
                initialCameraPosition: CameraPosition(
                  target: modal.driverData !=null &&
                      modal.driverData!.data !=null &&
                      modal.driverData!.data!.length > 0 &&
                      modal.driverData!.data![0].startCoordinates !=null &&
                      modal.driverData!.data![0].startCoordinates!.lat != null &&
                      modal.driverData!.data![0].startCoordinates!.lng != null &&
                      modal.driverData!.data![0].startCoordinates!.lng != null
                      ? LatLng(
                      double.parse(
                          modal
                              .driverData!.data![0].startCoordinates!.lat
                              .toString()),
                      double.parse(
                          modal
                              .driverData!.data![0].startCoordinates!.lng
                              .toString()))
                      : LatLng(double.parse(Provider.of<GetLocation>(context, listen: false).locationData!.latitude.toString()),
                      double.parse(Provider.of<GetLocation>(context, listen: false).locationData!.longitude.toString())),
                  zoom: 18.0,
                ),
                onMapCreated: _onMapCreated,

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
                              .width * 0.5,
                          child: TextFormField(
                            controller: addressTextCtrl,
                            readOnly: true,
                            onTap: () async {
                              await Common.openPlacePicker(context).then((value) => {
                                addressTextCtrl.text = value['address'],
                                lat = value['latt'],
                                lng = value['lng'],
                              });
                              if (lat != 0.0 && lng != 0.0) {
                                Provider.of<Driverlist>(context, listen: false).loading = false;
                                Provider.of<Driverlist>(context, listen: false).driverData =null;
                                await Provider.of<Driverlist>(context, listen: false).driverList(context,
                                    lat.toString(),
                                    lng.toString());
                                setState(() {});
                              }
                            },
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                hintText: 'Your Location'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.close),onPressed: (){
                                addressTextCtrl.clear();
                              },),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              : Common.loadingIndicator(Colors.blue);
        },
      ),
    );
  }

  customDiloge() {
    return showDialog(
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

  void _showOrderDetailPopUp(BuildContext context, String title, String dis,
      String action) {
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

  getCurrentLocation() async {
    await Provider.of<GetLocation>(context, listen: false)
        .showlocation(context);
    print("Langtitude: " +
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .latitude
            .toString());
    print("Longtitude: " +
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .longitude
            .toString());
    if (Provider
        .of<GetLocation>(context, listen: false)
        .locationData != null &&
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .latitude !=
            null &&
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .longitude !=
            null) {
      setState(() {
        lat = Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .latitude!;
        lng = Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .longitude!;
      });
      print("Langtitude: " + lat.toString());
      print("Longtitude: " + lng.toString());
    } else {
      setState(() {
        lat = 37.42796133580664;
        lng = -122.085749655962;
      });
      print("Langtitude: " + lat.toString());
      print("Longtitude: " + lng.toString());
    }
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      target: LatLng(lat, lng),
    );
    if (mapsController != null) {
      mapsController!
          .animateCamera(CameraUpdate.newCameraPosition(cPosition));
    }
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
    // _getAddressFromLatLng();
  }


  getDriverList() async {
    Provider.of<AdsProvider>(context, listen: false).ads(context);
    Provider.of<AdsProvider>(context, listen: false).reset(context);
    Provider.of<AdsProvider>(context, listen: false).startTimer(context);
    await Provider.of<GetLocation>(context, listen: false)
        .showlocation(context);
    Provider
        .of<Driverlist>(context, listen: false)
        .loading = false;
    Provider
        .of<Driverlist>(context, listen: false)
        .driverData = null;
    if (Provider
        .of<GetLocation>(context, listen: false)
        .locationData != null &&
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .latitude !=
            null &&
        Provider
            .of<GetLocation>(context, listen: false)
            .locationData!
            .longitude !=
            null) {
      await Provider.of<Driverlist>(context, listen: false).driverList(context,
          Provider
              .of<GetLocation>(context, listen: false)
              .locationData!
              .latitude.toString(), Provider
              .of<GetLocation>(context, listen: false)
              .locationData!
              .longitude.toString());
      setState(() {});
    }
  }

}
