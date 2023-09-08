/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 09:22:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 13:25:58
 * @FilePath: /eatm_manager/lib/common/api/reporting_api.dart
 * @Description: 报工接口
 */
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/http.dart';

class ReportingApi {
  // 是否启用mock
  static bool get isMock => ConfigStore.instance.openMock ?? false;

  // 查询
  static Future<ResponseApiBody> query(Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/reporting/query',
        data: params, isMock: isMock);
  }

  // 获取机床资源
  static Future<ResponseApiBody> getMachineResource(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/GetMacResource',
        data: params, isMock: isMock);
  }

  // 报工
  static Future<ResponseApiBody> reporting(params) async {
    return await HttpUtil.post('/Eatm/reporting/report',
        data: params, isMock: isMock);
  }

  // 获取人员列表
  static Future<ResponseApiBody> getPersonList(
      Map<String, dynamic> params) async {
    return await HttpUtil.post('/Eatm/reporting/getPeopleList',
        data: params, isMock: isMock);
  }
}
