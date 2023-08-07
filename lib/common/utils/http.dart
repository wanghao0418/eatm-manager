import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide FormData;

import '../store/index.dart';

enum Method {
  GET(value: 'get'),
  POST(value: 'post'),
  PUT(value: 'put'),
  DELETE(value: 'delete');

  const Method({required this.value});

  final String value;
}

class HttpUtil {
  static Dio? instance;
  static String? baseUrl;

  static Future<ResponseApiBody> get(String url,
      {data, requestToken = true, isMock = false}) async {
    return await request(url,
        data: data,
        requestToken: requestToken,
        method: Method.GET.value,
        isMock: isMock);
  }

  static Future<ResponseApiBody> post(String url,
      {data, requestToken = true, isMock = false}) async {
    return await request(url,
        data: data, requestToken: requestToken, isMock: isMock);
  }

  static Future<ResponseApiBody> request(String url,
      {data, method, requestToken = true, isMock = false}) async {
    data = data ?? {};
    method = method ?? Method.POST.value;

    if (isMock) {
      var mockEnv = ConfigStore.instance.mockEnv!;
      url = mockEnv + url;
    }

    // if (requestToken && !UserStore.instance.isLogin) {
    //   UserStore.instance.onLogout();
    // }

    Dio dio = createInstance()!;
    dio.options.method = method;

    ResponseApiBody responseBodyApi;
    try {
      Response res = await dio.request(url, data: data);
      responseBodyApi = ResponseApiBody.fromMap(res.data);
    } catch (e) {
      responseBodyApi =
          ResponseApiBody(success: false, message: '请求出错了：' + e.toString());
    }

    return responseBodyApi;
  }

