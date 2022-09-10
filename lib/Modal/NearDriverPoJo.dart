import 'dart:convert';

NearDriverPoJo nearDriverPoJoFromJson(String str) => NearDriverPoJo.fromJson(json.decode(str));

String nearDriverPoJoToJson(NearDriverPoJo data) => json.encode(data.toJson());

class NearDriverPoJo {
  NearDriverPoJo({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory NearDriverPoJo.fromJson(Map<String, dynamic> json) => NearDriverPoJo(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.deviceId,
    this.lat,
    this.lng,
    this.emailVerifiedAt,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.distance,
    this.profilePic,
    this.status,
    this.rememberDevices,
  });

  int? id;
  String? name;
  String? email;
  dynamic phone;
  String? deviceId;
  String? lat;
  String? lng;
  dynamic emailVerifiedAt;
  int? isEmailVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  double? distance;
  String? profilePic;
  String? status;
  String? rememberDevices;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    lat: json["lat"] == null ? null : json["lat"],
    lng: json["lng"] == null ? null : json["lng"],
    emailVerifiedAt: json["email_verified_at"],
    isEmailVerified: json["isEmailVerified"] == null ? null : json["isEmailVerified"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
    status: json["status"] == null ? null : json["status"],
    rememberDevices: json["remember_devices"] == null ? null : json["remember_devices"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone,
    "device_id": deviceId == null ? null : deviceId,
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
    "email_verified_at": emailVerifiedAt,
    "isEmailVerified": isEmailVerified == null ? null : isEmailVerified,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "distance": distance == null ? null : distance,
    "profile_pic": profilePic == null ? null : profilePic,
    "status": status == null ? null : status,
    "remember_devices": rememberDevices == null ? null : rememberDevices,
  };
}
