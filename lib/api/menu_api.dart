import '../common/request.dart';

class MenuApi {
  static Future<ResponseBodyApi> listAuth() async {
    return await Http.post('/Eatm/ListMenu');
  }

  static Future<ResponseBodyApi> list(data) async {
    ResponseBodyApi responseBodyApi =
        await Http.post('/Eatm/ListMenu', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> saveOrUpdate(data) async {
    ResponseBodyApi responseBodyApi =
        await Http.post('/Eatm/SaveOrUpdate', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return Http.post('/Eatm/SaveOrUpdate', data: data);
  }
}
