/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-29 11:35:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 10:56:40
 * @FilePath: /eatm_manager/lib/common/api/discharge_api.dart
 * @Description: 放电接口
 */
import 'package:eatm_manager/common/utils/http.dart';

class DischargeApi {
  static bool isMock = true;

  // 获取EDM钢件信息
  static Future<ResponseApiBody> getSteelEDMData() async {
    return await HttpUtil.post('/Eatm/EdmSteelInfoRequest');
  }

  // 获取EDM放电信息
  static Future<ResponseApiBody> getDischargeData(data) async {
    return await HttpUtil.post('/Eatm/GetEdmElecInfo',
        data: data, isMock: isMock);
  }

  // 获取EDM任务信息
  static Future<ResponseApiBody> getEdmTaskInfo(data) async {
    return await HttpUtil.post('/Eatm/CreatSteelEdmTask',
        data: data, isMock: isMock);
  }

  // 更新钢件放电任务
  static Future<ResponseApiBody> updateSteelEdmTask(data) async {
    return await HttpUtil.post('/Eatm/UpdateSteelEdmTask',
        data: data, isMock: isMock);
  }
}
