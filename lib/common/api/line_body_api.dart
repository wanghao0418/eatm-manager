/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 17:34:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-17 17:50:51
 * @FilePath: /eatm_manager/lib/common/api/line_body_api.dart
 * @Description: 线体公用接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class LineBodyApi {
  // 是否启用mock
  static bool isMock = true;

  // 获取机床列表
  static Future<ResponseApiBody> getMachineList() async {
    return await HttpUtil.post('/Eatm/lineBody/getMacList',
        data: {}, isMock: isMock);
  }
}
