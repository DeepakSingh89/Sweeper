import 'dart:io';
import 'package:Sweeper/Network/ApiServices.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/marker_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driverlist extends ChangeNotifier{
  bool? status;
  String? message;
  List<Data>? data;

  Driverlist? driverData;

  bool loading = false;
  PolylinePoints? polylinePoints = PolylinePoints();
  Polyline? polyline;
  List<LatLng> polylineCoordinates = [];
  Map<MarkerId, Marker> markers = {};
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  Map<PolylineId, Polyline> mapPolylines = {};
  int polyId = 1;
  int markId = 1;
  static const LatLng _center = const LatLng(26.89191, 75.74136);

  Driverlist({this.status, this.message, this.data});

  Driverlist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

  Future<dynamic> driverListForDriver(BuildContext context, String lat, String lng) async{
    try {
      loading = false;
      notifyListeners();
      var response = await ApiServices.getDriversForDriver(context, lat, lng);
      if (response != null)
      {
        if (response.status== true)
        {
          driverData = response;
          loading = true;
          notifyListeners();
          _add(driverData!.data!);
          _addMarker(driverData!.data!, "origin");
          notifyListeners();
        } else if(response.status== false){
          driverData = null;
          mapPolylines.clear();
          markers.clear();
          loading = true;
          notifyListeners();
          Common.showSnackBar(response.message.toString(), context, Colors.red);
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
     // Common.showSnackBar(ConstantsText.serverError, context, Colors.red);
    }
  }
  Future<dynamic> driverList(BuildContext context, String lat, String lng) async{
    try {
      loading = false;
      notifyListeners();
      var response = await ApiServices.getDrivers(context, lat, lng);
      if (response != null)
      {
        if (response.status== true)
        {

          driverData = response;
          loading = true;
          notifyListeners();
          _add(driverData!.data!);
          _addMarker(driverData!.data!, "origin");
          notifyListeners();
        } else if(response.status== false){
          driverData = null;
          mapPolylines.clear();
          markers.clear();
          loading = true;
          notifyListeners();
          Common.showSnackBar(response.message.toString(), context, Colors.red);
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

  void _add(List<Data> data) {
    data.forEach((index) {
      final String polylineIdVal = 'polyline_id_$polyId';
      final PolylineId polylineId = PolylineId(polylineIdVal);
      List<LatLng> _createPoints() {
        final List<LatLng> points = <LatLng>[];
        points.add(LatLng(index.startCoordinates!.lat!, index.startCoordinates!.lng!));
        points.add(LatLng(index.endCoordinates!.lat!, index.endCoordinates!.lng!));
        return points;
      }
      final Polyline polyline = Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: polylineId,
        consumeTapEvents: true,
        color: Colors.red,
        width: 5,
        points: _createPoints(),
        geodesic: true,
        jointType: JointType.round,
      );
      mapPolylines[polylineId] = polyline;
      polyId++;
      notifyListeners();
    });
  }

  _addMarker(List<Data> data, String id) async {
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)), "assets/images/delivery-truck.png");
  data.forEach((index) {
    MarkerId markerId = MarkerId("Marker_$markId");
    Marker marker =
    Marker(markerId: markerId, icon: icon,
        position: LatLng(double.parse(index.startCoordinates!.lat.toString()),double.parse(index.startCoordinates!.lng.toString()) ));
    markers[markerId] = marker;
    markId++;
    notifyListeners();
  });
  }


  ///*************** Send Friend Request Api *************///
  void sendFriendRequest(String driverId, BuildContext context) async {
    try {
      Common.showLoading(context);
      var response = await ApiServices.sendFriendRequestApi(driverId, context);
      if (response != null) {
        Common.hideLoading(context);
        if (response.status == "success") {
          driverData!.data![driverData!.data!
              .indexWhere((element) => element.id.toString() == driverId)]
              .status = "requested";
          notifyListeners();
          Common.showSnackBar(response.message.toString(), context, Colors.black);
        } else if (response.status == "fail") {
          Common.showSnackBar(response.message.toString(), context, Colors.red);
        }
      } else {
        Common.hideLoading(context);
        Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
      }
    } on SocketException {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.internetIssue, context, Colors.red);
    } catch (exception) {
      Common.hideLoading(context);
      Common.showSnackBar(ConstantsText.somethingWrongError, context, Colors.red);
    }
  }


}

class Data {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  String? deviceId;
  dynamic customerId;
  String? lat;
  String? lng;
  dynamic emailVerifiedAt;
  int? isEmailVerified;
  int? notificationStatus;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<RouteCoordinates>? routeCoordinates;
  dynamic distance;
  String? profilePic;
  String? rememberDevices;
  String? status;
  RouteCoordinates? startCoordinates;
  RouteCoordinates? endCoordinates;
  String? city;

  Data(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.deviceId,
        this.customerId,
        this.lat,
        this.lng,
        this.emailVerifiedAt,
        this.isEmailVerified,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.routeCoordinates,
        this.distance,
        this.profilePic,
        this.rememberDevices,
        this.status,
        this.startCoordinates,
        this.endCoordinates,
        this.city});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    deviceId = json['device_id'];
    customerId = json['customer_id'];
    lat = json['lat'];
    lng = json['lng'];
    emailVerifiedAt = json['email_verified_at'];
    isEmailVerified = json['isEmailVerified'];
    notificationStatus = json['notification_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['route_coordinates'] != null) {
      routeCoordinates = <RouteCoordinates>[];
      json['route_coordinates'].forEach((v) {
        routeCoordinates!.add(new RouteCoordinates.fromJson(v));
      });
    }
    distance = json['distance'];
    profilePic = json['profile_pic'];
    rememberDevices = json['remember_devices'];
    status = json['status'];
    startCoordinates = json['start_coordinates'] != null
        ? new RouteCoordinates.fromJson(json['start_coordinates'])
        : null;
    endCoordinates = json['end_coordinates'] != null
        ? new RouteCoordinates.fromJson(json['end_coordinates'])
        : null;
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['device_id'] = this.deviceId;
    data['customer_id'] = this.customerId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['isEmailVerified'] = this.isEmailVerified;
    data['notification_status'] = this.notificationStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.routeCoordinates != null) {
      data['route_coordinates'] =
          this.routeCoordinates!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    data['profile_pic'] = this.profilePic;
    data['remember_devices'] = this.rememberDevices;
    data['status'] = this.status;
    if (this.startCoordinates != null) {
      data['start_coordinates'] = this.startCoordinates!.toJson();
    }
    if (this.endCoordinates != null) {
      data['end_coordinates'] = this.endCoordinates!.toJson();
    }
    data['city'] = this.city;
    return data;
  }
}

class RouteCoordinates {
  double? lat;
  double? lng;

  RouteCoordinates({this.lat, this.lng});

  RouteCoordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

