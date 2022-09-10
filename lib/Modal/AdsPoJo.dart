import 'dart:convert';

AdsPoJo adsPoJoFromJson(String str) => AdsPoJo.fromJson(json.decode(str));

String adsPoJoToJson(AdsPoJo data) => json.encode(data.toJson());

class AdsPoJo {
  AdsPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory AdsPoJo.fromJson(Map<String, dynamic> json) => AdsPoJo(
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
    this.id,
    this.title,
    this.description,
    this.bannerImage,
    this.status,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? title;
  String? description;
  String? bannerImage;
  int? status;
  DateTime? startAt;
  DateTime? endAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    bannerImage: json["banner_image"] == null ? null : json["banner_image"],
    status: json["status"] == null ? null : json["status"],
    startAt: json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
    endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "banner_image": bannerImage == null ? null : bannerImage,
    "status": status == null ? null : status,
    "start_at": startAt == null ? null : startAt!.toIso8601String(),
    "end_at": endAt == null ? null : endAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
