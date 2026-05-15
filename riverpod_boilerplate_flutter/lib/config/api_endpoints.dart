part of '../core/network/http_service.dart';

abstract final class ApiConstants {
  static const String url = "https://api.autoexpertstx.com";
  static const String baseUrl = "$url/api/v1";
  static const String login = "$baseUrl/login";
  static const String preferences = "$baseUrl/get/preferences";

}

