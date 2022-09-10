import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as polyPlugin;
class Routes with ChangeNotifier{
  String? status;
  String? message;
  List<Datum>? data;

  String selectedDate = '', showDate = '';
  DateTime? sdateTime;
  late String dateTime;
  String? dateVal;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  bool loading = false;
  Routes? getRoutesData;

  Routes({this.status, this.message, this.data});

  Routes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }


  Future<dynamic> routeList(BuildContext context) async{
    try {
      Uint8List? markerIcon =
      await Common.getBytesFromAsset('assets/images/delivery-truck.png', 100);
      var response = await ApiServices.getRoutes(context);
      if (response != null)
      {
        notifyListeners();
        if (response.status== "success")
        {
          loading = true;
          notifyListeners();
          getRoutesData=response;
          for(int i=0;i<getRoutesData!.data!.length;i++)
          {
            if(getRoutesData!.data![i].routeCoordinates!.length>0)
            {
              for(int j=0;j<getRoutesData!.data![i].routeCoordinates!.length;j++)
              {
                if(j==0){
                  getRoutesData!.data![i].originLatt=  getRoutesData!.data![i].routeCoordinates![j].lat;
                  getRoutesData!.data![i].origin_lng= getRoutesData!.data![i].routeCoordinates![j].lng;
                }else if(j==getRoutesData!.data![i].routeCoordinates!.length-1){
                  getRoutesData!.data![i].destiLatt= getRoutesData!.data![i].routeCoordinates![j].lat;
                  getRoutesData!.data![i].desti_lng= getRoutesData!.data![i].routeCoordinates![j].lng;
                }
              }
              print('lng ${getRoutesData!.data![i].origin_lng}');
              print('latti ${getRoutesData!.data![i].originLatt}');

              getRoutesData!.data![i].markers!.add(Marker(
                visible: false,
                markerId: MarkerId('sourcePin''${getRoutesData!.data![i].id}'),
                position: LatLng(getRoutesData!.data![i].originLatt!,
                    getRoutesData!.data![i].origin_lng!),
                // ignore: deprecated_member_use
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ));
              getRoutesData!.data![i].markers!.add(Marker(
                markerId: MarkerId('destPin''${getRoutesData!.data![i].id}'),
                position: LatLng(getRoutesData!.data![i].destiLatt!,
                    getRoutesData!.data![i].desti_lng!),
                // ignore: deprecated_member_use
                icon: BitmapDescriptor.fromBytes(markerIcon),
              ));

              await createPolylines(getRoutesData!.data![i].originLatt,
                  getRoutesData!.data![i].origin_lng,
                  getRoutesData!.data![i].destiLatt
                  ,getRoutesData!.data![i].desti_lng,
                  getRoutesData!.data![i].id,i);
            }

          }
          notifyListeners();
        } else {
          loading = true;
          notifyListeners();
          Common.showSnackBar(response.message!, context, Colors.red);
        }
      } else {
        loading = true;
        notifyListeners();
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      loading = true;
      notifyListeners();
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }


  ///************ Share Route *****************///
  Future<dynamic> shareRoute(String driverId,String routeId,String date, BuildContext context) async{
    try {
      Common.showLoading(context);
      var response = await ApiServices.shareRouteApi(driverId, routeId, date,context);
      if (response != null) {
        Common.hideLoading(context);
        if (response['status'] == "success") {
          Navigator.pop(context);
          Common.showSnackBar(response['message'].toString(), context, Colors.black);
        } else if (response['status'] == "fail"){
          Navigator.pop(context);
          Common.showSnackBar(response['message'].toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }




  createPolylines(userLat, userLng,
      destinationLat,  destinationLng,int? polyline_id,int? index) async
  {
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    polyPlugin.PolylinePoints polylinePoints = polyPlugin.PolylinePoints();
    // Initializing PolylinePoints
    polylinePoints = polyPlugin.PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    polyPlugin.PolylineResult result =
    await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDfYy9JovU1we00qR3PZQt3dx_imneouds', // Google Place API Key
      polyPlugin.PointLatLng( userLat,userLng),
      polyPlugin.PointLatLng( destinationLat,  destinationLng),
      travelMode: polyPlugin.TravelMode.driving,
    );
    notifyListeners();
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((polyPlugin.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    notifyListeners();
    // Defining an ID
    PolylineId id = PolylineId('poly''${polyline_id}');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 2,
      color: Colors.blue,
    );

    polylines[id] = polyline;
    getRoutesData!.data![index!].polylines![id]=polyline;
    notifyListeners();
  }

  // select  date
  selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    );
    if (d != null)
      selectedDate = DateFormat('yyy-MM-dd').format(d).toString();
    var date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(d.toString(), true);
    var dateLocal = date.toLocal();
    // var formattedDate = "${dateLocal.month}/${dateLocal.day.toString().padLeft(2, '0')}/${dateLocal.year.toString().padLeft(2, '0')}";
    // dateVal =
    // "${dateLocal.month}/${dateLocal.day.toString().padLeft(2, '0')}/${dateLocal.year.toString().padLeft(2, '0')}";

    DateFormat formatter = DateFormat('MM/dd/yyy');
    final String formatted = formatter.format(dateLocal);
    showDate = formatted;
    notifyListeners();

  }




}



class Datum {
  int? id;
  int? driverId;
  String? routeName;
  String? routeDesc;
  String? routeTime;
  int? status;
  double? originLatt;
  double? origin_lng;
  double? destiLatt;
  double? desti_lng;
  List<RouteCoordinate>? routeCoordinates;
  Map<PolylineId, Polyline>? polylines = {};
  Set<Marker>? markers = {};
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Datum(
      {this.id,
        this.driverId,
        this.routeName,
        this.routeDesc,
        this.routeTime,
        this.status,
        this.routeCoordinates,
        this.polylines,
        this.markers,
        this.originLatt,
        this.origin_lng,
        this.destiLatt,
        this.desti_lng,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Datum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    routeName = json['route_name'];
    routeDesc = json['route_desc'];
    routeTime = json['route_time'];
    status = json['status'];
    if (json['route_coordinates'] != null) {
      routeCoordinates = [];
      json['route_coordinates'].forEach((v) {
        routeCoordinates!.add(new RouteCoordinate.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['route_name'] = this.routeName;
    data['route_desc'] = this.routeDesc;
    data['route_time'] = this.routeTime;
    data['status'] = this.status;
    if (this.routeCoordinates != null) {
      data['route_coordinates'] =
          this.routeCoordinates!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class RouteCoordinate {
  RouteCoordinate({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory RouteCoordinate.fromJson(Map<String, dynamic> json) => RouteCoordinate(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
  };
}
