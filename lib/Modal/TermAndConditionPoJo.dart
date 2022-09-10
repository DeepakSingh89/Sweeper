import 'dart:convert';

TermAndConditionPoJo termAndConditionPoJoFromJson(String str) => TermAndConditionPoJo.fromJson(json.decode(str));

String termAndConditionPoJoToJson(TermAndConditionPoJo data) => json.encode(data.toJson());

class TermAndConditionPoJo {
  TermAndConditionPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory TermAndConditionPoJo.fromJson(Map<String, dynamic> json) => TermAndConditionPoJo(
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
    this.shortDescription,
    this.description,
    this.status,
    this.userId,
    this.parrentId,
    this.type,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? title;
  dynamic shortDescription;
  String? description;
  String? status;
  int? userId;
  int? parrentId;
  String? type;
  String? slug;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    shortDescription: json["short_description"],
    description: json["description"] == null ? null : json["description"],
    status: json["status"] == null ? null : json["status"],
    userId: json["user_id"] == null ? null : json["user_id"],
    parrentId: json["parrent_id"] == null ? null : json["parrent_id"],
    type: json["type"] == null ? null : json["type"],
    slug: json["slug"] == null ? null : json["slug"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "short_description": shortDescription,
    "description": description == null ? null : description,
    "status": status == null ? null : status,
    "user_id": userId == null ? null : userId,
    "parrent_id": parrentId == null ? null : parrentId,
    "type": type == null ? null : type,
    "slug": slug == null ? null : slug,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
