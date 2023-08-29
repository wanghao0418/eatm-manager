/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-29 11:35:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-29 17:18:13
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
}
