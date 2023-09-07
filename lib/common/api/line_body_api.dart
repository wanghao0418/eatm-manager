/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 17:34:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 10:23:24
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
    return await HttpUtil.post('/Eatm/lineBody/getMacList',
        data: {}, isMock: isMock);
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
}
