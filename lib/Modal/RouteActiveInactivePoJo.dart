import 'dart:convert';

RouteActiveInactivePoJo routeActiveInactivePoJoFromJson(String str) => RouteActiveInactivePoJo.fromJson(json.decode(str));

String routeActiveInactivePoJoToJson(RouteActiveInactivePoJo data) => json.encode(data.toJson());

class RouteActiveInactivePoJo {
  RouteActiveInactivePoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory RouteActiveInactivePoJo.fromJson(Map<String, dynamic> json) => RouteActiveInactivePoJo(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.driverId,
    this.routeId,
    this.routeName,
    this.routeCoordinates,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int? driverId;
  int? routeId;
  String? routeName;
  List<RouteCoordinate>? routeCoordinates;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    driverId: json["driver_id"] == null ? null : json["driver_id"],
    routeId: json["route_id"] == null ? null : json["route_id"],
    routeName: json["route_name"] == null ? null : json["route_name"],
    routeCoordinates: json["route_coordinates"] == null ? null : List<RouteCoordinate>.from(json["route_coordinates"].map((x) => RouteCoordinate.fromJson(x))),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId == null ? null : driverId,
    "route_id": routeId == null ? null : routeId,
    "route_name": routeName == null ? null : routeName,
    "route_coordinates": routeCoordinates == null ? null : List<dynamic>.from(routeCoordinates!.map((x) => x.toJson())),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "id": id == null ? null : id,
  };
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
