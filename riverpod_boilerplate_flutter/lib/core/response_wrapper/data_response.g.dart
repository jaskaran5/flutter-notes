// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseWrapper<TModel> _$ResponseWrapperFromJson<TModel>(
  Map<String, dynamic> json,
  TModel Function(Object? json) fromJsonTModel,
) =>
    ResponseWrapper<TModel>(
      statusCode: json['statusCode'] as int?,
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonTModel),
    );

Map<String, dynamic> _$ResponseWrapperToJson<TModel>(
  ResponseWrapper<TModel> instance,
  Object? Function(TModel value) toJsonTModel,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('message', instance.message);
  writeNotNull('statusCode', instance.statusCode);
  writeNotNull('data', _$nullableGenericToJson(instance.data, toJsonTModel));
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
