/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 18:03:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-10 13:57:51
 * @FilePath: /eatm_manager/lib/common/api/machine_binding_api.dart
 * @Description: 机床绑定接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class MachineBindingApi {
  // 查询
  static Future<ResponseApiBody> query(Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/Query', data: params);
  }

  // 获取机床资源
  static Future<ResponseApiBody> getMachineResource(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetMacResource', data: params);
  }

  // 绑定
  static Future<ResponseApiBody> binding(Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/MachineSelect', data: params);
  }
}
