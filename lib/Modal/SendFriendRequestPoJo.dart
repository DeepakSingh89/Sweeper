import 'dart:convert';

SendFriendsRequestPoJo sendFriendsRequestPoJoFromJson(String str) => SendFriendsRequestPoJo.fromJson(json.decode(str));

String sendFriendsRequestPoJoToJson(SendFriendsRequestPoJo data) => json.encode(data.toJson());

class SendFriendsRequestPoJo {
  SendFriendsRequestPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory SendFriendsRequestPoJo.fromJson(Map<String, dynamic> json) => SendFriendsRequestPoJo(
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
    this.sendBy,
    this.sendTo,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int? sendBy;
  String? sendTo;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sendBy: json["send_by"] == null ? null : json["send_by"],
    sendTo: json["send_to"] == null ? null : json["send_to"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "send_by": sendBy == null ? null : sendBy,
    "send_to": sendTo == null ? null : sendTo,
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "id": id == null ? null : id,
  };
}
