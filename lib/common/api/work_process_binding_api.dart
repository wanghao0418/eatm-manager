/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 18:03:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-23 11:41:12
 * @FilePath: /eatm_manager/lib/common/api/machine_binding_api.dart
 * @Description: 机床绑定接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class WorkProcessBindingApi {
  // 查询
  static Future<ResponseApiBody> query(Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/workProcess/query', data: params);
  }

  // 获取机床资源
  static Future<ResponseApiBody> getMachineResource(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetMacResource', data: params);
  }

  // 绑定机床
  static Future<ResponseApiBody> bindMachine(params) async {
    return await HttpUtil.post('/Eatm/machine/bind', data: params);
  }

  // 绑定工艺信息
  static Future<ResponseApiBody> binding(params) async {
    return await HttpUtil.post('/Eatm/workProcess/bind', data: params);
  }

  // 获取绑定资源信息
  static Future<ResponseApiBody> getBindingResource(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetBIndResourceinfo', data: params);
  }

  // 获取托盘类型信息
  static Future<ResponseApiBody> getTrayTypeInfo(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetTraytpeListInfo', data: params);
  }

  // 获取装夹方式信息
  static Future<ResponseApiBody> getClampTypeInfo(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetClampTypeInfo', data: params);
  }
}
