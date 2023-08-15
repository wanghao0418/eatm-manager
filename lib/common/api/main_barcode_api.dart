/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-14 17:45:24
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-14 17:46:54
 * @FilePath: /eatm_manager/lib/common/api/main_barcode_api.dart
 * @Description: 芯片条码接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class MainBarcodeApi {
  // 匹配
  static Future<ResponseApiBody> match(data) async {
    return await HttpUtil.post('/Eatm/Matching', data: data);
  }

  // 解绑
  static Future<ResponseApiBody> unbind(data) async {
    return await HttpUtil.post('/Eatm/MatchUnbind', data: data);
  }

  // 查询
  static Future<ResponseApiBody> query(data) async {
    return await HttpUtil.post('/Eatm/MatchQuery', data: data);
  }

  // 交换
  static Future<ResponseApiBody> exchange(data) async {
    return await HttpUtil.post('/Eatm/MatchExchange', data: data);
  }
}
