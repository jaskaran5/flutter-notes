import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/all_getter.dart';
import '../../config/helper.dart';





class Injector {
  static final Injector _singleton = Injector._internal();
  static final _dio = Dio();
  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  Dio getDio() {
    BaseOptions options = BaseOptions(receiveTimeout: const Duration(seconds: 90), connectTimeout: const Duration(seconds: 90));
    _dio.options = options;
    _dio.options.followRedirects = false;
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.interceptors.clear();
/*    _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
          error: true,
          request: true,
        ));*/
    _dio.interceptors.add(LoggingInterceptors());
    return _dio;
  }

  static Options? getHeaderToken() {
    String? token = Getters.authToken;
    //int? userId = Getters.getLoginUser?.id;
    if (token != null) {
    //  printLog("Logged in user Id==>>$userId");
      printLog("AuthToken==>> Bearer $token");
      var headerOptions = Options(headers: {
        'Authorization': 'Bearer $token',
        // options.headers['Authorization'] = 'Bearer ' +usertoken!;
      });
      return headerOptions;
    }
    return null;
  }
}

class LoggingInterceptors extends Interceptor {

  String printObject(Object object) {
    Map jsonMapped = json.decode(json.encode(object));
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyPrint = encoder.convert(jsonMapped);
    return prettyPrint;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("--> ${options.method.toUpperCase()} ${"${options.baseUrl}${options.path}"}");
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    print("queryParameters:");
    options.queryParameters.forEach((k, v) => print('$k: $v'));
    if (options.data != null) {
      try{
        FormData formData = options.data as FormData;
        print("Body:");
        var buffer = [];
        for(MapEntry<String, String> pair in formData.fields){
          buffer.add('${pair.key}:${pair.value}');
        }
        print("Body:{${buffer.join(', ')}}");
      }catch(e){
        print("Body: ${printObject(options.data)}");
      }
    }
    print("--> END ${options.method.isNotEmpty ? options.method.toUpperCase() : 'METHOD'}");
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}");
    print("${err.response != null ? err.response!.data : 'Unknown Error'}");
    print("<-- End error");
    return super.onError(err, handler);


  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("<-- ${response.statusCode} ${(response.requestOptions.baseUrl.isNotEmpty  ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL')}");
    print("Headers:");
    response.headers.forEach((k, v) => print('$k: $v'));
    print("Response: ${response.data}");
    print("<-- END HTTP");
    return super.onResponse(response, handler);
  }

}