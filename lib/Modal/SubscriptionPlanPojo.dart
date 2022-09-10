// To parse this JSON data, do
//
//     final subscriptionPlanPoJo = subscriptionPlanPoJoFromJson(jsonString);

import 'dart:convert';

SubscriptionPlanPoJo subscriptionPlanPoJoFromJson(String str) => SubscriptionPlanPoJo.fromJson(json.decode(str));

String subscriptionPlanPoJoToJson(SubscriptionPlanPoJo data) => json.encode(data.toJson());

class SubscriptionPlanPoJo {
  SubscriptionPlanPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<Datum>? data;

  factory SubscriptionPlanPoJo.fromJson(Map<String, dynamic> json) => SubscriptionPlanPoJo(
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
    this.title,
    this.description,
    this.price,
    this.type,
    this.number,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? title;
  String? description;
  String? price;
  String? type;
  int? number;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    type: json["type"] == null ? null : json["type"],
    number: json["number"] == null ? null : json["number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "price": price == null ? null : price,
    "type": type == null ? null : type,
    "number": number == null ? null : number,
    "created_at": createdAt == null ? null : createdAt! .toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!                                         .toIso8601String(),
    "deleted_at": deletedAt,
  };
}
