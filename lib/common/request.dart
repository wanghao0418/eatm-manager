import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eatm_manager/common/config.dart';

enum Method {
  GET(value: 'get'),
  POST(value: 'post'),
  PUT(value: 'put'),
  DELETE(value: 'delete');

  const Method({required this.value});

  final String value;
}

class Http {
  static Dio? instance;
  static String? baseUrl;

  static Future<ResponseBodyApi> get(String url,
      {data, requestToken = true}) async {
    return await request(url,
        data: data, requestToken: requestToken, method: Method.GET.value);
  }

  static Future<ResponseBodyApi> post(String url,
      {data, requestToken = true}) async {
    return await request(url, data: data, requestToken: requestToken);
  }

  static Future<ResponseBodyApi> request(String url,
      {data, method, requestToken = true}) async {
    data = data ?? {};
    method = method ?? Method.POST.value;

    // if (requestToken && !Utils.isLogin()) {
    //   Utils.logout();
    // }

    Dio dio = createInstance()!;
    dio.options.method = method;

    ResponseBodyApi responseBodyApi;
    try {
      Response res = await dio.request(url, data: data);
      responseBodyApi = ResponseBodyApi.fromMap(res.data);
    } catch (e) {
      responseBodyApi =
          ResponseBodyApi(success: false, message: '请求出错了：' + e.toString());
    }

    return responseBodyApi;
  }

  static Dio? createInstance() {
    if (instance == null) {
      GlobalConfig application = GlobalConfig.instance.application;

      BaseOptions options = BaseOptions(
        baseUrl: baseUrl ?? application.productBaseUrl!,
        connectTimeout: Duration(seconds: application.connectTimeout ?? 1000),
        receiveTimeout: Duration(seconds: application.receiveTimeout ?? 1000),
      );

      instance = Dio(options);

      instance!.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
        print(e.message);
        handler.next(e);
      }));
    }

    return instance;
  }

  static clear() {
    instance = null;
  }

  static setBaseUrl(String url) {
    baseUrl = url;
  }
}

class ResponseBodyApi<T> {
  bool? success;
  String? code;
  String? message;
  T? data;
  ResponseBodyApi({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  ResponseBodyApi<T> copyWith({
    bool? success,
    String? code,
    String? message,
    T? data,
  }) {
    return ResponseBodyApi<T>(
      success: success ?? this.success,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data,
    };
  }

  factory ResponseBodyApi.fromMap(Map<String, dynamic> map) {
    return ResponseBodyApi<T>(
      success: map['success'],
      code: map['code'],
      message: map['message'],
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseBodyApi.fromJson(String source) =>
      ResponseBodyApi.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResponseBodyApi(success: $success, code: $code, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ResponseBodyApi<T> &&
        o.success == success &&
        o.code == code &&
        o.message == message &&
        o.data == data;
  }

  @override
  int get hashCode {
    return success.hashCode ^ code.hashCode ^ message.hashCode ^ data.hashCode;
  }
}
