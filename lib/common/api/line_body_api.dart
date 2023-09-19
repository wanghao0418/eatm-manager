/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 17:34:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-18 11:11:25
 * @FilePath: /eatm_manager/lib/common/api/line_body_api.dart
 * @Description: 线体公用接口
 */
import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/http.dart';

class LineBodyApi {
  // 是否启用mock
  static bool get isMock => ConfigStore.instance.openMock ?? false;

  // 获取机床列表
  static Future<ResponseApiBody> getMachineList() async {
    return await HttpUtil.post('/Eatm/lineBody/getMacList', data: {});
  }

  // 获取线体运行信息
  static Future<ResponseApiBody> getLineRunInfo() async {
    return await HttpUtil.post('/Eatm/CropRate', data: {}, isMock: isMock);
  }

  // 获取当日任务数
  static Future<ResponseApiBody> getTodayTaskNum() async {
    return await HttpUtil.post('/Eatm/GetTotalTasksOfTheDay',
        data: {}, isMock: isMock);
  }

  // 获取累计完成数
  static Future<ResponseApiBody> getTotalFinishNum() async {
    return await HttpUtil.post('/Eatm/ProductionLineStatistics',
        data: {}, isMock: isMock);
  }

  // 获取机床加工完成情况
  static Future<ResponseApiBody> getMachineProcessInfo() async {
    return await HttpUtil.post('/Eatm/ProcessFinishTotal',
        data: {}, isMock: isMock);
  }

  // 获取机床报警
  static Future<ResponseApiBody> getMachineAlarmInfo() async {
    return await HttpUtil.post('/Eatm/GetMacAlarmInfo',
        data: {}, isMock: isMock);
  }

  // 获取线体设备运行状态
  static Future<ResponseApiBody> getEquipmentRunStatus() async {
    return await HttpUtil.post('/Eatm/macRunState', data: {}, isMock: isMock);
  }
}
