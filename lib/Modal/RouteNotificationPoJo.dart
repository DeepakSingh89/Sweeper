import 'dart:convert';

RouteNotificationPoJo routeNotificationPoJoFromJson(String str) => RouteNotificationPoJo.fromJson(json.decode(str));

String routeNotificationPoJoToJson(RouteNotificationPoJo data) => json.encode(data.toJson());

class RouteNotificationPoJo {
  RouteNotificationPoJo({
     this.status,
     this.message,
     this.data,
  });

  String? status;
  String? message;
  List<Datum>? data;

  factory RouteNotificationPoJo.fromJson(Map<String, dynamic> json) => RouteNotificationPoJo(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
     this.id,
     this.userId,
     this.title,
     this.description,
     this.status,
     this.type,
     this.extra,
     this.date,
     this.createdAt,
     this.updatedAt,
    this.deletedAt,
  });

  int? id;
  int? userId;
  String? title;
  String? description;
  String? status;
  String? type;
  Extra? extra;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
    type: json["type"],
    extra: Extra.fromJson(json["extra"]),
    date: DateTime.parse(json["date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "status": status,
    "type": type,
    "extra": extra!.toJson(),
    "date": date!.toIso8601String(),
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Extra {
  Extra({
     this.routeId,
     this.sharedToId,
     this.sharedToName,
     this.sharedToProfilePic,
     this.sharedById,
    this.sharedByName,
    this.sharedByProfilePic,
    this.routeName,
    this.sharedDate,
  });

  int? routeId;
  int? sharedToId;
  String? sharedToName;
  String? sharedToProfilePic;
  int? sharedById;
  String? sharedByName;
  String? sharedByProfilePic;
  String? routeName;
  DateTime? sharedDate;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
    routeId: json["route_id"],
    sharedToId: json["shared_to_id"],
    sharedToName: json["shared_to_name"],
    sharedToProfilePic: json["shared_to_profile_pic"],
    sharedById: json["shared_by_id"],
    sharedByName: json["shared_by_name"],
    sharedByProfilePic: json["shared_by_profile_pic"],
    routeName: json["route_name"],
    sharedDate: DateTime.parse(json["shared_date"]),
  );

  Map<String, dynamic> toJson() => {
    "route_id": routeId,
    "shared_to_id": sharedToId,
    "shared_to_name": sharedToName,
    "shared_to_profile_pic": sharedToProfilePic,
    "shared_by_id": sharedById,
    "shared_by_name": sharedByName,
    "shared_by_profile_pic": sharedByProfilePic,
    "route_name": routeName,
    "shared_date": sharedDate!.toIso8601String(),
  };
}




// import 'dart:convert';
//
// RouteNotificationPoJo routeNotificationPoJoFromJson(String str) => RouteNotificationPoJo.fromJson(json.decode(str));
//
// String routeNotificationPoJoToJson(RouteNotificationPoJo data) => json.encode(data.toJson());
//
// class RouteNotificationPoJo {
//   RouteNotificationPoJo({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   String? status;
//   String? message;
//   List<Datum>? data;
//
//   factory RouteNotificationPoJo.fromJson(Map<String, dynamic> json) => RouteNotificationPoJo(
//     status: json["status"] == null ? null : json["status"],
//     message: json["message"] == null ? null : json["message"],
//     data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status == null ? null : status,
//     "message": message == null ? null : message,
//     "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   Datum({
//     this.id,
//     this.userId,
//     this.title,
//     this.description,
//     this.status,
//     this.type,
//     this.extra,
//     this.date,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//   });
//
//   int? id;
//   int? userId;
//   String? title;
//   String? description;
//   String? status;
//   String? type;
//   Extra? extra;
//   DateTime? createdAt;
//   DateTime? date;
//   DateTime? updatedAt;
//   dynamic deletedAt;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"] == null ? null : json["id"],
//     userId: json["user_id"] == null ? null : json["user_id"],
//     title: json["title"] == null ? null : json["title"],
//     description: json["description"] == null ? null : json["description"],
//     status: json["status"] == null ? null : json["status"],
//     type: json["type"] == null ? null : json["type"],
//     extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     deletedAt: json["deleted_at"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id == null ? null : id,
//     "user_id": userId == null ? null : userId,
//     "title": title == null ? null : title,
//     "description": description == null ? null : description,
//     "status": status == null ? null : status,
//     "type": type == null ? null : type,
//     "extra": extra == null ? null : extra!.toJson(),
//     "date": date == null ? null : date!.toIso8601String(),
//     "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
//     "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
//     "deleted_at": deletedAt,
//   };
// }
//
// class Extra {
//   Extra({
//     this.routeName,
//     this.routeId,
//  //   this.responseById,
//     //this.responseByName,
//    // this.responseByProfilePic,
//   //  this.response,
//     this.sharedDate,
//     this.sharedToId,
//     this.sharedToName,
//     this.sharedToProfilePic,
//     this.sharedById,
//     this.sharedByName,
//     this.sharedByProfilePic,
//   });
//
//   String? routeName;
//   String? routeId;
//  // int? responseById;
//  // String? responseByName;
//  // String? responseByProfilePic;
//  // String? response;
//   DateTime? sharedDate;
//   String? sharedToId;
//   String? sharedToName;
//   String? sharedToProfilePic;
//   int? sharedById;
//   String? sharedByName;
//   String? sharedByProfilePic;
//
//   factory Extra.fromJson(Map<String, dynamic> json) => Extra(
//     routeName: json["route_name"] == null ? null : json["route_name"],
//     routeId: json["route_id"] == null ? null : json["route_id"],
//    // responseById: json["response_by_id"] == null ? null : json["response_by_id"],
//    // responseByName: json["response_by_name"] == null ? null : json["response_by_name"],
//   //  responseByProfilePic: json["response_by_profile_pic"] == null ? null : json["response_by_profile_pic"],
//   //  response: json["response"] == null ? null : json["response"],
//     sharedDate: json["shared_date"] == null ? null : DateTime.parse(json["shared_date"]),
//     sharedToId: json["shared_to_id"] == null ? null : json["shared_to_id"],
//     sharedToName: json["shared_to_name"] == null ? null : json["shared_to_name"],
//     sharedToProfilePic: json["shared_to_profile_pic"] == null ? null : json["shared_to_profile_pic"],
//     sharedById: json["shared_by_id"] == null ? null : json["shared_by_id"],
//     sharedByName: json["shared_by_name"] == null ? null : json["shared_by_name"],
//     sharedByProfilePic: json["shared_by_profile_pic"] == null ? null : json["shared_by_profile_pic"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "route_name": routeName == null ? null : routeName,
//     "route_id": routeId == null ? null : routeId,
//    // "response_by_id": responseById == null ? null : responseById,
//     //"response_by_name": responseByName == null ? null : responseByName,
//    // "response_by_profile_pic": responseByProfilePic == null ? null : responseByProfilePic,
//    // "response": response == null ? null : response,
//     "shared_date": sharedDate == null ? null : sharedDate!.toIso8601String(),
//     "shared_to_id": sharedToId == null ? null : sharedToId,
//     "shared_to_name": sharedToName == null ? null : sharedToName,
//     "shared_to_profile_pic": sharedToProfilePic == null ? null : sharedToProfilePic,
//     "shared_by_id": sharedById == null ? null : sharedById,
//     "shared_by_name": sharedByName == null ? null : sharedByName,
//     "shared_by_profile_pic": sharedByProfilePic == null ? null : sharedByProfilePic,
//   };
// }
