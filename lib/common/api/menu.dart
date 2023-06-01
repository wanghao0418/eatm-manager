import 'package:eatm_manager/common/utils/http.dart';

class MenuApi {
  static Future<ResponseApiBody> getMenuList() async {
    return await HttpUtil.post('/Eatm/ListMenu');
  }

  static Future<ResponseApiBody> list(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/ListMenu', data: data);
    return responseBodyApi;
  }

  static Future<ResponseApiBody> saveOrUpdate(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/SaveOrUpdate', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return HttpUtil.post('/Eatm/SaveOrUpdate', data: data);
  }
}
