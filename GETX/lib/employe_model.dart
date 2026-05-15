// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  String? status;
  List<EmployeeData>? data;
  String? message;

  EmployeeModel({
    this.status,
    this.data,
    this.message,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<EmployeeData>.from(json["data"]!.map((x) => EmployeeData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class EmployeeData {
  int? id;
  String? employeeName;
  int? employeeSalary;
  int? employeeAge;
  String? profileImage;

  EmployeeData({
    this.id,
    this.employeeName,
    this.employeeSalary,
    this.employeeAge,
    this.profileImage,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    id: json["id"],
    employeeName: json["employee_name"],
    employeeSalary: json["employee_salary"],
    employeeAge: json["employee_age"],
    profileImage: json["profile_image"],
  );

Map<String, dynamic> toJson() => <String,dynamic>{
    "id": id,
    "employee_name": employeeName,
    "employee_salary": employeeSalary,
    "employee_age": employeeAge,
    "profile_image": profileImage,
  };
}
