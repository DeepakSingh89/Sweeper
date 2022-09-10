import 'dart:convert';

CardDeletePoJo cardDeletePoJoFromJson(String str) => CardDeletePoJo.fromJson(json.decode(str));

String cardDeletePoJoToJson(CardDeletePoJo data) => json.encode(data.toJson());

class CardDeletePoJo {
  CardDeletePoJo({
    this.status,
    this.message,
    this.response,
  });

  String? status;
  String? message;
  Response? response;

  factory CardDeletePoJo.fromJson(Map<String, dynamic> json) => CardDeletePoJo(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "response": response == null ? null : response!.toJson(),
  };
}

class Response {
  Response({
    this.id,
    this.object,
    this.deleted,
  });

  String? id;
  String? object;
  bool? deleted;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    deleted: json["deleted"] == null ? null : json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "deleted": deleted == null ? null : deleted,
  };
}
