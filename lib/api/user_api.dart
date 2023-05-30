import '../common/request.dart';

class UserApi {
  static Future<ResponseBodyApi> login(data) async {
    ResponseBodyApi responseBodyApi =
        await Http.post('/Eatm/Login', data: data, requestToken: false);
    return responseBodyApi;
  }
}