  static Dio? createInstance() {
    if (instance == null) {
      var application = ConfigStore.instance;

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

// class HttpUtil {
//   static final HttpUtil _instance = HttpUtil._internal();
//   factory HttpUtil() => _instance;
//   String baseUrl = ConfigStore.instance.devBaseUrl!;
//   late Dio dio;
//   CancelToken cancelToken = CancelToken();

//   static void setBaseUrl(String url) {
//     _instance.baseUrl = url;
//   }

//   HttpUtil._internal() {
//     // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
//     BaseOptions options = BaseOptions(
//       // 请求基地址,可以包含子路径
//       baseUrl: baseUrl,

//       // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
//       //连接服务器超时时间，单位是毫秒.
//       connectTimeout:
//           Duration(seconds: ConfigStore.instance.connectTimeout ?? 5000),

//       // 响应流上前后两次接受到数据的间隔，单位为毫秒。
//       receiveTimeout:
//           Duration(seconds: ConfigStore.instance.receiveTimeout ?? 5000),

//       // Http请求头.
//       headers: {},

//       /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
//       /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
//       /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
//       /// 就会自动编码请求体.
//       contentType: 'application/json; charset=utf-8',

//       /// [responseType] 表示期望以那种格式(方式)接受响应数据。
//       /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
//       ///
//       /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
//       /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
//       ///
//       /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
//       responseType: ResponseType.json,
//     );

//     dio = Dio(options);

//     // Cookie管理
//     // CookieJar cookieJar = CookieJar();
//     // dio.interceptors.add(CookieManager(cookieJar));

//     // 添加拦截器
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Do something before request is sent
//         return handler.next(options); //continue
//         // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
//         // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
//         //
//         // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
//         // 这样请求将被中止并触发异常，上层catchError会被调用。
//       },
//       onResponse: (response, handler) {
//         // Do something with response data
//         return handler.next(response); // continue
//         // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
//         // 这样请求将被中止并触发异常，上层catchError会被调用。
//       },
//       onError: (DioError e, handler) {
//         // Do something with response error
//         // Loading.dismiss();
//         print('$e,1111111111');
//         ErrorEntity eInfo = createErrorEntity(e);
//         onError(eInfo);
//         return handler.next(e); //continue
//         // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
//         // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
//       },
//     ));
//   }

//   /*
//    * error统一处理
//    */

//   // 错误处理
//   void onError(ErrorEntity eInfo) {
//     print('error.code -> ' +
//         eInfo.code.toString() +
//         ', error.message -> ' +
//         eInfo.message);
//     switch (eInfo.code) {
//       case 401:
//         UserStore.instance.onLogout();
//         // EasyLoading.showError(eInfo.message);
//         break;
//       default:
//         // EasyLoading.showError('未知错误');
//         break;
//     }
//   }

//   // 错误信息
//   ErrorEntity createErrorEntity(DioError error) {
//     switch (error.type) {
//       case DioErrorType.cancel:
//         return ErrorEntity(code: -1, message: "请求取消");
//       case DioErrorType.connectionTimeout:
//         return ErrorEntity(code: -1, message: "连接超时");
//       case DioErrorType.sendTimeout:
//         return ErrorEntity(code: -1, message: "请求超时");
//       case DioErrorType.receiveTimeout:
//         return ErrorEntity(code: -1, message: "响应超时");
//       case DioErrorType.badResponse:
//         {
//           try {
//             int errCode =
//                 error.response != null ? error.response!.statusCode! : -1;
//             // String errMsg = error.response.statusMessage;
//             // return ErrorEntity(code: errCode, message: errMsg);
//             switch (errCode) {
//               case 400:
//                 return ErrorEntity(code: errCode, message: "请求语法错误");
//               case 401:
//                 return ErrorEntity(code: errCode, message: "没有权限");
//               case 403:
//                 return ErrorEntity(code: errCode, message: "服务器拒绝执行");
//               case 404:
//                 return ErrorEntity(code: errCode, message: "无法连接服务器");
//               case 405:
//                 return ErrorEntity(code: errCode, message: "请求方法被禁止");
//               case 500:
//                 return ErrorEntity(code: errCode, message: "服务器内部错误");
//               case 502:
//                 return ErrorEntity(code: errCode, message: "无效的请求");
//               case 503:
//                 return ErrorEntity(code: errCode, message: "服务器挂了");
//               case 505:
//                 return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
//               default:
//                 {
//                   // return ErrorEntity(code: errCode, message: "未知错误");
//                   return ErrorEntity(
//                     code: errCode,
//                     message: error.response != null
//                         ? error.response!.statusMessage!
//                         : "",
//                   );
//                 }
//             }
//           } on Exception catch (_) {
//             return ErrorEntity(code: -1, message: "未知错误");
//           }
//         }
//       default:
//         {
//           return ErrorEntity(code: -1, message: error.message as String);
//         }
//     }
//   }

//   /*
//    * 取消请求
//    *
//    * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
//    * 所以参数可选
//    */
//   void cancelRequests(CancelToken token) {
//     token.cancel("cancelled");
//   }

//   /// 读取本地配置
//   Map<String, dynamic>? getAuthorizationHeader() {
//     var headers = <String, dynamic>{};
//     // Get.isRegistered<UserStore>() &&
//     if (UserStore.instance.hasToken == true) {
//       headers['Authorization'] = 'Bearer ${UserStore.instance.token}';
//     }
//     return headers;
//   }

//   /// restful get 操作
//   /// refresh 是否下拉刷新 默认 false
//   /// noCache 是否不缓存 默认 true
//   /// list 是否列表 默认 false
//   /// cacheKey 缓存key
//   /// cacheDisk 是否磁盘缓存
//   Future get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     bool refresh = false,
//     bool noCache = !CACHE_ENABLE,
//     bool list = false,
//     String cacheKey = '',
//     bool cacheDisk = false,
//   }) async {
//     Options requestOptions = options ?? Options();
//     if (requestOptions.extra == null) {
//       requestOptions.extra = Map();
//     }
//     requestOptions.extra!.addAll({
//       "refresh": refresh,
//       "noCache": noCache,
//       "list": list,
//       "cacheKey": cacheKey,
//       "cacheDisk": cacheDisk,
//     });
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }

//     var response = await dio.get(
//       path,
//       queryParameters: queryParameters,
//       options: options,
//       cancelToken: cancelToken,
//     );
//     return ResponseApiBody.fromJson(response.data);
//   }

//   /// restful post 操作
//   Future post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     var response = await dio.post(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }

//   /// restful put 操作
//   Future put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     var response = await dio.put(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }

//   /// restful patch 操作
//   Future patch(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     var response = await dio.patch(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }

//   /// restful delete 操作
//   Future delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     var response = await dio.delete(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }

//   /// restful post form 表单提交操作
//   Future postForm(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     var response = await dio.post(
//       path,
//       data: FormData.fromMap(data),
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }

//   /// restful post Stream 流数据
//   Future postStream(
//     String path, {
//     dynamic data,
//     int dataLength = 0,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     requestOptions.headers!.addAll({
//       Headers.contentLengthHeader: dataLength.toString(),
//     });
//     var response = await dio.post(
//       path,
//       data: Stream.fromIterable(data.map((e) => [e])),
//       queryParameters: queryParameters,
//       options: requestOptions,
//       cancelToken: cancelToken,
//     );
//     return response.data;
//   }
// }

// // 异常处理
// class ErrorEntity implements Exception {
//   int code = -1;
//   String message = "";
//   ErrorEntity({required this.code, required this.message});

//   String toString() {
//     if (message == "") return "Exception";
//     return "Exception: code $code, $message";
//   }
// }

// 响应体
class ResponseApiBody<T> {
  bool? success;
  String? code;
  String? message;
  T? data;
  ResponseApiBody({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  ResponseApiBody<T> copyWith({
    bool? success,
    String? code,
    String? message,
    T? data,
  }) {
    return ResponseApiBody<T>(
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

  factory ResponseApiBody.fromMap(Map<String, dynamic> map) {
    return ResponseApiBody<T>(
      success: map['success'],
      code: map['code'],
      message: map['message'],
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseApiBody.fromJson(String source) =>
      ResponseApiBody.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResponseBodyApi(success: $success, code: $code, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ResponseApiBody<T> &&
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
