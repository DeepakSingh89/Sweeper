import 'dart:convert';

CityListPoJo cityListPoJoFromJson(String str) => CityListPoJo.fromJson(json.decode(str));

String cityListPoJoToJson(CityListPoJo data) => json.encode(data.toJson());

class CityListPoJo {
  CityListPoJo({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory CityListPoJo.fromJson(Map<String, dynamic> json) => CityListPoJo(
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
    this.cityName,
  });

  String? cityName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cityName: json["city_name"] == null ? null : json["city_name"],
  );

  Map<String, dynamic> toJson() => {
    "city_name": cityName == null ? null : cityName,
  };
}
