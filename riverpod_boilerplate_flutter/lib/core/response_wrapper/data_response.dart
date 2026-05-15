part 'data_response.g.dart';

class ResponseWrapper<TModel> {
  bool? status;
  int? statusCode;
  String? message;
  TModel? data;

  ResponseWrapper({this.status, this.statusCode, this.message, this.data});

  factory ResponseWrapper.fromJson(
    Map<String, dynamic> json,
    TModel Function(Object? json) fromJsonT,
  ) =>
      _$ResponseWrapperFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(TModel value) toJsonT) =>
      _$ResponseWrapperToJson(this, toJsonT);
}
