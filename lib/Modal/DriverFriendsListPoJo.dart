import 'dart:convert';

DriverFriendsListPoJo driverFriendsListPoJoFromJson(String str) => DriverFriendsListPoJo.fromJson(json.decode(str));

String driverFriendsListPoJoToJson(DriverFriendsListPoJo data) => json.encode(data.toJson());

class DriverFriendsListPoJo {
  DriverFriendsListPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<Datum>? data;

  factory DriverFriendsListPoJo.fromJson(Map<String, dynamic> json) => DriverFriendsListPoJo(
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
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.email,
    this.phone,
    this.deviceId,
    this.lat,
    this.lng,
    this.emailVerifiedAt,
    this.isEmailVerified,
    this.password,
    this.rememberToken,
    this.driverId,
    this.profilePic,
  });

  int? id;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? name;
  String? email;
  dynamic phone;
  String? deviceId;
  dynamic lat;
  dynamic lng;
  dynamic emailVerifiedAt;
  int? isEmailVerified;
  String? password;
  dynamic rememberToken;
  int? driverId;
  String? profilePic;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    lat: json["lat"],
    lng: json["lng"],
    emailVerifiedAt: json["email_verified_at"],
    isEmailVerified: json["isEmailVerified"] == null ? null : json["isEmailVerified"],
    password: json["password"] == null ? null : json["password"],
    rememberToken: json["remember_token"],
    driverId: json["driver_id"] == null ? null : json["driver_id"],
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone,
    "device_id": deviceId == null ? null : deviceId,
    "lat": lat,
    "lng": lng,
    "email_verified_at": emailVerifiedAt,
    "isEmailVerified": isEmailVerified == null ? null : isEmailVerified,
    "password": password == null ? null : password,
    "remember_token": rememberToken,
    "driver_id": driverId == null ? null : driverId,
    "profile_pic": profilePic == null ? null : profilePic,
  };
}
