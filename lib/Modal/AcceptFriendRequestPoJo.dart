// To parse this JSON data, do
//
//     final acceptFriendsRequestPoJo = acceptFriendsRequestPoJoFromJson(jsonString);

import 'dart:convert';

AcceptFriendsRequestPoJo acceptFriendsRequestPoJoFromJson(String str) => AcceptFriendsRequestPoJo.fromJson(json.decode(str));

String acceptFriendsRequestPoJoToJson(AcceptFriendsRequestPoJo data) => json.encode(data.toJson());

class AcceptFriendsRequestPoJo {
  AcceptFriendsRequestPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory AcceptFriendsRequestPoJo.fromJson(Map<String, dynamic> json) => AcceptFriendsRequestPoJo(
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
    this.sendBy,
    this.sendTo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  int? sendBy;
  int? sendTo;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    sendBy: json["send_by"] == null ? null : json["send_by"],
    sendTo: json["send_to"] == null ? null : json["send_to"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "send_by": sendBy == null ? null : sendBy,
    "send_to": sendTo == null ? null : sendTo,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
