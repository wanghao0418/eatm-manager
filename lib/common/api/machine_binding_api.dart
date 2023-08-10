/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 18:03:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-09 18:09:00
 * @FilePath: /eatm_manager/lib/common/api/machine_binding_api.dart
 * @Description: 机床绑定接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class MachineBindingApi {
  // 查询
  static Future<ResponseApiBody> query(Map<String, dynamic> params) async {
    return await HttpUtil.post('/api/Device/GetDeviceList', data: params);
  }

  // 获取机床资源
  static Future<ResponseApiBody> getMachineResource(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetMacResource', data: params);
  }
}
