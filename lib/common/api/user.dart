import '../utils/http.dart';

class UserApi {
  // 登录
  static Future<ResponseApiBody> login(params) async {
    ResponseApiBody response = await HttpUtil.post('/Eatm/Login', data: params);
    return response;
  }
}
