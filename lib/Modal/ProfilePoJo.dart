import 'dart:convert';

ProfilePoJo profilePoJoFromJson(String str) => ProfilePoJo.fromJson(json.decode(str));

String profilePoJoToJson(ProfilePoJo data) => json.encode(data.toJson());

class ProfilePoJo {
  ProfilePoJo({
    this.status,
    this.message,
    this.userInfo,
  });

  bool? status;
  String? message;
  UserInfo? userInfo;

  factory ProfilePoJo.fromJson(Map<String, dynamic> json) => ProfilePoJo(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    userInfo: json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "user_info": userInfo == null ? null : userInfo!.toJson(),
  };
}

class UserInfo {
  UserInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.deviceId,
    this.lat,
    this.lng,
    this.emailVerifiedAt,
    this.isEmailVerified,
    this.notificationStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.profilePic,
    this.city,
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
  dynamic notificationStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? profilePic;
  String? city;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    lat: json["lat"] == null ? null : json["lat"],
    lng: json["lng"] == null ? null : json["lng"],
    emailVerifiedAt: json["email_verified_at"],
    isEmailVerified: json["isEmailVerified"] == null ? null : json["isEmailVerified"],
    notificationStatus: json["notification_status"] == null ? null : json["notification_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
    city: json["city"] == null ? null : json["city"],
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
    "notification_status": notificationStatus == null ? null : notificationStatus,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "profile_pic": profilePic == null ? null : profilePic,
    "city": city == null ? null : city,
  };
}
