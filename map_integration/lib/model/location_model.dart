import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({
    this.srNo,
    this.date,
    this.place,
    this.latitude,
    this.longitude,
  });

  int? srNo;
  DateTime? date;
  String? place;
  String? latitude;
  String? longitude;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        srNo: json["sr_no"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        place: json["place"],
        latitude: json["latitude"].toString(),
        longitude: json["longitude"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "sr_no": srNo.toString(),
        "date": date == null ? null : date!.toIso8601String(),
        "place": place,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      };
  static const TABLE_NAME = "ds_location";
}
