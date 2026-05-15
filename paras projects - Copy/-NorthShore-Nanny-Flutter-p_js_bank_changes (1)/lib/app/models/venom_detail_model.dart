import 'dart:convert';

VenomDetailModel venomDetailModelFromJson(String str) =>
    VenomDetailModel.fromJson(json.decode(str));

String venomDetailModelToJson(VenomDetailModel data) =>
    json.encode(data.toJson());

class VenomDetailModel {
  int? response;
  dynamic message;
  VenomData? data;

  VenomDetailModel({
    this.response,
    this.message,
    this.data,
  });

  factory VenomDetailModel.fromJson(Map<String, dynamic> json) =>
      VenomDetailModel(
        response: json["response"],
        message: json["message"],
        data: json["data"] == null ? null : VenomData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": data?.toJson(),
      };
}

class VenomData {
  int? id;
  int? userid;
  String? venmoUserName;
  String? guardianName;
  String? phoneNumber;
  bool? isVenmoDetails;
  DateTime? createdOn;
  dynamic user;

  VenomData({
    this.id,
    this.userid,
    this.venmoUserName,
    this.guardianName,
    this.phoneNumber,
    this.isVenmoDetails,
    this.createdOn,
    this.user,
  });

  factory VenomData.fromJson(Map<String, dynamic> json) => VenomData(
        id: json["id"],
        userid: json["userid"],
        venmoUserName: json["venmoUserName"],
        guardianName: json["gaurdianName"],
        phoneNumber: json["phoneNumber"],
        isVenmoDetails: json["isVenmoDetails"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "venmoUserName": venmoUserName,
        "gaurdianName": guardianName,
        "phoneNumber": phoneNumber,
        "isVenmoDetails": isVenmoDetails,
        "createdOn": createdOn?.toIso8601String(),
        "user": user,
      };
}
