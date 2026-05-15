// To parse this JSON data, do
//
//     final customerHomeDashboardResponseModel = customerHomeDashboardResponseModelFromJson(jsonString);

import 'dart:convert';

import 'nanny_profile_model.dart';

CustomerHomeDashboardResponseModel customerHomeDashboardResponseModelFromJson(
        String str) =>
    CustomerHomeDashboardResponseModel.fromJson(json.decode(str));

String customerHomeDashboardResponseModelToJson(
        CustomerHomeDashboardResponseModel data) =>
    json.encode(data.toJson());

class CustomerHomeDashboardResponseModel {
  int? response;
  dynamic message;
  // List<NannyDataList>? data;
  Data? data;

  CustomerHomeDashboardResponseModel({
    this.response,
    this.message,
    this.data,
  });

  factory CustomerHomeDashboardResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CustomerHomeDashboardResponseModel(
        response: json["response"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        // data: json["data"] == null
        //     ? []
        //     : List<NannyDataList>.from(
        //         json["data"]!.map((x) => NannyDataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        // "data": data == null
        //     ? []
        //     : List<dynamic>.from(data!.map((x) => x.toJson())),
        "data": data?.toJson(),
      };
}

class Data {
  final String? address;
  final String? latitude;
  final String? longitude;
  final List<NannyDataList>? dataList;

  Data({
    this.address,
    this.dataList,
    this.latitude,
    this.longitude,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        address: json["address"],
        dataList: json["dashboardmodel"] == null
            ? []
            : List<NannyDataList>.from(
                json["dashboardmodel"]!.map((x) => NannyDataList.fromJson(x))),
        longitude: json['longitude'] == 'null' ? '0.0' : json['longitude'],
        latitude: json['latitude'] == 'null' ? '0.0' : json['latitude'],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "dashboardmodel": dataList == null
            ? []
            : List<dynamic>.from(dataList!.map((x) => x.toJson()))
      };
}

class NannyDataList {
  int? id;
  dynamic gender;
  dynamic name;
  dynamic image;
  bool? isFavorite;
  dynamic aboutMe;
  double? distance;
  dynamic age;
  dynamic experience;
  dynamic location;
  dynamic latitude;
  dynamic longitude;
  dynamic reviewCount;
  double? rating;
  List<RatingList>? ratingList;

  NannyDataList({
    this.id,
    this.gender,
    this.name,
    this.image,
    this.isFavorite,
    this.aboutMe,
    this.distance,
    this.age,
    this.experience,
    this.location,
    this.latitude,
    this.longitude,
    this.reviewCount,
    this.rating,
    this.ratingList,
  });

  factory NannyDataList.fromJson(Map<String, dynamic> json) => NannyDataList(
        id: json.containsKey("userId")?int.tryParse(json["userId"].toString()) ?? 0:json["id"],
        gender: json["gender"] ?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        isFavorite: json["isFavorite"] ?? false,
        aboutMe: json.containsKey("about")?json['about']??"":json["aboutMe"] ?? '',
        distance: json["distance"]?.toDouble(),
        age: json["age"] ?? '',
        experience: json["experience"] ?? '',
        location: json["location"] ?? "",
        latitude: json["latitude"] ?? '0.0',
        longitude: json["longitude"] ?? '0.0',
        reviewCount: json["reviewCount"] ?? '',
        rating: json["rating"] ?? 0.0,
        ratingList: json["ratingList"] == null
            ? []
            : List<RatingList>.from(
                json["ratingList"]!.map((x) => RatingList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gender": gender,
        "name": name,
        "image": image,
        "isFavorite": isFavorite,
        "aboutMe": aboutMe,
        "distance": distance,
        "age": age,
        "experience": experience,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "reviewCount": reviewCount,
        "rating": rating,
        "ratingList": ratingList == null
            ? []
            : List<dynamic>.from(ratingList!.map((x) => x.toJson())),
      };
}
